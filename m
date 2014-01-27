Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbaA0UgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:36:18 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:43359 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbaA0UgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:36:15 -0500
Message-ID: <52E6C33C.8050706@amacapital.net>
Date: Mon, 27 Jan 2014 12:36:12 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] x86, mpx: hook #BR exception handler to allocate
 bound tables
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com> <1390727338-20487-3-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1390727338-20487-3-git-send-email-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2014 01:08 AM, Qiaowei Ren wrote:
> An access to an invalid bound directory entry will cause a #BR
> exception. This patch hook #BR exception handler to allocate
> one bound table and bind it with that buond directory entry.
> 
> This will avoid the need of forwarding the #BR exception
> to the user space when bound directory has invalid entry.
> 
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> ---
>  arch/x86/include/asm/mpx.h |   35 ++++++++++++++++++++++++++++
>  arch/x86/kernel/Makefile   |    1 +
>  arch/x86/kernel/mpx.c      |   44 +++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/traps.c    |   55 +++++++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 134 insertions(+), 1 deletions(-)
>  create mode 100644 arch/x86/include/asm/mpx.h
>  create mode 100644 arch/x86/kernel/mpx.c
> 
> diff --git a/arch/x86/include/asm/mpx.h b/arch/x86/include/asm/mpx.h
> new file mode 100644
> index 0000000..d074153
> --- /dev/null
> +++ b/arch/x86/include/asm/mpx.h
> @@ -0,0 +1,35 @@
> +#ifndef _ASM_X86_MPX_H
> +#define _ASM_X86_MPX_H
> +
> +#include <linux/types.h>
> +#include <asm/ptrace.h>
> +
> +#ifdef CONFIG_X86_64
> +
> +#define MPX_L1_BITS	28
> +#define MPX_L1_SHIFT	3
> +#define MPX_L2_BITS	17
> +#define MPX_L2_SHIFT	5
> +#define MPX_IGN_BITS	3
> +#define MPX_L2_NODE_ADDR_MASK	0xfffffffffffffff8UL
> +
> +#define MPX_BNDSTA_ADDR_MASK	0xfffffffffffffffcUL
> +#define MPX_BNDCFG_ADDR_MASK	0xfffffffffffff000UL
> +
> +#else
> +
> +#define MPX_L1_BITS	20
> +#define MPX_L1_SHIFT	2
> +#define MPX_L2_BITS	10
> +#define MPX_L2_SHIFT	4
> +#define MPX_IGN_BITS	2
> +#define MPX_L2_NODE_ADDR_MASK	0xfffffffcUL
> +
> +#define MPX_BNDSTA_ADDR_MASK	0xfffffffcUL
> +#define MPX_BNDCFG_ADDR_MASK	0xfffff000UL
> +
> +#endif
> +
> +void do_mpx_bt_fault(struct xsave_struct *xsave_buf);
> +
> +#endif /* _ASM_X86_MPX_H */
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index cb648c8..becb970 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -41,6 +41,7 @@ obj-$(CONFIG_PREEMPT)	+= preempt.o
>  
>  obj-y				+= process.o
>  obj-y				+= i387.o xsave.o
> +obj-y				+= mpx.o
>  obj-y				+= ptrace.o
>  obj-$(CONFIG_X86_32)		+= tls.o
>  obj-$(CONFIG_IA32_EMULATION)	+= tls.o
> diff --git a/arch/x86/kernel/mpx.c b/arch/x86/kernel/mpx.c
> new file mode 100644
> index 0000000..e055e0e
> --- /dev/null
> +++ b/arch/x86/kernel/mpx.c
> @@ -0,0 +1,44 @@
> +#include <linux/kernel.h>
> +#include <linux/syscalls.h>
> +#include <asm/processor.h>
> +#include <asm/mpx.h>
> +#include <asm/mman.h>
> +#include <asm/i387.h>
> +#include <asm/fpu-internal.h>
> +#include <asm/alternative.h>
> +
> +static bool allocate_bt(unsigned long bd_entry)
> +{
> +	unsigned long bt_size = 1UL << (MPX_L2_BITS+MPX_L2_SHIFT);
> +	unsigned long bt_addr, old_val = 0;
> +
> +	bt_addr = sys_mmap_pgoff(0, bt_size, PROT_READ | PROT_WRITE,
> +			MAP_ANONYMOUS | MAP_PRIVATE | MAP_POPULATE, -1, 0);
> +	if (bt_addr == -1) {
> +		pr_err("L2 Node Allocation Failed at L1 addr %lx\n",
> +				bd_entry);
> +		return false;
> +	}
> +	bt_addr = (bt_addr & MPX_L2_NODE_ADDR_MASK) | 0x01;
> +
> +	user_atomic_cmpxchg_inatomic(&old_val,
> +			(long __user *)bd_entry, 0, bt_addr);
> +	if (old_val)
> +		vm_munmap(bt_addr & MPX_L2_NODE_ADDR_MASK, bt_size);
> +
> +	return true;
> +}

