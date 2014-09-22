Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaIVTSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:18:20 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55840 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbaIVTSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:18:18 -0400
Date: Mon, 22 Sep 2014 12:18:16 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Tero Kristo <t-kristo@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, tony@atomide.com,
        nm@ti.com, mturquette@linaro.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: prevent erronous parsing of children during rate
 change
Message-ID: <20140922191816.GF10233@codeaurora.org>
References: <1408628866-32351-1-git-send-email-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408628866-32351-1-git-send-email-t-kristo@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, Tero Kristo wrote:
> In some cases, clocks can switch their parent with clk_set_rate, for
> example clk_mux can do this in some cases. Current implementation of
> clk_change_rate uses un-safe list iteration on the clock children, which
> will cause wrong clocks to be parsed in case any of the clock children
> change their parents during the change rate operation. Fixed by using
> the safe list iterator instead.
> 
> The problem was detected due to some divide by zero errors generated
> by clock init on dra7-evm board, see discussion under
> http://article.gmane.org/gmane.linux.ports.arm.kernel/349180 for details.
> 
> Signed-off-by: Tero Kristo <t-kristo@ti.com>
> To: Mike Turquette <mturquette@linaro.org>
> Reported-by: Nishanth Menon <nm@ti.com>
> ---
>  drivers/clk/clk.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index b76fa69..bacc06f 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1467,6 +1467,7 @@ static struct clk *clk_propagate_rate_change(struct clk *clk, unsigned long even
>  static void clk_change_rate(struct clk *clk)
>  {
>  	struct clk *child;
> +	struct hlist_node *tmp;
>  	unsigned long old_rate;
>  	unsigned long best_parent_rate = 0;
>  	bool skip_set_rate = false;
> @@ -1502,7 +1503,11 @@ static void clk_change_rate(struct clk *clk)
>  	if (clk->notifier_count && old_rate != clk->rate)
>  		__clk_notify(clk, POST_RATE_CHANGE, old_rate, clk->rate);
>  
> -	hlist_for_each_entry(child, &clk->children, child_node) {
> +	/*
> +	 * Use safe iteration, as change_rate can actually swap parents
> +	 * for certain clock types.
> +	 */
> +	hlist_for_each_entry_safe(child, tmp, &clk->children, child_node) {
>  		/* Skip children who will be reparented to another clock */
>  		if (child->new_parent && child->new_parent != clk)
>  			continue;

Are we not hitting the new_parent check here? I don't understand
how we can be changing parents here unless the check is being
avoided, in which case I wonder why determine_rate isn't being
used.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
