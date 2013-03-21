Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab3CUVtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:49:25 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41377 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab3CUVtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:49:23 -0400
Date: Thu, 21 Mar 2013 21:49:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kevin Hilman <khilman@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        Mats Liljegren <mats.liljegren@enea.com>
Subject: Re: [PATCH 1/4] ARM: context tracking: add exception support
Message-ID: <20130321214908.GU4977@n2100.arm.linux.org.uk>
References: <1363824121-26169-1-git-send-email-khilman@linaro.org> <1363824121-26169-2-git-send-email-khilman@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363824121-26169-2-git-send-email-khilman@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 05:01:58PM -0700, Kevin Hilman wrote:
> Add ARM support for the context tracking subsystem by instrumenting
> exception entry/exit points.
> 
> Special thanks to Mats Liljegren for testing, collaboration and adding
> support for exceptions/faults that were missing in early test versions.

Not sure all of these are a good idea or are correct...

> @@ -405,7 +406,9 @@ asmlinkage void __exception do_undefinstr(struct pt_regs *regs)
>  	unsigned int instr;
>  	siginfo_t info;
>  	void __user *pc;
> +	enum ctx_state prev_state;
>  
> +	prev_state = exception_enter();
>  	pc = (void __user *)instruction_pointer(regs);
>  
>  	if (processor_mode(regs) == SVC_MODE) {
> @@ -433,8 +436,10 @@ asmlinkage void __exception do_undefinstr(struct pt_regs *regs)
>  		goto die_sig;
>  	}
>  
> -	if (call_undef_hook(regs, instr) == 0)
> +	if (call_undef_hook(regs, instr) == 0) {
> +		exception_exit(prev_state);
>  		return;
> +	}
>  
>  die_sig:
>  #ifdef CONFIG_DEBUG_USER
> @@ -451,12 +456,17 @@ die_sig:
>  	info.si_addr  = pc;
>  
>  	arm_notify_die("Oops - undefined instruction", regs, &info, 0, 6);
> +	exception_exit(prev_state);

So, FP emulation and VFP support happens via a separate path.  Does this
also need to be instrumented?

