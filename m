Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab3JHOOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 10:14:23 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:52001 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab3JHOOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 10:14:18 -0400
Message-ID: <52541313.4020101@synopsys.com>
Date: Tue, 8 Oct 2013 19:43:39 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.cross-arch
To: Richard Weinberger <richard@nod.at>, <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
        <catalin.marinas@arm.com>, <will.deacon@arm.com>,
        <hskinnemoen@gmail.com>, <egtvedt@samfundet.no>, <vapier@gentoo.org>,
        <msalter@redhat.com>, <a-jacquiot@ti.com>, <starvik@axis.com>,
        <jesper.nilsson@axis.com>, <dhowells@redhat.com>,
        <rkuo@codeaurora.org>, <tony.luck@intel.com>, <fenghua.yu@intel.com>,
        <takata@linux-m32r.org>, <geert@linux-m68k.org>,
        <james.hogan@imgtec.com>, <monstr@monstr.eu>,
        <yasutake.koichi@jp.panasonic.com>, <ralf@linux-mips.org>,
        <jonas@southpole.se>, <jejb@parisc-linux.org>, <deller@gmx.de>,
        <benh@kernel.crashing.org>, <paulus@samba.org>,
        <schwidefsky@de.ibm.com>, <heiko.carstens@de.ibm.com>,
        <liqin.linux@gmail.com>, <lennox.wu@gmail.com>,
        <linux-sh@vger.kernel.org>, <cmetcalf@tilera.com>,
        <gxt@mprc.pku.edu.cn>, <linux-xtensa@linux-xtensa.org>,
        <akpm@linux-foundation.org>, <oleg@redhat.com>, <tj@kernel.org>
Subject: Re: [PATCH 01/29] arc: Use get_signal() signal_setup_done()
References: <1381231701-4008-1-git-send-email-richard@nod.at> <1381231701-4008-2-git-send-email-richard@nod.at>
In-Reply-To: <1381231701-4008-2-git-send-email-richard@nod.at>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.243]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard/all,

Sorry if this is repost - it seems the bounce back from Paul Mundt caused my
earlier reply to not be posted to list. I wonder how other are managing to reply
to thread or is that a Synopsys email server quirk.

Anyways,

On 10/08/2013 04:57 PM, Richard Weinberger wrote:
> Use the more generic functions get_signal() signal_setup_done()
> for signal delivery.

I never realized Al has added the infrastructure already (back when ARC port was
being discussed for mainlining)

Since you are touching all arches, it might make sense to also throw in sigsp()
replacement too.

Something like below:

-    if ((ka->sa.sa_flags & SA_ONSTACK) && !sas_ss_flags(sp))
-        sp = current->sas_ss_sp + current->sas_ss_size;


> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/arc/kernel/signal.c | 39 +++++++++++++++------------------------
>  1 file changed, 15 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/arc/kernel/signal.c b/arch/arc/kernel/signal.c
> index 7e95e1a..c2031e2 100644
> --- a/arch/arc/kernel/signal.c
> +++ b/arch/arc/kernel/signal.c
> @@ -179,14 +179,13 @@ static inline int map_sig(int sig)
>  }
>  
>  static int
> -setup_rt_frame(int signo, struct k_sigaction *ka, siginfo_t *info,
> -	       sigset_t *set, struct pt_regs *regs)
> +setup_rt_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
>  {
>  	struct rt_sigframe __user *sf;
>  	unsigned int magic = 0;
>  	int err = 0;
>  
> -	sf = get_sigframe(ka, regs, sizeof(struct rt_sigframe));
> +	sf = get_sigframe(&ksig->ka, regs, sizeof(struct rt_sigframe));

At least for ARC, it is possible to change get_sigframe() first arg to be ksignal
as well. Rest of changes look good.

Thanks for the series !

P.S. I wonder how u r going to achieve closure on this since SH folks have not
been responding. A patch series of mine is stuck in mid air due to lack of ACK/NAK
from them.

-Vineet

>  	if (!sf)
>  		return 1;
>  
> @@ -205,8 +204,8 @@ setup_rt_frame(int signo, struct k_sigaction *ka, siginfo_t *info,
>  	 *  #2: struct siginfo
>  	 *  #3: struct ucontext (completely populated)
>  	 */
> -	if (unlikely(ka->sa.sa_flags & SA_SIGINFO)) {
> -		err |= copy_siginfo_to_user(&sf->info, info);
> +	if (unlikely(ksig->ka.sa.sa_flags & SA_SIGINFO)) {
> +		err |= copy_siginfo_to_user(&sf->info, &ksig->info);
>  		err |= __put_user(0, &sf->uc.uc_flags);
>  		err |= __put_user(NULL, &sf->uc.uc_link);
>  		err |= __save_altstack(&sf->uc.uc_stack, regs->sp);
> @@ -227,16 +226,16 @@ setup_rt_frame(int signo, struct k_sigaction *ka, siginfo_t *info,
>  		return err;
>  
>  	/* #1 arg to the user Signal handler */
> -	regs->r0 = map_sig(signo);
> +	regs->r0 = map_sig(ksig->sig);
>  
>  	/* setup PC of user space signal handler */
> -	regs->ret = (unsigned long)ka->sa.sa_handler;
> +	regs->ret = (unsigned long)ksig->ka.sa.sa_handler;
>  
>  	/*
>  	 * handler returns using sigreturn stub provided already by userpsace
>  	 */
> -	BUG_ON(!(ka->sa.sa_flags & SA_RESTORER));
> -	regs->blink = (unsigned long)ka->sa.sa_restorer;
> +	BUG_ON(!(ksig->ka.sa.sa_flags & SA_RESTORER));
> +	regs->blink = (unsigned long)ksig->ka.sa.sa_restorer;
>  
>  	/* User Stack for signal handler will be above the frame just carved */
>  	regs->sp = (unsigned long)sf;
> @@ -298,38 +297,30 @@ static void arc_restart_syscall(struct k_sigaction *ka, struct pt_regs *regs)
>   * OK, we're invoking a handler
>   */
>  static void
> -handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
> -	      struct pt_regs *regs)
> +handle_signal(struct ksignal *ksig, struct pt_regs *regs)
>  {
>  	sigset_t *oldset = sigmask_to_save();
>  	int ret;
>  
>  	/* Set up the stack frame */
> -	ret = setup_rt_frame(sig, ka, info, oldset, regs);
> +	ret = setup_rt_frame(ksig, oldset, regs);
>  
> -	if (ret)
> -		force_sigsegv(sig, current);
> -	else
> -		signal_delivered(sig, info, ka, regs, 0);
> +	signal_setup_done(ret, ksig, 0);
>  }
>  
>  void do_signal(struct pt_regs *regs)
>  {
> -	struct k_sigaction ka;
> -	siginfo_t info;
> -	int signr;
> +	struct ksignal ksig;
>  	int restart_scall;
>  
> -	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
> -
>  	restart_scall = in_syscall(regs) && syscall_restartable(regs);
>  
> -	if (signr > 0) {
> +	if (get_signal(&ksig)) {
>  		if (restart_scall) {
> -			arc_restart_syscall(&ka, regs);
> +			arc_restart_syscall(&ksig.ka, regs);
>  			syscall_wont_restart(regs);	/* No more restarts */
>  		}
> -		handle_signal(signr, &ka, &info, regs);
> +		handle_signal(&ksig, regs);
>  		return;
>  	}
>  
> 

