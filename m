Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbaFSOMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 10:12:09 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:3177 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754027AbaFSOMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 10:12:07 -0400
Date: Thu, 19 Jun 2014 10:12:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [GIT PULL] tracing: Cleanups and fixes to syscall tracepoints
Message-ID: <20140619101204.2b0b3837@gandalf.local.home>
In-Reply-To: <20140619095908.49dbc025@gandalf.local.home>
References: <20140619095908.49dbc025@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please do not pull this. I just found out that it can break other archs
as it uses TIF_SYSCALL_TRACEPOINT in generic code and not all archs
define it.

I'll work on a fix for this and send an update.

-- Steve


On Thu, 19 Jun 2014 09:59:08 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Linus,
> 
> This includes three patches from Oleg Nesterov. The first is a fix to a
> race condition that happens between enabling/disabling syscall tracepoints
> and new process creations (the check to go into the ptrace path for a process
> can be set when it shouldn't, or not set when it should). Not a major bug
> but one that should be fixed and even applied to stable.
> 
> The other two patches are cleanup/fixes that are not that critical, but
> for an -rc1 release would be nice to have. They both deal with syscall
> tracepoints.
> 
> I would have included these with my initial pull request, but as Oleg
> posted his last version as a reply to the bottom of the patch 1/3
> thread, I missed it.
> 
> Please pull the latest trace-fixes-v3.16-rc1 tree, which can be found at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> trace-fixes-v3.16-rc1
> 
> Tag SHA1: b6890d3b54aa3ff1aa34afb6c7af367895b9f07a
> Head SHA1: 72fa1a896d8ef355e81270667803ceb16a3dd13f
> 
> 
> Oleg Nesterov (3):
>       tracing: Fix syscall_*regfunc() vs copy_process() race
>       tracing: Change syscall_*regfunc() to check PF_KTHREAD and use for_each_process_thread()
>       tracing: syscall_regfunc() should not skip kernel threads
> 
> ----
>  include/trace/syscall.h | 15 +++++++++++++++
>  kernel/fork.c           |  2 ++
>  kernel/tracepoint.c     | 26 +++++++++++---------------
>  3 files changed, 28 insertions(+), 15 deletions(-)
> ---------------------------
> diff --git a/include/trace/syscall.h b/include/trace/syscall.h
> index fed853f3d7aa..291c2824fafb 100644
> --- a/include/trace/syscall.h
> +++ b/include/trace/syscall.h
> @@ -4,6 +4,7 @@
>  #include <linux/tracepoint.h>
>  #include <linux/unistd.h>
>  #include <linux/ftrace_event.h>
> +#include <linux/thread_info.h>
>  
>  #include <asm/ptrace.h>
>  
> @@ -32,4 +33,18 @@ struct syscall_metadata {
>  	struct ftrace_event_call *exit_event;
>  };
>  
> +#ifdef CONFIG_TRACEPOINTS
> +static inline void syscall_tracepoint_update(struct task_struct *p)
> +{
> +	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
> +		set_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
> +	else
> +		clear_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
> +}
> +#else
> +static inline void syscall_tracepoint_update(struct task_struct *p)
> +{
> +}
> +#endif
> +
>  #endif /* _TRACE_SYSCALL_H */
> diff --git a/kernel/fork.c b/kernel/fork.c
> index d2799d1fc952..6a13c46cd87d 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1487,7 +1487,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  
>  	total_forks++;
>  	spin_unlock(&current->sighand->siglock);
> +	syscall_tracepoint_update(p);
>  	write_unlock_irq(&tasklist_lock);
> +
>  	proc_fork_connector(p);
>  	cgroup_post_fork(p);
>  	if (clone_flags & CLONE_THREAD)
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 33cbd8c203f8..3490407dc7b7 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -492,33 +492,29 @@ static int sys_tracepoint_refcount;
>  
>  void syscall_regfunc(void)
>  {
> -	unsigned long flags;
> -	struct task_struct *g, *t;
> +	struct task_struct *p, *t;
>  
>  	if (!sys_tracepoint_refcount) {
> -		read_lock_irqsave(&tasklist_lock, flags);
> -		do_each_thread(g, t) {
> -			/* Skip kernel threads. */
> -			if (t->mm)
> -				set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
> -		} while_each_thread(g, t);
> -		read_unlock_irqrestore(&tasklist_lock, flags);
> +		read_lock(&tasklist_lock);
> +		for_each_process_thread(p, t) {
> +			set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
> +		}
> +		read_unlock(&tasklist_lock);
>  	}
>  	sys_tracepoint_refcount++;
>  }
>  
>  void syscall_unregfunc(void)
>  {
> -	unsigned long flags;
> -	struct task_struct *g, *t;
> +	struct task_struct *p, *t;
>  
>  	sys_tracepoint_refcount--;
>  	if (!sys_tracepoint_refcount) {
> -		read_lock_irqsave(&tasklist_lock, flags);
> -		do_each_thread(g, t) {
> +		read_lock(&tasklist_lock);
> +		for_each_process_thread(p, t) {
>  			clear_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
> -		} while_each_thread(g, t);
> -		read_unlock_irqrestore(&tasklist_lock, flags);
> +		}
> +		read_unlock(&tasklist_lock);
>  	}
>  }
>  #endif

