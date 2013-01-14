Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab3ANH3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 02:29:17 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7172 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab3ANH3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 02:29:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 13 Jan 2013 23:29:08 -0800
Date: Mon, 14 Jan 2013 09:28:55 +0200
From: Sivaram Nair <sivaramn@nvidia.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 2/9] clk: tegra: Add tegra specific clocks
Message-ID: <20130114072855.GB17884@sivaramn-lnx>
References: <1357890387-23245-1-git-send-email-pgaikwad@nvidia.com>
 <1357890387-23245-3-git-send-email-pgaikwad@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <1357890387-23245-3-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 08:46:20AM +0100, Prashant Gaikwad wrote:
> +static int _program_pll(struct clk_hw *hw, struct tegra_clk_pll_freq_table *cfg,
> +                       unsigned long rate)
> +{
> +       struct tegra_clk_pll *pll = to_clk_pll(hw);
> +       unsigned long flags = 0;
> +       u32 divp, val, old_base;
> +       int state;
> +
> +       divp = __ffs(cfg->p);
> +
> +       if (pll->flags & TEGRA_PLLU)
> +               divp ^= 1;
> +
> +       if (pll->lock)
> +               spin_lock_irqsave(pll->lock, flags);
> +
> +       old_base = val = pll_readl_base(pll);
> +       val &= ~((divm_mask(pll) << pll->divm_shift) |
> +                (divn_mask(pll) << pll->divn_shift) |
> +                (divp_mask(pll) << pll->divp_shift));
> +       val |= ((cfg->m << pll->divm_shift) |
> +               (cfg->n << pll->divn_shift) |
> +               (divp << pll->divp_shift));
> +       if (val == old_base) {
> +               if (pll->lock)
> +                       spin_unlock_irqrestore(pll->lock, flags);
> +               return 0;
> +       }
> +
> +       state = clk_pll_is_enabled(hw);
> +
> +       if (state) {
> +               if (pll->lock)
> +                       spin_unlock_irqrestore(pll->lock, flags);
> +
> +               clk_pll_disable(hw);
> +               val &= ~(PLL_BASE_BYPASS | PLL_BASE_ENABLE);
> +
> +               if (pll->lock)
> +                       spin_lock_irqsave(pll->lock, flags);

Instead of doing spin_unlock, disable and spin_lock, can't we use
_clk_pll_disable here, without the locks?

regards,
Sivaram
