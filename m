Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbaHFC1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 22:27:42 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:33565 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750922AbaHFC1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 22:27:41 -0400
X-IronPort-AV: E=Sophos;i="5.04,273,1406563200"; 
   d="scan'208";a="34235207"
Message-ID: <53E191AC.2000700@cn.fujitsu.com>
Date: Wed, 6 Aug 2014 10:23:40 +0800
From: Chai Wen <chaiw.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <mingo@redhat.com>
Subject: Re: [PATCH 2/2] softlockup: make detector be aware of task switch
 of processes hogging cpu
References: <1407137779-19129-1-git-send-email-chaiw.fnst@cn.fujitsu.com> <1407137779-19129-2-git-send-email-chaiw.fnst@cn.fujitsu.com> <20140804143122.GF87407@redhat.com> <53E045DD.4010505@cn.fujitsu.com> <20140805152013.GK87407@redhat.com>
In-Reply-To: <20140805152013.GK87407@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.161]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 11:20 PM, Don Zickus wrote:

> On Tue, Aug 05, 2014 at 10:47:57AM +0800, Chai Wen wrote:
>> On 08/04/2014 10:31 PM, Don Zickus wrote:
>>
>>> On Mon, Aug 04, 2014 at 03:36:19PM +0800, chai wen wrote:
>>>>
>>>> For now, soft lockup detector warns once for each case of process softlockup.
>>>> But the thread 'watchdog/n' may can not always get cpu at the time slot between
>>>> the task switch of two processes hogging that cpu.
>>>> This case is a false negative of "warn only once for a process", as there may be
>>>> a different process that is going to hog the cpu. Is is better for detector to
>>>> be aware of it. 
>>>
>>> I am not sure I fully understand the problem resolved.
>>>
>>> >From the changelog I understood that two processes bouncing back and forth
>>> could hog the cpu and could create a 'false negative' (a situation not
>>> reported but should).
>>
>>
>> Hi Don
>>
>> Thanks for your comment.
>> Perhaps 'task-switch' is wrong and is some misleading here, sorry for that.
>>
>> Here I mean the very case that between a termination of an old cpu hogging
>> process and a starting getting cpu of a new process hogging cpu.
>> The case that two or more processes bouncing back and forth and the thread 'watchdog/n'
>> getting no chance to run is rather difficult to be supposed. And I think this situation
>> does not exist.
>>
>> When I am reading the code of warning once about a case, I think maybe it is
>> not so reliable by judging a "soft_watchdog_warn". And I tried a simple test to see
>> if it could handle the cased I mentioned above. Please see the comment and detail of
>> the test below.
> 
> Thank you for your test case.  I understand the problem now.  If you have
> multiple processes hogging the cpu and you kill the one reported by
> the softlockup warning, you will never know about the other processes
> because the soft_watchdog_warn variable never gets a chance to reset.
> 
> I am ok with your patch then.
> 
> Do you mind if I modify the changelog a little bit to maybe help explain
> the problem better?  I am thinking of something like below:
> 
> "
> For now, soft lockup detector warns once for each case of process softlockup.
> But the thread 'watchdog/n' may not always get the cpu at the time slot between
> the task switch of two processes hogging that cpu to reset
> soft_watchdog_warn.
> 
> An example would be two processes hogging the cpu.  Process A causes the
> softlockup warning and is killed manually by a user.  Process B
> immediately becomes the new process hogging the cpu preventing the
> softlockup code from resetting the soft_watchdog_warn variable.
> 
> This case is a false negative of "warn only once for a process", as there may be
> a different process that is going to hog the cpu.  Resolve this by
> saving/checking the pid of the hogging process and use that to reset
> soft_watchdog_warn too.
> "


Your changelog and comment below is more specific for this case.
Thanks for your work on this patch.
Please feel free to do it like this.


thanks
chai wen


