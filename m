Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbaJXPhE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:37:04 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46713 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855AbaJXPhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:37:01 -0400
Date: Fri, 24 Oct 2014 17:36:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        "linux-pm@vger.kernel.org >> Linux PM list" 
	<linux-pm@vger.kernel.org>
Subject: Re: [RFC/PATCH] PM / Sleep: Timer quiesce in freeze state
Message-ID: <20141024153656.GM12706@worktop.programming.kicks-ass.net>
References: <5446787E.60202@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5446787E.60202@linux.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 11:15:10PM +0800, Li, Aubrey wrote:
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -917,6 +917,14 @@ static void local_apic_timer_interrupt(void)
>  	 */
>  	inc_irq_stat(apic_timer_irqs);
>  
> +	/*
> +	 * if timekeeping is suspended, the clock event device will be
> +	 * suspended as well, so we are not supposed to invoke the event
> +	 * handler of clock event device.
> +	 */
> +	if (unlikely(timekeeping_suspended))
> +		return;
> +
>  	evt->event_handler(evt);
>  }
>  

How would this even happen? Didn't we just suspend the lapic?

> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> index 4ca9a33..e58d880 100644
> --- a/kernel/power/suspend.c
> +++ b/kernel/power/suspend.c
> @@ -28,16 +28,20 @@
>  #include <linux/ftrace.h>
>  #include <trace/events/power.h>
>  #include <linux/compiler.h>
> +#include <linux/stop_machine.h>
> +#include <linux/clockchips.h>
> +#include <linux/hrtimer.h>
>  
>  #include "power.h"
> +#include "../time/tick-internal.h"
> +#include "../time/timekeeping_internal.h"
>  
>  const char *pm_labels[] = { "mem", "standby", "freeze", NULL };
>  const char *pm_states[PM_SUSPEND_MAX];
>  
>  static const struct platform_suspend_ops *suspend_ops;
>  static const struct platform_freeze_ops *freeze_ops;
> -static DECLARE_WAIT_QUEUE_HEAD(suspend_freeze_wait_head);
> -static bool suspend_freeze_wake;
> +static int suspend_freeze_wake;
>  
>  void freeze_set_ops(const struct platform_freeze_ops *ops)
>  {
> @@ -48,22 +52,179 @@ void freeze_set_ops(const struct platform_freeze_ops *ops)
>  
>  static void freeze_begin(void)
>  {
> -	suspend_freeze_wake = false;
> +	suspend_freeze_wake = -1;
>  }
>  
> -static void freeze_enter(void)
> +enum freezer_state {
> +	FREEZER_NONE,
> +	FREEZER_PICK_TK,
> +	FREEZER_SUSPEND_CLKEVT,
> +	FREEZER_SUSPEND_TK,
> +	FREEZER_IDLE,
> +	FREEZER_RESUME_TK,
> +	FREEZER_RESUME_CLKEVT,
> +	FREEZER_EXIT,
> +};
> +
> +struct freezer_data {
> +	int			thread_num;
> +	atomic_t		thread_ack;
> +	enum freezer_state	state;
> +};
> +
> +static void set_state(struct freezer_data *fd, enum freezer_state state)
> +{
> +	/* set ack counter */
> +	atomic_set(&fd->thread_ack, fd->thread_num);
> +	/* guarantee the write ordering between ack counter and state */
> +	smp_wmb();
> +	fd->state = state;
> +}
> +
> +static void ack_state(struct freezer_data *fd)
> +{
> +	if (atomic_dec_and_test(&fd->thread_ack))
> +		set_state(fd, fd->state + 1);
> +}
> +
> +static void freezer_pick_tk(int cpu)
> +{
> +	if (tick_do_timer_cpu == TICK_DO_TIMER_NONE) {
> +		static DEFINE_SPINLOCK(lock);
> +
> +		spin_lock(&lock);
> +		if (tick_do_timer_cpu == TICK_DO_TIMER_NONE)
> +			tick_do_timer_cpu = cpu;
> +		spin_unlock(&lock);
> +	}
> +}
> +
> +static void freezer_suspend_clkevt(int cpu)
> +{
> +	if (tick_do_timer_cpu == cpu)
> +		return;
> +
> +	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
> +}
> +
> +static void freezer_suspend_tk(int cpu)
>  {
> +	if (tick_do_timer_cpu != cpu)
> +		return;
> +

I had a note here that this might be broken for clocksource drivers that
have suspend/resume methods. You seem to have 'lost' that note, is that
because you found it isn't a problem?

> +	timekeeping_suspend();
> +
>  	cpuidle_use_deepest_state(true);
>  	cpuidle_resume();
> -	wait_event(suspend_freeze_wait_head, suspend_freeze_wake);
> +}
> +
> +static void freezer_idle(int cpu)
> +{
> +	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
> +	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
> +
> +	stop_critical_timings();
> +
> +	while (suspend_freeze_wake == -1) {
> +		int next_state;
> +
> +		/*
> +		 * interrupt must be disabled before cpu enters idle
> +		 */
> +		local_irq_disable();
> +
> +		next_state = cpuidle_select(drv, dev);
> +		if (next_state < 0) {
> +			arch_cpu_idle();
> +			continue;
> +		}
> +		/*
> +		 * cpuidle_enter will return with interrupt enabled
> +		 */
> +		cpuidle_enter(drv, dev, next_state);
> +	}
> +
> +	if (suspend_freeze_wake == cpu)
> +		kick_all_cpus_sync();
> +

So I disabled IRQs here

> +	start_critical_timings();
> +}
> +
> +static void freezer_resume_tk(int cpu)
> +{
> +	if (tick_do_timer_cpu != cpu)
> +		return;
> +
>  	cpuidle_pause();
>  	cpuidle_use_deepest_state(false);
> +

Such that they would still be disabled here

> +	local_irq_disable();
> +	timekeeping_resume();
> +	local_irq_enable();
> +}
> +
> +static void freezer_resume_clkevt(int cpu)
> +{
> +	if (tick_do_timer_cpu == cpu)
> +		return;
> +
> +	touch_softlockup_watchdog();
> +	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);

And here.

> +	local_irq_disable();
> +	hrtimers_resume();
> +	local_irq_enable();
> +}
> +
> +typedef void (*freezer_fn)(int);
> +
> +static freezer_fn freezer_func[FREEZER_EXIT] = {
> +	NULL,
> +	freezer_pick_tk,
> +	freezer_suspend_clkevt,
> +	freezer_suspend_tk,
> +	freezer_idle,
> +	freezer_resume_tk,
> +	freezer_resume_clkevt,
> +};

Because this is a stop_machine callback, which are nominally run with
IRQs disabled.

> +static int freezer_stopper_fn(void *arg)
> +{
> +	struct freezer_data *fd = arg;
> +	enum freezer_state state = FREEZER_NONE;
> +	int cpu = smp_processor_id();
> +
> +	do {
> +		cpu_relax();
> +		if (fd->state != state) {
> +			state = fd->state;
> +			if (freezer_func[state])
> +				(*freezer_func[state])(cpu);
> +			ack_state(fd);
> +		}
> +	} while (fd->state != FREEZER_EXIT);
> +	return 0;
> +}

Now I suppose the problem is with cpu_pause() which needs IPIs to
complete? Do we really need cpuidle_pause() there?
cpuidle_uninstall_handlers() seems like a daft thing to call just about
there.
