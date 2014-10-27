Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaJ0G1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 02:27:32 -0400
Received: from mga14.intel.com ([192.55.52.115]:60787 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbaJ0G1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 02:27:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="406516297"
Message-ID: <544DE5CF.9040501@linux.intel.com>
Date: Mon, 27 Oct 2014 14:27:27 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        "linux-pm@vger.kernel.org >> Linux PM list" 
	<linux-pm@vger.kernel.org>
Subject: Re: [RFC/PATCH] PM / Sleep: Timer quiesce in freeze state
References: <5446787E.60202@linux.intel.com> <20141024153656.GM12706@worktop.programming.kicks-ass.net>
In-Reply-To: <20141024153656.GM12706@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/24 23:36, Peter Zijlstra wrote:
> On Tue, Oct 21, 2014 at 11:15:10PM +0800, Li, Aubrey wrote:
>> +++ b/arch/x86/kernel/apic/apic.c
>> @@ -917,6 +917,14 @@ static void local_apic_timer_interrupt(void)
>>  	 */
>>  	inc_irq_stat(apic_timer_irqs);
>>  
>> +	/*
>> +	 * if timekeeping is suspended, the clock event device will be
>> +	 * suspended as well, so we are not supposed to invoke the event
>> +	 * handler of clock event device.
>> +	 */
>> +	if (unlikely(timekeeping_suspended))
>> +		return;
>> +
>>  	evt->event_handler(evt);
>>  }
>>  
> 
> How would this even happen? Didn't we just suspend the lapic?

There are two race conditions in my mind.

The first one occurs after the interrupt is disabled and before we
suspend lapic. In this time slot, if apic timer interrupt occurs, the
interrupt is pending there because the interrupt is disabled. Then we
suspend timekeeping, and then we enter idle and exit idle with interrupt
re-enabled, the timer interrupt is handled with timekeeping is
suspended. So we at least will hit WARN_ON(timekeeping_suspended) in
ktime_get().

The other occurs after timekeeping_suspended = 1 and before we suspend
lapic. In this time slot, if apic timer interrupt occurs, we will hit
the WARN in ktime_get() as above.

