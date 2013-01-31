Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab3AaFVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 00:21:14 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:46954 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab3AaFVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 00:21:11 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-cd-5109ff46bb8a
From: Namhyung Kim <namhyung@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        tglx@linutronix.de
Subject: Re: [RFC 1/2] cpuidle: trace state of the CPU
References: <1359580757-4121-1-git-send-email-bigeasy@linutronix.de>
	<1359580757-4121-2-git-send-email-bigeasy@linutronix.de>
Date: Thu, 31 Jan 2013 14:21:10 +0900
In-Reply-To: <1359580757-4121-2-git-send-email-bigeasy@linutronix.de>
	(Sebastian Andrzej Siewior's message of "Wed, 30 Jan 2013 22:19:16
	+0100")
Message-ID: <87y5faszax.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2013 22:19:16 +0100, Sebastian Andrzej Siewior wrote:
> This patch adds an interface to cpuidle in order to retrieve the current
> idle state of a given CPU. Zero means the CPU is not in an idle state. Either
> because a cpuidle driver is not available or because the CPU is busy
> executing code. Values greater than zero the CPU indicate that the CPU
> is in some kind of idle state. The larger the value, the deeper the idle
> state.
>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/cpuidle/cpuidle.c |   13 ++++++++++++-
>  include/linux/cpuidle.h   |    2 ++
>  2 files changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index e1f6860..3594e0c 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -23,6 +23,7 @@
>  #include "cpuidle.h"
>  
>  DEFINE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
> +static DEFINE_PER_CPU(unsigned int, cpu_state);

What about making it 'int' as cpuidle_get_state() returns int type?

>  
>  DEFINE_MUTEX(cpuidle_lock);
>  LIST_HEAD(cpuidle_detected_devices);
> @@ -40,13 +41,23 @@ void disable_cpuidle(void)
>  	off = 1;
>  }
>  
> +int cpuidle_get_state(int cpu)
> +{
> +	return per_cpu(cpu_state, cpu);
> +}
> +
>  static int __cpuidle_register_device(struct cpuidle_device *dev);
>  
>  static inline int cpuidle_enter(struct cpuidle_device *dev,
>  				struct cpuidle_driver *drv, int index)
>  {
>  	struct cpuidle_state *target_state = &drv->states[index];
> -	return target_state->enter(dev, drv, index);
> +	int ret;
> +
> +	per_cpu(cpu_state, smp_processor_id()) = index + 1;
> +	ret = target_state->enter(dev, drv, index);
> +	per_cpu(cpu_state, smp_processor_id()) = 0;

Maybe we can use local variable 'cpu' for this duplicated
smp_processor_id() call as it's never executed on another cpu in
between?

Thanks,
Namhyung


> +	return ret;
>  }
>  
>  static inline int cpuidle_enter_tk(struct cpuidle_device *dev,
> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
> index 24cd1037..256baeb 100644
> --- a/include/linux/cpuidle.h
> +++ b/include/linux/cpuidle.h
> @@ -155,6 +155,7 @@ extern int cpuidle_wrap_enter(struct cpuidle_device *dev,
>  				struct cpuidle_driver *drv, int index,
>  				int (*enter)(struct cpuidle_device *dev,
>  					struct cpuidle_driver *drv, int index));
> +extern int cpuidle_get_state(int cpu);
>  extern int cpuidle_play_dead(void);
>  
>  extern struct cpuidle_driver *cpuidle_get_cpu_driver(struct cpuidle_device *dev);
> @@ -186,6 +187,7 @@ static inline int cpuidle_wrap_enter(struct cpuidle_device *dev,
>  				int (*enter)(struct cpuidle_device *dev,
>  					struct cpuidle_driver *drv, int index))
>  { return -ENODEV; }
> +static inline int cpuidle_get_state(int cpu) {return 0; }
>  static inline int cpuidle_play_dead(void) {return -ENODEV; }
>  #endif
