Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbaCKVyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 17:54:19 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37851 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbaCKVyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 17:54:17 -0400
Message-ID: <531F8605.10003@linaro.org>
Date: Tue, 11 Mar 2014 14:54:13 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jiri Bohac <jbohac@suse.cz>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: is printk() safe within a timekeeper_seq write section?
References: <20140306174531.GA30634@midget.suse.cz> <531F6429.8050008@linaro.org> <alpine.DEB.2.02.1403112040100.18573@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1403112040100.18573@ionos.tec.linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 02:32 PM, Thomas Gleixner wrote:
> On Tue, 11 Mar 2014, John Stultz wrote:
>> On 03/06/2014 09:45 AM, Jiri Bohac wrote:
>>> Hi,
>>>
>>> I'm looking at the printk call in
>>> __timekeeping_inject_sleeptime(), introduced in cb5de2f8
>>> (time: Catch invalid timespec sleep values in __timekeeping_inject_sleeptime)
>>>
>>> Is it safe to call printk() while timekeeper_seq is held for
>>> writing?
>>>
>>> What about this call chain?
>>>   printk
>>>     vprintk_emit
>>>       console_unlock
>>>         up(&console_sem)
>>>           __up
>>> 	    wake_up_process
>>> 	      try_to_wake_up
>>> 	        ttwu_do_activate
>>> 		  ttwu_activate
>>> 		    activate_task
>>> 		      enqueue_task
>>> 		        enqueue_task_fair
>>> 			  hrtick_update
>>> 			    hrtick_start_fair
>>> 			      hrtick_start_fair
>>> 			        get_time
>>> 				  ktime_get
>>> 				    --> endless loop on
>>> 				    read_seqcount_retry(&timekeeper_seq, ...)
>>> 		  
>>>
>>> It looks like an unlikely but possible deadlock. 
>>> Or did I overlook something?
>> So I don't think I've seen anything like the above in my testing, but it
>> may just be very hard to get that path to trigger.
> It's hard, but possible:
>
> CPU0	     		CPU1
>
> T1 down(&console_sem);
> 			T2 down(&console_sem);
> 			   --> preemption or interrupt
> 			        write_seqcount_begin(&timekeeper_seq);
> T1 up(&console_sem);
> 				down(&console_sem);
> 				....
> 				up(&console_sem);
> 				   wakeup(T2);
> 				     ....
> 				     hrtick_update();
> 				     
>> I was also surprised the seqlock lockdep enablement changes wouldn't
>> catch this, but Jiri pointed out printk calls lockdep_off in
>> vprintk_emit() - which makes sense as you don't want lockdep splats
>> calling printk and recursing - but is frustrating to have that hole in
>> the checking.
>>
>> There's a few spots where we do printks with the timekeeping seqlock
>> held, and they're annoyingly nested far enough to make deferring the
>> printk awkward. So I'm half thinking we could have some sort of buffer
>> something like time_printk() could fill and then flush it after the lock
>> is dropped. Then we just need something to warn if any new printks' are
>> added to timekeeping seqlock sequences.
>>
>> The whole thing makes my head spin a bit, since even if we remove the
>> explicit printks, I'm not sure where else printk might be triggered
>> (like via lockdep warnings, for instance), where it might be unsafe.
>>
>> Peter/Thomas: Any thoughts on the deferred printk buffer? Does printk
>> already have something like this? Any other ideas here?
> I was thinking about something like that for RT as on RT printk is a
> complete nightmare. It's simple to implement that, but as we know from
> the RT experience it can lead to painful loss of debug output.
>
> Assume you printk inside such a region, which just fills the dmesg
> buffer and schedules the delayed output. Now in that same region you
> run into a deadlock which causes the whole machine to freeze. Then you
> won't see the debug output, which might actually give you the hint why
> the system deadlocked ....
Ok, so a generic solution is probably not going to be worth it then. My
thought was that since we do a very limited amount of informational
printks in the timekeeping code, we can be fairly safe delaying the
print-out until we drop the locks.

For timekeeping, its really 4 call sites:
* invalid inject_sleep_time deltas
* > 11% clocksource freq adjustments
* insert leap second
* delete leap second

The first can probably be dropped all together, and signaled via an
error return.

The second can probably be replaced by a hard cap, although it would be
good to still know we hit that limit.

The last two (only one of which ever really happens) are mostly just
informative to the system admin, as most users don't check the TIME_OOP
flag to note the leap occurred.

So unless you have other suggestions I think delaying the printouts it
is the best approach for the timekeeping code.

We then just have to hope we don't have any other call-out sites that
conditionally trip printks as well (nor any that might add printks any
time in the future). Any clue on how best to catch those cases? Audits
like Jiri's here probably won't scale over time.

thanks
-john
