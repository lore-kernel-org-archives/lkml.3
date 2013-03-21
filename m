Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab3CUSJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:09:38 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48152 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382Ab3CUSJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:09:37 -0400
Date: Thu, 21 Mar 2013 18:09:22 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv3 01/10] clocksource: add generic dummy timer driver
Message-ID: <20130321180922.GB10716@e106331-lin.cambridge.arm.com>
References: <1363198676-30417-1-git-send-email-sboyd@codeaurora.org>
 <1363198676-30417-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363198676-30417-2-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

I've just been trying to test the dummy timer, and realised it's broken, as it
registers a cpu notifier from a device_initcall (after SMP's been brought up),
and doesn't ensure all active CPUs have been set up. Evidently no-one else has
attempted to test it thus far, and I'm not able to throughly test it at the
moment.

For now I'd recommend going back to the rearranging the existing arm
implementation as you had in v1. We seem to have ironed out the kinks with
having a simultaneous arch_timer and dummy, so I don't imagine we'll have major
issues taking that route.

Thanks,
Mark.

On Wed, Mar 13, 2013 at 06:17:47PM +0000, Stephen Boyd wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> Several architectures have a dummy timer driver tightly coupled with
> their broadcast code to support machines without cpu-local timers (or
> where there is a lack of driver support).
> 
> Since 12ad100046: "clockevents: Add generic timer broadcast function"
> it's been possible to write broadcast-capable timer drivers decoupled
> from the broadcast mechanism. We can use this functionality to implement
> a generic dummy timer driver that can be shared by all architectures
> with generic tick broadcast (ARCH_HAS_TICK_BROADCAST).
> 
> This patch implements a generic dummy timer using this facility.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> [sboyd: Make percpu data static and use __this_cpu_ptr()]
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/clocksource/Makefile      |  1 +
>  drivers/clocksource/dummy_timer.c | 67 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 68 insertions(+)
>  create mode 100644 drivers/clocksource/dummy_timer.c
> 
> diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
> index 4d8283a..655d718 100644
> --- a/drivers/clocksource/Makefile
> +++ b/drivers/clocksource/Makefile
> @@ -22,3 +22,4 @@ obj-$(CONFIG_VT8500_TIMER)	+= vt8500_timer.o
>  
>  obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
>  obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
> +obj-$(CONFIG_ARCH_HAS_TICK_BROADCAST)	+= dummy_timer.o
> diff --git a/drivers/clocksource/dummy_timer.c b/drivers/clocksource/dummy_timer.c
> new file mode 100644
> index 0000000..7e1ce45
> --- /dev/null
> +++ b/drivers/clocksource/dummy_timer.c
> @@ -0,0 +1,67 @@
> +/*
> + *  linux/drivers/clocksource/dummy_timer.c
> + *
> + *  Copyright (C) 2013 ARM Ltd.
> + *  All Rights Reserved
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#include <linux/clockchips.h>
> +#include <linux/cpu.h>
> +#include <linux/init.h>
> +#include <linux/percpu.h>
> +
> +static DEFINE_PER_CPU(struct clock_event_device, dummy_timer_evt);
> +
> +static void dummy_timer_set_mode(enum clock_event_mode mode,
> +			   struct clock_event_device *evt)
> +{
> +	/*
> +	 * Core clockevents code will call this when exchanging timer devices.
> +	 * We don't need to do anything here.
> +	 */
> +}
> +
> +static void __cpuinit dummy_timer_setup(void)
> +{
> +	int cpu = smp_processor_id();
> +	struct clock_event_device *evt = __this_cpu_ptr(&dummy_timer_evt);
> +
> +	evt->name	= "dummy_timer";
> +	evt->features	= CLOCK_EVT_FEAT_PERIODIC |
> +			  CLOCK_EVT_FEAT_ONESHOT |
> +			  CLOCK_EVT_FEAT_DUMMY;
> +	evt->rating	= 100;
> +	evt->set_mode	= dummy_timer_set_mode;
> +	evt->cpumask	= cpumask_of(cpu);
> +
> +	clockevents_register_device(evt);
> +}
> +
> +static int __cpuinit dummy_timer_cpu_notify(struct notifier_block *self,
> +				      unsigned long action, void *hcpu)
> +{
> +	if ((action & ~CPU_TASKS_FROZEN) == CPU_STARTING)
> +		dummy_timer_setup();
> +
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block dummy_timer_cpu_nb __cpuinitdata = {
> +	.notifier_call = dummy_timer_cpu_notify,
> +};
> +
> +static int __init dummy_timer_register(void)
> +{
> +	int err = register_cpu_notifier(&dummy_timer_cpu_nb);
> +	if (err)
> +		return err;
> +
> +	/* We won't get a call on the boot CPU, so register immediately */
> +	dummy_timer_setup();
> +
> +	return 0;
> +}
> +device_initcall(dummy_timer_register);
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> 
