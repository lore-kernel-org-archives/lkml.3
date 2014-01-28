Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbaA0PQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 10:16:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:48433 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753651AbaA0PQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 10:16:15 -0500
X-IronPort-AV: E=Sophos;i="4.95,729,1384272000"; 
   d="scan'208";a="9458421"
Message-ID: <52E723BB.9070100@cn.fujitsu.com>
Date: Mon, 27 Jan 2014 22:27:55 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
CC: peterz@infradead.org, linux-kernel@vger.kernel.org, raistlin@linux.it,
        juri.lelli@gmail.com, clark.williams@gmail.com, mingo@redhat.com,
        rostedt@goodmis.org
Subject: Re: [PATCH 3/3 V2] sched: Implement task_nice as static inline function.
References: <20140127130850.GB4941@twins.programming.kicks-ass.net> <1390878045-7096-1-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1390878045-7096-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/27 22:28:40,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/27 22:28:44,
	Serialize complete at 2014/01/27 22:28:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, what about this version?

On 01/27/2014 10:00 PM, Dongsheng Yang wrote:
> As commit 0e0c0797 expose the priority related macros in linux/sched/prio.h,
> we don't have to implement task_nice in kernel/sched/core.c any more.
>
> This patch implement it in linux/sched/sched.h as static inline function,
> saving the kernel stack and enhancing the performance.
>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>      Changelog:
>          - v1:
>              * leave the task_prio() in kernel/sched/core.c
>              * remove macro TASK_NICE and implement it as static inline
>                function in include/linux/sched.h.
>   include/linux/sched.h      | 11 ++++++++++-
>   include/linux/sched/prio.h |  1 -
>   kernel/sched/core.c        | 26 +++++++-------------------
>   kernel/sched/cputime.c     |  4 ++--
>   4 files changed, 19 insertions(+), 23 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index ba1b732..5b63361 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2083,7 +2083,16 @@ static inline void sched_autogroup_exit(struct signal_struct *sig) { }
>   extern bool yield_to(struct task_struct *p, bool preempt);
>   extern void set_user_nice(struct task_struct *p, long nice);
>   extern int task_prio(const struct task_struct *p);
> -extern int task_nice(const struct task_struct *p);
> +/**
> + * task_nice - return the nice value of a given task.
> + * @p: the task in question.
> + *
> + * Return: The nice value [ -20 ... 0 ... 19 ].
> + */
> +static inline int task_nice(const struct task_struct *p)
> +{
> +	return PRIO_TO_NICE((p)->static_prio);
> +}
>   extern int can_nice(const struct task_struct *p, const int nice);
>   extern int task_curr(const struct task_struct *p);
>   extern int idle_cpu(int cpu);
> diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
> index 13216f1..410ccb7 100644
> --- a/include/linux/sched/prio.h
> +++ b/include/linux/sched/prio.h
> @@ -27,7 +27,6 @@
>    */
>   #define NICE_TO_PRIO(nice)	(MAX_RT_PRIO + (nice) + 20)
>   #define PRIO_TO_NICE(prio)	((prio) - MAX_RT_PRIO - 20)
> -#define TASK_NICE(p)		PRIO_TO_NICE((p)->static_prio)
>   
>   /*
>    * 'User priority' is the nice value converted to something we
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 7fea865..b2bc1db 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2998,7 +2998,7 @@ void set_user_nice(struct task_struct *p, long nice)
>   	unsigned long flags;
>   	struct rq *rq;
>   
> -	if (TASK_NICE(p) == nice || nice < -20 || nice > 19)
> +	if (task_nice(p) == nice || nice < -20 || nice > 19)
>   		return;
>   	/*
>   	 * We have to be careful, if called from sys_setpriority(),
> @@ -3076,7 +3076,7 @@ SYSCALL_DEFINE1(nice, int, increment)
>   	if (increment > 40)
>   		increment = 40;
>   
> -	nice = TASK_NICE(current) + increment;
> +	nice = task_nice(current) + increment;
>   	if (nice < -20)
>   		nice = -20;
>   	if (nice > 19)
> @@ -3109,18 +3109,6 @@ int task_prio(const struct task_struct *p)
>   }
>   
>   /**
> - * task_nice - return the nice value of a given task.
> - * @p: the task in question.
> - *
> - * Return: The nice value [ -20 ... 0 ... 19 ].
> - */
> -int task_nice(const struct task_struct *p)
> -{
> -	return TASK_NICE(p);
> -}
> -EXPORT_SYMBOL(task_nice);
> -
> -/**
>    * idle_cpu - is a given cpu idle currently?
>    * @cpu: the processor in question.
>    *
> @@ -3319,7 +3307,7 @@ recheck:
>   	 */
>   	if (user && !capable(CAP_SYS_NICE)) {
>   		if (fair_policy(policy)) {
> -			if (attr->sched_nice < TASK_NICE(p) &&
> +			if (attr->sched_nice < task_nice(p) &&
>   			    !can_nice(p, attr->sched_nice))
>   				return -EPERM;
>   		}
> @@ -3343,7 +3331,7 @@ recheck:
>   		 * SCHED_NORMAL if the RLIMIT_NICE would normally permit it.
>   		 */
>   		if (p->policy == SCHED_IDLE && policy != SCHED_IDLE) {
> -			if (!can_nice(p, TASK_NICE(p)))
> +			if (!can_nice(p, task_nice(p)))
>   				return -EPERM;
>   		}
>   
> @@ -3383,7 +3371,7 @@ recheck:
>   	 * If not changing anything there's no need to proceed further:
>   	 */
>   	if (unlikely(policy == p->policy)) {
> -		if (fair_policy(policy) && attr->sched_nice != TASK_NICE(p))
> +		if (fair_policy(policy) && attr->sched_nice != task_nice(p))
>   			goto change;
>   		if (rt_policy(policy) && attr->sched_priority != p->rt_priority)
>   			goto change;
> @@ -3835,7 +3823,7 @@ SYSCALL_DEFINE3(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
>   	else if (task_has_rt_policy(p))
>   		attr.sched_priority = p->rt_priority;
>   	else
> -		attr.sched_nice = TASK_NICE(p);
> +		attr.sched_nice = task_nice(p);
>   
>   	rcu_read_unlock();
>   
> @@ -7006,7 +6994,7 @@ void normalize_rt_tasks(void)
>   			 * Renice negative nice level userspace
>   			 * tasks back to 0:
>   			 */
> -			if (TASK_NICE(p) < 0 && p->mm)
> +			if (task_nice(p) < 0 && p->mm)
>   				set_user_nice(p, 0);
>   			continue;
>   		}
> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> index 9994791..58624a6 100644
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -142,7 +142,7 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
>   	p->utimescaled += cputime_scaled;
>   	account_group_user_time(p, cputime);
>   
> -	index = (TASK_NICE(p) > 0) ? CPUTIME_NICE : CPUTIME_USER;
> +	index = (task_nice(p) > 0) ? CPUTIME_NICE : CPUTIME_USER;
>   
>   	/* Add user time to cpustat. */
>   	task_group_account_field(p, index, (__force u64) cputime);
> @@ -169,7 +169,7 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
>   	p->gtime += cputime;
>   
>   	/* Add guest time to cpustat. */
> -	if (TASK_NICE(p) > 0) {
> +	if (task_nice(p) > 0) {
>   		cpustat[CPUTIME_NICE] += (__force u64) cputime;
>   		cpustat[CPUTIME_GUEST_NICE] += (__force u64) cputime;
>   	} else {

