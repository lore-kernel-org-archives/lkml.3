Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbaIEJDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:03:44 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:53171 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaIEJDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:03:39 -0400
Message-ID: <54097C6B.7040805@linaro.org>
Date: Fri, 05 Sep 2014 10:03:39 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v1 1/6] arm: fiq: Replace default FIQ handler
References: <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org> <1409846620-14542-1-git-send-email-daniel.thompson@linaro.org> <1409846620-14542-2-git-send-email-daniel.thompson@linaro.org> <alpine.LFD.2.11.1409041452500.16533@knanqh.ubzr>
In-Reply-To: <alpine.LFD.2.11.1409041452500.16533@knanqh.ubzr>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/14 19:57, Nicolas Pitre wrote:
> On Thu, 4 Sep 2014, Daniel Thompson wrote:
> 
>> This patch introduces a new default FIQ handler that is structured in a
>> similar way to the existing ARM exception handler and result in the FIQ
>> being handled by C code running on the SVC stack (despite this code run
>> in the FIQ handler is subject to severe limitations with respect to
>> locking making normal interaction with the kernel impossible).
>>
>> This default handler allows concepts that on x86 would be handled using
>> NMIs to be realized on ARM.
>>
>> Credit:
>>
>>     This patch is a near complete re-write of a patch originally
>>     provided by Anton Vorontsov. Today only a couple of small fragments
>>     survive, however without Anton's work to build from this patch would
>>     not exist.
>>
>> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Nicolas Pitre <nico@linaro.org>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> ---
>>  arch/arm/kernel/entry-armv.S | 110 +++++++++++++++++++++++++++++++++++++++----
>>  arch/arm/kernel/setup.c      |   8 +++-
>>  arch/arm/kernel/traps.c      |  26 ++++++++--
>>  3 files changed, 130 insertions(+), 14 deletions(-)
>>
>> diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
>> index 36276cd..03dc0e0 100644
>> --- a/arch/arm/kernel/entry-armv.S
>> +++ b/arch/arm/kernel/entry-armv.S
>> @@ -146,7 +146,7 @@ ENDPROC(__und_invalid)
>>  #define SPFIX(code...)
>>  #endif
>>  
>> -	.macro	svc_entry, stack_hole=0
>> +	.macro	svc_entry, stack_hole=0, call_trace=1
>>   UNWIND(.fnstart		)
>>   UNWIND(.save {r0 - pc}		)
>>  	sub	sp, sp, #(S_FRAME_SIZE + \stack_hole - 4)
>> @@ -183,10 +183,35 @@ ENDPROC(__und_invalid)
>>  	stmia	r7, {r2 - r6}
>>  
>>  #ifdef CONFIG_TRACE_IRQFLAGS
>> +	.if \call_trace
>>  	bl	trace_hardirqs_off
>> +	.endif
>>  #endif
>>  	.endm
>>  
>> +@
>> +@ svc_exit_via_fiq - similar to svc_exit but switches to FIQ mode before exit
>> +@
>> +@ This macro acts in a similar manner to svc_exit but switches to FIQ
>> +@ mode to restore the final part of the register state.
>> +@
>> +@ We cannot use the normal svc_exit procedure because that would
>> +@ clobber spsr_svc (FIQ could be delivered during the first few instructions
>> +@ of vector_swi meaning its contents have not been saved anywhere).
>> +@
> 
> Wouldn't it be better for this macro to live in entry-header.S alongside 
> the others?

I'm not sure either way.

svc_exit_from_fiq isn't needed by entry-common.S and cannot be used by
entry-v7m.S because v7m has no FIQ. For that reason I decided to place
it alongside svc_entry in entry-armv.S rather than alongside svc_exit in
entry-header.S .

I am happy to move it if you have a strong preference here. Please let
me know.


> Also you should probably create a Thumb2 version.

I'll look at this.


Daniel.


