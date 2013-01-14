Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139Ab3ANWhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 17:37:47 -0500
Received: from eso.teric.us ([69.164.192.171]:59605 "EHLO eso.teric.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757717Ab3ANWhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 17:37:45 -0500
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jan 2013 17:37:45 EST
Date: Mon, 14 Jan 2013 16:32:20 -0600
From: Josh Cartwright <joshc@eso.teric.us>
To: Cong Ding <dinggnu@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        John Linn <john.linn@xilinx.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: mach-zynq/timer.c: fix memory leakage
Message-ID: <20130114223220.GC28312@kryptos>
References: <1358198331-31949-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358198331-31949-1-git-send-email-dinggnu@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 10:18:46PM +0100, Cong Ding wrote:
> the variable ttccs allocated isn't freed when error occurs, so we call kfree
> before return.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  arch/arm/mach-zynq/timer.c |   25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/mach-zynq/timer.c b/arch/arm/mach-zynq/timer.c
> index f9fbc9c..df04761 100644
> --- a/arch/arm/mach-zynq/timer.c
> +++ b/arch/arm/mach-zynq/timer.c
> @@ -203,15 +203,15 @@ static void __init zynq_ttc_setup_clocksource(struct device_node *np,
>  
>  	err = of_property_read_u32(np, "reg", &reg);
>  	if (WARN_ON(err))
> -		return;
> +		goto out;
>  
>  	clk = of_clk_get_by_name(np, "cpu_1x");
>  	if (WARN_ON(IS_ERR(clk)))
> -		return;
> +		goto out;
>  
>  	err = clk_prepare_enable(clk);
>  	if (WARN_ON(err))
> -		return;
> +		goto out;
>  
>  	ttccs->xttc.base_addr = base + reg * 4;
>  
> @@ -229,7 +229,10 @@ static void __init zynq_ttc_setup_clocksource(struct device_node *np,
>  
>  	err = clocksource_register_hz(&ttccs->cs, clk_get_rate(clk) / PRESCALE);
>  	if (WARN_ON(err))
> -		return;
> +		goto out;
> +	return;
> +out:
> +	kfree(ttccs);
>  }

Okay...hmm.  If initialization of the timer fails, you'll have bigger
issues then just a small memory leak.  Especially since right now the
TTC is the only supported timer on zynq.

But okay, to be forward looking we should probably properly handle these
error cases.

You've only handled the memory leak here, but there are other potential
leaks that you should be handling (the clk handle, clock event
interrupt, ioremap()'d region, etc).  Could you take care of those while
your at it?

   Josh
