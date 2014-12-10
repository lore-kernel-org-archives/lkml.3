Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbaLJQif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:38:35 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:64336 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142AbaLJQid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:38:33 -0500
Date: Wed, 10 Dec 2014 16:38:18 +0000
From: Steve Capper <steve.capper@linaro.org>
To: David Long <dave.long@linaro.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        William Cohen <wcohen@redhat.com>, David Miller <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/5] ARM64: Add kernel probes(Kprobes) support
Message-ID: <20141210163817.GA27500@linaro.org>
References: <547F242D.1060705@redhat.com>
 <547F94B0.1000902@linaro.org>
 <547FB5DD.901@redhat.com>
 <547FCB73.1010707@linaro.org>
 <CAPvkgC3=KKKMa1hWdOYOcV7D7kQSLtnNnXLBB64_P-V+_qUwTw@mail.gmail.com>
 <54803ADD.2090201@hitachi.com>
 <CAPvkgC26-CprjLVH55=7z73JtxTumFFZ4W7itevXxMwReVqQ1g@mail.gmail.com>
 <54804B1F.3020703@hitachi.com>
 <20141209133340.GA20265@linaro.org>
 <548706C6.2050105@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548706C6.2050105@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 09:27:18AM -0500, David Long wrote:
> On 12/09/14 08:33, Steve Capper wrote:
> >On Thu, Dec 04, 2014 at 08:53:03PM +0900, Masami Hiramatsu wrote:

[...]

> >
> >Not sure if this is helpful, but the following also caused a crash for
> >me:
> >
> >echo "p:trace_event_buffer_lock_reserve trace_event_buffer_lock_reserve" > /sys/kernel/debug/tracing/kprobe_events
> >echo "p:memcpy memcpy" >> /sys/kernel/debug/tracing/kprobe_events
> >echo 1 > /sys/kernel/debug/tracing/events/kprobes/enable
> >
> >[immediate crash]
> >
> >The crash point for me is in the arm64 ASID allocator, it again looks
> >like the interrupts are in an unexpected state.
> >(check_and_switch_context goes down the irqs disabled code path, I
> >think incorrectly).
> >
> >This occurred for me both with and without the proposed irq saving fix.
> >
> >I will do some more digging.
> >
> 
> Thanks, more information is good.
> 

Hi,

Some good news, I think I've fixed the problem I've been experiencing.

Basically, I've torn out all the interrupt save/restore and have
narrowed the scope to just sandwich the instruction single-step. This
simplifies a lot of logic, and I've now been able to perf record a
kprobe on memcpy (and the trace_event_buffer_lock_reserve + memcpy
test) without any issues on a Juno platform.

I may have been somewhat over-zealous with the chainsaw, so please do
put this fix through its paces.

Cheers,
--
Steve


>From d3f4d80ce19bec71bd03209beb2fbfd8084d6543 Mon Sep 17 00:00:00 2001
From: Steve Capper <steve.capper@linaro.org>
Date: Mon, 1 Dec 2014 11:30:10 +0000
Subject: [PATCH] Fix the interrupt handling for kprobes

---
 arch/arm64/kernel/kprobes.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kernel/kprobes.c b/arch/arm64/kernel/kprobes.c
index be7c330..d39d826 100644
--- a/arch/arm64/kernel/kprobes.c
+++ b/arch/arm64/kernel/kprobes.c
@@ -229,10 +229,6 @@ skip_singlestep_missed(struct kprobe_ctlblk *kcb, struct pt_regs *regs)
 {
 	/* set return addr to next pc to continue */
 	instruction_pointer(regs) += sizeof(kprobe_opcode_t);
-
-	if (kcb->kprobe_status != KPROBE_REENTER)
-		kprobes_restore_local_irqflag(regs);
-
 }
 
 static void __kprobes setup_singlestep(struct kprobe *p,
@@ -259,7 +255,7 @@ static void __kprobes setup_singlestep(struct kprobe *p,
 			spsr_set_debug_flag(regs, 0);
 
 		/* IRQs and single stepping do not mix well. */
-		local_irq_disable();
+		kprobes_save_local_irqflag(regs);
 		kernel_enable_single_step(regs);
 		instruction_pointer(regs) = slot;
 	} else	{
@@ -326,7 +322,6 @@ post_kprobe_handler(struct kprobe_ctlblk *kcb, struct pt_regs *regs)
 	}
 
 	reset_current_kprobe();
-	kprobes_restore_local_irqflag(regs);
 }
 
 int __kprobes kprobe_fault_handler(struct pt_regs *regs, unsigned int fsr)
@@ -380,8 +375,6 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, unsigned int fsr)
 			return 1;
 
 		break;
-	default:
-		break;
 	}
 	return 0;
 }
@@ -446,7 +439,6 @@ void __kprobes kprobe_handler(struct pt_regs *regs)
 		 * handling of this interrupt is appropriate.
 		 * Return back to original instruction, and continue.
 		 */
-		kprobes_restore_local_irqflag(regs);
 		return;
 	} else if (cur) {
 		/* We probably hit a jprobe.  Call its break handler. */
@@ -459,7 +451,6 @@ void __kprobes kprobe_handler(struct pt_regs *regs)
 		/* breakpoint is removed, now in a race
 		 * Return back to original instruction & continue.
 		 */
-		kprobes_restore_local_irqflag(regs);
 	}
 }
 
@@ -485,6 +476,7 @@ kprobe_single_step_handler(struct pt_regs *regs, unsigned int esr)
 	retval = kprobe_ss_hit(kcb, instruction_pointer(regs));
 
 	if (retval == DBG_HOOK_HANDLED) {
+		kprobes_restore_local_irqflag(regs);
 		kernel_disable_single_step();
 
 		if (kcb->kprobe_status == KPROBE_REENTER)
@@ -499,7 +491,6 @@ kprobe_single_step_handler(struct pt_regs *regs, unsigned int esr)
 static int __kprobes
 kprobe_breakpoint_handler(struct pt_regs *regs, unsigned int esr)
 {
-	kprobes_save_local_irqflag(regs);
 	kprobe_handler(regs);
 	return DBG_HOOK_HANDLED;
 }
@@ -563,7 +554,6 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 		memcpy((void *)stack_addr, kcb->jprobes_stack,
 		       MIN_STACK_SIZE(stack_addr));
 		preempt_enable_no_resched();
-		kprobes_restore_local_irqflag(regs);
 		return 1;
 	}
 	return 0;
@@ -655,8 +645,6 @@ trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
 		kfree(ri);
 	}
 
-	kprobes_restore_local_irqflag(regs);
-
 	/* return 1 so that post handlers not called */
 	return 1;
 }
-- 
1.9.3

