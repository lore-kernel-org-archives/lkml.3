Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbbA0IDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 03:03:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:26526 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757740AbbA0IDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 03:03:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,473,1418112000"; 
   d="scan'208";a="676526726"
Message-ID: <54C74651.3020403@linux.intel.com>
Date: Tue, 27 Jan 2015 16:03:29 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>, "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v3]PM/Sleep: Timer quiesce in freeze state
References: <54866625.8010406@linux.intel.com> <54C5FE6A.9010300@linux.intel.com> <alpine.DEB.2.11.1501260946390.5526@nanos> <2137807.aqSxQQCuJ3@vostro.rjw.lan>
In-Reply-To: <2137807.aqSxQQCuJ3@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/26 22:41, Rafael J. Wysocki wrote:
> On Monday, January 26, 2015 10:40:24 AM Thomas Gleixner wrote:
>> On Mon, 26 Jan 2015, Li, Aubrey wrote:
>>> On 2015/1/22 18:15, Thomas Gleixner wrote:
> 
> [...]
> 
>>>>> +		/*
>>>>> +		 * cpuidle_enter will return with interrupt enabled
>>>>> +		 */
>>>>> +		cpuidle_enter(drv, dev, next_state);
>>>>
>>>> How is that supposed to work?
>>>>
>>>> If timekeeping is not yet unfrozen, then any interrupt handling code
>>>> which calls anything time related is going to hit lala land.
>>>>
>>>> You must guarantee that timekeeping is unfrozen before any interrupt
>>>> is handled. If you cannot guarantee that, you cannot freeze
>>>> timekeeping ever.
>>>>
>>>> The cpu local tick device is less critical, but it happens to work by
>>>> chance, not by design.
>>>
>>> There are two way to guarantee this: the first way is, disable interrupt
>>> before timekeeping frozen and enable interrupt after timekeeping is
>>> unfrozen. However, we need to handle wakeup handler before unfreeze
>>> timekeeping to wake freeze task up from wait queue.
>>>
>>> So we have to go the other way, the other way is, we ignore time related
>>> calls during freeze, like what I added in irq_enter below.
>>
>> Groan. You just do not call in irq_enter/exit(), but what prevents any
>> interrupt handler or whatever to call into the time/timer code after
>> interrupts got reenabled?
>>
>> Nothing. 
>>
>>> Or, we need to re-implement freeze wait and wake up mechanism?
>>
>> You need to make sure in the low level idle implementation that this
>> cannot happen.
>>
>> tick_freeze()
>> {
>> 	raw_spin_lock(&tick_freeze_lock);
>> 	tick_frozen++;
>> 	if (tick_frozen == num_online_cpus())
>> 		timekeeping_suspend();
>> 	else
>> 		tick_suspend_local();
>> 	raw_spin_unlock(&tick_freeze_lock);
>> }
>>
>> tick_unfreeze()
>> {
>> 	raw_spin_lock(&tick_freeze_lock);
>> 	if (tick_frozen == num_online_cpus())
>> 		timekeeping_resume();
>> 	else
>> 		tick_resume_local();
>> 	tick_frozen--;
>> 	raw_spin_unlock(&tick_freeze_lock);
>> }
>>
>> idle_freeze()
>> {
>> 	local_irq_disable();
>>
>> 	tick_freeze();
>>
>> 	/* Must keep interrupts disabled! */
>>        	go_deep_idle()
>>
>> 	tick_unfreeze();
>>
>> 	local_irq_enable();
>> }
>>
>> That's the only way you can do it proper, everything else will just be
>> a horrible mess of bandaids and duct tape.
>>
>> So that does not need any of the irq_enter/exit conditionals, it does
>> not need the real_handler hack. It just works.
> 
> As long as go_deep_idle() above does not enable interrupts.  This means we won't
> be able to use some C-states for suspend-to-idle (hald-induced C1 on some x86
> for one example), but that's not a very big deal.

Does the legacy ACPI system IO method to enter C2/C3 need interrupt
enabled as well?

Do we need some platform ops to cover those legacy platforms? Different
platform go different branch here.

Thanks,
-Aubrey

> 
>> The only remaining issue might be a NMI calling into
>> ktime_get_mono_fast_ns() before timekeeping is resumed. Its probably a
>> non issue on x86/tsc, but it might be a problem on other platforms
>> which turn off devices, clocks, It's not rocket science to prevent
>> that.
> 
> I don't see any users of ktime_get_mono_fast_ns() at all, unless some non-trivial
> macros are involved.  At least grepping for it only returns the definition,
> declarations and the line in trace.c.
> 
> Rafael
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