> 
>>
>>>
>>> But looking at the patch below I was a little confused on the
>>> __touch_watchdog addition.  See below:
>>>
>>>>
>>>> Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>
>>>> ---
>>>>  kernel/watchdog.c |   18 ++++++++++++++++--
>>>>  1 files changed, 16 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
>>>> index 4c2e11c..908050c 100644
>>>> --- a/kernel/watchdog.c
>>>> +++ b/kernel/watchdog.c
>>>> @@ -42,6 +42,7 @@ static DEFINE_PER_CPU(bool, softlockup_touch_sync);
>>>>  static DEFINE_PER_CPU(bool, soft_watchdog_warn);
>>>>  static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
>>>>  static DEFINE_PER_CPU(unsigned long, soft_lockup_hrtimer_cnt);
>>>> +static DEFINE_PER_CPU(pid_t, softlockup_warn_pid_saved);
>>>>  #ifdef CONFIG_HARDLOCKUP_DETECTOR
>>>>  static DEFINE_PER_CPU(bool, hard_watchdog_warn);
>>>>  static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
>>>> @@ -317,6 +318,8 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>>>>  	 */
>>>>  	duration = is_softlockup(touch_ts);
>>>>  	if (unlikely(duration)) {
>>>> +		pid_t pid = task_pid_nr(current);
>>>> +
>>>>  		/*
>>>>  		 * If a virtual machine is stopped by the host it can look to
>>>>  		 * the watchdog like a soft lockup, check to see if the host
>>>> @@ -326,8 +329,18 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>>>>  			return HRTIMER_RESTART;
>>>>  
>>>>  		/* only warn once */
>>>> -		if (__this_cpu_read(soft_watchdog_warn) == true)
>>>> +		if (__this_cpu_read(soft_watchdog_warn) == true) {
>>>> +			/*
>>>> +			 * soft lockup detector should be aware of that there
>>>> +			 * may be a task-swicth of two different processes
>>>> +			 * hogging the cpu continously
>>>> +			 */
> 
> Can I modify the comment above to something like:
> 
> 
> +			/*
> +			 * Handle the case where multiple processes are
> +			 * causing softlockups but the duration is small
> +			 * enough, the softlockup detector can not reset
> +			 * itself in time.  Use pids to detect this.
> +			 */
> 
> 
> Cheers,
> Don
> 
>>>
>>> The above piece is what I am trying to understand.  Are you saying that
>>> when two different processes are hogging the cpu, undo the
>>> soft_watchdog_warn and allow the second pid to be reported?
>>>
>>
>>
>> Yes, Indeed.
>>
>>> Just trying to understand the problem and see if this is the right
>>> approach (because 3 or more processes could cause the same problem???).
>>>
>>
>>
>> Only 2 processes is involved in this case as mentioned above, and it is a case about
>> a termination of an old process and a starting of a new process.
>>
>> Here is my test about the case:
>>
>> 	stuck.c:
>> 	#include <stdlib.h>
>> 	#include <stdio.h>
>>
>> 	int main(int argc, char **argv)
>> 	{
>>     		while(1);
>>     		exit(0);
>> 	}
>>
>> 	# gcc -o stuck stuck.c
>> 	# ./stuck &
>> 	[1] 30309
>> 	# ./stuck &
>> 	[2] 30310
>> 	# taskset -pc 3 30309
>> 	pid 30309's current affinity list: 0-3
>> 	pid 30309's new affinity list: 3
>> 	# taskset -pc 3 30310
>> 	pid 30310's current affinity list: 0-3
>> 	pid 30310's new affinity list: 3
>>
>> 	Then change the schedule policy of 30309 and 30310 to be SCHED_FIFO with the MAX_RT_PRIO-1 priority.
>> 	As the firstly changed to SCHED_FIFO process hogging cpu#3, and is reported after about ~20s.
>> 	After it is killed or terminated, the process 30310 is going out and keeping hogging the cpu continuously
>> 	But this process can not be always reported by the detector in this test.
>> 	If removing the 'warn once' checking, pid change and rather big lockup duration could be found.
>>
>> thanks
>> chai wen
>>
>>> Cheers,
>>> Don
>>>
>>>>  			return HRTIMER_RESTART;
>>>> +		}
>>>>  
>>>>  		if (softlockup_all_cpu_backtrace) {
>>>>  			/* Prevent multiple soft-lockup reports if one cpu is already
>>>> @@ -342,7 +355,8 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>>>>  
>>>>  		printk(KERN_EMERG "BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
>>>>  			smp_processor_id(), duration,
>>>> -			current->comm, task_pid_nr(current));
>>>> +			current->comm, pid);
>>>> +		__this_cpu_write(softlockup_warn_pid_saved, pid);
>>>>  		print_modules();
>>>>  		print_irqtrace_events(current);
>>>>  		if (regs)
>>>> -- 
>>>> 1.7.1
>>>>
>>> .
>>>
>>
>>
>>
>> -- 
>> Regards
>>
>> Chai Wen
> .
> 



-- 
Regards

Chai Wen
