Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbaBQNUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 08:20:36 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:62262 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbaBQNUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 08:20:35 -0500
Message-ID: <53020C9D.1050208@gmail.com>
Date: Mon, 17 Feb 2014 14:20:29 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mtk.manpages@gmail.com, Dario Faggioli <raistlin@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        rostedt@goodmis.org, Oleg Nesterov <oleg@redhat.com>,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, Linux Kernel <linux-kernel@vger.kernel.org>,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com
Subject: Re: [PATCH 01/13] sched: Add 3 new scheduler syscalls to support
 an extended scheduling parameters ABI
References: <20131217122720.950475833@infradead.org> <20131217123352.692059839@infradead.org> <CAHO5Pa3=+Zhg72tVfddSUvgirUyObir6atJVo4_16bVWB2Osgw@mail.gmail.com> <20140121153851.GZ31570@twins.programming.kicks-ass.net> <CAKgNAkgw+U44SH0wd_06ZMXaCC9nCX4NZxZHkMKUdC7E7YxBhQ@mail.gmail.com> <20140214161929.GL27965@twins.programming.kicks-ass.net>
In-Reply-To: <20140214161929.GL27965@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter,

On 02/14/2014 05:19 PM, Peter Zijlstra wrote:
> On Fri, Feb 14, 2014 at 03:13:22PM +0100, Michael Kerrisk (man-pages) wrote:
>> Peter, Dario,
>>
>> This is a little late in the day, but I think it's an important point
>> to just check before this API goes final.
>>
>>> SYNOPSIS
>>>         #include <sched.h>
>>>
>>>         struct sched_attr {
>>>                 u32 size;
>>>
>>>                 u32 sched_policy;
>>>                 u64 sched_flags;
>> [...]
>>>         };
>>>
>>>         int sched_setattr(pid_t pid, const struct sched_attr *attr);
>>>
>>>         int sched_getattr(pid_t pid, const struct sched_attr *attr, unsigned int size);
>>
>> So, I that there's a flags field in the structure, which allows for
>> some extensibility for these calls in the future. However, is it
>> worthwhile to consider adding a 'flags' argument in the base signature
>> of either of these calls, to allow for some possible extensions in the
>> future. (See http://lwn.net/SubscriberLink/585415/7b905c0248a158a2/ ).
> 
> Sure why not.. 

Well, it doesn't need to be added gratuitously -- just if you think there's
some nonzero chance it might prove useful in the future ;-).

> I picked 'unsigned long' for the flags argument; I don't
> think there's a real standard for this, I've seen: 'int' 'unsigned int'
> and 'unsigned long' flags.
> 
> Please holler if there is indeed a preference and I picked the wrong
> one.
> 
> BTW; do you need more text on the manpage thingy I send you or was that
> sufficient?

If your could take another pass though your existing text, to incorporate the
new flags stuff, and then send a page to me + linux-man@
that would be great.

Cheers,

Michael


> ---
> Subject: sched: Add 'flags' argument to sched_{set,get}attr() syscalls
> 
> Because of a recent syscall design debate; its deemed appropriate for
> each syscall to have a flags argument for future extension; without
> immediately requiring new syscalls.
> 
> Suggested-by: Michael Kerrisk <mtk.manpages@gmail.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  include/linux/syscalls.h |  6 ++++--
>  kernel/sched/core.c      | 11 ++++++-----
>  2 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 40ed9e9a77e5..bf41aeb09078 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -281,13 +281,15 @@ asmlinkage long sys_sched_setscheduler(pid_t pid, int policy,
>  asmlinkage long sys_sched_setparam(pid_t pid,
>  					struct sched_param __user *param);
>  asmlinkage long sys_sched_setattr(pid_t pid,
> -					struct sched_attr __user *attr);
> +					struct sched_attr __user *attr,
> +					unsigned long flags);
>  asmlinkage long sys_sched_getscheduler(pid_t pid);
>  asmlinkage long sys_sched_getparam(pid_t pid,
>  					struct sched_param __user *param);
>  asmlinkage long sys_sched_getattr(pid_t pid,
>  					struct sched_attr __user *attr,
> -					unsigned int size);
> +					unsigned int size,
> +					unsigned long flags);
>  asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
>  					unsigned long __user *user_mask_ptr);
>  asmlinkage long sys_sched_getaffinity(pid_t pid, unsigned int len,
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index fb9764fbc537..deeaa54fdf92 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3631,13 +3631,14 @@ SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct sched_param __user *, param)
>   * @pid: the pid in question.
>   * @uattr: structure containing the extended parameters.
>   */
> -SYSCALL_DEFINE2(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr)
> +SYSCALL_DEFINE3(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr,
> +			       unsigned long, flags)
>  {
>  	struct sched_attr attr;
>  	struct task_struct *p;
>  	int retval;
>  
> -	if (!uattr || pid < 0)
> +	if (!uattr || pid < 0 || flags)
>  		return -EINVAL;
>  
>  	if (sched_copy_attr(uattr, &attr))
> @@ -3774,8 +3775,8 @@ static int sched_read_attr(struct sched_attr __user *uattr,
>   * @uattr: structure containing the extended parameters.
>   * @size: sizeof(attr) for fwd/bwd comp.
>   */
> -SYSCALL_DEFINE3(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
> -		unsigned int, size)
> +SYSCALL_DEFINE4(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
> +		unsigned int, size, unsigned long, flags)
>  {
>  	struct sched_attr attr = {
>  		.size = sizeof(struct sched_attr),
> @@ -3784,7 +3785,7 @@ SYSCALL_DEFINE3(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
>  	int retval;
>  
>  	if (!uattr || pid < 0 || size > PAGE_SIZE ||
> -	    size < SCHED_ATTR_SIZE_VER0)
> +	    size < SCHED_ATTR_SIZE_VER0 || flags)
>  		return -EINVAL;
>  
>  	rcu_read_lock();
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
