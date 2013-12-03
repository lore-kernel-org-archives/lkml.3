Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab3LCRFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:05:05 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:44243 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab3LCRFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:05:02 -0500
Message-ID: <529E0F3A.9020608@gmail.com>
Date: Tue, 03 Dec 2013 18:04:58 +0100
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        tglx@linutronix.de, mingo@redhat.com, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 02/14] sched: add extended scheduling interface. (new
 ABI)
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>	<1383831828-15501-3-git-send-email-juri.lelli@gmail.com>	<20131127132354.GA18422@gmail.com>	<20131127133027.GE10022@twins.programming.kicks-ass.net>	<20131127140143.GB24403@gmail.com>	<20131127141334.GA13532@twins.programming.kicks-ass.net>	<20131127141721.GA24979@gmail.com>	<5297257B.7090200@gmail.com>	<20131128112858.GK10022@twins.programming.kicks-ass.net>	<20131130140633.GB19027@gmail.com>	<529E0338.3080802@gmail.com> <20131203114123.5693b6b7@gandalf.local.home>
In-Reply-To: <20131203114123.5693b6b7@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 05:41 PM, Steven Rostedt wrote:
> On Tue, 03 Dec 2013 17:13:44 +0100
> Juri Lelli <juri.lelli@gmail.com> wrote:
> 
>> On 11/30/2013 03:06 PM, Ingo Molnar wrote:
>>>
>>> * Peter Zijlstra <peterz@infradead.org> wrote:
>>>
>>>> On Thu, Nov 28, 2013 at 12:14:03PM +0100, Juri Lelli wrote:
>>>>> +SYSCALL_DEFINE2(sched_getattr, pid_t, pid, struct sched_attr __user *, attr)
>>>>>  {
>>>>> -	struct sched_param2 lp;
>>>>> +	struct sched_attr lp;
>>>>>  	struct task_struct *p;
>>>>>  	int retval;
>>>>>  
>>>>> -	if (!param2 || pid < 0)
>>>>> +	if (!attr || pid < 0)
>>>>>  		return -EINVAL;
>>>>>  
>>>>> +	memset(&lp, 0, sizeof(struct sched_attr));
>>>>> +
>>>>>  	rcu_read_lock();
>>>>>  	p = find_process_by_pid(pid);
>>>>>  	retval = -ESRCH;
>>>>> @@ -3427,7 +3495,7 @@ SYSCALL_DEFINE2(sched_getparam2, pid_t, pid, struct sched_param2 __user *, param
>>>>>  	lp.sched_priority = p->rt_priority;
>>>>>  	rcu_read_unlock();
>>>>>  
>>>>> -	retval = copy_to_user(param2, &lp, sizeof(lp)) ? -EFAULT : 0;
>>>>> +	retval = copy_to_user(attr, &lp, sizeof(lp)) ? -EFAULT : 0;
>>>>>  	return retval;
>>>>>  
>>>>>  out_unlock:
>>>>
>>>>
>>>> So this side needs a bit more care; suppose the kernel has a larger attr
>>>> than userspace knows about.
>>>>
>>>> What would make more sense; add another syscall argument with the
>>>> userspace sizeof(struct sched_attr), or expect userspace to initialize
>>>> attr->size to the right value before calling sched_getattr() ?
>>>>
>>>> To me the extra argument makes more sense; that is:
>>>>
>>>>   struct sched_attr attr;
>>>>
>>>>   ret = sched_getattr(0, &attr, sizeof(attr));
>>>>
>>>> seems like a saner thing than:
>>>>
>>>>   struct sched_attr attr = { .size = sizeof(attr), };
>>>>
>>>>   ret = sched_getattr(0, &attr);
>>>>
>>>> Mostly because the former has a clear separation between input and 
>>>> output arguments, whereas for the second form the attr argument is 
>>>> both input and output.
>>>>
>>>> Ingo?
>>>
>>> I suppose so - in the sys_perf_event_open() case we ran out of 
>>> arguments, so attr::size was the only sane way to do it.
>>>
>>
>> Ok, I modified it like this:
>>
>> ------------------------------------------------------------
>> Subject: [PATCH] fixup: add checks for sys_sched_getattr
>>
>> Add an extra argument to the syscall with the userspace
>> sizeof(struct sched_attr) to be able to handle situations
>> when the kernel has a larger attr than userspace knows about.
>> ---
>>  include/linux/syscalls.h |    3 ++-
>>  kernel/sched/core.c      |   55 ++++++++++++++++++++++++++++++++++++++++++----
>>  2 files changed, 53 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
>> index fbdf44a..45ce599 100644
>> --- a/include/linux/syscalls.h
>> +++ b/include/linux/syscalls.h
>> @@ -288,7 +288,8 @@ asmlinkage long sys_sched_getscheduler(pid_t pid);
>>  asmlinkage long sys_sched_getparam(pid_t pid,
>>  					struct sched_param __user *param);
>>  asmlinkage long sys_sched_getattr(pid_t pid,
>> -					struct sched_attr __user *attr);
>> +					struct sched_attr __user *attr,
>> +					unsigned int size);
>>  asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
>>  					unsigned long __user *user_mask_ptr);
>>  asmlinkage long sys_sched_getaffinity(pid_t pid, unsigned int len,
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index fe755f7..b7d91c6 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -3507,7 +3507,7 @@ do_sched_setscheduler(pid_t pid, int policy, struct sched_param __user *param)
>>  }
>>  
>>  /*
>> - * Mimics kerner/events/core.c perf_copy_attr().
>> + * Mimics kernel/events/core.c perf_copy_attr().
>>   */
>>  static int sched_copy_attr(struct sched_attr __user *uattr,
>>  			   struct sched_attr *attr)
>> @@ -3726,18 +3726,65 @@ out_unlock:
>>  	return retval;
>>  }
>>  
>> +static int sched_read_attr(struct sched_attr __user *uattr,
>> +			   struct sched_attr *attr,
>> +			   unsigned int size,
>> +			   unsigned int usize)
>> +{
>> +	int ret;
>> +
>> +	if (!access_ok(VERIFY_WRITE, uattr, SCHED_ATTR_SIZE_VER0))
> 
> We want to verify from uattr to usize, right? As that is what we are
> writing to.
> 

Right. s/SCHED_ATTR_SIZE_VER0/usize/

>> +		return -EFAULT;
>> +
>> +	/*
>> +	 * zero the full structure, so that a short copy will be nice.
>> +	 */
>> +	memset(uattr, 0, sizeof(*uattr));
> 
> Wait! We can't write to user space like this, not to mention that usize
> may even be less than sizeof(struct sched_attr).
> 

Ouch! I should never copy and paste.

> 
>> +
>> +	/*
>> +	 * If we're handed a smaller struct than we know of,
>> +	 * ensure all the unknown bits are 0 - i.e. old
>> +	 * user-space does not get uncomplete information.
>> +	 */
>> +	if (usize < sizeof(*attr)) {
>> +		unsigned char *addr;
>> +		unsigned char *end;
>> +
>> +		addr = (void *)attr + usize;
>> +		end  = (void *)attr + size;
>> +
>> +		for (; addr < end; addr++)
>> +			if (*addr)
>> +				goto err_size;
>> +	}
>> +

But, if we got here, we know that all is zero after usize and that
usize >= SCHED_ATTR_SIZE_VER0 (see below). So it should be safe to
copy_to_user() without the memset (since attr has been already zeroed),
do I get it right?

Thanks,

- Juri

>> +	ret = copy_to_user(uattr, attr, usize);
>> +	if (ret)
>> +		return -EFAULT;
>> +
>> +out:
>> +	return ret;
>> +
>> +err_size:
>> +	ret = -E2BIG;
>> +	goto out;
>> +}
>> +
>>  /**
>>   * sys_sched_getattr - same as above, but with extended "sched_param"
>>   * @pid: the pid in question.
>>   * @attr: structure containing the extended parameters.
>> + * @size: sizeof(attr) for fwd/bwd comp.
>>   */
>> -SYSCALL_DEFINE2(sched_getattr, pid_t, pid, struct sched_attr __user *, attr)
>> +SYSCALL_DEFINE3(sched_getattr, pid_t, pid, struct sched_attr __user *, attr,
>> +		unsigned int, size)
>>  {
>>  	struct sched_attr lp;
>>  	struct task_struct *p;
>>  	int retval;
>>  
>> -	if (!attr || pid < 0)
>> +	if (!attr || pid < 0 || size > PAGE_SIZE ||
>> +	    size < SCHED_ATTR_SIZE_VER0)
>>  		return -EINVAL;
>>  
>>  	memset(&lp, 0, sizeof(struct sched_attr));
>> @@ -3758,7 +3805,7 @@ SYSCALL_DEFINE2(sched_getattr, pid_t, pid, struct sched_attr __user *, attr)
>>  		lp.sched_priority = p->rt_priority;
>>  	rcu_read_unlock();
>>  
>> -	retval = copy_to_user(attr, &lp, sizeof(lp)) ? -EFAULT : 0;
>> +	retval = sched_read_attr(attr, &lp, sizeof(lp), size);
>>  	return retval;
>>  
>>  out_unlock:
>> -----------------------------------------------------------
>>
>> Do we need to make sched_setattr symmetrical, or, since the user has
>> to fill the fields anyway, we leave it as is?
>>
>> Thanks,
>>
>> - Juri
> 
