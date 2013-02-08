Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946658Ab3BHPs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 10:48:28 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:58794 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760152Ab3BHPs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 10:48:26 -0500
Date: Fri, 8 Feb 2013 15:48:09 +0000
From: Will Deacon <will.deacon@arm.com>
To: =?iso-8859-1?Q?Andr=E9?= Hentschel <nerv@dawncrow.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] arm: Preserve TPIDRURW on context switch
Message-ID: <20130208154809.GF3495@mudshark.cambridge.arm.com>
References: <5112DC7E.4020108@dawncrow.de>
 <20130206225150.GL17833@n2100.arm.linux.org.uk>
 <5112E0C3.1080706@dawncrow.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5112E0C3.1080706@dawncrow.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 11:01:23PM +0000, André Hentschel wrote:
> Am 06.02.2013 23:51, schrieb Russell King - ARM Linux:
> > On Wed, Feb 06, 2013 at 11:43:10PM +0100, André Hentschel wrote:
> >> There are more and more applications coming to WinRT, Wine could support them,
> >> but mostly they expect to have the thread environment block (TEB) in TPIDRURW.
> >> This register must be preserved per thread instead of being cleared.
> > 
> > I'd prefer this was done a little more sensitively to those CPUs where
> > loads/stores are expensive, namely:
> > 
> >> +
> >> +	@ preserve TPIDRURW register state
> >> +	get_tls2	r3, r4, r5
> >> +	str	r3, [r1, #TI_TP2_VALUE]
> >> +	ldr	r3, [r2, #TI_TP2_VALUE]
> >> +	set_tls2	r3, r4, r5
> > 
> > those two loads/stores get omitted from the thread switching if the CPU
> > doesn't support it.  Do you think that's something you could do?
> 
> No, i'm not sure how to improve this. How does the process can continue, can you or someone else fix that and add his Signed-off-by?

How about something like the (completely untested) diff below?

Andre: if this works for you, I'm happy to write a commit message etc.

Cheers,

Will

--->8

diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index cddda1f..d90be6d 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -58,7 +58,7 @@ struct thread_info {
 	struct cpu_context_save	cpu_context;	/* cpu context */
 	__u32			syscall;	/* syscall number */
 	__u8			used_cp[16];	/* thread used copro */
-	unsigned long		tp_value;
+	unsigned long		tp_value[2];	/* TLS registers */
 #ifdef CONFIG_CRUNCH
 	struct crunch_state	crunchstate;
 #endif
diff --git a/arch/arm/include/asm/tls.h b/arch/arm/include/asm/tls.h
index 73409e6..e1b09d32 100644
--- a/arch/arm/include/asm/tls.h
+++ b/arch/arm/include/asm/tls.h
@@ -6,9 +6,9 @@
 	.endm
 
 	.macro set_tls_v6k, tp, tmp1, tmp2
-	mcr	p15, 0, \tp, c13, c0, 3		@ set TLS register
-	mov	\tmp1, #0
-	mcr	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
+	ldrd	\tmp1, \tmp2, [\tp]
+	mcr	p15, 0, \tmp1, c13, c0, 3	@ set user r/o TLS register
+	mcr	p15, 0, \tmp2, c13, c0, 2	@ set user r/w TLS register
 	.endm
 
 	.macro set_tls_v6, tp, tmp1, tmp2
@@ -16,15 +16,17 @@
 	ldr	\tmp1, [\tmp1, #0]
 	mov	\tmp2, #0xffff0fff
 	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
-	mcrne	p15, 0, \tp, c13, c0, 3		@ yes, set TLS register
-	movne	\tmp1, #0
-	mcrne	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
-	streq	\tp, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
+	ldrdne	\tmp1, \tmp2, [\tp]
+	ldreq	\tmp1, [\tp]
+	mcrne	p15, 0, \tmp1, c13, c0, 3	@ yes, set user r/o TLS register
+	mcrne	p15, 0, \tmp2, c13, c0, 2	@ set user r/w TLS register
+	streq	\tmp1, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
 	.endm
 
 	.macro set_tls_software, tp, tmp1, tmp2
-	mov	\tmp1, #0xffff0fff
-	str	\tp, [\tmp1, #-15]		@ set TLS value at 0xffff0ff0
+	ldr	\tmp1, [\tp]
+	mov	\tmp2, #0xffff0fff
+	str	\tmp1, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
 	.endm
 #endif
 
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 0f82098..a0a8fe3 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -728,7 +728,7 @@ ENTRY(__switch_to)
  UNWIND(.fnstart	)
  UNWIND(.cantunwind	)
 	add	ip, r1, #TI_CPU_SAVE
-	ldr	r3, [r2, #TI_TP_VALUE]
+	add	r3, r2, #TI_TP_VALUE
  ARM(	stmia	ip!, {r4 - sl, fp, sp, lr} )	@ Store most regs on stack
  THUMB(	stmia	ip!, {r4 - sl, fp}	   )	@ Store most regs on stack
  THUMB(	str	sp, [ip], #4		   )
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index c6dec5f..ea298d2 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -400,7 +400,7 @@ copy_thread(unsigned long clone_flags, unsigned long stack_start,
 	clear_ptrace_hw_breakpoint(p);
 
 	if (clone_flags & CLONE_SETTLS)
-		thread->tp_value = childregs->ARM_r3;
+		thread->tp_value[0] = childregs->ARM_r3;
 
 	thread_notify(THREAD_NOTIFY_COPY, thread);
 
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 03deeff..2bc1514 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -849,7 +849,7 @@ long arch_ptrace(struct task_struct *child, long request,
 #endif
 
 		case PTRACE_GET_THREAD_AREA:
-			ret = put_user(task_thread_info(child)->tp_value,
+			ret = put_user(task_thread_info(child)->tp_value[0],
 				       datap);
 			break;
 
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index b0179b8..08b0db9 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -588,7 +588,7 @@ asmlinkage int arm_syscall(int no, struct pt_regs *regs)
 		return regs->ARM_r0;
 
 	case NR(set_tls):
-		thread->tp_value = regs->ARM_r0;
+		thread->tp_value[0] = regs->ARM_r0;
 		if (tls_emu)
 			return 0;
 		if (has_tls_reg) {
@@ -706,7 +706,7 @@ static int get_tp_trap(struct pt_regs *regs, unsigned int instr)
 	int reg = (instr >> 12) & 15;
 	if (reg == 15)
 		return 1;
-	regs->uregs[reg] = current_thread_info()->tp_value;
+	regs->uregs[reg] = current_thread_info()->tp_value[0];
 	regs->ARM_pc += 4;
 	return 0;
 }
