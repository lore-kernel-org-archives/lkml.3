Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbaH0BhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:37:04 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:3632 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752295AbaH0BhB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:37:01 -0400
X-IronPort-AV: E=Sophos;i="5.04,408,1406563200"; 
   d="scan'208";a="35115377"
Message-ID: <53FD356D.6050507@cn.fujitsu.com>
Date: Wed, 27 Aug 2014 09:33:33 +0800
From: Chai Wen <chaiw.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: <akpm@linux-foundation.org>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] softlockup: make detector be aware of task switch of
 processes hogging cpu
References: <20140821023051.GO49576@redhat.com> <1408599742-21674-1-git-send-email-chaiw.fnst@cn.fujitsu.com> <20140822015822.GZ49576@redhat.com> <53FC82D2.1020401@cn.fujitsu.com> <20140826142214.GN49576@redhat.com>
In-Reply-To: <20140826142214.GN49576@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.167.226.161]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 10:22 PM, Don Zickus wrote:

> On Tue, Aug 26, 2014 at 08:51:30PM +0800, Chai Wen wrote:
>> On 08/22/2014 09:58 AM, Don Zickus wrote:
>>
>>> On Thu, Aug 21, 2014 at 01:42:22PM +0800, chai wen wrote:
>>>> For now, soft lockup detector warns once for each case of process softlockup.
>>>> But the thread 'watchdog/n' may not always get the cpu at the time slot between
>>>> the task switch of two processes hogging that cpu to reset soft_watchdog_warn.
>>>>
>>>> An example would be two processes hogging the cpu.  Process A causes the
>>>> softlockup warning and is killed manually by a user.  Process B immediately
>>>> becomes the new process hogging the cpu preventing the softlockup code from
>>>> resetting the soft_watchdog_warn variable.
>>>>
>>>> This case is a false negative of "warn only once for a process", as there may
>>>> be a different process that is going to hog the cpu.  Resolve this by
>>>> saving/checking the task pointer of the hogging process and use that to reset
>>>> soft_watchdog_warn too.
>>>>
>>>> Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>
>>>> Signed-off-by: Don Zickus <dzickus@redhat.com>
>>>
>>> Acked-by: Don Zickus <dzickus@redhat.com>
>>>
>>
>>
>> Hi Andrew
>>
>> Sorry for some disturbing.
>> Could you help to check and pick up this little improvement patch ?
>>
>> I am not sure which MAINTAINER I should talk to, but the original version of
>> this patch is queued to -mm tree by you, so I assume that they are in the charge of you.
>>
>>
>> thanks
>> chai wen
> 
> Hi Chai,
> 
> Sorry about that.  Ingo asked me privately to pick this up and re-post
> with my signoff.  I was converting to a new test env and was going to use this
> patch as an excuse to exercise it.  That is the delay.  Let me get this
> out today.
> 


OK， It is kind of you to do that, thanks for your work. :)

thanks
chai wen

> Cheers,
> Don
> 
>>
>>>> ---
>>>>  kernel/watchdog.c |   16 +++++++++++++++-
>>>>  1 files changed, 15 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
>>>> index 0037db6..2e55620 100644
>>>> --- a/kernel/watchdog.c
>>>> +++ b/kernel/watchdog.c
>>>> @@ -42,6 +42,7 @@ static DEFINE_PER_CPU(bool, softlockup_touch_sync);
>>>>  static DEFINE_PER_CPU(bool, soft_watchdog_warn);
>>>>  static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
>>>>  static DEFINE_PER_CPU(unsigned long, soft_lockup_hrtimer_cnt);
>>>> +static DEFINE_PER_CPU(struct task_struct *, softlockup_task_ptr_saved);
>>>>  #ifdef CONFIG_HARDLOCKUP_DETECTOR
>>>>  static DEFINE_PER_CPU(bool, hard_watchdog_warn);
>>>>  static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
>>>> @@ -328,8 +329,20 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>>>>  			return HRTIMER_RESTART;
>>>>  
>>>>  		/* only warn once */
>>>> -		if (__this_cpu_read(soft_watchdog_warn) == true)
>>>> +		if (__this_cpu_read(soft_watchdog_warn) == true) {
>>>> +			/*
>>>> +			 * Handle the case where multiple processes are
>>>> +			 * causing softlockups but the duration is small
>>>> +			 * enough, the softlockup detector can not reset
>>>> +			 * itself in time.  Use task pointers to detect this.
>>>> +			 */
>>>> +			if (__this_cpu_read(softlockup_task_ptr_saved) !=
>>>> +			    current) {
>>>> +				__this_cpu_write(soft_watchdog_warn, false);
>>>> +				__touch_watchdog();
>>>> +			}
>>>>  			return HRTIMER_RESTART;
>>>> +		}
>>>>  
>>>>  		if (softlockup_all_cpu_backtrace) {
>>>>  			/* Prevent multiple soft-lockup reports if one cpu is already
>>>> @@ -345,6 +358,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>>>>  		pr_emerg("BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
>>>>  			smp_processor_id(), duration,
>>>>  			current->comm, task_pid_nr(current));
>>>> +		__this_cpu_write(softlockup_task_ptr_saved, current);
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
