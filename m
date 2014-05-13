Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaEMGXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 02:23:51 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:60463 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaEMGXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 02:23:38 -0400
Message-ID: <5371BA64.8070203@hitachi.com>
Date: Tue, 13 May 2014 15:23:32 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Denys Vlasenko <dvlasenk@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>
Subject: Re: [PATCH 1/1] uprobes/x86: Fix the wrong ->si_addr when xol triggers
 a trap
References: <20140508191140.GA16892@redhat.com> <20140512170822.GA28335@redhat.com> <20140512170850.GB28335@redhat.com>
In-Reply-To: <20140512170850.GB28335@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/05/13 2:08), Oleg Nesterov wrote:
> If the probed insn triggers a trap, ->si_addr = regs->ip is technically
> correct, but this is not what the signal handler wants; we need to pass
> the address of the probed insn, not the address of xol slot.
> 
> Add the new arch-agnostic helper, uprobe_get_trap_addr(), and change
> fill_trap_info() and math_error() to use it. !CONFIG_UPROBES case in
> uprobes.h uses a macro to avoid include hell and ensure that it can be
> compiled even if an architecture doesn't define instruction_pointer().
> 
> Test-case:
> 
> 	#include <signal.h>
> 	#include <stdio.h>
> 	#include <unistd.h>
> 
> 	extern void probe_div(void);
> 
> 	void sigh(int sig, siginfo_t *info, void *c)
> 	{
> 		int passed = (info->si_addr == probe_div);
> 		printf(passed ? "PASS\n" : "FAIL\n");
> 		_exit(!passed);
> 	}
> 
> 	int main(void)
> 	{
> 		struct sigaction sa = {
> 			.sa_sigaction	= sigh,
> 			.sa_flags	= SA_SIGINFO,
> 		};
> 
> 		sigaction(SIGFPE, &sa, NULL);
> 
> 		asm (
> 			"xor %ecx,%ecx\n"
> 			".globl probe_div; probe_div:\n"
> 			"idiv %ecx\n"
> 		);
> 
> 		return 0;
> 	}
> 
> it fails if probe_div() is probed.
> 
> Note: show_unhandled_signals users should probably use this helper too,
> but we need to cleanup them first.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Looks good to me :)

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks,

> ---
>  arch/x86/kernel/traps.c |    7 ++++---
>  include/linux/uprobes.h |    4 ++++
>  kernel/events/uprobes.c |   10 ++++++++++
>  3 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 73b3ea3..3fdb205 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -23,6 +23,7 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/ptrace.h>
> +#include <linux/uprobes.h>
>  #include <linux/string.h>
>  #include <linux/delay.h>
>  #include <linux/errno.h>
> @@ -148,11 +149,11 @@ static siginfo_t *fill_trap_info(struct pt_regs *regs, int signr, int trapnr,
>  
>  	case X86_TRAP_DE:
>  		sicode = FPE_INTDIV;
> -		siaddr = regs->ip;
> +		siaddr = uprobe_get_trap_addr(regs);
>  		break;
>  	case X86_TRAP_UD:
>  		sicode = ILL_ILLOPN;
> -		siaddr = regs->ip;
> +		siaddr = uprobe_get_trap_addr(regs);
>  		break;
>  	case X86_TRAP_AC:
>  		sicode = BUS_ADRALN;
> @@ -531,7 +532,7 @@ static void math_error(struct pt_regs *regs, int error_code, int trapnr)
>  	task->thread.error_code = error_code;
>  	info.si_signo = SIGFPE;
>  	info.si_errno = 0;
> -	info.si_addr = (void __user *)regs->ip;
> +	info.si_addr = (void __user *)uprobe_get_trap_addr(regs);
>  	if (trapnr == X86_TRAP_MF) {
>  		unsigned short cwd, swd;
>  		/*
> diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
> index edff2b9..88c3b7e 100644
> --- a/include/linux/uprobes.h
> +++ b/include/linux/uprobes.h
> @@ -102,6 +102,7 @@ extern int __weak set_orig_insn(struct arch_uprobe *aup, struct mm_struct *mm, u
>  extern bool __weak is_swbp_insn(uprobe_opcode_t *insn);
>  extern bool __weak is_trap_insn(uprobe_opcode_t *insn);
>  extern unsigned long __weak uprobe_get_swbp_addr(struct pt_regs *regs);
> +extern unsigned long uprobe_get_trap_addr(struct pt_regs *regs);
>  extern int uprobe_write_opcode(struct mm_struct *mm, unsigned long vaddr, uprobe_opcode_t);
>  extern int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *uc);
>  extern int uprobe_apply(struct inode *inode, loff_t offset, struct uprobe_consumer *uc, bool);
> @@ -130,6 +131,9 @@ extern bool __weak arch_uprobe_ignore(struct arch_uprobe *aup, struct pt_regs *r
>  #else /* !CONFIG_UPROBES */
>  struct uprobes_state {
>  };
> +
> +#define uprobe_get_trap_addr(regs)	instruction_pointer(regs)
> +
>  static inline int
>  uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *uc)
>  {
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index a13251e..3b02c72 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1351,6 +1351,16 @@ unsigned long __weak uprobe_get_swbp_addr(struct pt_regs *regs)
>  	return instruction_pointer(regs) - UPROBE_SWBP_INSN_SIZE;
>  }
>  
> +unsigned long uprobe_get_trap_addr(struct pt_regs *regs)
> +{
> +	struct uprobe_task *utask = current->utask;
> +
> +	if (unlikely(utask && utask->active_uprobe))
> +		return utask->vaddr;
> +
> +	return instruction_pointer(regs);
> +}
> +
>  /*
>   * Called with no locks held.
>   * Called in context of a exiting or a exec-ing thread.
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


