Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbaFUBLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 21:11:32 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50934 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbaFUBLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 21:11:30 -0400
Date: Fri, 20 Jun 2014 18:11:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [for-next][PATCH v2 1/3] tracing: Fix syscall_*regfunc() vs
 copy_process() race
Message-ID: <20140621011125.GA23415@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140620104518.722157733@goodmis.org>
 <20140620104711.140660296@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620104711.140660296@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062101-0928-0000-0000-000002D940A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 06:45:19AM -0400, Steven Rostedt wrote:
> From: Oleg Nesterov <oleg@redhat.com>
> 
> syscall_regfunc() and syscall_unregfunc() should set/clear
> TIF_SYSCALL_TRACEPOINT system-wide, but do_each_thread() can race
> with copy_process() and miss the new child which was not added to
> the process/thread lists yet.
> 
> Change copy_process() to update the child's TIF_SYSCALL_TRACEPOINT
> under tasklist.
> 
> Link: http://lkml.kernel.org/p/20140413185854.GB20668@redhat.com
> 
> Cc: stable@vger.kernel.org # 2.6.33
> Fixes: a871bd33a6c0 "tracing: Add syscall tracepoints"
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  include/trace/syscall.h | 15 +++++++++++++++
>  kernel/fork.c           |  2 ++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/include/trace/syscall.h b/include/trace/syscall.h
> index fed853f3d7aa..9674145e2f6a 100644
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
> +#if defined(CONFIG_TRACEPOINTS) && defined(CONFIG_HAVE_SYSCALL_TRACEPOINTS)
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
> -- 
> 2.0.0
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

