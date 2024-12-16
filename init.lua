-- configure options
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.relativenumber = true
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system(
        {"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
         lazypath})
end
vim.opt.rtp:prepend(lazypath)

local opts = {}
local plugins = {
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000
    }, 
    {
      'nvim-telescope/telescope.nvim',
       --tag = '0.1.6',
       dependencies = {'nvim-lua/plenary.nvim'}
    }, 
    {
        "zbirenbaum/copilot.lua"
    }, 
    {
        "zbirenbaum/copilot-cmp"
    }, 
    {
        "hrsh7th/nvim-cmp"
    }, 
    {
        "hrsh7th/cmp-nvim-lsp"
    }
}

-- setup lazy loading
require("lazy").setup(plugins, opts)

-- setup telescope
local telescope = require('telescope')

telescope.setup {
    defaults = {
        vimgrep_arguments = {'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column',
                             '--smart-case', '--glob=!bin/**', '--glob=!obj/**'}
    }
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<leader>fb", builtin.find_files, {})
vim.keymap.set('n', "<leader>fg", builtin.live_grep, {})

-- setup catppuccin
require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"

-- setup copilot
require("copilot").setup({
    panel = {
        enabled = true
    },
    suggestion = {
        enabled = true
    },
    filetypes = {
        markdown = true,
        yaml = true,
        lua = true,
        json = true
    },
    copilot_node_command = 'node', -- Node.js version must be > 16.x
    server_opts_overrides = {}
})

-- setup copilot-cmp
require("copilot_cmp").setup()

vim.keymap.set('n', '<leader>cc', ':Copilot panel<CR>', {
    noremap = true,
    silent = true
})

-- setup cmp
local cmp = require("cmp")

cmp.setup({
    mapping = {
        -- Navigate suggestions
        ["<Tab>"] = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Insert
        }),
        ["<S-Tab>"] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Insert
        }),

        -- Accept suggestion
        ["<CR>"] = cmp.mapping.confirm({
            select = true
        }), -- Accept selected suggestion or first item if none selected

        -- Alternative key for accepting suggestion
        ["<C-y>"] = cmp.mapping.confirm({
            select = true
        }),

        -- Dismiss the completion menu
        ["<C-e>"] = cmp.mapping.abort()
    },
    sources = {{
        name = "nvim_lsp"
    }, {
        name = "copilot"
    }}
})

-- Shortcut for searching your neovim configuration files
vim.keymap.set("n", "<leader>sn", function()
	builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })

vim.keymap.set("n", "<leader><leader>x", "<cmd>:source %<CR>")
vim.keymap.set("n", "<leader>x", ":.lua<CR>")
vim.keymap.set("v", "<leader>x", ":lua<CR>")