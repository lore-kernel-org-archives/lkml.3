Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbaK0XVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 18:21:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbaK0XVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 18:21:40 -0500
Date: Fri, 28 Nov 2014 00:21:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Evan Teran <eteran@alum.rit.edu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Pedro Alves <palves@redhat.com>, Roland McGrath <roland@hack.frob.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ptrace/x86: fix the TIF_FORCED_TF logic in
	handle_signal()
Message-ID: <20141127232126.GA25773@redhat.com>
References: <20141103201256.GA5213@redhat.com> <20141103201317.GA5221@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141103201317.GA5221@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping ;)

Should I resend? This fixes the real (although not that serious) bug
and nobody objected.

On 11/03, Oleg Nesterov wrote:
>
> When the TIF_SINGLESTEP tracee dequeues a signal, handle_signal()
> clears TIF_FORCED_TF and X86_EFLAGS_TF but leaves TIF_SINGLESTEP set.
> 
> If the tracer does PTRACE_SINGLESTEP again, enable_single_step() sets
> X86_EFLAGS_TF but not TIF_FORCED_TF. This means that the subsequent
> PTRACE_CONT doesn't not clear X86_EFLAGS_TF, and the tracee gets the
> wrong SIGTRAP.
> 
> Test-case (needs -O2 to avoid prologue insns in signal handler):
> 
> 	#include <unistd.h>
> 	#include <stdio.h>
> 	#include <sys/ptrace.h>
> 	#include <sys/wait.h>
> 	#include <sys/user.h>
> 	#include <assert.h>
> 	#include <stddef.h>
> 
> 	void handler(int n)
> 	{
> 		asm("nop");
> 	}
> 
> 	int child(void)
> 	{
> 		assert(ptrace(PTRACE_TRACEME, 0,0,0) == 0);
> 		signal(SIGALRM, handler);
> 		kill(getpid(), SIGALRM);
> 		return 0x23;
> 	}
> 
> 	void *getip(int pid)
> 	{
> 		return (void*)ptrace(PTRACE_PEEKUSER, pid,
> 					offsetof(struct user, regs.rip), 0);
> 	}
> 
> 	int main(void)
> 	{
> 		int pid, status;
> 
> 		pid = fork();
> 		if (!pid)
> 			return child();
> 
> 		assert(wait(&status) == pid);
> 		assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGALRM);
> 
> 		assert(ptrace(PTRACE_SINGLESTEP, pid, 0, SIGALRM) == 0);
> 		assert(wait(&status) == pid);
> 		assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGTRAP);
> 		assert((getip(pid) - (void*)handler) == 0);
> 
> 		assert(ptrace(PTRACE_SINGLESTEP, pid, 0, SIGALRM) == 0);
> 		assert(wait(&status) == pid);
> 		assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGTRAP);
> 		assert((getip(pid) - (void*)handler) == 1);
> 
> 		assert(ptrace(PTRACE_CONT, pid, 0,0) == 0);
> 		assert(wait(&status) == pid);
> 		assert(WIFEXITED(status) && WEXITSTATUS(status) == 0x23);
> 
> 		return 0;
> 	}
> 
> The last assert() fails because PTRACE_CONT wrongly triggers another
> single-step and X86_EFLAGS_TF can't be cleared by debugger until the
> tracee does sys_rt_sigreturn().
> 
> Change handle_signal() to do user_disable_single_step() if stepping,
> we do not need to preserve TIF_SINGLESTEP because we are going to do
> ptrace_notify(), and it is simply wrong to leak this bit.
> 
> While at it, change the comment to explain why we also need to clear
> TF unconditionally after setup_rt_frame().
> 
> Note: in the longer term we should probably change setup_sigcontext()
> to use get_flags() and then just remove this user_disable_single_step().
> And, the state of TIF_FORCED_TF can be wrong after restore_sigcontext()
> which can set/clear TF, this needs another fix.
> 
> Reported-by: Evan Teran <eteran@alum.rit.edu>
> Reported-by: Pedro Alves <palves@redhat.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  arch/x86/kernel/signal.c |   22 +++++++++++-----------
>  1 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
> index ed37a76..9d3a15b 100644
> --- a/arch/x86/kernel/signal.c
> +++ b/arch/x86/kernel/signal.c
> @@ -629,7 +629,8 @@ setup_rt_frame(struct ksignal *ksig, struct pt_regs *regs)
>  static void
>  handle_signal(struct ksignal *ksig, struct pt_regs *regs)
>  {
> -	bool failed;
> +	bool stepping, failed;
> +
>  	/* Are we from a system call? */
>  	if (syscall_get_nr(current, regs) >= 0) {
>  		/* If so, check system call restarting.. */
> @@ -653,12 +654,13 @@ handle_signal(struct ksignal *ksig, struct pt_regs *regs)
>  	}
>  
>  	/*
> -	 * If TF is set due to a debugger (TIF_FORCED_TF), clear the TF
> -	 * flag so that register information in the sigcontext is correct.
> +	 * If TF is set due to a debugger (TIF_FORCED_TF), clear TF now
> +	 * so that register information in the sigcontext is correct and
> +	 * then notify the tracer before entering the signal handler.
>  	 */
> -	if (unlikely(regs->flags & X86_EFLAGS_TF) &&
> -	    likely(test_and_clear_thread_flag(TIF_FORCED_TF)))
> -		regs->flags &= ~X86_EFLAGS_TF;
> +	stepping = test_thread_flag(TIF_SINGLESTEP);
> +	if (stepping)
> +		user_disable_single_step(current);
>  
>  	failed = (setup_rt_frame(ksig, regs) < 0);
>  	if (!failed) {
> @@ -669,10 +671,8 @@ handle_signal(struct ksignal *ksig, struct pt_regs *regs)
>  		 * it might disable possible debug exception from the
>  		 * signal handler.
>  		 *
> -		 * Clear TF when entering the signal handler, but
> -		 * notify any tracer that was single-stepping it.
> -		 * The tracer may want to single-step inside the
> -		 * handler too.
> +		 * Clear TF for the case when it wasn't set by debugger to
> +		 * avoid the recursive send_sigtrap() in SIGTRAP handler.
>  		 */
>  		regs->flags &= ~(X86_EFLAGS_DF|X86_EFLAGS_RF|X86_EFLAGS_TF);
>  		/*
> @@ -681,7 +681,7 @@ handle_signal(struct ksignal *ksig, struct pt_regs *regs)
>  		if (used_math())
>  			drop_init_fpu(current);
>  	}
> -	signal_setup_done(failed, ksig, test_thread_flag(TIF_SINGLESTEP));
> +	signal_setup_done(failed, ksig, stepping);
>  }
>  
>  #ifdef CONFIG_X86_32
> -- 
> 1.5.5.1
> 

