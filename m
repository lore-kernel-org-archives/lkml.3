Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbaDNX5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 19:57:25 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:57279 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbaDNX5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 19:57:23 -0400
Date: Tue, 15 Apr 2014 01:57:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 1/3] tracing: fix syscall_*regfunc() vs copy_process()
 race
Message-ID: <20140414235718.GH1877@localhost.localdomain>
References: <360091921.1294.1397060915052.JavaMail.zimbra@efficios.com>
 <20140409124249.4081e665@gandalf.local.home>
 <20140409170505.GA27638@redhat.com>
 <20140409170542.GB27638@redhat.com>
 <20140410090643.46ca2226@gandalf.local.home>
 <20140410133435.GB12228@redhat.com>
 <20140411112259.79f0a0ba@gandalf.local.home>
 <20140411155845.GA30199@redhat.com>
 <20140413185828.GA20668@redhat.com>
 <20140413185854.GB20668@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140413185854.GB20668@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 08:58:54PM +0200, Oleg Nesterov wrote:
> syscall_regfunc() and syscall_unregfunc() should set/clear
> TIF_SYSCALL_TRACEPOINT system-wide, but do_each_thread() can race
> with copy_process() and miss the new child which was not added to
> the process/thread lists yet.
> 
> Change copy_process() to update the child's TIF_SYSCALL_TRACEPOINT
> under tasklist.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

> ---
>  include/trace/syscall.h |   15 +++++++++++++++
>  kernel/fork.c           |    2 ++
>  2 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/include/trace/syscall.h b/include/trace/syscall.h
> index fed853f..291c282 100644
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
> index a17621c..2d55a47 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1484,7 +1484,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
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
> 1.5.5.1
> 
> 