If anyone ever wants to use hugepages for the L2 tables, will this break
ABI?  If so, can we get the ABI right to start with?  (For example, this
could allocate 2MB blocks, clear MAP_POPULATE, and keep track of which
pages within the blocks are within use.)

> +
> +void do_mpx_bt_fault(struct xsave_struct *xsave_buf)
> +{
> +	unsigned long status;
> +	unsigned long bd_entry, bd_base;
> +	unsigned long bd_size = 1UL << (MPX_L1_BITS+MPX_L1_SHIFT);
> +
> +	bd_base = xsave_buf->bndcsr.cfg_reg_u & MPX_BNDCFG_ADDR_MASK;
> +	status = xsave_buf->bndcsr.status_reg;
> +
> +	bd_entry = status & MPX_BNDSTA_ADDR_MASK;
> +	if ((bd_entry >= bd_base) && (bd_entry < bd_base + bd_size))
> +		allocate_bt(bd_entry);

What happens if this fails?  Retrying forever isn't very nice.

> +}
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 57409f6..6b284a4 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -59,6 +59,7 @@
>  #include <asm/fixmap.h>
>  #include <asm/mach_traps.h>
>  #include <asm/alternative.h>
> +#include <asm/mpx.h>
>  
>  #ifdef CONFIG_X86_64
>  #include <asm/x86_init.h>
> @@ -213,7 +214,6 @@ dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
>  
>  DO_ERROR_INFO(X86_TRAP_DE,     SIGFPE,  "divide error",			divide_error,		     FPE_INTDIV, regs->ip )
>  DO_ERROR     (X86_TRAP_OF,     SIGSEGV, "overflow",			overflow					  )
> -DO_ERROR     (X86_TRAP_BR,     SIGSEGV, "bounds",			bounds						  )
>  DO_ERROR_INFO(X86_TRAP_UD,     SIGILL,  "invalid opcode",		invalid_op,		     ILL_ILLOPN, regs->ip )
>  DO_ERROR     (X86_TRAP_OLD_MF, SIGFPE,  "coprocessor segment overrun",	coprocessor_segment_overrun			  )
>  DO_ERROR     (X86_TRAP_TS,     SIGSEGV, "invalid TSS",			invalid_TSS					  )
> @@ -263,6 +263,59 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
>  }
>  #endif
>  
> +dotraplinkage void do_bounds(struct pt_regs *regs, long error_code)
> +{
> +	enum ctx_state prev_state;
> +	unsigned long status;
> +	struct xsave_struct *xsave_buf;
> +	struct task_struct *tsk = current;
> +
> +	prev_state = exception_enter();
> +	if (notify_die(DIE_TRAP, "bounds", regs, error_code,
> +			X86_TRAP_BR, SIGSEGV) == NOTIFY_STOP)
> +		goto exit;
> +	conditional_sti(regs);
> +
> +	if (!user_mode(regs)) {
> +		if (!fixup_exception(regs)) {
> +			tsk->thread.error_code = error_code;
> +			tsk->thread.trap_nr = X86_TRAP_BR;
> +			die("bounds", regs, error_code);
> +		}

Why the fixup?  Unless I'm missing something, the kernel has no business
getting #BR on access to a user address.

Or are you adding code to allow the kernel to use MPX itself?  If so,
shouldn't this use an MPX-specific fixup to allow normal C code to use
this stuff?

> +		goto exit;
> +	}
> +
> +	if (!boot_cpu_has(X86_FEATURE_MPX)) {
> +		do_trap(X86_TRAP_BR, SIGSEGV, "bounds", regs, error_code, NULL);
> +		goto exit;

This, as well as the status == 0 case, should probably document that the
exception is from BOUND, not MPX.

> +	}
> +
> +	fpu_xsave(&tsk->thread.fpu);
> +	xsave_buf = &(tsk->thread.fpu.state->xsave);
> +	status = xsave_buf->bndcsr.status_reg;
> +
> +	switch (status & 0x3) {
> +	case 2:
> +		/*
> +		 * Bound directory has invalid entry.
> +		 * No signal will be sent to the user space.
> +		 */
> +		do_mpx_bt_fault(xsave_buf);

If mmap fails, this should presumably generate SIGBUS.  (See above).

> +		break;
> +
> +	case 1: /* Bound violation. */
> +	case 0: /* No MPX exception. */
> +		do_trap(X86_TRAP_BR, SIGSEGV, "bounds", regs, error_code, NULL);
> +		break;

What does "No Intel MPX exception" mean?  Surely that has business
sending #BR.

> +
> +	default:
> +		break;

What does status 3 mean?  The docs say "reserved".  Presumably this
should log and kill the process.

In general, should this function decode BNDSTATUS and write the output
into siginfo somewhere useful?

--Andy
