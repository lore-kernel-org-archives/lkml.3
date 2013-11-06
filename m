Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab3KFKvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:51:11 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756068Ab3KFKvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:51:07 -0500
Message-ID: <527A1F10.9060102@nod.at>
Date: Wed, 06 Nov 2013 11:50:56 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jonas Bonn <jonas@southpole.se>
CC: linux-kernel@vger.kernel.org, linux@openrisc.net
Subject: Re: [PATCH 1/1] openrisc: Use get_signal() signal_setup_done()
References: <1381232035-4240-3-git-send-email-richard@nod.at> <1383733051-10112-1-git-send-email-jonas@southpole.se>
In-Reply-To: <1383733051-10112-1-git-send-email-jonas@southpole.se>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.11.2013 11:17, schrieb Jonas Bonn:
> From: Richard Weinberger <richard@nod.at>
> 
> Use the more generic functions get_signal() signal_setup_done()
> for signal delivery.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> Signed-off-by: Jonas Bonn <jonas@southpole.se>
> ---
> 
> Hi Richard,
> 
> What's the status of this patch series?  Are these lined up for 3.13 already?

It has to wait for 3.14.
I got distracted and had not much time for Linux last month.
After the merge window I'll send v2 of the series.

> The changes look good but I've got a big rework of the signal handling code
> for OpenRISC and the patch doesn't apply cleanly.  I've reworked your patch
> (see below) and would just like you to verify that I haven't messed anything
> up.  If it's OK by you, I will take the below patch directly into the OpenRISC
> tree.

Patch looks good. :)
(But I didn't test it!)

Thanks,
//richard

> Best regards,
> Jonas
> 
>  arch/openrisc/kernel/signal.c | 59 ++++++++++++++++---------------------------
>  1 file changed, 22 insertions(+), 37 deletions(-)
> 
> diff --git a/arch/openrisc/kernel/signal.c b/arch/openrisc/kernel/signal.c
> index c277ec8..66775bc 100644
> --- a/arch/openrisc/kernel/signal.c
> +++ b/arch/openrisc/kernel/signal.c
> @@ -166,20 +166,21 @@ static inline void __user *get_sigframe(struct k_sigaction *ka,
>   * trampoline which performs the syscall sigreturn, or a provided
>   * user-mode trampoline.
>   */
> -static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
> -			  sigset_t *set, struct pt_regs *regs)
> +static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
> +			  struct pt_regs *regs)
>  {
>  	struct rt_sigframe *frame;
>  	unsigned long return_ip;
>  	int err = 0;
>  
> -	frame = get_sigframe(ka, regs, sizeof(*frame));
> +	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
> +
>  	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
> -		goto give_sigsegv;
> +		return -EFAULT;
>  
>  	/* Create siginfo.  */
> -	if (ka->sa.sa_flags & SA_SIGINFO)
> -		err |= copy_siginfo_to_user(&frame->info, info);
> +	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
> +		err |= copy_siginfo_to_user(&frame->info, &ksig->info);
>  
>  	/* Create the ucontext.  */
>  	err |= __put_user(0, &frame->uc.uc_flags);
> @@ -190,7 +191,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
>  	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
>  
>  	if (err)
> -		goto give_sigsegv;
> +		return -EFAULT;
>  
>  	/* trampoline - the desired return ip is the retcode itself */
>  	return_ip = (unsigned long)&frame->retcode;
> @@ -204,14 +205,14 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
>  	err |= __put_user(0x15000000, (unsigned long *)(frame->retcode + 8));
>  
>  	if (err)
> -		goto give_sigsegv;
> +		return -EFAULT;
>  
>  	/* TODO what is the current->exec_domain stuff and invmap ? */
>  
>  	/* Set up registers for signal handler */
> -	regs->pc = (unsigned long)ka->sa.sa_handler; /* what we enter NOW */
> +	regs->pc = (unsigned long)ksig->ka.sa.sa_handler; /* what we enter NOW */
>  	regs->gpr[9] = (unsigned long)return_ip;     /* what we enter LATER */
> -	regs->gpr[3] = (unsigned long)sig;           /* arg 1: signo */
> +	regs->gpr[3] = (unsigned long)ksig->sig;           /* arg 1: signo */
>  	regs->gpr[4] = (unsigned long)&frame->info;  /* arg 2: (siginfo_t*) */
>  	regs->gpr[5] = (unsigned long)&frame->uc;    /* arg 3: ucontext */
>  
> @@ -219,25 +220,16 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
>  	regs->sp = (unsigned long)frame;
>  
>  	return 0;
> -
> -give_sigsegv:
> -	force_sigsegv(sig, current);
> -	return -EFAULT;
>  }
>  
>  static inline void
> -handle_signal(unsigned long sig,
> -	      siginfo_t *info, struct k_sigaction *ka,
> -	      struct pt_regs *regs)
> +handle_signal(struct ksignal *ksig, struct pt_regs *regs)
>  {
>  	int ret;
>  
> -	ret = setup_rt_frame(sig, ka, info, sigmask_to_save(), regs);
> -	if (ret)
> -		return;
> +	ret = setup_rt_frame(ksig, sigmask_to_save(), regs);
>  
> -	signal_delivered(sig, info, ka, regs,
> -				 test_thread_flag(TIF_SINGLESTEP));
> +	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
>  }
>  
>  /*
> @@ -254,9 +246,7 @@ handle_signal(unsigned long sig,
>  
>  int do_signal(struct pt_regs *regs, int syscall)
>  {
> -	siginfo_t info;
> -	int signr;
> -	struct k_sigaction ka;
> +	struct ksignal ksig;
>  	unsigned long continue_addr = 0;
>  	unsigned long restart_addr = 0;
>  	unsigned long retval = 0;
> @@ -286,28 +276,23 @@ int do_signal(struct pt_regs *regs, int syscall)
>  	}
>  
>  	/*
> -	 * Get the signal to deliver.  When running under ptrace, at this
> -	 * point the debugger may change all our registers ...
> +	 * Get the signal to deliver.  During the call to get_signal the
> +	 * debugger may change all our registers so we may need to revert
> +	 * the decision to restart the syscall; specifically, if the PC is
> +	 * changed, don't restart the syscall.
>  	 */
> -	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
> -	/*
> -	 * Depending on the signal settings we may need to revert the
> -	 * decision to restart the system call.  But skip this if a
> -	 * debugger has chosen to restart at a different PC.
> -	 */
> -	if (signr > 0) {
> +	if (get_signal(&ksig)) {
>  		if (unlikely(restart) && regs->pc == restart_addr) {
>  			if (retval == -ERESTARTNOHAND ||
>  			    retval == -ERESTART_RESTARTBLOCK
>  			    || (retval == -ERESTARTSYS
> -			        && !(ka.sa.sa_flags & SA_RESTART))) {
> +			        && !(ksig.ka.sa.sa_flags & SA_RESTART))) {
>  				/* No automatic restart */
>  				regs->gpr[11] = -EINTR;
>  				regs->pc = continue_addr;
>  			}
>  		}
> -
> -		handle_signal(signr, &info, &ka, regs);
> +		handle_signal(&ksig, regs);
>  	} else {
>  		/* no handler */
>  		restore_saved_sigmask();
> 

