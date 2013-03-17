Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab3CQSy5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 14:54:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21428 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab3CQSyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 14:54:54 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=dg4Nx7oYL4YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=T1sv73n0zC0A:10 a=20KFwNOVAAAA:8 a=IgarNBvqBE6palEcv74A:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363546493.25967.129.camel@gandalf.local.home>
Subject: Re: [PATCH 2/2] tracing: syscall_regfunc() should not skip kernel
 threads
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-arch <linux-arch@vger.kernel.org>
Date: Sun, 17 Mar 2013 14:54:53 -0400
In-Reply-To: <20130317182834.GA22989@redhat.com>
References: <20130317182834.GA22989@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-03-17 at 19:28 +0100, Oleg Nesterov wrote:
> syscall_regfunc() ignores the kernel thread because "it has
> no effect", see cc3b13c1 "Don't trace kernel thread syscalls".
> 
> However, this means that a user-space task spawned by
> call_usermodehelper() won't report the system calls if
> kernel_execve() is called when sys_tracepoint_refcount != 0.
> 
> Remove this check. Hopefully the unnecessary report from
> ret_from_fork path mentioned by cc3b13c1 is fine. In fact
> "this is the only case" is not true. Say, kernel_execve()
> itself does "int 80" on X86_32. Hopefully fine too.
> 

I'm really thinking the TIF_SYSCALL_TRACEPOINT flag is getting a bit
ridiculous. We really should have a "swap syscall table when tracepoints
enabled" that changes the syscall table that does exactly the same thing
as the normal table but wraps the system call with the tracepoints.
Something that we are looking to do with interrupts.

Altough this may not be that trivial, as this seems to be the method to
trace system calls on not only x86, but also PowerPC, ARM, s390, Sparc,
and sh.

-- Steve

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/tracepoint.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index a16754b..4e1e4ca 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -737,9 +737,7 @@ void syscall_regfunc(void)
>  	if (!sys_tracepoint_refcount) {
>  		read_lock(&tasklist_lock);
>  		do_each_thread(g, t) {
> -			/* Skip kernel threads. */
> -			if (!(t->flags & PF_KTHREAD))
> -				set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
> +			set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
>  		} while_each_thread(g, t);
>  		read_unlock(&tasklist_lock);
>  	}


