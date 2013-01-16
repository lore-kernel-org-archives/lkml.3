Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab3APMb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 07:31:59 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5283 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab3APMb6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 07:31:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 16 Jan 2013 04:31:51 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 16 Jan 2013 13:31:51 +0100
Subject: Re: [PATCH v4 2/9] clk: tegra: Add tegra specific clocks
Thread-Topic: [PATCH v4 2/9] clk: tegra: Add tegra specific clocks
Thread-Index: Ac3z5XcF/KpMR8DCTnCzgcoyHzcLsw==
Message-ID: <20130116.143151.1531468192773974887.hdoyu@nvidia.com>
References: <1357890387-23245-1-git-send-email-pgaikwad@nvidia.com><1357890387-23245-3-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1357890387-23245-3-git-send-email-pgaikwad@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prashant Gaikwad <pgaikwad@nvidia.com> wrote @ Fri, 11 Jan 2013 08:46:20 +0100:
...
> +const struct clk_ops tegra_clk_periph_ops = {
> +       .get_parent = clk_periph_get_parent,
> +       .set_parent = clk_periph_set_parent,
> +       .recalc_rate = clk_periph_recalc_rate,
> +       .round_rate = clk_periph_round_rate,
> +       .set_rate = clk_periph_set_rate,
> +       .is_enabled = clk_periph_is_enabled,
> +       .enable = clk_periph_enable,
> +       .disable = clk_periph_disable,
> +};
> +
> +const struct clk_ops tegra_clk_periph_nodiv_ops = {
> +       .get_parent = clk_periph_get_parent,
> +       .set_parent = clk_periph_set_parent,
> +       .is_enabled = clk_periph_is_enabled,
> +       .enable = clk_periph_enable,
> +       .disable = clk_periph_disable,
> +};
> +
> +struct clk *tegra_clk_periph(const char *name, const char **parent_names,
> +                            int num_parents, struct tegra_clk_periph *periph,
> +                            void __iomem *clk_base, u32 offset)
> +{
> +       struct clk *clk;
> +       struct clk_init_data init;
> +
> +       init.name = name;
> +       init.ops = &tegra_clk_periph_ops;
> +       init.flags = 0;
> +       init.parent_names = parent_names;
> +       init.num_parents = num_parents;
> +
> +       periph->hw.init = &init;
> +       periph->magic = TEGRA_CLK_PERIPH_MAGIC;
> +       periph->mux.reg = clk_base + offset;
> +       periph->divider.reg = clk_base + offset;
> +       periph->gate.clk_base = clk_base;
> +
> +       clk = clk_register(NULL, &periph->hw);
> +       if (IS_ERR(clk))
> +               return clk;
> +
> +       periph->mux.hw.clk = clk;
> +       periph->divider.hw.clk = clk;
> +       periph->gate.hw.clk = clk;
> +
> +       return clk;
> +}
> +
> +struct clk *tegra_clk_periph_nodiv(const char *name, const char **parent_names,
> +                             int num_parents, struct tegra_clk_periph *periph,
> +                             void __iomem *clk_base, u32 offset)
> +{
> +       struct clk *clk;
> +       struct clk_init_data init;
> +
> +       init.name = name;
> +       init.ops = &tegra_clk_periph_nodiv_ops;
> +       init.flags = CLK_SET_RATE_PARENT;
> +       init.parent_names = parent_names;
> +       init.num_parents = num_parents;
> +
> +       periph->hw.init = &init;
> +       periph->magic = TEGRA_CLK_PERIPH_MAGIC;
> +       periph->mux.reg = clk_base + offset;
> +       periph->gate.clk_base = clk_base;
> +
> +       clk = clk_register(NULL, &periph->hw);
> +       if (IS_ERR(clk))
> +               return clk;
> +
> +       periph->mux.hw.clk = clk;
> +       periph->gate.hw.clk = clk;
> +
> +       return clk;
> +}

The above two functions are almost duplicate, can we take the common part from them?

const struct clk_ops tegra_clk_periph_nodiv_ops = {
       .get_parent = clk_periph_get_parent,
       .set_parent = clk_periph_set_parent,
       .is_enabled = clk_periph_is_enabled,
       .enable = clk_periph_enable,
       .disable = clk_periph_disable,
};

struct clk *__tegra_clk_periph(const char *name, const char **parent_names,
			    int num_parents, struct tegra_clk_periph *periph,
			    void __iomem *clk_base, u32 offset, int div)
{
       struct clk *clk;
       struct clk_init_data init;

       init.name = name;
       init.parent_names = parent_names;
       init.num_parents = num_parents;
       init.ops = div ? &tegra_clk_periph_ops : &tegra_clk_periph_nodiv_ops
       init.flags = div ? 0 :　CLK_SET_RATE_PARENT;

       periph->hw.init = &init;
       periph->magic = TEGRA_CLK_PERIPH_MAGIC;
       periph->mux.reg = clk_base + offset;
       periph->divider.reg = clk_base + offset;
       periph->gate.clk_base = clk_base;

       clk = clk_register(NULL, &periph->hw);
       if (IS_ERR(clk))
	       return clk;

       periph->mux.hw.clk = clk;
       periph->divider.hw.clk = div ? NULL : clk;
       periph->gate.hw.clk = clk;

       return clk;
}

static inline struct clk *tegra_clk_periph(const char *name, const char **parent_names,
			    int num_parents, struct tegra_clk_periph *periph,
			    void __iomem *clk_base, u32 offset)
{
	return __tegra_clk_periph(name, parent_names, num_parents, periph, clk_base, offset, 1);
}

static inline struct clk *tegra_clk_periph_nodiv(const char *name, const char **parent_names,
			     int num_parents, struct tegra_clk_periph *periph,
			     void __iomem *clk_base, u32 offset, )
{
	return __tegra_clk_periph(name, parent_names, num_parents, periph, clk_base, offset, 0);
}
