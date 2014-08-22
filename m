Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbaHVPiC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:38:02 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:44460 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932097AbaHVPiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:38:00 -0400
Date: Fri, 22 Aug 2014 11:37:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] kernel: trace_syscalls: Replace rcu_assign_pointer()
 with RCU_INIT_POINTER()
Message-ID: <20140822113758.172eb474@gandalf.local.home>
In-Reply-To: <20140822142822.GA32391@ada>
References: <20140822142822.GA32391@ada>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014 17:28:22 +0300
Andreea-Cristina Bernat <bernat.ada@gmail.com> wrote:

> The uses of "rcu_assign_pointer()" are NULLing out the pointers.
> According to RCU_INIT_POINTER()'s block comment:
> "1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
> it is better to use it instead of rcu_assign_pointer() because it has a
> smaller overhead.
> 
> The following Coccinelle semantic patch was used:
> @@
> @@
> 
> - rcu_assign_pointer
> + RCU_INIT_POINTER
>   (..., NULL)

I guess I can add this. It's a very slow path thus it isn't critical.

Although, I hate the name. Perhaps we should add another macro called
RCU_CLEAR_POINTER() or something that just nulls it. That way it
documents the use. To me, INIT means the pointer is being initialized,
where in reality it's just being cleared. I guess one could argue that
the pointer is being "re-initialized".

Thanks!

-- Steve

> 
> Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
> ---
>  kernel/trace/trace_syscalls.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 759d5e0..4dc8b79 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -425,7 +425,7 @@ static void unreg_event_syscall_enter(struct ftrace_event_file *file,
>  		return;
>  	mutex_lock(&syscall_trace_lock);
>  	tr->sys_refcount_enter--;
> -	rcu_assign_pointer(tr->enter_syscall_files[num], NULL);
> +	RCU_INIT_POINTER(tr->enter_syscall_files[num], NULL);
>  	if (!tr->sys_refcount_enter)
>  		unregister_trace_sys_enter(ftrace_syscall_enter, tr);
>  	mutex_unlock(&syscall_trace_lock);
> @@ -463,7 +463,7 @@ static void unreg_event_syscall_exit(struct ftrace_event_file *file,
>  		return;
>  	mutex_lock(&syscall_trace_lock);
>  	tr->sys_refcount_exit--;
> -	rcu_assign_pointer(tr->exit_syscall_files[num], NULL);
> +	RCU_INIT_POINTER(tr->exit_syscall_files[num], NULL);
>  	if (!tr->sys_refcount_exit)
>  		unregister_trace_sys_exit(ftrace_syscall_exit, tr);
>  	mutex_unlock(&syscall_trace_lock);