>> +	.macro  svc_exit_via_fiq, rpsr
>> +
>> +	mov	r0, sp
>> +	ldmib	r0, {r1 - r14}	@ abort is deadly from here onward (it will
>> +				@ clobber state restored below)
>> +	msr	cpsr_c, #FIQ_MODE | PSR_I_BIT | PSR_F_BIT
>> +	add	r8, r0, #S_PC
>> +	ldr	r9, [r0, #S_PSR]
>> +	msr	spsr_cxsf, r9
>> +	ldr	r0, [r0, #S_R0]
>> +	ldmia	r8, {pc}^
>> +	.endm
>> +
>>  	.align	5
>>  __dabt_svc:
>>  	svc_entry
>> @@ -295,6 +320,15 @@ __pabt_svc:
>>  ENDPROC(__pabt_svc)
>>  
>>  	.align	5
>> +__fiq_svc:
>> +	svc_entry 0, 0
>> +	mov	r0, sp				@ struct pt_regs *regs
>> +	bl	handle_fiq_as_nmi
>> +	svc_exit_via_fiq r5
>> + UNWIND(.fnend		)
>> +ENDPROC(__fiq_svc)
>> +
>> +	.align	5
>>  .LCcralign:
>>  	.word	cr_alignment
>>  #ifdef MULTI_DABORT
>> @@ -305,6 +339,38 @@ ENDPROC(__pabt_svc)
>>  	.word	fp_enter
>>  
>>  /*
>> + * Abort mode handlers
>> + */
>> +
>> +@
>> +@ Taking a FIQ in abort mode is similar to taking a FIQ in SVC mode
>> +@ and reuses the same macros. However in abort mode we must also
>> +@ save/restore lr_abt and spsr_abt to make nested aborts safe.
>> +@
>> +	.align 5
>> +__fiq_abt:
>> +	svc_entry 0, 0
>> +
>> +	msr	cpsr_c, #ABT_MODE | PSR_I_BIT | PSR_F_BIT
>> +	mov	r0, lr		@ Save lr_abt
>> +	mrs	r1, spsr	@ Save spsr_abt, abort is now safe
>> +	msr	cpsr_c, #SVC_MODE | PSR_I_BIT | PSR_F_BIT
>> +	push	{r0 - r1}
>> +
>> +	sub	r0, sp, #8			@ struct pt_regs *regs
>> +	bl	handle_fiq_as_nmi
>> +
>> +	pop	{r0 - r1}
>> +	msr	cpsr_c, #ABT_MODE | PSR_I_BIT | PSR_F_BIT
>> +	mov	lr, r0		@ Restore lr_abt, abort is unsafe
>> +	msr	spsr_cxsf, r1	@ Restore spsr_abt
>> +	msr	cpsr_c, #SVC_MODE | PSR_I_BIT | PSR_F_BIT
>> +
>> +	svc_exit_via_fiq r5
>> + UNWIND(.fnend		)
>> +ENDPROC(__fiq_svc)
>> +
>> +/*
>>   * User mode handlers
>>   *
>>   * EABI note: sp_svc is always 64-bit aligned here, so should S_FRAME_SIZE
>> @@ -683,6 +749,18 @@ ENTRY(ret_from_exception)
>>  ENDPROC(__pabt_usr)
>>  ENDPROC(ret_from_exception)
>>  
>> +	.align	5
>> +__fiq_usr:
>> +	usr_entry
>> +	kuser_cmpxchg_check
>> +	mov	r0, sp				@ struct pt_regs *regs
>> +	bl	handle_fiq_as_nmi
>> +	get_thread_info tsk
>> +	mov	why, #0
>> +	b	ret_to_user_from_irq
>> + UNWIND(.fnend		)
>> +ENDPROC(__fiq_usr)
>> +
>>  /*
>>   * Register switch for ARMv3 and ARMv4 processors
>>   * r0 = previous task_struct, r1 = previous thread_info, r2 = next thread_info
>> @@ -1118,17 +1196,29 @@ vector_addrexcptn:
>>  	b	vector_addrexcptn
>>  
>>  /*=============================================================================
>> - * Undefined FIQs
>> + * FIQ "NMI" handler
>>   *-----------------------------------------------------------------------------
>> - * Enter in FIQ mode, spsr = ANY CPSR, lr = ANY PC
>> - * MUST PRESERVE SVC SPSR, but need to switch to SVC mode to show our msg.
>> - * Basically to switch modes, we *HAVE* to clobber one register...  brain
>> - * damage alert!  I don't think that we can execute any code in here in any
>> - * other mode than FIQ...  Ok you can switch to another mode, but you can't
>> - * get out of that mode without clobbering one register.
>> + * Handle a FIQ using the SVC stack allowing FIQ act like NMI on x86
>> + * systems.
>>   */
>> -vector_fiq:
>> -	subs	pc, lr, #4
>> +	vector_stub	fiq, FIQ_MODE, 4
>> +
>> +	.long	__fiq_usr			@  0  (USR_26 / USR_32)
>> +	.long	__fiq_svc			@  1  (FIQ_26 / FIQ_32)
>> +	.long	__fiq_svc			@  2  (IRQ_26 / IRQ_32)
>> +	.long	__fiq_svc			@  3  (SVC_26 / SVC_32)
>> +	.long	__fiq_svc			@  4
>> +	.long	__fiq_svc			@  5
>> +	.long	__fiq_svc			@  6
>> +	.long	__fiq_abt			@  7
>> +	.long	__fiq_svc			@  8
>> +	.long	__fiq_svc			@  9
>> +	.long	__fiq_svc			@  a
>> +	.long	__fiq_svc			@  b
>> +	.long	__fiq_svc			@  c
>> +	.long	__fiq_svc			@  d
>> +	.long	__fiq_svc			@  e
>> +	.long	__fiq_svc			@  f
>>  
>>  	.globl	vector_fiq_offset
>>  	.equ	vector_fiq_offset, vector_fiq
>> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
>> index 84db893d..c031063 100644
>> --- a/arch/arm/kernel/setup.c
>> +++ b/arch/arm/kernel/setup.c
>> @@ -133,6 +133,7 @@ struct stack {
>>  	u32 irq[3];
>>  	u32 abt[3];
>>  	u32 und[3];
>> +	u32 fiq[3];
>>  } ____cacheline_aligned;
>>  
>>  #ifndef CONFIG_CPU_V7M
>> @@ -470,7 +471,10 @@ void notrace cpu_init(void)
>>  	"msr	cpsr_c, %5\n\t"
>>  	"add	r14, %0, %6\n\t"
>>  	"mov	sp, r14\n\t"
>> -	"msr	cpsr_c, %7"
>> +	"msr	cpsr_c, %7\n\t"
>> +	"add	r14, %0, %8\n\t"
>> +	"mov	sp, r14\n\t"
>> +	"msr	cpsr_c, %9"
>>  	    :
>>  	    : "r" (stk),
>>  	      PLC (PSR_F_BIT | PSR_I_BIT | IRQ_MODE),
>> @@ -479,6 +483,8 @@ void notrace cpu_init(void)
>>  	      "I" (offsetof(struct stack, abt[0])),
>>  	      PLC (PSR_F_BIT | PSR_I_BIT | UND_MODE),
>>  	      "I" (offsetof(struct stack, und[0])),
>> +	      PLC (PSR_F_BIT | PSR_I_BIT | FIQ_MODE),
>> +	      "I" (offsetof(struct stack, fiq[0])),
>>  	      PLC (PSR_F_BIT | PSR_I_BIT | SVC_MODE)
>>  	    : "r14");
>>  #endif
>> diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
>> index c8e4bb7..7912a9e 100644
>> --- a/arch/arm/kernel/traps.c
>> +++ b/arch/arm/kernel/traps.c
>> @@ -25,6 +25,7 @@
>>  #include <linux/delay.h>
>>  #include <linux/init.h>
>>  #include <linux/sched.h>
>> +#include <linux/irq.h>
>>  
>>  #include <linux/atomic.h>
>>  #include <asm/cacheflush.h>
>> @@ -460,10 +461,29 @@ die_sig:
>>  	arm_notify_die("Oops - undefined instruction", regs, &info, 0, 6);
>>  }
>>  
>> -asmlinkage void do_unexp_fiq (struct pt_regs *regs)
>> +/*
>> + * Handle FIQ similarly to NMI on x86 systems.
>> + *
>> + * The runtime environment for NMIs is extremely restrictive
>> + * (NMIs can pre-empt critical sections meaning almost all locking is
>> + * forbidden) meaning this default FIQ handling must only be used in
>> + * circumstances where non-maskability improves robustness, such as
>> + * watchdog or debug logic.
>> + *
>> + * This handler is not appropriate for general purpose use in drivers
>> + * platform code and can be overrideen using set_fiq_handler.
>> + */
>> +asmlinkage void __exception_irq_entry handle_fiq_as_nmi(struct pt_regs *regs)
>>  {
>> -	printk("Hmm.  Unexpected FIQ received, but trying to continue\n");
>> -	printk("You may have a hardware problem...\n");
>> +#ifdef CONFIG_FIQ
>> +	struct pt_regs *old_regs = set_irq_regs(regs);
>> +
>> +	nmi_enter();
>> +	/* nop for now */
>> +	nmi_exit();
>> +
>> +	set_irq_regs(old_regs);
>> +#endif
>>  }
>>  
>>  /*
>> -- 
>> 1.9.3
>>
>>

