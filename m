Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbaJ1Ej7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 00:39:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:15939 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbaJ1Ej4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 00:39:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="407062624"
Message-ID: <544F1E19.5030606@linux.intel.com>
Date: Tue, 28 Oct 2014 12:39:53 +0800
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
> complete? 

Yes, cpu_pause() will invoke smp IPI functions which need interrupt is
enabled. So I changed irq ops like above. Actually, I have an early
version to move cpuidle_pause()/cpuidle_resume() out of stop_machine(),
that might be a better solution?

Thanks,
-Aubrey

