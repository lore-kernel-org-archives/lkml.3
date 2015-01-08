Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbbAHVc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 16:32:59 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36705 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbbAHVc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 16:32:57 -0500
Message-ID: <54AEF788.3060401@codeaurora.org>
Date: Thu, 08 Jan 2015 13:32:56 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mike Turquette <mturquette@linaro.org>
CC: linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH v2] clk: Do not complain about correctly set read-only
 muxes when assigning clock parents from device tree
References: <1420559120-17405-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1420559120-17405-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2015 07:45 AM, Philipp Zabel wrote:
> diff --git a/drivers/clk/clk-conf.c b/drivers/clk/clk-conf.c
> index aad4796..bb4dc02 100644
> --- a/drivers/clk/clk-conf.c
> +++ b/drivers/clk/clk-conf.c
> @@ -62,10 +62,13 @@ static int __set_clk_parents(struct device_node *node, bool clk_supplier)
>  			goto err;
>  		}
>  
> -		rc = clk_set_parent(clk, pclk);
> -		if (rc < 0)
> -			pr_err("clk: failed to reparent %s to %s: %d\n",
> -			       __clk_get_name(clk), __clk_get_name(pclk), rc);
> +		if (pclk != __clk_get_parent(clk)) {
> +			rc = clk_set_parent(clk, pclk);
> +			if (rc < 0)
> +				pr_err("clk: failed to reparent %s to %s: %d\n",
> +				       __clk_get_name(clk),
> +				       __clk_get_name(pclk), rc);
> +		}
>  		clk_put(clk);
>  		clk_put(pclk);
>  	}

Why not do this in the core? As far as I can tell other drivers could
run into the same problem, no? Does this work?

-----8<-------

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index f4963b7d4e17..3278645f4729 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1677,16 +1677,18 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 	if (!clk)
 		return 0;
 
-	/* verify ops for for multi-parent clks */
-	if ((clk->num_parents > 1) && (!clk->ops->set_parent))
-		return -ENOSYS;
-
 	/* prevent racing with updates to the clock topology */
 	clk_prepare_lock();
 
 	if (clk->parent == parent)
 		goto out;
 
+	/* verify ops for for multi-parent clks */
+	if ((clk->num_parents > 1) && (!clk->ops->set_parent)) {
+		ret = -ENOSYS;
+		goto out;
+	}
+
 	/* check that we are allowed to re-parent if the clock is in use */
 	if ((clk->flags & CLK_SET_PARENT_GATE) && clk->prepare_count) {
 		ret = -EBUSY;

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

