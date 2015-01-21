Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbbAUAOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:14:21 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33811 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbbAUAOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:14:17 -0500
Date: Tue, 20 Jan 2015 16:14:15 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v10 2/3] clk: Make clk API return per-user struct clk
 instances
Message-ID: <20150121001415.GE27202@codeaurora.org>
References: <1421760306-6301-1-git-send-email-tomeu.vizoso@collabora.com>
 <1421760306-6301-3-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421760306-6301-3-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20, Tomeu Vizoso wrote:
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 97f3425..e867d6a 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1719,6 +1817,31 @@ out:
>  
>  	return ret;
>  }
> +
> +/**
> + * clk_set_parent - switch the parent of a mux clk
> + * @clk: the mux clk whose input we are switching
> + * @parent: the new input to clk
> + *
> + * Re-parent clk to use parent as its new input source.  If clk is in
> + * prepared state, the clk will get enabled for the duration of this call. If
> + * that's not acceptable for a specific clk (Eg: the consumer can't handle
> + * that, the reparenting is glitchy in hardware, etc), use the
> + * CLK_SET_PARENT_GATE flag to allow reparenting only when clk is unprepared.
> + *
> + * After successfully changing clk's parent clk_set_parent will update the
> + * clk topology, sysfs topology and propagate rate recalculation via
> + * __clk_recalc_rates.
> + *
> + * Returns 0 on success, -EERROR otherwise.
> + */
> +int clk_set_parent(struct clk *clk, struct clk *parent)
> +{
> +	if (!clk || !parent)
> +		return 0;

This is a behavior change, although it's very possible nobody
cares besides clk.c itself. Before this change
clk_set_parent(clk, NULL) would orphan the clock and move it to
the orphan list. Now we're going to do nothing. We should keep
the original behavior, although I don't know why anybody would
want to orphan a clock from a driver. The only place I think
we're using this correctly is on the clock unregistration path.

> +
> +	return clk_core_set_parent(clk->core, parent->core);
> +}
>  EXPORT_SYMBOL_GPL(clk_set_parent);
>  
>  /**

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
