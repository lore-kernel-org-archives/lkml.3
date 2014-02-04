Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbaBDJFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 04:05:17 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:22655 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaBDJFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 04:05:02 -0500
Message-ID: <52F0AD31.6060200@atmel.com>
Date: Tue, 4 Feb 2014 10:04:49 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Mike Turquette <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] clk: at91: replace prog clk round_rate with determine_rate
References: <1391426731-9392-1-git-send-email-b.brezillon@overkiz.com> <1391426731-9392-3-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1391426731-9392-3-git-send-email-b.brezillon@overkiz.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2014 12:25, Boris BREZILLON :
> Implement the determine_rate callback to choose the best parent clk that
> fulfills the requested rate.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Nice feature, thanks!

> ---
>  drivers/clk/at91/clk-programmable.c |   56 +++++++++++++++++------------------
>  1 file changed, 28 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/clk/at91/clk-programmable.c b/drivers/clk/at91/clk-programmable.c
> index 02f62a0..8e242c7 100644
> --- a/drivers/clk/at91/clk-programmable.c
> +++ b/drivers/clk/at91/clk-programmable.c
> @@ -105,40 +105,40 @@ static unsigned long clk_programmable_recalc_rate(struct clk_hw *hw,
>  	return parent_rate >> prog->pres;
>  }
>  
> -static long clk_programmable_round_rate(struct clk_hw *hw, unsigned long rate,
> -					unsigned long *parent_rate)
> +static long clk_programmable_determine_rate(struct clk_hw *hw,
> +					    unsigned long rate,
> +					    unsigned long *best_parent_rate,
> +					    struct clk **best_parent_clk)
>  {
> -	unsigned long best_rate = *parent_rate;
> -	unsigned long best_diff;
> -	unsigned long new_diff;
> -	unsigned long cur_rate;
> -	int shift = shift;
> -
> -	if (rate > *parent_rate)
> -		return *parent_rate;
> -	else
> -		best_diff = *parent_rate - rate;
> -
> -	if (!best_diff)
> -		return best_rate;
> +	struct clk *parent = NULL;
> +	long best_rate = -EINVAL;
> +	unsigned long parent_rate;
> +	unsigned long tmp_rate;
> +	int shift;
> +	int i;
>  
> -	for (shift = 1; shift < PROG_PRES_MASK; shift++) {
> -		cur_rate = *parent_rate >> shift;
> +	for (i = 0; i < __clk_get_num_parents(hw->clk); i++) {
> +		parent = clk_get_parent_by_index(hw->clk, i);
> +		if (!parent)
> +			continue;
>  
> -		if (cur_rate > rate)
> -			new_diff = cur_rate - rate;
> -		else
> -			new_diff = rate - cur_rate;
> +		parent_rate = __clk_get_rate(parent);
> +		for (shift = 0; shift < PROG_PRES_MASK; shift++) {
> +			tmp_rate = parent_rate >> shift;
> +			if (tmp_rate <= rate)
> +				break;
> +		}
>  
> -		if (!new_diff)
> -			return cur_rate;
> +		if (tmp_rate > rate)
> +			continue;
>  
> -		if (new_diff < best_diff) {
> -			best_diff = new_diff;
> -			best_rate = cur_rate;
> +		if (best_rate < 0 || (rate - tmp_rate) < (rate - best_rate)) {
> +			best_rate = tmp_rate;
> +			*best_parent_rate = parent_rate;
> +			*best_parent_clk = parent;
>  		}
>  
> -		if (rate > cur_rate)
> +		if (!best_rate)
>  			break;
>  	}
>  
> @@ -231,7 +231,7 @@ static const struct clk_ops programmable_ops = {
>  	.prepare = clk_programmable_prepare,
>  	.is_prepared = clk_programmable_is_ready,
>  	.recalc_rate = clk_programmable_recalc_rate,
> -	.round_rate = clk_programmable_round_rate,
> +	.determine_rate = clk_programmable_determine_rate,
>  	.get_parent = clk_programmable_get_parent,
>  	.set_parent = clk_programmable_set_parent,
>  	.set_rate = clk_programmable_set_rate,
> 


-- 
Nicolas Ferre
