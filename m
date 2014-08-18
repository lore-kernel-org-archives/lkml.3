Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaHRMCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 08:02:22 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:36470 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaHRMCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 08:02:20 -0400
Message-ID: <53F1EB45.3060103@gmail.com>
Date: Mon, 18 Aug 2014 14:02:13 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Humberto Silva Naves <hsnaves@gmail.com>,
        linux-samsung-soc@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 1/2] clk: samsung: Add validation of rate tables for the
 PLL clocks
References: <1407160968-12108-1-git-send-email-hsnaves@gmail.com> <1407160968-12108-2-git-send-email-hsnaves@gmail.com>
In-Reply-To: <1407160968-12108-2-git-send-email-hsnaves@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Humberto,

Sorry for long delay, I've been quite busy with certain things and I
couldn't reply earlier.

Thanks a lot for the patch. In general it looks very nice and finally
makes the semantics of this code sane, but please see few minor comments
inline.

On 04.08.2014 16:02, Humberto Silva Naves wrote:
> Currently there is no mechanism for validation of the PLL rate tables
> in the samsung clock driver. In addition, the implementation does not
> allow the use ``heterogenous'' tables (i.e., tables whose entries can
> correspond to different clock sources).
> For instance, consider the VPLL clock from Exynos5410. Its input source
> is the MUX mout_vpllsrc, which can generate either 24 MHz or 27 MHz.
> The usual way to add rate tables for these two different clock sources
> would be:

[snip]

> +	PLL_36XX_RATE(148500000, 24000000,  99, 2, 3,     0),
> +	PLL_36XX_RATE(148352005, 24000000,  98, 2, 3, 59070),
> +	PLL_36XX_RATE(108000000, 24000000, 144, 2, 4,     0),
> +	PLL_36XX_RATE( 74250000, 24000000,  99, 2, 4,     0),
> +	PLL_36XX_RATE( 74176002, 24000000,  98, 3, 4, 59070),
> +	PLL_36XX_RATE( 54054000, 24000000, 216, 3, 5, 14156),
> +	PLL_36XX_RATE( 54000000, 24000000, 144, 2, 5,     0),
>  	{ /* sentinel */ }
>  };

This patch could be split into two or more smaller patches, because it's
so big that it's quite hard to review.

For example, the extension of struct samsung_pll_rate_table and related
macros along with related rate tables in SoC drivers could be patch 1
(even though nothing would use the new data yet, nothing would break),
then patch 2 could contain changes to the PLL framework and finally
patch 3 could remove the conditional assignments of rate tables in SoC
drivers.

>  
>  static struct samsung_pll_clock exynos3250_plls[nr_plls] __initdata = {

[snip]

> @@ -1144,6 +1235,121 @@ static const struct clk_ops samsung_pll2650xx_clk_min_ops = {
>  	.recalc_rate = samsung_pll2650xx_recalc_rate,
>  };
>  
> +static unsigned long __init
> +_samsung_clk_rate_from_table(struct samsung_pll_rate_table *entry,
> +				enum samsung_pll_type type)
> +{
> +	unsigned long parent_rate;
> +	u32 pdiv, mdiv, sdiv;
> +
> +	parent_rate = (unsigned long) entry->brate;
> +	pdiv = (u32) entry->pdiv;
> +	mdiv = (u32) entry->mdiv;
> +	sdiv = (u32) entry->sdiv;
> +
> +	switch (type) {
> +	case pll_2126:
> +		return _samsung_pll2126_rate(parent_rate, mdiv, pdiv, sdiv);

[snip]

> +	case pll_2650xx:
> +		return _samsung_pll2650xx_rate(parent_rate, mdiv, pdiv, sdiv,
> +					(s16) entry->kdiv);
> +	default:
> +		pr_warn("%s: cannot compute rate for pll type %d\n",
> +			__func__, type);
> +		return 0;
> +	}
> +}

I think it might be a bit cleaner to just save respective function in a
new field of samsung_clk_pll struct. This would be facilitated by
_samsung_clk_register_pll() function which already has a big switch over
pll_clk->type, so you could just stuff there proper assignments. Then
_samsung_clk_rate_from_table() would take struct samsung_clk_pll *
instead of pll type and call the function from the stored pointer.

> +
> +/* used for sorting the pll rate table */
> +static int __init _samsung_clk_cmp_rates(const void *p1, const void *p2)
> +{
> +	const struct samsung_pll_rate_table *e1 = p1;
> +	const struct samsung_pll_rate_table *e2 = p2;
> +
> +	/* sorting in descending order */
> +	if (e1->orate > e2->orate)
> +		return -1;
> +	else if (e1->orate == e2->orate)
> +		return 0;
> +	else
> +		return 1;
> +}
> +
> +static const struct samsung_pll_rate_table * __init
> +_samsung_clk_copy_rate_table(struct samsung_pll_clock *pll_clk,
> +			unsigned int *rate_count)
> +{
> +	struct samsung_pll_rate_table *tbl;
> +	unsigned int i, len;
> +
> +	/* find count of rates in rate_table (at last entry, brate = 0) */
> +	for (len = 0; pll_clk->rate_table[len].brate != 0; )
> +		len++;
> +
> +	tbl = kmemdup(pll_clk->rate_table, len *
> +			sizeof(struct samsung_pll_rate_table), GFP_KERNEL);
> +	if (!tbl)
> +		return NULL;
> +
> +	/* validate the entries in the table */
> +	for (i = 0; i < len; i++) {
> +		unsigned long orate;
> +		orate = _samsung_clk_rate_from_table(&tbl[i], pll_clk->type);
> +		if ((unsigned int) orate != tbl[i].orate) {
> +			pr_warn("%s: invalid entry in table: out_rate=%u"
> +				" base_rate=%u, replacing with out_rate=$u\n",
> +				__func__, tbl[i].orate, tbl[i].brate);
> +			tbl[i].orate = orate;

I wonder if we shouldn't rather disable such entry completely, e.g. by
assigning 0 to orate (your code below already accounts for such
entries). The rationale behind this idea is that if an entry has
incorrect orate, then it's quite likely that prate or coefficients are
wrong too.

> +		}
> +	}
> +
> +	/* sort in descending order according to output_rate */
> +	sort(tbl, len, sizeof(*tbl), &_samsung_clk_cmp_rates, NULL);

No need for & in case of function pointers.

> +
> +	/* discard invalid entries */
> +	while (len > 0)
> +		if (tbl[len - 1].orate == 0)
> +			len--;
> +
> +	if (rate_count)

What is the reason to make rate_count optional? IMHO the function could
be specified to require a valid pointer. Or maybe even better: What
about changing it to return an integer error and make it take a pointer
to struct samsung_clk_pll as its argument instead and change its fields
directly?

> +		*rate_count = len;
> +
> +	return tbl;
> +}
> +
>  static void __init _samsung_clk_register_pll(struct samsung_clk_provider *ctx,
>  				struct samsung_pll_clock *pll_clk,
>  				void __iomem *base)

[snip]
		\
> @@ -83,10 +88,9 @@ enum samsung_pll_type {
>  		.vsel	=	(_vsel),			\
>  	}
>  
> -/* NOTE: Rate table should be kept sorted in descending order. */
> -
>  struct samsung_pll_rate_table {
> -	unsigned int rate;
> +	unsigned int orate;		/* output rate */
> +	unsigned int brate;		/* the base rate */

nit: prate (as for parent rate) would be more consistent with what is
already used in clock code.

Best regards,
Tomasz
