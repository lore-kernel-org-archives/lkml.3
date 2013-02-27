Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab3B0FcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 00:32:03 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42356 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab3B0Fbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 00:31:53 -0500
Message-ID: <512D9A8F.3080305@ti.com>
Date: Wed, 27 Feb 2013 11:03:03 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: <john.stultz@linaro.org>, <tglx@linutronix.de>, <viresh.kumar@linaro.org>,
        <jacob.jun.pan@linux.intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linaro-kernel@lists.linaro.org>,
        <patches@linaro.org>, <linus.walleij@stericsson.com>
Subject: Re: [PATCH 2/4] time : set broadcast irq affinity
References: <1361917047-29230-1-git-send-email-daniel.lezcano@linaro.org> <1361917047-29230-3-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1361917047-29230-3-git-send-email-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 February 2013 03:47 AM, Daniel Lezcano wrote:
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
> to specify which clocksource can handle it.
>
Minor. Can mention the flag name as well here "CLOCK_EVT_FEAT_DYNIRQ"

> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---
>   include/linux/clockchips.h   |    1 +
>   kernel/time/tick-broadcast.c |   39 ++++++++++++++++++++++++++++++++-------
>   2 files changed, 33 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
> index 6634652..c256cea 100644
> --- a/include/linux/clockchips.h
> +++ b/include/linux/clockchips.h
> @@ -54,6 +54,7 @@ enum clock_event_nofitiers {
>    */
>   #define CLOCK_EVT_FEAT_C3STOP		0x000008
>   #define CLOCK_EVT_FEAT_DUMMY		0x000010
> +#define CLOCK_EVT_FEAT_DYNIRQ		0x000020
>
Please add some comments about the usage of the flag.

>   /**
>    * struct clock_event_device - clock event device descriptor
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index 6197ac0..1f7b4f4 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -406,13 +406,36 @@ struct cpumask *tick_get_broadcast_oneshot_mask(void)
>   	return to_cpumask(tick_broadcast_oneshot_mask);
>   }
>
> -static int tick_broadcast_set_event(struct clock_event_device *bc,
> +/*
> + * Set broadcast interrupt affinity
> + */
> +static void tick_broadcast_set_affinity(struct clock_event_device *bc, int cpu)
> +{
Better is just make second parameter as cpu_mask rather than CPU
cpu number. Its a semantic of affinity hook which you can easily retain.

> +	if (!(bc->features & CLOCK_EVT_FEAT_DYNIRQ))
> +		return;
> +
> +	if (cpumask_equal(bc->cpumask, cpumask_of(cpu)))
> +		return;
> +
> +	bc->cpumask = cpumask_of(cpu);
You can avoid the cpumask_of() couple of times above.

> +	irq_set_affinity(bc->irq, bc->cpumask);
> +}
> +
> +static int tick_broadcast_set_event(struct clock_event_device *bc, int cpu,
>   				    ktime_t expires, int force)
>   {
> +	int ret;
> +
>   	if (bc->mode != CLOCK_EVT_MODE_ONESHOT)
>   		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
>
> -	return clockevents_program_event(bc, expires, force);
> +	ret = clockevents_program_event(bc, expires, force);
> +	if (ret)
> +		return ret;
> +
> +	tick_broadcast_set_affinity(bc, cpu);
In case you go by cpumask paramater, then above can be just
tick_broadcast_set_affinity(bc, cpumask_of(cpu));

> +
> +	return 0;
>   }
>
>   int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
> @@ -441,7 +464,7 @@ static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
>   {
>   	struct tick_device *td;
>   	ktime_t now, next_event;
> -	int cpu;
> +	int cpu, next_cpu;
>
>   	raw_spin_lock(&tick_broadcast_lock);
>   again:
> @@ -454,8 +477,10 @@ again:
>   		td = &per_cpu(tick_cpu_device, cpu);
>   		if (td->evtdev->next_event.tv64 <= now.tv64)
>   			cpumask_set_cpu(cpu, to_cpumask(tmpmask));
> -		else if (td->evtdev->next_event.tv64 < next_event.tv64)
> +		else if (td->evtdev->next_event.tv64 < next_event.tv64) {
>   			next_event.tv64 = td->evtdev->next_event.tv64;
> +			next_cpu = cpu;
> +		}
>   	}
>
>   	/*
> @@ -478,7 +503,7 @@ again:
>   		 * Rearm the broadcast device. If event expired,
>   		 * repeat the above
>   		 */
> -		if (tick_broadcast_set_event(dev, next_event, 0))
> +		if (tick_broadcast_set_event(dev, next_cpu, next_event, 0))
>   			goto again;
>   	}
>   	raw_spin_unlock(&tick_broadcast_lock);
> @@ -521,7 +546,7 @@ void tick_broadcast_oneshot_control(unsigned long reason)
>   			cpumask_set_cpu(cpu, tick_get_broadcast_oneshot_mask());
>   			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
>   			if (dev->next_event.tv64 < bc->next_event.tv64)
> -				tick_broadcast_set_event(bc, dev->next_event, 1);
> +				tick_broadcast_set_event(bc, cpu, dev->next_event, 1);
Since you have embedded the irq_affinity() in above function,
the IRQ affinity for bc->irq will remain to the last CPU
on which the interrupt fired. In general it should be fine
but would be good if you clear it on
CLOCK_EVT_NOTIFY_BROADCAST_EXIT. Not a must have though.

Regards,
Santosh
