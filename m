Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170AbaKRPqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:46:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120AbaKRPqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:46:04 -0500
Message-ID: <546B5C9B.5040101@redhat.com>
Date: Tue, 18 Nov 2014 09:50:03 -0500
From: William Cohen <wcohen@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Long <dave.long@linaro.org>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
CC: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/5] arm64: Add kernel return probes support(kretprobes)
References: <1416292375-29560-1-git-send-email-dave.long@linaro.org> <1416292375-29560-4-git-send-email-dave.long@linaro.org>
In-Reply-To: <1416292375-29560-4-git-send-email-dave.long@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 01:32 AM, David Long wrote:
> From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
> 
> AArch64 ISA does not instructions to pop PC register value
> from stack(like ARM v7 has ldmia {...,pc}) without using
> one of the general purpose registers. This means return probes
> cannot return to the actual return address directly without
> modifying register context, and without trapping into debug exception.

The first might read better with something like:

Unlike the ARMv7 (ldmia {...,pc}) the AArch64 ISA cannot directly pop the PC register value from the stack without using one of the general purpose registers.

-Will
> 
> So like many other architectures, we prepare a global routine
> with NOPs, which serve as trampoline to hack away the
> function return address, by placing an extra kprobe on the
> trampoline entry.
> 
> The pre-handler of this special trampoline' kprobe execute return
> probe handler functions and restore original return address in ELR_EL1,
> this way, saved pt_regs still hold the original register context to be
> carried back to the probed kernel function.
> 
> Signed-off-by: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
> Signed-off-by: David A. Long <dave.long@linaro.org>
> ---
>  arch/arm64/Kconfig               |   1 +
>  arch/arm64/include/asm/kprobes.h |   1 +
>  arch/arm64/kernel/kprobes.c      | 114 ++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 115 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 256ef90..02f31b7 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -61,6 +61,7 @@ config ARM64
>  	select HAVE_RCU_TABLE_FREE
>  	select HAVE_SYSCALL_TRACEPOINTS
>  	select HAVE_KPROBES if !XIP_KERNEL
> +	select HAVE_KRETPROBES if HAVE_KPROBES
>  	select IRQ_DOMAIN
>  	select MODULES_USE_ELF_RELA
>  	select NO_BOOTMEM
> diff --git a/arch/arm64/include/asm/kprobes.h b/arch/arm64/include/asm/kprobes.h
> index b35d3b9..a2de3b8 100644
> --- a/arch/arm64/include/asm/kprobes.h
> +++ b/arch/arm64/include/asm/kprobes.h
> @@ -56,5 +56,6 @@ void arch_remove_kprobe(struct kprobe *);
>  int kprobe_fault_handler(struct pt_regs *regs, unsigned int fsr);
>  int kprobe_exceptions_notify(struct notifier_block *self,
>  			     unsigned long val, void *data);
> +void kretprobe_trampoline(void);
>  
>  #endif /* _ARM_KPROBES_H */
> diff --git a/arch/arm64/kernel/kprobes.c b/arch/arm64/kernel/kprobes.c
> index 789ab61..be7c330 100644
> --- a/arch/arm64/kernel/kprobes.c
> +++ b/arch/arm64/kernel/kprobes.c
> @@ -569,6 +569,117 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
>  	return 0;
>  }
>  
> +/*
> + * Kretprobes: kernel return probes handling
> + *
> + * AArch64 mode does not support popping the PC value from the
> + * stack like on ARM 32-bit (ldmia {..,pc}), so atleast one
> + * register need to be used to achieve branching/return.
> + * It means return probes cannot return back to the original
> + * return address directly without modifying the register context.
> + *
> + * So like other architectures, we prepare a global routine
> + * with NOPs, which serve as trampoline address that hack away the
> + * function return, with the exact register context.
> + * Placing a kprobe on trampoline routine entry will trap again to
> + * execute return probe handlers and restore original return address
> + * in ELR_EL1, this way saved pt_regs still hold the original
> + * register values to be carried back to the caller.
> + */
> +static void __used kretprobe_trampoline_holder(void)
> +{
> +	asm volatile (".global kretprobe_trampoline\n"
> +			"kretprobe_trampoline:\n"
> +			"NOP\n\t"
> +			"NOP\n\t");
> +}
> +
> +static int __kprobes
> +trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
> +{
> +	struct kretprobe_instance *ri = NULL;
> +	struct hlist_head *head, empty_rp;
> +	struct hlist_node *tmp;
> +	unsigned long flags, orig_ret_addr = 0;
> +	unsigned long trampoline_address =
> +		(unsigned long)&kretprobe_trampoline;
> +
> +	INIT_HLIST_HEAD(&empty_rp);
> +	kretprobe_hash_lock(current, &head, &flags);
> +
> +	/*
> +	 * It is possible to have multiple instances associated with a given
> +	 * task either because multiple functions in the call path have
> +	 * a return probe installed on them, and/or more than one return
> +	 * probe was registered for a target function.
> +	 *
> +	 * We can handle this because:
> +	 *     - instances are always inserted at the head of the list
> +	 *     - when multiple return probes are registered for the same
> +	 *       function, the first instance's ret_addr will point to the
> +	 *       real return address, and all the rest will point to
> +	 *       kretprobe_trampoline
> +	 */
> +	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
> +		if (ri->task != current)
> +			/* another task is sharing our hash bucket */
> +			continue;
> +
> +		if (ri->rp && ri->rp->handler) {
> +			__this_cpu_write(current_kprobe, &ri->rp->kp);
> +			get_kprobe_ctlblk()->kprobe_status = KPROBE_HIT_ACTIVE;
> +			ri->rp->handler(ri, regs);
> +			__this_cpu_write(current_kprobe, NULL);
> +		}
> +
> +		orig_ret_addr = (unsigned long)ri->ret_addr;
> +		recycle_rp_inst(ri, &empty_rp);
> +
> +		if (orig_ret_addr != trampoline_address)
> +			/*
> +			 * This is the real return address. Any other
> +			 * instances associated with this task are for
> +			 * other calls deeper on the call stack
> +			 */
> +			break;
> +	}
> +
> +	kretprobe_assert(ri, orig_ret_addr, trampoline_address);
> +	/* restore the original return address */
> +	instruction_pointer(regs) = orig_ret_addr;
> +	reset_current_kprobe();
> +	kretprobe_hash_unlock(current, &flags);
> +
> +	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
> +		hlist_del(&ri->hlist);
> +		kfree(ri);
> +	}
> +
> +	kprobes_restore_local_irqflag(regs);
> +
> +	/* return 1 so that post handlers not called */
> +	return 1;
> +}
> +
> +void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
> +				      struct pt_regs *regs)
> +{
> +	ri->ret_addr = (kprobe_opcode_t *)regs->regs[30];
> +
> +	/* replace return addr (x30) with trampoline */
> +	regs->regs[30] = (long)&kretprobe_trampoline;
> +}
> +
> +static struct kprobe trampoline = {
> +	.addr = (kprobe_opcode_t *) &kretprobe_trampoline,
> +	.pre_handler = trampoline_probe_handler
> +};
> +
> +int __kprobes arch_trampoline_kprobe(struct kprobe *p)
> +{
> +	return p->addr == (kprobe_opcode_t *) &kretprobe_trampoline;
> +}
> +
>  /* Break Handler hook */
>  static struct break_hook kprobes_break_hook = {
>  	.esr_mask = BRK64_ESR_MASK,
> @@ -586,5 +697,6 @@ int __init arch_init_kprobes(void)
>  	register_break_hook(&kprobes_break_hook);
>  	register_step_hook(&kprobes_step_hook);
>  
> -	return 0;
> +	/* register trampoline for kret probe */
> +	return register_kprobe(&trampoline);
>  }
> 

