Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbbAIOuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:50:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50312 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbbAIOuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:50:21 -0500
Message-ID: <1420815016.3914.16.camel@pengutronix.de>
Subject: Re: [PATCH v2] clk: Do not complain about correctly set read-only
 muxes when assigning clock parents from device tree
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Date: Fri, 09 Jan 2015 15:50:16 +0100
In-Reply-To: <54AEF788.3060401@codeaurora.org>
References: <1420559120-17405-1-git-send-email-p.zabel@pengutronix.de>
	 <54AEF788.3060401@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Am Donnerstag, den 08.01.2015, 13:32 -0800 schrieb Stephen Boyd:
[...]
> Why not do this in the core? As far as I can tell other drivers could
> run into the same problem, no? Does this work?
> 
> -----8<-------
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index f4963b7d4e17..3278645f4729 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1677,16 +1677,18 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
>  	if (!clk)
>  		return 0;
>  
> -	/* verify ops for for multi-parent clks */
> -	if ((clk->num_parents > 1) && (!clk->ops->set_parent))
> -		return -ENOSYS;
> -
>  	/* prevent racing with updates to the clock topology */
>  	clk_prepare_lock();
>  
>  	if (clk->parent == parent)
>  		goto out;
>  
> +	/* verify ops for for multi-parent clks */
> +	if ((clk->num_parents > 1) && (!clk->ops->set_parent)) {
> +		ret = -ENOSYS;
> +		goto out;
> +	}
> +
>  	/* check that we are allowed to re-parent if the clock is in use */
>  	if ((clk->flags & CLK_SET_PARENT_GATE) && clk->prepare_count) {
>  		ret = -EBUSY;

"[PATCH] clk: make set_parent succeed for any clock if the parent to be
set is the same as the current parent" ?

It works, but it also changes the API, as it makes
   clk_set_parent(some_non_mux, its_current_parent)
succeed instead of return -ENOSYS.

regards
Philipp