>  }
>  
>  asmlinkage void do_unexp_fiq (struct pt_regs *regs)
>  {
> +	enum ctx_state prev_state;
> +
> +	prev_state = exception_enter();
>  	printk("Hmm.  Unexpected FIQ received, but trying to continue\n");
>  	printk("You may have a hardware problem...\n");
> +	exception_exit(prev_state);

Not a good idea.  If we get here chances are things are really broken.

>  }
>  
>  /*
> @@ -467,6 +477,9 @@ asmlinkage void do_unexp_fiq (struct pt_regs *regs)
>   */
>  asmlinkage void bad_mode(struct pt_regs *regs, int reason)
>  {
> +	enum ctx_state prev_state;
> +
> +	prev_state = exception_enter();
>  	console_verbose();
>  
>  	printk(KERN_CRIT "Bad mode in %s handler detected\n", handler[reason]);

Same here.  If we get here, we're probably about to die a horrid death.

> @@ -746,7 +759,9 @@ baddataabort(int code, unsigned long instr, struct pt_regs *regs)
>  {
>  	unsigned long addr = instruction_pointer(regs);
>  	siginfo_t info;
> +	enum ctx_state prev_state;
>  
> +	prev_state = exception_enter();
>  #ifdef CONFIG_DEBUG_USER
>  	if (user_debug & UDBG_BADABORT) {
>  		printk(KERN_ERR "[%d] %s: bad data abort: code %d instr 0x%08lx\n",
> @@ -762,6 +777,7 @@ baddataabort(int code, unsigned long instr, struct pt_regs *regs)
>  	info.si_addr  = (void __user *)addr;
>  
>  	arm_notify_die("unknown data abort code", regs, &info, instr, 0);
> +	exception_exit(prev_state);
>  }
>  
>  void __readwrite_bug(const char *fn)
> diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
> index 5dbf13f..759b70d 100644
> --- a/arch/arm/mm/fault.c
> +++ b/arch/arm/mm/fault.c
> @@ -19,6 +19,7 @@
>  #include <linux/sched.h>
>  #include <linux/highmem.h>
>  #include <linux/perf_event.h>
> +#include <linux/context_tracking.h>
>  
>  #include <asm/exception.h>
>  #include <asm/pgtable.h>
> @@ -424,9 +425,15 @@ do_translation_fault(unsigned long addr, unsigned int fsr,
>  	pgd_t *pgd, *pgd_k;
>  	pud_t *pud, *pud_k;
>  	pmd_t *pmd, *pmd_k;
> -
> -	if (addr < TASK_SIZE)
> -		return do_page_fault(addr, fsr, regs);
> +	enum ctx_state prev_state;
> +
> +	prev_state = exception_enter();
> +	if (addr < TASK_SIZE) {
> +		int ret;
> +		ret = do_page_fault(addr, fsr, regs);
> +		exception_exit(prev_state);
> +		return ret;
> +	}
>  
>  	if (user_mode(regs))
>  		goto bad_area;
> @@ -472,10 +479,12 @@ do_translation_fault(unsigned long addr, unsigned int fsr,
>  		goto bad_area;
>  
>  	copy_pmd(pmd, pmd_k);
> +	exception_exit(prev_state);
>  	return 0;
>  
>  bad_area:
>  	do_bad_area(addr, fsr, regs);
> +	exception_exit(prev_state);
>  	return 0;
>  }
>  #else					/* CONFIG_MMU */
> @@ -494,7 +503,12 @@ do_translation_fault(unsigned long addr, unsigned int fsr,
>  static int
>  do_sect_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>  {
> +	enum ctx_state prev_state;
> +
> +	prev_state = exception_enter();
>  	do_bad_area(addr, fsr, regs);
> +	exception_exit(prev_state);
> +
>  	return 0;
>  }
>  
> @@ -542,9 +556,11 @@ do_DataAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>  {
>  	const struct fsr_info *inf = fsr_info + fsr_fs(fsr);
>  	struct siginfo info;
> +	enum ctx_state prev_state;
>  
> +	prev_state = exception_enter();
>  	if (!inf->fn(addr, fsr & ~FSR_LNX_PF, regs))
> -		return;
> +		goto out;
>  
>  	printk(KERN_ALERT "Unhandled fault: %s (0x%03x) at 0x%08lx\n",
>  		inf->name, fsr, addr);
> @@ -554,6 +570,8 @@ do_DataAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>  	info.si_code  = inf->code;
>  	info.si_addr  = (void __user *)addr;
>  	arm_notify_die("", regs, &info, fsr, 0);
> +out:
> +	exception_exit(prev_state);
>  }
>  
>  void __init
> @@ -574,9 +592,11 @@ do_PrefetchAbort(unsigned long addr, unsigned int ifsr, struct pt_regs *regs)
>  {
>  	const struct fsr_info *inf = ifsr_info + fsr_fs(ifsr);
>  	struct siginfo info;
> +	enum ctx_state prev_state;
>  
> +	prev_state = exception_enter();
>  	if (!inf->fn(addr, ifsr | FSR_LNX_PF, regs))
> -		return;
> +		goto out;
>  
>  	printk(KERN_ALERT "Unhandled prefetch abort: %s (0x%03x) at 0x%08lx\n",
>  		inf->name, ifsr, addr);
> @@ -586,6 +606,8 @@ do_PrefetchAbort(unsigned long addr, unsigned int ifsr, struct pt_regs *regs)
>  	info.si_code  = inf->code;
>  	info.si_addr  = (void __user *)addr;
>  	arm_notify_die("", regs, &info, ifsr, 0);
> +out:
> +	exception_exit(prev_state);
>  }
>  
>  #ifndef CONFIG_ARM_LPAE

What is the reason for putting all this in the individual functions
and not in the prefetch/data abort handlers -
do_PrefetchAbort()/do_DataAbort()?
