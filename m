Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbbAZIoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 03:44:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:50708 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbbAZIoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 03:44:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,467,1418112000"; 
   d="scan'208";a="656430298"
Message-ID: <54C5FE6A.9010300@linux.intel.com>
Date: Mon, 26 Jan 2015 16:44:26 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Peter Zijlstra <peterz@infradead.org>, "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v3]PM/Sleep: Timer quiesce in freeze state
References: <54866625.8010406@linux.intel.com> <54B5B724.4020108@linux.intel.com> <5541724.ryTEJUkIdN@vostro.rjw.lan> <alpine.DEB.2.11.1501221021580.5526@nanos>
In-Reply-To: <alpine.DEB.2.11.1501221021580.5526@nanos>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thanks for the comments, my feedback below:

On 2015/1/22 18:15, Thomas Gleixner wrote:
> On Tue, 9 Dec 2014, Li, Aubrey wrote:
>> diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
>> index 2e4cb67..d118e0b 100644
>> --- a/include/linux/clockchips.h
>> +++ b/include/linux/clockchips.h
>> @@ -18,6 +18,9 @@ enum clock_event_nofitiers {
>>  	CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
>>  	CLOCK_EVT_NOTIFY_SUSPEND,
>>  	CLOCK_EVT_NOTIFY_RESUME,
>> +	CLOCK_EVT_NOTIFY_FREEZE_PREPARE,
>> +	CLOCK_EVT_NOTIFY_FREEZE,
>> +	CLOCK_EVT_NOTIFY_UNFREEZE,
> 
> Can we please stop adding more crap to that notifier thing? I rather
> see that go away than being expanded.

Are you referring to FREEZE_PREPARE or remove all of FREEZE staff at all?

What's the disadvantage of adding more notifier?

> 
>> @@ -95,6 +98,7 @@ enum clock_event_mode {
>>   */
>>  struct clock_event_device {
>>  	void			(*event_handler)(struct clock_event_device *);
>> +	void			(*real_handler)(struct clock_event_device *);
> 
> This is really not the place to put this. We have the hotpath
> functions together at the beginning of the struct and not some random
> stuff used once in a while. Think about cache lines.

okay, will move to the tail.

> 
> A proper explanation why you need this at all is missing.
> 
Thanks, will add some comments here.

>>  /*
>> + * cpu idle freeze function
>> + */
> 
> How is that comment helpful?
> 
> Not at all. But its simpler to add pointless comments than to document
> the important and non obvious stuff, right?

okay.

> 
>> +static void cpu_idle_freeze(void)
>> +{
>> +	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
>> +	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
>> +
>> +	/*
>> +	 * suspend tick, the last CPU suspend timekeeping
>> +	 */
>> +	clockevents_notify(CLOCK_EVT_NOTIFY_FREEZE, NULL);
>> +	/*
>> +	 * idle loop here if idle_should_freeze()
>> +	 */
>> +	while (idle_should_freeze()) {
>> +		int next_state;
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
> 
> How is that supposed to work?
> 
> If timekeeping is not yet unfrozen, then any interrupt handling code
> which calls anything time related is going to hit lala land.
> 
> You must guarantee that timekeeping is unfrozen before any interrupt
> is handled. If you cannot guarantee that, you cannot freeze
> timekeeping ever.
> 
> The cpu local tick device is less critical, but it happens to work by
> chance, not by design.

There are two way to guarantee this: the first way is, disable interrupt
before timekeeping frozen and enable interrupt after timekeeping is
unfrozen. However, we need to handle wakeup handler before unfreeze
timekeeping to wake freeze task up from wait queue.

So we have to go the other way, the other way is, we ignore time related
calls during freeze, like what I added in irq_enter below.

Or, we need to re-implement freeze wait and wake up mechanism?
> 
>>  void irq_enter(void)
>>  {
>>  	rcu_irq_enter();
>> -	if (is_idle_task(current) && !in_interrupt()) {
>> +	if (is_idle_task(current) && !in_interrupt() && !in_freeze()) {
>>  		/*
>>  		 * Prevent raise_softirq from needlessly waking up ksoftirqd
>>  		 * here, as softirq will be serviced on return from interrupt.
>> @@ -364,7 +365,7 @@ static inline void tick_irq_exit(void)
>>  
>>  	/* Make sure that timer wheel updates are propagated */
>>  	if ((idle_cpu(cpu) && !need_resched()) || tick_nohz_full_cpu(cpu)) {
>> -		if (!in_interrupt())
>> +		if (!in_interrupt() && !in_freeze())
>>  			tick_nohz_irq_exit();
> 
> We keep adding conditional over conditionals to the irq_enter/exit
> hotpath. Can we please find some more intelligent solution for this?

I need more time to consider this, will get back to you if I have an idea.

> 
>> @@ -375,15 +386,21 @@ void tick_shutdown(unsigned int *cpup)
>>  void tick_suspend(void)
>>  {
>>  	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
>> +	struct clock_event_device *dev = td->evtdev;
>>  
>> +	dev->real_handler = dev->event_handler;
>> +	dev->event_handler = clockevents_handle_noop;
> 
> Lacks a proper explanation. What's the point of this exercise?

Yeah, will add comments in the next version.

> 
>> +void tick_freeze_prepare(void)
>> +{
>> +	tick_freeze_target_depth = num_online_cpus();
> 
> So we have a 'notifier' callback just to store the number of online
> cpus? That's beyond silly. What's wrong with having a frozen counter
> and comparing that to num_online_cpus()?
> 
It looks like a notifier is unpopular, I was trying to avoid a global
variable across different kernel modules. But yes, I can change. May I
know the disadvantage of notifier callback?

>> +void tick_freeze(void)
>> +{
>> +	/*
>> +	 * This is serialized against a concurrent wakeup
>> +	 * via clockevents_lock
>> +	 */
>> +	tick_freeze_target_depth--;
>> +	tick_suspend();
>> +
>> +	/*
>> +	 * the last tick_suspend CPU suspends timekeeping
>> +	 */
>> +	if (!tick_freeze_target_depth)
>> +		timekeeping_freeze();
>> +}
>> +
>> +void tick_unfreeze(void)
>> +{
>> +	/*
>> +	 * the first wakeup CPU resumes timekeeping
>> +	 */
>> +	if (timekeeping_suspended) {
>> +		timekeeping_unfreeze();
>> +		touch_softlockup_watchdog();
>> +		tick_resume();
>> +		hrtimers_resume();
>> +	} else {
>> +		tick_resume();
>> +	}
>> +}
> 
> This is really horrible. We now have basically the same code for
> freeze/unfreeze and suspend/resume just in different files and with
> slightly different functionality.

Let me try to see if I can re-org these functions. Besides the
reduplicated code, do you see anything broken of the implementation?


> And we have that just because you want to (ab)use clockevents_lock for
> serialization.

The V2 patch was using stop machine mechanism according to Peter's
suggestion. This V3 patch, IIRC, clockevents_lock was your suggestion.
Do you have any better idea now?

Thanks,
-Aubrey
> 
> Thanks,
> 
> 	tglx

