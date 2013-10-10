Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab3JJKlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 06:41:24 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:38535 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab3JJKlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 06:41:21 -0400
Date: Thu, 10 Oct 2013 12:39:16 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Paul Walmsley <pwalmsley@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/5] clk: tegra: Add support for PLLSS
Message-ID: <20131010103915.GA6735@ulmo.nvidia.com>
References: <1380878014-22088-1-git-send-email-pdeschrijver@nvidia.com>
 <1380878014-22088-2-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <1380878014-22088-2-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 04, 2013 at 12:12:40PM +0300, Peter De Schrijver wrote:
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

This is missing a commit description.

> diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
[...]
> +const struct clk_ops tegra_clk_pllss_ops = {

static?

> +struct clk *tegra_clk_register_pllss(const char *name, const char *parent_name,
> +				void __iomem *clk_base, unsigned long flags,
> +				unsigned long fixed_rate,
> +				struct tegra_clk_pll_params *pll_params,
> +				struct tegra_clk_pll_freq_table *freq_table,
> +				spinlock_t *lock)
> +{
[...]
> +	pll = _tegra_init_pll(clk_base, NULL, fixed_rate, pll_params,
> +				pll_flags, freq_table, lock);
> +
> +	if (IS_ERR(pll))

I'd leave out the blank line separating the assignment of pll and the
check for validity. Grouping them together like that makes it
immediately clear that they belong together.

> +		return ERR_CAST(pll);
> +
> +	val = pll_readl_base(pll);
> +
> +	if (val & (3 << 25)) {

Same here. Also 3 << 25 could probably be a symbolic constant, something
like PLLSS_REF_SRC_SEL_MASK perhaps?

> +		WARN(1, "Unknown parent selected for %s: %d\n", name,
> +			val >> 25);

Similarly, this should be something like:

		(val & PLLSS_REF_SRC_SEL_MASK) >> PLLSS_REF_SRC_SEL_SHIFT

> +		kfree(pll);
> +		return ERR_PTR(-EINVAL);
> +	}
> +	_get_pll_mnp(pll, &cfg);

Nit: I'd put a blank line before this, to separate the block and the
function call. That is:

	}

	_get_pll_mnp(...);

> +
> +	if (cfg.n > 1) {
> +		WARN(1, "%s should not be initialized\n", name);
> +		kfree(pll);
> +		return ERR_PTR(-EINVAL);
> +	}

Is this really fatal? Can't we just configure the PLL from scratch?

> +	parent_rate = __clk_get_rate(parent);
> +
> +	pll_params->vco_min = _clip_vco_min(pll_params->vco_min, parent_rate);
> +
> +	cfg.m = _pll_fixed_mdiv(pll_params, parent_rate);
> +	cfg.n = cfg.m * pll_params->vco_min / parent_rate;
> +
> +	for (i = 0; pll_params->pdiv_tohw[i].pdiv; i++)
> +		;
> +	cfg.p = pll_params->pdiv_tohw[i-1].hw_val;

Could use a blank line to separate them. Also what if .pdiv of the first
entry is 0? The loop will terminate on the first run and i will be 0, so
this would try to access pdiv_tohw[-1]. Can that ever happen?

> +	_update_pll_mnp(pll, &cfg);
> +
> +	pll_writel_misc(PLLSS_MISC_DEFAULT, pll);
> +	pll_writel(PLLSS_CFG_DEFAULT, pll_params->ext_misc_reg[0], pll);
> +	pll_writel(PLLSS_CTRL1_DEFAULT, pll_params->ext_misc_reg[1], pll);
> +	pll_writel(PLLSS_CTRL1_DEFAULT, pll_params->ext_misc_reg[2], pll);
> +
> +	val = pll_readl_base(pll);
> +	if (val & PLL_BASE_ENABLE) {
> +		if (val & BIT(pll_params->iddq_bit_idx)) {
> +			WARN(1, "%s is on but IDDQ set\n", name);
> +			kfree(pll);
> +			return ERR_PTR(-EINVAL);
> +		}
> +	} else
> +		val |= BIT(pll_params->iddq_bit_idx);
> +
> +	val &= ~BIT(24); /* disable lock override */

Could use a symbolic name as well. PLLS_LOCK_OVERRIDE?

> +	pll_writel_base(val, pll);
> +
> +	clk = _tegra_clk_register_pll(pll, name, parent_name, flags,
> +					&tegra_clk_pllss_ops);
> +
> +	if (IS_ERR(clk))

I'd remove the blank line between the above two here as well.

> +struct clk *tegra_clk_register_pllss(const char *name, const char *parent_name,
> +			   void __iomem *clk_base, unsigned long flags,
> +			   unsigned long fixed_rate,
> +			   struct tegra_clk_pll_params *pll_params,
> +			   struct tegra_clk_pll_freq_table *freq_table,
> +			   spinlock_t *lock);

Nit: Parameter alignment looks funky here. I think you should either
align them with the first argument on the first line or use only tabs to
indent. Given that you don't align them anywhere else, I'd suggest using
the latter for consistency.

Thierry

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSVoPTAAoJEN0jrNd/PrOhbTEP/2do2P1JjwYvyH/eIwtE3HnX
XOza2TMy1lS2fS14ueUgAPPM6VIbc5QdkBYayd09LQC9ccj3qEJ6Lb5JdvtmNLrz
ifBwakQAakmsqXpG1Dm5jbOcaEvpm06H0Diof4mAWL10W9+5cpsCN9sAslLuw1BC
kGf/IrLxq5rdOtBi04zCstnfKl7epsgvrQKC4WEodaz6VOoaRNKx7XUF+EOaU/pL
mJHlcQMJ2MyXexhmQXuNOo8PmyNegmVOd8qF08HgHrowjhFfIvyl83ndf/AlM9zz
0EPgtjfCR0bj388sWyYbixTYkSQfZAlXC6M4EMNE5a6CSmA6jpC/FN7uQaEz5QkW
GKjTiI/5yJfxqyBv3Ve+VmD4pF7j6UBQi+yjzT8vY5Cp6ntOQ8rnQ0a9e8DhMm9h
9fcEtLnuDHqvZzPhEec7m9Us+JotXfsxR9EbSXA+bH0IQQWdJSDYPTHZ7R3+e43f
Oay2NWPreREfMpV6O2DVdYfVks8XVmNoIEtaYAU6FLid6SuUBZDvRj838KKx3hNl
qCOkMBcZ3agAlT0vf/bBtjpWZzK11Jc8zLeEI4qWd5TnSXJ5ALSbtqURoh+WdYdj
Ba0Add3xabiJFxoAdaiDINRWccvmNEiKDD8UAC0SKYoxHgZoEC+Suv/NzNUhd62G
odLqR3qq6zrFrbA8HOr2
=P9h8
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
