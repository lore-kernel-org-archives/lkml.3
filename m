Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab3LKOdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 09:33:01 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43380 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab3LKOc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 09:32:59 -0500
Message-ID: <52A87799.8010300@linaro.org>
Date: Wed, 11 Dec 2013 15:32:57 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] time: Serialize calls to 'clockevents_update_freq'
 in the timing core
References: <alpine.DEB.2.02.1312071151340.30673@ionos.tec.linutronix.de> <1386635686-15686-1-git-send-email-soren.brinkmann@xilinx.com> <1386635686-15686-2-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1386635686-15686-2-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 01:34 AM, Soren Brinkmann wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
>
> We can identify the broadcast device in the core and serialize all
> callers including interrupts on a different CPU against the update.
> Also, disabling interrupts is moved into the core allowing callers to
> leave interrutps enabled when calling clockevents_update_freq().
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>   kernel/time/clockevents.c    | 29 ++++++++++++++++++++++-------
>   kernel/time/tick-broadcast.c | 25 +++++++++++++++++++------
>   kernel/time/tick-internal.h  |  4 ++++
>   3 files changed, 45 insertions(+), 13 deletions(-)
>
> diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
> index 086ad6043bcb..641d91003a45 100644
> --- a/kernel/time/clockevents.c
> +++ b/kernel/time/clockevents.c
> @@ -439,6 +439,16 @@ void clockevents_config_and_register(struct clock_event_device *dev,
>   }
>   EXPORT_SYMBOL_GPL(clockevents_config_and_register);
>
> +int __clockevents_update_freq(struct clock_event_device *dev, u32 freq)
> +{
> +	clockevents_config(dev, freq);
> +
> +	if (dev->mode != CLOCK_EVT_MODE_ONESHOT)
> +		return 0;
> +
> +	return clockevents_program_event(dev, dev->next_event, false);
> +}
> +

./arch/arm/kernel/smp_twd.c should be modified to call 
__clockevents_update_freq instead of clockevents_update_freq, no ?

>   /**
>    * clockevents_update_freq - Update frequency and reprogram a clock event device.
>    * @dev:	device to modify
> @@ -446,17 +456,22 @@ EXPORT_SYMBOL_GPL(clockevents_config_and_register);
>    *
>    * Reconfigure and reprogram a clock event device in oneshot
>    * mode. Must be called on the cpu for which the device delivers per
> - * cpu timer events with interrupts disabled!  Returns 0 on success,
> - * -ETIME when the event is in the past.
> + * cpu timer events. If called for the broadcast device the core takes
> + * care of serialization.
> + *
> + * Returns 0 on success, -ETIME when the event is in the past.
>    */
>   int clockevents_update_freq(struct clock_event_device *dev, u32 freq)
>   {
> -	clockevents_config(dev, freq);
> -
> -	if (dev->mode != CLOCK_EVT_MODE_ONESHOT)
> -		return 0;
> +	unsigned long flags;
> +	int ret;
>
> -	return clockevents_program_event(dev, dev->next_event, false);
> +	local_irq_save(flags);
> +	ret = tick_broadcast_update_freq(dev, freq);
> +	if (ret == -ENODEV)
> +		ret = __clockevents_update_freq(dev, freq);
> +	local_irq_restore(flags);
> +	return ret;
>   }
>
>   /*
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index 9532690daaa9..63a33b33fc4e 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -120,6 +120,19 @@ int tick_is_broadcast_device(struct clock_event_device *dev)
>   	return (dev && tick_broadcast_device.evtdev == dev);
>   }
>
> +int tick_broadcast_update_freq(struct clock_event_device *dev, u32 freq)
> +{
> +	int ret = -ENODEV;
> +
> +	if (tick_is_broadcast_device(dev)) {
> +		raw_spin_lock(&tick_broadcast_lock);
> +		ret = __clockevents_update_freq(dev, freq);
> +		raw_spin_unlock(&tick_broadcast_lock);
> +	}
> +	return ret;
> +}
> +
> +
>   static void err_broadcast(const struct cpumask *mask)
>   {
>   	pr_crit_once("Failed to broadcast timer tick. Some CPUs may be unresponsive.\n");
> @@ -272,12 +285,8 @@ static void tick_do_broadcast(struct cpumask *mask)
>    */
>   static void tick_do_periodic_broadcast(void)
>   {
> -	raw_spin_lock(&tick_broadcast_lock);
> -
>   	cpumask_and(tmpmask, cpu_online_mask, tick_broadcast_mask);
>   	tick_do_broadcast(tmpmask);
> -
> -	raw_spin_unlock(&tick_broadcast_lock);
>   }
>
>   /*
> @@ -287,13 +296,15 @@ static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
>   {
>   	ktime_t next;
>
> +	raw_spin_lock(&tick_broadcast_lock);
> +
>   	tick_do_periodic_broadcast();
>
>   	/*
>   	 * The device is in periodic mode. No reprogramming necessary:
>   	 */
>   	if (dev->mode == CLOCK_EVT_MODE_PERIODIC)
> -		return;
> +		goto unlock;
>
>   	/*
>   	 * Setup the next period for devices, which do not have
> @@ -306,9 +317,11 @@ static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
>   		next = ktime_add(next, tick_period);
>
>   		if (!clockevents_program_event(dev, next, false))
> -			return;
> +			goto unlock;
>   		tick_do_periodic_broadcast();
>   	}
> +unlock:
> +	raw_spin_unlock(&tick_broadcast_lock);
>   }
>
>   /*
> diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
> index 18e71f7fbc2a..22fd431a02eb 100644
> --- a/kernel/time/tick-internal.h
> +++ b/kernel/time/tick-internal.h
> @@ -111,6 +111,7 @@ extern int tick_resume_broadcast(void);
>   extern void tick_broadcast_init(void);
>   extern void
>   tick_set_periodic_handler(struct clock_event_device *dev, int broadcast);
> +int tick_broadcast_update_freq(struct clock_event_device *dev, u32 freq);
>
>   #else /* !BROADCAST */
>
> @@ -133,6 +134,8 @@ static inline void tick_shutdown_broadcast(unsigned int *cpup) { }
>   static inline void tick_suspend_broadcast(void) { }
>   static inline int tick_resume_broadcast(void) { return 0; }
>   static inline void tick_broadcast_init(void) { }
> +static inline int tick_broadcast_update_freq(struct clock_event_device *dev,
> +					     u32 freq) { return -ENODEV; }
>
>   /*
>    * Set the periodic handler in non broadcast mode
> @@ -154,4 +157,5 @@ static inline int tick_device_is_functional(struct clock_event_device *dev)
>
>   #endif
>
> +int __clockevents_update_freq(struct clock_event_device *dev, u32 freq);
>   extern void do_timer(unsigned long ticks);
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

