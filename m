Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab3CQSsr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 14:48:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26546 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab3CQSsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 14:48:46 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=nJI44pA0MDYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Z3CilEaj6XsA:10 a=20KFwNOVAAAA:8 a=iLMMwQ58nTghOZc7rj0A:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363546123.25967.125.camel@gandalf.local.home>
Subject: Re: [PATCH 1/2] tracing: syscall_*regfunc() can race with
 copy_process()
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Date: Sun, 17 Mar 2013 14:48:43 -0400
In-Reply-To: <20130317182831.GA22986@redhat.com>
References: <20130317182831.GA22986@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-03-17 at 19:28 +0100, Oleg Nesterov wrote:
> syscall_regfunc() and syscall_unregfunc() should set/clear
> TIF_SYSCALL_TRACEPOINT system-wide, but do_each_thread() can race
> with copy_process() and miss the new child which was not added to
> init_task.tasks list yet.
> 
> Change copy_process() to update the child's TIF_SYSCALL_TRACEPOINT
> under tasklist.

Is this because "p = dup_task_struct(current);" is outside the lock?
Probably should state this in the change log.

> 
> While at it,
> 
> 	- remove _irqsafe from syscall_regfunc/syscall_unregfunc,
> 	  read_lock(tasklist) doesn't need to disable irqs.

I'm fine with this.

> 
> 	- change syscall_unregfunc() to check PF_KTHREAD to skip
> 	  the kernel threads, ->mm != NULL is the common mistake.

I'm fine with this too.

> 
> 	  Note: probably this check should be simply removed, needs
> 	  another patch.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/fork.c       |    7 +++++++
>  kernel/tracepoint.c |   12 +++++-------
>  2 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 1766d32..8184a53 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1472,7 +1472,14 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  
>  	total_forks++;
>  	spin_unlock(&current->sighand->siglock);
> +#ifdef CONFIG_TRACEPOINTS
> +	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
> +		set_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
> +	else
> +		clear_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
> +#endif

I hate seeing #ifdef code like this in C files. Can you add a function
to set this in include/trace/syscalls.h:

#ifdef CONFIG_TRACEPOINTS
static inline void syscall_tracepoint_update(struct task_struct *p)
{
	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
		set_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
	else
		clear_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
}
#else
static inline void syscall_tracepoint_update(struct task_struct *p) {}
#endif

Then in copy_process() just have:

	syscall_tracepoint_update(p);

Thanks,

-- Steve


>  	write_unlock_irq(&tasklist_lock);
> +
>  	proc_fork_connector(p);
>  	cgroup_post_fork(p);
>  	if (clone_flags & CLONE_THREAD)
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 0c05a45..a16754b 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -732,33 +732,31 @@ static int sys_tracepoint_refcount;
>  
>  void syscall_regfunc(void)
>  {
> -	unsigned long flags;
>  	struct task_struct *g, *t;
>  
>  	if (!sys_tracepoint_refcount) {
> -		read_lock_irqsave(&tasklist_lock, flags);
> +		read_lock(&tasklist_lock);
>  		do_each_thread(g, t) {
>  			/* Skip kernel threads. */
> -			if (t->mm)
> +			if (!(t->flags & PF_KTHREAD))
>  				set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
>  		} while_each_thread(g, t);
> -		read_unlock_irqrestore(&tasklist_lock, flags);
> +		read_unlock(&tasklist_lock);
>  	}
>  	sys_tracepoint_refcount++;
>  }
>  
>  void syscall_unregfunc(void)
>  {
> -	unsigned long flags;
>  	struct task_struct *g, *t;
>  
>  	sys_tracepoint_refcount--;
>  	if (!sys_tracepoint_refcount) {
> -		read_lock_irqsave(&tasklist_lock, flags);
> +		read_lock(&tasklist_lock);
>  		do_each_thread(g, t) {
>  			clear_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
>  		} while_each_thread(g, t);
> -		read_unlock_irqrestore(&tasklist_lock, flags);
> +		read_unlock(&tasklist_lock);
>  	}
>  }
>  #endif


