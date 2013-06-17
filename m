Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab3FQCMn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 22:12:43 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:52386 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab3FQCMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 22:12:41 -0400
Date: Mon, 17 Jun 2013 11:13:43 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        linux-sh@vger.kernel.org, marc.zyngier@arm.com,
        catalin.marinas@arm.com, john.stultz@linaro.org,
        shinya.kuribayashi.px@renesas.com, tglx@linutronix.de
Subject: Re: [PATCH/RFC] arm: arch_timer: Do not set C3STOP in case CPU_IDLE=n
Message-ID: <20130617021342.GJ15043@verge.net.au>
References: <20130617002056.7646.54131.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617002056.7646.54131.sendpatchset@w520>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 09:20:56AM +0900, Magnus Damm wrote:
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
> 
>  I propose carrying this patch locally to enable high resolution
>  timers until CPU_IDLE and an additional clock event is supported.
> 
>  Observed on r8a73a4 and APE6EVM.

Hi Magnus,

Is this patch intended to be picked up by me for the LTSI-3.4.25 based
backports that live in my renesas-backports tree?

If so, could you  clearly state this (below the '---' is fine) and
include a proper Sob line to indicate that it is fit to be merged
even if that merge is not into mainline.

Thanks

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
