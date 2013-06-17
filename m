Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab3FQOyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 10:54:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43482 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750903Ab3FQOyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 10:54:13 -0400
Date: Mon, 17 Jun 2013 15:53:52 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "shinya.kuribayashi.px@renesas.com" 
	<shinya.kuribayashi.px@renesas.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH/RFC] arm: arch_timer: Do not set C3STOP in case
 CPU_IDLE=n
Message-ID: <20130617145352.GG6809@e106331-lin.cambridge.arm.com>
References: <20130617002056.7646.54131.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617002056.7646.54131.sendpatchset@w520>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 01:20:56AM +0100, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Modify the ARM architected timer driver to not set C3STOP
> in case CPU_IDLE is disabled. This is a short term fix that
> allows use of high resolution timers even though no additional
> clock event is registered.
> 
> Not-really-Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  If someone cares about this case then perhaps it should be
>  moved up to the clock event main code. The same issue should
>  in theory trigger on all architectures, perhaps x86 people
>  hunting for low latency may try to disable CPU_IDLE?

I think that changing tick_is_oneshot_capable and friends to only worry about
C3STOP when CPU_IDLE is enabled would be a nicer solution. That way you enable
all clock_event_devices with C3STOP to function as high resolution timers when
CPU_IDLE's selected. Presenting the hardware differently depending on CPU_IDLE
feels wrong.

Having some other clock_event_device would be a nicer solution still.

Thanks,
Mark.

> 
>  I propose carrying this patch locally to enable high resolution
>  timers until CPU_IDLE and an additional clock event is supported.
> 
>  Observed on r8a73a4 and APE6EVM.
> 
>  drivers/clocksource/arm_arch_timer.c |   18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> --- 0001/drivers/clocksource/arm_arch_timer.c
> +++ work/drivers/clocksource/arm_arch_timer.c	2013-06-17 09:03:44.000000000 +0900
> @@ -125,7 +125,23 @@ static int arch_timer_set_next_event_phy
>  
>  static int __cpuinit arch_timer_setup(struct clock_event_device *clk)
>  {
> -	clk->features = CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_C3STOP;
> +	clk->features = CLOCK_EVT_FEAT_ONESHOT;
> +#ifdef CONFIG_CPU_IDLE
> +	/* By not setting the C3STOP flag it is possible to let the
> +	 * ARM architected timer to be the only clock event installed
> +	 * on the system and have working high resolution timers.
> +	 *
> +	 * If the C3STOP flag is set unconditionally then the kernel
> +	 * will always prevent using the high resoultion timer feature
> +	 * unless an additional clock event is registered.
> +	 *
> +	 * In the case where CPU_IDLE is enabled then there is a chance
> +	 * that deeper sleep states will be handled by software, but
> +	 * if CPU_IDLE is disabled then deep sleep states cannot be
> +	 * entered and the feature flagged by C3STOP is not needed.
> +	 */
> +	clk->features |= CLOCK_EVT_FEAT_C3STOP;
> +#endif
>  	clk->name = "arch_sys_timer";
>  	clk->rating = 450;
>  	if (arch_timer_use_virtual) {
> 