> 
>> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
>> index 4ca9a33..e58d880 100644
>> --- a/kernel/power/suspend.c
>> +++ b/kernel/power/suspend.c
>> @@ -28,16 +28,20 @@
>>  #include <linux/ftrace.h>
>>  #include <trace/events/power.h>
>>  #include <linux/compiler.h>
>> +#include <linux/stop_machine.h>
>> +#include <linux/clockchips.h>
>> +#include <linux/hrtimer.h>
>>  
>>  #include "power.h"
>> +#include "../time/tick-internal.h"
>> +#include "../time/timekeeping_internal.h"
>>  
>>  const char *pm_labels[] = { "mem", "standby", "freeze", NULL };
>>  const char *pm_states[PM_SUSPEND_MAX];
>>  
>>  static const struct platform_suspend_ops *suspend_ops;
>>  static const struct platform_freeze_ops *freeze_ops;
>> -static DECLARE_WAIT_QUEUE_HEAD(suspend_freeze_wait_head);
>> -static bool suspend_freeze_wake;
>> +static int suspend_freeze_wake;
>>  
>>  void freeze_set_ops(const struct platform_freeze_ops *ops)
>>  {
>> @@ -48,22 +52,179 @@ void freeze_set_ops(const struct platform_freeze_ops *ops)
>>  
>>  static void freeze_begin(void)
>>  {
>> -	suspend_freeze_wake = false;
>> +	suspend_freeze_wake = -1;
>>  }
>>  
>> -static void freeze_enter(void)
>> +enum freezer_state {
>> +	FREEZER_NONE,
>> +	FREEZER_PICK_TK,
>> +	FREEZER_SUSPEND_CLKEVT,
>> +	FREEZER_SUSPEND_TK,
>> +	FREEZER_IDLE,
>> +	FREEZER_RESUME_TK,
>> +	FREEZER_RESUME_CLKEVT,
>> +	FREEZER_EXIT,
>> +};
>> +
>> +struct freezer_data {
>> +	int			thread_num;
>> +	atomic_t		thread_ack;
>> +	enum freezer_state	state;
>> +};
>> +
>> +static void set_state(struct freezer_data *fd, enum freezer_state state)
>> +{
>> +	/* set ack counter */
>> +	atomic_set(&fd->thread_ack, fd->thread_num);
>> +	/* guarantee the write ordering between ack counter and state */
>> +	smp_wmb();
>> +	fd->state = state;
>> +}
>> +
>> +static void ack_state(struct freezer_data *fd)
>> +{
>> +	if (atomic_dec_and_test(&fd->thread_ack))
>> +		set_state(fd, fd->state + 1);
>> +}
>> +
>> +static void freezer_pick_tk(int cpu)
>> +{
>> +	if (tick_do_timer_cpu == TICK_DO_TIMER_NONE) {
>> +		static DEFINE_SPINLOCK(lock);
>> +
>> +		spin_lock(&lock);
>> +		if (tick_do_timer_cpu == TICK_DO_TIMER_NONE)
>> +			tick_do_timer_cpu = cpu;
>> +		spin_unlock(&lock);
>> +	}
>> +}
>> +
>> +static void freezer_suspend_clkevt(int cpu)
>> +{
>> +	if (tick_do_timer_cpu == cpu)
>> +		return;
>> +
>> +	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
>> +}
>> +
>> +static void freezer_suspend_tk(int cpu)
>>  {
>> +	if (tick_do_timer_cpu != cpu)
>> +		return;
>> +
> 
> I had a note here that this might be broken for clocksource drivers that
> have suspend/resume methods. You seem to have 'lost' that note, is that
> because you found it isn't a problem?
> 
I don't see it's a problem as long as we do not refer the clock source
before it resumes. But I think my testing didn't cover that case that
clock source drivers have suspend/resume methods. Can you please give
more details what do you worry about?

>> +	timekeeping_suspend();
>> +
>>  	cpuidle_use_deepest_state(true);
>>  	cpuidle_resume();
>> -	wait_event(suspend_freeze_wait_head, suspend_freeze_wake);
>> +}
>> +
>> +static void freezer_idle(int cpu)
>> +{
>> +	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
>> +	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
>> +
>> +	stop_critical_timings();
>> +
>> +	while (suspend_freeze_wake == -1) {
>> +		int next_state;
>> +
>> +		/*
>> +		 * interrupt must be disabled before cpu enters idle
>> +		 */
>> +		local_irq_disable();
>> +
>> +		next_state = cpuidle_select(drv, dev);
>> +		if (next_state < 0) {
>> +			arch_cpu_idle();
>> +			continue;
>> +		}
>> +		/*
>> +		 * cpuidle_enter will return with interrupt enabled
>> +		 */
>> +		cpuidle_enter(drv, dev, next_state);
>> +	}
>> +
>> +	if (suspend_freeze_wake == cpu)
>> +		kick_all_cpus_sync();
>> +
> 
> So I disabled IRQs here
> 
>> +	start_critical_timings();
>> +}
>> +
>> +static void freezer_resume_tk(int cpu)
>> +{
>> +	if (tick_do_timer_cpu != cpu)
>> +		return;
>> +
>>  	cpuidle_pause();
>>  	cpuidle_use_deepest_state(false);
>> +
> 
> Such that they would still be disabled here
> 
>> +	local_irq_disable();
>> +	timekeeping_resume();
>> +	local_irq_enable();
>> +}
>> +
>> +static void freezer_resume_clkevt(int cpu)
>> +{
>> +	if (tick_do_timer_cpu == cpu)
>> +		return;
>> +
>> +	touch_softlockup_watchdog();
>> +	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
> 
> And here.
> 
>> +	local_irq_disable();
>> +	hrtimers_resume();
>> +	local_irq_enable();
>> +}
>> +
>> +typedef void (*freezer_fn)(int);
>> +
>> +static freezer_fn freezer_func[FREEZER_EXIT] = {
>> +	NULL,
>> +	freezer_pick_tk,
>> +	freezer_suspend_clkevt,
>> +	freezer_suspend_tk,
>> +	freezer_idle,
>> +	freezer_resume_tk,
>> +	freezer_resume_clkevt,
>> +};
> 
> Because this is a stop_machine callback, which are nominally run with
> IRQs disabled.

Let me double confirm and address this concern in a later mail.
> 
>> +static int freezer_stopper_fn(void *arg)
>> +{
>> +	struct freezer_data *fd = arg;
>> +	enum freezer_state state = FREEZER_NONE;
>> +	int cpu = smp_processor_id();
>> +
>> +	do {
>> +		cpu_relax();
>> +		if (fd->state != state) {
>> +			state = fd->state;
>> +			if (freezer_func[state])
>> +				(*freezer_func[state])(cpu);
>> +			ack_state(fd);
>> +		}
>> +	} while (fd->state != FREEZER_EXIT);
>> +	return 0;
>> +}
> 
> Now I suppose the problem is with cpu_pause() which needs IPIs to
> complete? Do we really need cpuidle_pause() there?
> cpuidle_uninstall_handlers() seems like a daft thing to call just about
> there.

Please check the log of 8651f97bd951d0bb1c10fa24e3fa3455193f3548.
Rafael should know more this question than me.

Thanks,
-Aubrey
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
