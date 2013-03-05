Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab3CEUkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:40:24 -0500
Received: from www.linutronix.de ([62.245.132.108]:39046 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab3CEUkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:40:22 -0500
Date: Tue, 5 Mar 2013 21:40:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: john.stultz@linaro.org, viresh.kumar@linaro.org,
        jacob.jun.pan@linux.intel.com, linux-arm-kernel@lists.infradead.org,
        santosh.shilimkar@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, rickard.andersson@stericsson.com,
        vincent.guittot@linaro.org, linus.walleij@stericsson.com
Subject: Re: [PATCH 2/4][V2] time : set broadcast irq affinity
In-Reply-To: <1362219013-18173-3-git-send-email-daniel.lezcano@linaro.org>
Message-ID: <alpine.LFD.2.02.1303052135080.22263@ionos>
References: <1362219013-18173-1-git-send-email-daniel.lezcano@linaro.org> <1362219013-18173-3-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Mar 2013, Daniel Lezcano wrote:
> When a cpu goes to a deep idle state where its local timer is shutdown,
> it notifies the time frame work to use the broadcast timer instead.
> 
> Unfortunately, the broadcast device could wake up any CPU, including an
> idle one which is not concerned by the wake up at all.
> 
> This implies, in the worst case, an idle CPU will wake up to send an IPI
> to another idle cpu.
> 
> This patch solves this by setting the irq affinity to the cpu concerned
> by the nearest timer event, by this way, the CPU which is wake up is
> guarantee to be the one concerned by the next event and we are safe with
> unnecessary wakeup for another idle CPU.
> 
> As the irq affinity is not supported by all the archs, a flag is needed
> to specify which clocksource can handle it : CLOCK_EVT_FEAT_DYNIRQ
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---
>  include/linux/clockchips.h   |    5 +++++
>  kernel/time/tick-broadcast.c |   40 +++++++++++++++++++++++++++++++++-------
>  2 files changed, 38 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
> index 6634652..c93e2a6 100644
> --- a/include/linux/clockchips.h
> +++ b/include/linux/clockchips.h
> @@ -55,6 +55,11 @@ enum clock_event_nofitiers {
>  #define CLOCK_EVT_FEAT_C3STOP		0x000008
>  #define CLOCK_EVT_FEAT_DUMMY		0x000010
>  
> +/*
> + * Clock event device can set its irq affinity dynamically
> + */
> +#define CLOCK_EVT_FEAT_DYNIRQ		0x000020
> +
>  /**
>   * struct clock_event_device - clock event device descriptor
>   * @event_handler:	Assigned by the framework to be called by the low
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index 6197ac0..9ca8ff5 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -406,13 +406,37 @@ struct cpumask *tick_get_broadcast_oneshot_mask(void)
>  	return to_cpumask(tick_broadcast_oneshot_mask);
>  }
>  
> -static int tick_broadcast_set_event(struct clock_event_device *bc,
> +/*
> + * Set broadcast interrupt affinity
> + */
> +static void tick_broadcast_set_affinity(struct clock_event_device *bc,
> +					const struct cpumask *cpumask)
> +{
> +	if (!(bc->features & CLOCK_EVT_FEAT_DYNIRQ))
> +		return;
> +
> +	if (cpumask_equal(bc->cpumask, cpumask))
> +		return;
> +
> +	bc->cpumask = cpumask;

This breaks with CONFIG_CPUMASK_OFFSTACK=y. cpumask_copy() is your friend!

Thanks,

	tglx
