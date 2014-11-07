Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaKGS65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:58:57 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:59564 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752106AbaKGS64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:58:56 -0500
Date: Fri, 7 Nov 2014 18:58:44 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Doug Anderson <dianders@chromium.org>
Cc: Mike Turquette <mturquette@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: Propagate prepare and enable when reparenting
 orphans
Message-ID: <20141107185844.GR4042@n2100.arm.linux.org.uk>
References: <1415386312-23741-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415386312-23741-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 10:51:52AM -0800, Doug Anderson wrote:
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 4896ae9..a3d3d58 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1650,6 +1650,17 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
>  	clk_reparent(clk, new_parent);
>  	__clk_recalc_accuracies(clk);
>  	__clk_recalc_rates(clk, POST_RATE_CHANGE);
> +
> +	if (clk->prepare_count) {
> +		unsigned long flags;
> +
> +		__clk_prepare(new_parent);
> +
> +		flags = clk_enable_lock();
> +		if (clk->enable_count)
> +			__clk_enable(new_parent);
> +		clk_enable_unlock(flags);
> +	}

I really don't understand why this isn't already done - I said this was
necessary a /long/ time ago.

However, the above isn't sufficient.  Think about the old parent - this
should be disabled and unprepared if it was prepared and enabled by the
child.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
