Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbbAOQst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:48:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbbAOQsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:48:46 -0500
Message-ID: <54B7EF3C.8060909@redhat.com>
Date: Thu, 15 Jan 2015 22:17:56 +0530
From: Pratyush Anand <panand@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
CC: Steve Capper <steve.capper@linaro.org>, Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Long <dave.long@linaro.org>, William Cohen <wcohen@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Query: ARM64: Behavior of el1_dbg exception while executing el0_dbg
References: <54AE830E.1090000@redhat.com> <20150108162312.GO11583@arm.com> <54AEBE45.9080203@redhat.com> <20150109154635.GG11258@arm.com> <54B00C39.1070809@redhat.com> <20150112173005.GK13360@arm.com> <54B4BF4C.2030009@redhat.com> <20150113155221.GG16524@e104818-lin.cambridge.arm.com> <54B55B95.1070402@redhat.com>
In-Reply-To: <54B55B95.1070402@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------010001090602030009040608"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010001090602030009040608
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Hi Will / Catalin,

On Tuesday 13 January 2015 11:23 PM, Pratyush Anand wrote:
> I will still try to find some way to capture enable_dbg macro path.H

I did instrumented debug tap points at all the location from where 
enable_debug macro is called(see attached debug patch). But, I do not 
see that, execution reaches to any of those tap points between el0_dbg 
and el1_dbg, and tap points debug log also confirms that el1_dbg is 
raised before el0_dbg is returned.

Details of log and code base can be seen here:
https://github.com/pratyushanand/linux/tree/ml_arm64_uprobe_devel_debug_kprobe_insertion_at_uprobe_breakpoint_handler

I am also providing debug log corresponding to attached patches here for 
quick reference. Please see if there is anything which I would still be 
missing in my analysis?


Step at user level:
================================

//inserting kprobe at 1st instruction of  uprobe_breakpoint_handler. So 
1st instruction of uprobe_breakpoint_handler has been replaced by 
BRK64_OPCODE_KPROBES when kprobe enabled.

     echo 'p:myprobe uprobe_breakpoint_handler' > 
/sys/kernel/debug/tracing/kprobe_events

//enabling kprobe

     echo 1 > /sys/kernel/debug/tracing/events/kprobes/enable

//run test application

     ./test&

//inserting uprobe at offset 0x5d0 of  uprobe_breakpoint_handler. So 
instruction at this offset has been replaced by BRK64_OPCODE_UPROBES, 
when uprobe enabled.

     echo 'p:test_entry test:0x5d0' > 
/sys/kernel/debug/tracing/uprobe_events

//enabling uprobe

     echo 1 > /sys/kernel/debug/tracing/events/uprobes/enable

observed flow summary
========================
     kprobe has been inserted at 1st instruction of 
uprobe_breakpoint_handler and
     uprobe has been inserted at offset 0x5d0 of test application.
     Observation is that execution flow is as under:
     -- Application executes  BRK64_OPCODE_UPROBES.
     -- el0_sync is raised.
     -- el0_sync
         -> kernel_entry 0
         -> el0_dbg
             -> do_debug_exception
                 ->brk_handler
                     ->call_break_hook
                         ->uprobe_breakpoint_handler
     (1st instruction of uprobe_breakpoint_handler has been modified as
     BRK64_OPCODE_KPROBES)
     -- el1_sync is raised.
     -- el1_sync
         -> kernel_entry 1
         -> el1_dbg
             -> do_debug_exception
                 ->brk_handler
                     ->call_break_hook
                         ->kprobe_breakpoint_handler

     Following printk messages confirms above flow. printk messages has been
     avoided into el0_dbg and el1_dbg execution path. All the tap points for
     these path have been written into per_cpu array and then they have been
     printed when kprobe_breakpoint_handler is executed.
     tap points have been instrumented wherever we are calling macro
     enable_dbg and also in uprobe/kprobe break/single step exception path.


printk debug messages with comments
============================================

     [   60.846047] arch_prepare_kprobe called at 89
     [   60.850344] arch_prepare_kprobe called at 97
     [   60.854595] arch_prepare_kprobe called at 110
     [   60.858959] arch_prepare_kprobe called at 114 with slot
     fffffdfffc000004
     [   60.865633] arch_prepare_ss_slot called at 46
     [   60.874466] arch_arm_kprobe called at 143
     [   60.878487] patch_text called at 136
     [   60.904226] arch_uprobe_analyze_insn called at 54
     [   60.908939] arch_uprobe_analyze_insn called at 68
     [   60.914155] 0.0: event 0 syndrom 0 @cpu 0
     [   60.918151] 0.0: event 0 syndrom 0 @cpu 1
     [   60.922143] 0.0: event 0 syndrom 0 @cpu 2
     [   60.926134] 1421337852.798722179: event 19 syndrom f2000008 @cpu 3

     [1][Pratyush]: ESR = f2000008 and event 19 says its uprobe breakpoint
     exception

     [   60.932286] 1421337852.798722179: event 19 syndrom f2000004 @cpu 3

     [2][Pratyush]: ESR = f2000004 and event 19 says its kprobe breakpoint
     exception

     [   60.938438] 1421337852.798722179: event 23 syndrom f2000004 @cpu 3

     [3][Pratyush]: ESR = f2000004 and event 23 says that we are in function
     kprobe_breakpoint_handler

     Since we did not receive any event corresponding to calling of
     enable_dbg macro
     or execution of either uprobe_breakpoint_handler or
     uprobe_single_step_handler, so it is confirmed that,
     we received el1_dbg while executing el0_dbg

     [   60.944590] 0.0: event 0 syndrom 0 @cpu 3
     [   60.948579] 0.0: event 0 syndrom 0 @cpu 4
     [   60.952569] 0.0: event 0 syndrom 0 @cpu 5
     [   60.956558] 0.0: event 0 syndrom 0 @cpu 6
     [   60.960547] 0.0: event 0 syndrom 0 @cpu 7
     [   60.964539] kprobe_handler called at 453 with addr fffffe000009fd80
     [   60.970778] kprobe_handler called at 456
     [   60.974681] kprobe_handler called at 465

~Pratyush

--------------010001090602030009040608
Content-Type: text/x-patch;
 name="0001-Debug-kprobe-insertion-at-uprobe_breakpoint_handler.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Debug-kprobe-insertion-at-uprobe_breakpoint_handler.pat";
 filename*1="ch"

>From cfe62741e100060ee4165fa662689b3220312823 Mon Sep 17 00:00:00 2001
Message-Id: <cfe62741e100060ee4165fa662689b3220312823.1421340459.git.panand@redhat.com>
From: Pratyush Anand <panand@redhat.com>
Date: Wed, 7 Jan 2015 21:40:49 +0530
Subject: [PATCH] Debug kprobe insertion at uprobe_breakpoint_handler

Step at user level:
================================

//inserting kprobe at 1st instruction of  uprobe_breakpoint_handler. So
//1st instruction of uprobe_breakpoint_handler has been replaced by
//BRK64_OPCODE_KPROBES when kprobe enabled.

    echo 'p:myprobe uprobe_breakpoint_handler' >
/sys/kernel/debug/tracing/kprobe_events

//enabling kprobe

    echo 1 > /sys/kernel/debug/tracing/events/kprobes/enable

//run test application

    ./test&

//inserting uprobe at offset 0x5d0 of  uprobe_breakpoint_handler. So
//instruction at this offset has been replaced by BRK64_OPCODE_UPROBES,
//when uprobe enabled.

    echo 'p:test_entry test:0x5d0' >
/sys/kernel/debug/tracing/uprobe_events

//enabling uprobe

    echo 1 > /sys/kernel/debug/tracing/events/uprobes/enable

observed flow summary
========================
    kprobe has been inserted at 1st instruction of
uprobe_breakpoint_handler and
    uprobe has been inserted at offset 0x5d0 of test application.
    Observation is that execution flow is as under:
    -- Application executes  BRK64_OPCODE_UPROBES.
    -- el0_sync is raised.
    -- el0_sync
        -> kernel_entry 0
        -> el0_dbg
            -> do_debug_exception
                ->brk_handler
                    ->call_break_hook
                        ->uprobe_breakpoint_handler
    (1st instruction of uprobe_breakpoint_handler has been modified as
    BRK64_OPCODE_KPROBES)
    -- el1_sync is raised.
    -- el1_sync
        -> kernel_entry 1
        -> el1_dbg
            -> do_debug_exception
                ->brk_handler
                    ->call_break_hook
                        ->kprobe_breakpoint_handler

    Following printk messages confirms above flow. printk messages has
been
    avoided into el0_dbg and el1_dbg execution path. All the tap points
for
    these path have been written into per_cpu array and then they have
been
    printed when kprobe_breakpoint_handler is executed.
    tap points have been instrumented wherever we are calling macro
    enable_dbg and also in uprobe/kprobe break/single step exception
path.

printk debug messages with comments
============================================

    [   60.846047] arch_prepare_kprobe called at 89
    [   60.850344] arch_prepare_kprobe called at 97
    [   60.854595] arch_prepare_kprobe called at 110
    [   60.858959] arch_prepare_kprobe called at 114 with slot
    fffffdfffc000004
    [   60.865633] arch_prepare_ss_slot called at 46
    [   60.874466] arch_arm_kprobe called at 143
    [   60.878487] patch_text called at 136
    [   60.904226] arch_uprobe_analyze_insn called at 54
    [   60.908939] arch_uprobe_analyze_insn called at 68
    [   60.914155] 0.0: event 0 syndrom 0 @cpu 0
    [   60.918151] 0.0: event 0 syndrom 0 @cpu 1
    [   60.922143] 0.0: event 0 syndrom 0 @cpu 2
    [   60.926134] 1421337852.798722179: event 19 syndrom f2000008 @cpu
3

    [1][Pratyush]: ESR = f2000008 and event 19 says its uprobe
breakpoint
    exception

    [   60.932286] 1421337852.798722179: event 19 syndrom f2000004 @cpu
3

    [2][Pratyush]: ESR = f2000004 and event 19 says its kprobe
breakpoint
    exception

    [   60.938438] 1421337852.798722179: event 23 syndrom f2000004 @cpu
3

    [3][Pratyush]: ESR = f2000004 and event 23 says that we are in
function
    kprobe_breakpoint_handler

    Since we did not receive any event corresponding to calling of
    enable_dbg macro
    or execution of either uprobe_breakpoint_handler or
    uprobe_single_step_handler, so it is confirmed that,
    we received el1_dbg while executing el0_dbg

    [   60.944590] 0.0: event 0 syndrom 0 @cpu 3
    [   60.948579] 0.0: event 0 syndrom 0 @cpu 4
    [   60.952569] 0.0: event 0 syndrom 0 @cpu 5
    [   60.956558] 0.0: event 0 syndrom 0 @cpu 6
    [   60.960547] 0.0: event 0 syndrom 0 @cpu 7
    [   60.964539] kprobe_handler called at 453 with addr
fffffe000009fd80
    [   60.970778] kprobe_handler called at 456
    [   60.974681] kprobe_handler called at 465

Signed-off-by: Pratyush Anand <panand@redhat.com>
---
 arch/arm64/include/asm/probes.h    |   2 +
 arch/arm64/kernel/debug-monitors.c |  91 +++++++++++++++++++++++++++++++
 arch/arm64/kernel/entry.S          | 108 +++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/kprobes.c        |  81 ++++++++++++++++++++++++++++
 arch/arm64/kernel/uprobes.c        |  26 +++++++--
 5 files changed, 304 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/probes.h b/arch/arm64/include/asm/probes.h
index 54c253ba2d25..aebcf37a64f9 100644
--- a/arch/arm64/include/asm/probes.h
+++ b/arch/arm64/include/asm/probes.h
@@ -15,6 +15,8 @@
 #ifndef _ARM_PROBES_H
 #define _ARM_PROBES_H
 
+void print_debug_log_buf(void);
+void c_log_debug_entry(u64 pt, u64 syn);
 struct kprobe;
 struct arch_specific_insn;
 
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index aaa0e87d52f1..4643a5243750 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -30,6 +30,91 @@
 #include <asm/cputype.h>
 #include <asm/system_misc.h>
 
+struct debug_log_buf {
+	u64	pt;
+	u64	syn;
+	struct timespec now;
+};
+
+#define MAX_DEBUG_LOG_COUNT	1000
+
+/*
+ * Debug point
+ * 1(el1_sync)
+ * 2(el1_irq)
+ * 3(el0_sync)
+ * 4(el0_irq)
+ * 5(el1_da)
+ * 6(el1_sp_pc)
+ * 7(el1_undef)
+ * 8(el1_inv)
+ * 9(el0_da)
+ * 10(el0_ia)
+ * 11(el0_fpsimd_acc)
+ * 12(el0_fpsimd_exc)
+ * 13(el0_sp_pc)
+ * 14(el0_undef)
+ * 15(el0_dbg)
+ * 16(el0_inv)
+ * 17(el0_irq_nacked)
+ * 18(el0_svc_nacked)
+ * 19 brk_handler
+ * 20 single_step
+ * 21 uprobe_breakpoint_handler
+ * 22 uprobe_single_step_handler
+ * 23 kprobe_breakpoint_handler
+ * 24 kprobe_single_step_handler
+ */
+
+static DEFINE_PER_CPU(struct debug_log_buf[MAX_DEBUG_LOG_COUNT], debug_log_events);
+static DEFINE_PER_CPU(u32, debug_log_counts);
+bool start_log_event;
+
+void print_debug_log_buf(void)
+{
+	u32 cpu;
+	u32 count, c;
+	struct debug_log_buf *log_buf;
+
+	if (!start_log_event)
+		return;
+
+	start_log_event = false;
+
+	for_each_possible_cpu(cpu) {
+		count = per_cpu(debug_log_counts, cpu);
+		log_buf = per_cpu(debug_log_events, cpu);
+		/* if last log is wrong, it means we did not overflow */
+		for (c = 0; c <= count; c++) {
+			printk("%ld.%ld: event %lld syndrom %llx @cpu %d\n",
+					(log_buf + c)->now.tv_sec, (log_buf + c)->now.tv_nsec,
+					(log_buf + c)->pt, (log_buf + c)->syn, cpu);
+		}
+	}
+}
+
+void c_log_debug_entry(u64 pt, u64 syn)
+{
+	u32 cpu;
+	u32 count;
+	struct debug_log_buf *log_buf;
+
+	if (!start_log_event)
+		return;
+
+	cpu = get_cpu();
+	count = per_cpu(debug_log_counts, cpu);
+	/* reset count when overflow */
+	if (count == MAX_DEBUG_LOG_COUNT)
+		per_cpu(debug_log_counts, cpu) = 0;
+	log_buf = per_cpu(debug_log_events, cpu);
+	(log_buf + count)->pt = pt;
+	(log_buf + count)->syn = syn;
+	(log_buf + count)->now = current_kernel_time();
+	per_cpu(debug_log_counts, cpu)++;
+	put_cpu();
+}
+
 /* Determine debug architecture. */
 u8 debug_monitors_arch(void)
 {
@@ -229,6 +314,7 @@ static int single_step_handler(unsigned long addr, unsigned int esr,
 {
 	siginfo_t info;
 
+	c_log_debug_entry(20, esr);
 	/*
 	 * If we are stepping a pending breakpoint, call the hw_breakpoint
 	 * handler first.
@@ -306,6 +392,11 @@ static int brk_handler(unsigned long addr, unsigned int esr,
 {
 	siginfo_t info;
 
+	/* start log when uprobe bkpt exception is received */
+	if (esr == 0xf2000008)
+		start_log_event = true;
+	c_log_debug_entry(19, esr);
+
 	if (call_break_hook(regs, esr) == DBG_HOOK_HANDLED)
 		return 0;
 
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 726b910fe6ec..271b8d9f7a9a 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -28,6 +28,96 @@
 #include <asm/thread_info.h>
 #include <asm/unistd.h>
 
+	.macro log_debug_entry, pt
+	push	x28, x29
+	push	x26, x27
+	push	x24, x25
+	push	x22, x23
+	push	x20, x21
+	push	x18, x19
+	push	x16, x17
+	push	x14, x15
+	push	x12, x13
+	push	x10, x11
+	push	x8, x9
+	push	x6, x7
+	push	x4, x5
+	push	x2, x3
+	push	x0, x1
+	push	x29, x30
+	.if \pt == 1
+	mov	x0, #1
+	.endif
+	.if \pt == 2
+	mov	x0, #2
+	.endif
+	.if \pt == 3
+	mov	x0, #3
+	.endif
+	.if \pt == 4
+	mov	x0, #4
+	.endif
+	.if \pt == 5
+	mov	x0, #5
+	.endif
+	.if \pt == 6
+	mov	x0, #6
+	.endif
+	.if \pt == 7
+	mov	x0, #7
+	.endif
+	.if \pt == 8
+	mov	x0, #8
+	.endif
+	.if \pt == 9
+	mov	x0, #9
+	.endif
+	.if \pt == 10
+	mov	x0, #10
+	.endif
+	.if \pt == 11
+	mov	x0, #11
+	.endif
+	.if \pt == 12
+	mov	x0, #12
+	.endif
+	.if \pt == 13
+	mov	x0, #13
+	.endif
+	.if \pt == 14
+	mov	x0, #14
+	.endif
+	.if \pt == 15
+	mov	x0, #15
+	.endif
+	.if \pt == 16
+	mov	x0, #16
+	.endif
+	.if \pt == 17
+	mov	x0, #17
+	.endif
+	.if \pt == 18
+	mov	x0, #18
+	.endif
+	mrs	x1, esr_el1			// read the syndrome register
+	bl	c_log_debug_entry
+	pop	x29, x30
+	pop	x0, x1
+	pop	x2, x3
+	pop	x4, x5
+	pop	x6, x7
+	pop	x8, x9
+	pop	x10, x11
+	pop	x12, x13
+	pop	x14, x15
+	pop	x16, x17
+	pop	x18, x19
+	pop	x20, x21
+	pop	x22, x23
+	pop	x24, x25
+	pop	x26, x27
+	pop	x28, x29
+	.endm
 /*
  * Context tracking subsystem.  Used to instrument transitions
  * between user and kernel mode.
@@ -269,6 +359,7 @@ ENDPROC(el1_error_invalid)
 el1_sync:
 	kernel_entry 1
 	mrs	x1, esr_el1			// read the syndrome register
+	//log_debug_entry 1
 	lsr	x24, x1, #ESR_EL1_EC_SHIFT	// exception class
 	cmp	x24, #ESR_EL1_EC_DABT_EL1	// data abort in EL1
 	b.eq	el1_da
@@ -288,6 +379,7 @@ el1_da:
 	 * Data abort handling
 	 */
 	mrs	x0, far_el1
+	log_debug_entry 5
 	enable_dbg
 	// re-enable interrupts if they were enabled in the aborted context
 	tbnz	x23, #7, 1f			// PSR_I_BIT
@@ -304,6 +396,7 @@ el1_sp_pc:
 	 * Stack or PC alignment exception handling
 	 */
 	mrs	x0, far_el1
+	log_debug_entry 6
 	enable_dbg
 	mov	x2, sp
 	b	do_sp_pc_abort
@@ -311,6 +404,7 @@ el1_undef:
 	/*
 	 * Undefined instruction
 	 */
+	log_debug_entry 7
 	enable_dbg
 	mov	x0, sp
 	b	do_undefinstr
@@ -327,6 +421,7 @@ el1_dbg:
 	kernel_exit 1
 el1_inv:
 	// TODO: add support for undefined instructions in kernel mode
+	log_debug_entry 8
 	enable_dbg
 	mov	x0, sp
 	mov	x1, #BAD_SYNC
@@ -337,6 +432,7 @@ ENDPROC(el1_sync)
 	.align	6
 el1_irq:
 	kernel_entry 1
+	log_debug_entry 2
 	enable_dbg
 #ifdef CONFIG_TRACE_IRQFLAGS
 	bl	trace_hardirqs_off
@@ -375,6 +471,7 @@ el1_preempt:
 el0_sync:
 	kernel_entry 0
 	mrs	x25, esr_el1			// read the syndrome register
+	//log_debug_entry 3
 	lsr	x24, x25, #ESR_EL1_EC_SHIFT	// exception class
 	cmp	x24, #ESR_EL1_EC_SVC64		// SVC in 64-bit state
 	b.eq	el0_svc
@@ -450,6 +547,7 @@ el0_da:
 	 */
 	mrs	x26, far_el1
 	// enable interrupts before calling the main handler
+	log_debug_entry 9
 	enable_dbg_and_irq
 	ct_user_exit
 	bic	x0, x26, #(0xff << 56)
@@ -463,6 +561,7 @@ el0_ia:
 	 */
 	mrs	x26, far_el1
 	// enable interrupts before calling the main handler
+	log_debug_entry 10
 	enable_dbg_and_irq
 	ct_user_exit
 	mov	x0, x26
@@ -474,6 +573,7 @@ el0_fpsimd_acc:
 	/*
 	 * Floating Point or Advanced SIMD access
 	 */
+	log_debug_entry 11
 	enable_dbg
 	ct_user_exit
 	mov	x0, x25
@@ -484,6 +584,7 @@ el0_fpsimd_exc:
 	/*
 	 * Floating Point or Advanced SIMD exception
 	 */
+	log_debug_entry 12
 	enable_dbg
 	ct_user_exit
 	mov	x0, x25
@@ -496,6 +597,7 @@ el0_sp_pc:
 	 */
 	mrs	x26, far_el1
 	// enable interrupts before calling the main handler
+	log_debug_entry 13
 	enable_dbg_and_irq
 	mov	x0, x26
 	mov	x1, x25
@@ -507,6 +609,7 @@ el0_undef:
 	 * Undefined instruction
 	 */
 	// enable interrupts before calling the main handler
+	log_debug_entry 14
 	enable_dbg_and_irq
 	ct_user_exit
 	mov	x0, sp
@@ -521,10 +624,12 @@ el0_dbg:
 	mov	x1, x25
 	mov	x2, sp
 	bl	do_debug_exception
+	log_debug_entry 15
 	enable_dbg
 	ct_user_exit
 	b	ret_to_user
 el0_inv:
+	log_debug_entry 16
 	enable_dbg
 	ct_user_exit
 	mov	x0, sp
@@ -537,7 +642,9 @@ ENDPROC(el0_sync)
 	.align	6
 el0_irq:
 	kernel_entry 0
+	//log_debug_entry 4
 el0_irq_naked:
+	log_debug_entry 17
 	enable_dbg
 #ifdef CONFIG_TRACE_IRQFLAGS
 	bl	trace_hardirqs_off
@@ -647,6 +754,7 @@ el0_svc:
 	mov	sc_nr, #__NR_syscalls
 el0_svc_naked:					// compat entry point
 	stp	x0, scno, [sp, #S_ORIG_X0]	// save the original x0 and syscall number
+	log_debug_entry 18
 	enable_dbg_and_irq
 	ct_user_exit 1
 
diff --git a/arch/arm64/kernel/kprobes.c b/arch/arm64/kernel/kprobes.c
index 514e11411a67..651b0e6b19d1 100644
--- a/arch/arm64/kernel/kprobes.c
+++ b/arch/arm64/kernel/kprobes.c
@@ -43,6 +43,7 @@ post_kprobe_handler(struct kprobe_ctlblk *, struct pt_regs *);
 
 static void __kprobes arch_prepare_ss_slot(struct kprobe *p)
 {
+	printk("%s called at %d\n", __func__, __LINE__);
 	/* prepare insn slot */
 	p->ainsn.insn[0] = p->opcode;
 
@@ -59,6 +60,7 @@ static void __kprobes arch_prepare_ss_slot(struct kprobe *p)
 
 static void __kprobes arch_prepare_simulate(struct kprobe *p)
 {
+	printk("%s called at %d\n", __func__, __LINE__);
 	if (p->ainsn.prepare)
 		p->ainsn.prepare(p->opcode, &p->ainsn);
 
@@ -71,6 +73,7 @@ static void __kprobes arch_simulate_insn(struct kprobe *p, struct pt_regs *regs)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	if (p->ainsn.handler)
 		p->ainsn.handler((u32)p->opcode, (long)p->addr, regs);
 
@@ -83,6 +86,7 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	kprobe_opcode_t insn;
 	unsigned long probe_addr = (unsigned long)p->addr;
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	/* copy instruction */
 	insn = *p->addr;
 	p->opcode = insn;
@@ -90,19 +94,25 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	if (in_exception_text(probe_addr))
 		return -EINVAL;
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	/* decode instruction */
 	switch (arm_kprobe_decode_insn(insn, &p->ainsn)) {
 	case INSN_REJECTED:	/* insn not supported */
+	printk("%s called at %d\n", __func__, __LINE__);
 		return -EINVAL;
 
 	case INSN_GOOD_NO_SLOT:	/* insn need simulation */
+	printk("%s called at %d\n", __func__, __LINE__);
 		p->ainsn.insn = NULL;
 		break;
 
 	case INSN_GOOD:	/* instruction uses slot */
+	printk("%s called at %d\n", __func__, __LINE__);
 		p->ainsn.insn = get_insn_slot();
 		if (!p->ainsn.insn)
 			return -ENOMEM;
+	printk("%s called at %d with slot %p\n", __func__, __LINE__,
+			p->ainsn.insn);
 		break;
 	};
 
@@ -123,43 +133,51 @@ static int __kprobes patch_text(kprobe_opcode_t *addr, u32 opcode)
 	addrs[0] = (void *)addr;
 	insns[0] = (u32)opcode;
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	return aarch64_insn_patch_text_sync(addrs, insns, 1);
 }
 
 /* arm kprobe: install breakpoint in text */
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
+	printk("%s called at %d\n", __func__, __LINE__);
 	patch_text(p->addr, BRK64_OPCODE_KPROBES);
 }
 
 /* disarm kprobe: remove breakpoint from text */
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
+	printk("%s called at %d\n", __func__, __LINE__);
 	patch_text(p->addr, p->opcode);
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
+	printk("%s called at %d\n", __func__, __LINE__);
 	if (p->ainsn.insn) {
 		free_insn_slot(p->ainsn.insn, 0);
 		p->ainsn.insn = NULL;
+	printk("%s called at %d\n", __func__, __LINE__);
 	}
 }
 
 static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
+	printk("%s called at %d\n", __func__, __LINE__);
 	kcb->prev_kprobe.kp = kprobe_running();
 	kcb->prev_kprobe.status = kcb->kprobe_status;
 }
 
 static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
+	printk("%s called at %d\n", __func__, __LINE__);
 	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
 }
 
 static void __kprobes set_current_kprobe(struct kprobe *p)
 {
+	printk("%s called at %d\n", __func__, __LINE__);
 	__this_cpu_write(current_kprobe, p);
 }
 
@@ -177,6 +195,7 @@ spsr_set_debug_flag(struct pt_regs *regs, int mask)
 {
 	unsigned long spsr = regs->pstate;
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	if (mask)
 		spsr |= PSR_D_BIT;
 	else
@@ -197,6 +216,7 @@ static void __kprobes kprobes_save_local_irqflag(struct pt_regs *regs)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	kcb->saved_irqflag = regs->pstate;
 	regs->pstate |= PSR_I_BIT;
 }
@@ -205,6 +225,7 @@ static void __kprobes kprobes_restore_local_irqflag(struct pt_regs *regs)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	if (kcb->saved_irqflag & PSR_I_BIT)
 		regs->pstate |= PSR_I_BIT;
 	else
@@ -216,10 +237,12 @@ set_ss_context(struct kprobe_ctlblk *kcb, unsigned long addr)
 {
 	kcb->ss_ctx.ss_status = KPROBES_STEP_PENDING;
 	kcb->ss_ctx.match_addr = addr + sizeof(kprobe_opcode_t);
+	printk("%s called at %d with match_addr %lx\n", __func__, __LINE__, kcb->ss_ctx.match_addr);
 }
 
 static void __kprobes clear_ss_context(struct kprobe_ctlblk *kcb)
 {
+	printk("%s called at %d\n", __func__, __LINE__);
 	kcb->ss_ctx.ss_status = KPROBES_STEP_NONE;
 	kcb->ss_ctx.match_addr = 0;
 }
@@ -227,6 +250,7 @@ static void __kprobes clear_ss_context(struct kprobe_ctlblk *kcb)
 static void __kprobes
 skip_singlestep_missed(struct kprobe_ctlblk *kcb, struct pt_regs *regs)
 {
+	printk("%s called at %d\n", __func__, __LINE__);
 	/* set return addr to next pc to continue */
 	instruction_pointer_set(regs,
 			instruction_pointer(regs) + sizeof(kprobe_opcode_t));
@@ -238,15 +262,19 @@ static void __kprobes setup_singlestep(struct kprobe *p,
 {
 	unsigned long slot;
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	if (reenter) {
 		save_previous_kprobe(kcb);
 		set_current_kprobe(p);
 		kcb->kprobe_status = KPROBE_REENTER;
+	printk("%s called at %d\n", __func__, __LINE__);
 	} else {
+	printk("%s called at %d\n", __func__, __LINE__);
 		kcb->kprobe_status = KPROBE_HIT_SS;
 	}
 
 	if (p->ainsn.insn) {
+	printk("%s called at %d\n", __func__, __LINE__);
 		/* prepare for single stepping */
 		slot = (unsigned long)p->ainsn.insn;
 
@@ -259,7 +287,10 @@ static void __kprobes setup_singlestep(struct kprobe *p,
 		kprobes_save_local_irqflag(regs);
 		kernel_enable_single_step(regs);
 		instruction_pointer_set(regs, slot);
+	printk("%s called at %d with slot %lx\n", __func__, __LINE__,
+			slot);
 	} else	{
+	printk("%s called at %d\n", __func__, __LINE__);
 		/* insn simulation */
 		arch_simulate_insn(p, regs);
 	}
@@ -269,15 +300,19 @@ static int __kprobes reenter_kprobe(struct kprobe *p,
 				    struct pt_regs *regs,
 				    struct kprobe_ctlblk *kcb)
 {
+	printk("%s called at %d\n", __func__, __LINE__);
 	switch (kcb->kprobe_status) {
 	case KPROBE_HIT_SSDONE:
+	printk("%s called at %d\n", __func__, __LINE__);
 	case KPROBE_HIT_ACTIVE:
 		if (!p->ainsn.check_condn ||
 				p->ainsn.check_condn((u32)p->opcode, &p->ainsn,
 					regs)) {
+	printk("%s called at %d\n", __func__, __LINE__);
 			kprobes_inc_nmissed_count(p);
 			setup_singlestep(p, regs, kcb, 1);
 		} else	{
+	printk("%s called at %d\n", __func__, __LINE__);
 			/* condition check failed, skip stepping */
 			skip_singlestep_missed(kcb, regs);
 		}
@@ -292,6 +327,7 @@ static int __kprobes reenter_kprobe(struct kprobe *p,
 		return 0;
 	}
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	return 1;
 }
 
@@ -300,30 +336,36 @@ post_kprobe_handler(struct kprobe_ctlblk *kcb, struct pt_regs *regs)
 {
 	struct kprobe *cur = kprobe_running();
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	if (!cur)
 		return;
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	/* return addr restore if non-branching insn */
 	if (cur->ainsn.restore.type == RESTORE_PC) {
 		instruction_pointer_set(regs, cur->ainsn.restore.addr);
+	printk("%s called at %d\n", __func__, __LINE__);
 		if (!instruction_pointer(regs))
 			BUG();
 	}
 
 	/* restore back original saved kprobe variables and continue */
 	if (kcb->kprobe_status == KPROBE_REENTER) {
+	printk("%s called at %d\n", __func__, __LINE__);
 		restore_previous_kprobe(kcb);
 		return;
 	}
 	/* call post handler */
 	kcb->kprobe_status = KPROBE_HIT_SSDONE;
 	if (cur->post_handler)	{
+	printk("%s called at %d\n", __func__, __LINE__);
 		/* post_handler can hit breakpoint and single step
 		 * again, so we enable D-flag for recursive exception.
 		 */
 		cur->post_handler(cur, regs, 0);
 	}
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	reset_current_kprobe();
 }
 
@@ -332,9 +374,12 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, unsigned int fsr)
 	struct kprobe *cur = kprobe_running();
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	switch (kcb->kprobe_status) {
 	case KPROBE_HIT_SS:
+	printk("%s called at %d\n", __func__, __LINE__);
 	case KPROBE_REENTER:
+	printk("%s called at %d\n", __func__, __LINE__);
 		/*
 		 * We are here because the instruction being single
 		 * stepped caused a page fault. We reset the current
@@ -352,7 +397,9 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, unsigned int fsr)
 
 		break;
 	case KPROBE_HIT_ACTIVE:
+	printk("%s called at %d\n", __func__, __LINE__);
 	case KPROBE_HIT_SSDONE:
+	printk("%s called at %d\n", __func__, __LINE__);
 		/*
 		 * We increment the nmissed count for accounting,
 		 * we can also use npre/npostfault count for accounting
@@ -367,8 +414,10 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, unsigned int fsr)
 		 * copy_from_user(), get_user() etc. Let the
 		 * user-specified handler try to fix it first.
 		 */
+	printk("%s called at %d\n", __func__, __LINE__);
 		if (cur->fault_handler && cur->fault_handler(cur, regs, fsr))
 			return 1;
+	printk("%s called at %d\n", __func__, __LINE__);
 
 		/*
 		 * In case the user-specified fault handler returned
@@ -376,6 +425,7 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, unsigned int fsr)
 		 */
 		if (fixup_exception(regs))
 			return 1;
+	printk("%s called at %d\n", __func__, __LINE__);
 
 		break;
 	}
@@ -385,6 +435,7 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, unsigned int fsr)
 int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
 				       unsigned long val, void *data)
 {
+	printk("%s called at %d\n", __func__, __LINE__);
 	return NOTIFY_DONE;
 }
 
@@ -399,13 +450,19 @@ void __kprobes kprobe_handler(struct pt_regs *regs)
 
 	p = get_kprobe((kprobe_opcode_t *) addr);
 
+	printk("%s called at %d with addr %lx\n", __func__, __LINE__,
+			addr);
 	if (p) {
+	printk("%s called at %d\n", __func__, __LINE__);
 		if (cur) {
+	printk("%s called at %d\n", __func__, __LINE__);
 			if (reenter_kprobe(p, regs, kcb))
 				return;
+	printk("%s called at %d\n", __func__, __LINE__);
 		} else if (!p->ainsn.check_condn ||
 				p->ainsn.check_condn((u32)p->opcode, &p->ainsn,
 					regs)) {
+	printk("%s called at %d\n", __func__, __LINE__);
 			/* Probe hit and conditional execution check ok. */
 			set_current_kprobe(p);
 			kcb->kprobe_status = KPROBE_HIT_ACTIVE;
@@ -424,6 +481,7 @@ void __kprobes kprobe_handler(struct pt_regs *regs)
 			if (!p->pre_handler || !p->pre_handler(p, regs)) {
 				kcb->kprobe_status = KPROBE_HIT_SS;
 				setup_singlestep(p, regs, kcb, 0);
+	printk("%s called at %d\n", __func__, __LINE__);
 				return;
 			}
 		} else {
@@ -431,6 +489,7 @@ void __kprobes kprobe_handler(struct pt_regs *regs)
 			 * Breakpoint hit but conditional check failed,
 			 * so just skip the instruction (NOP behaviour)
 			 */
+	printk("%s called at %d\n", __func__, __LINE__);
 			skip_singlestep_missed(kcb, regs);
 			return;
 		}
@@ -443,30 +502,37 @@ void __kprobes kprobe_handler(struct pt_regs *regs)
 		 * handling of this interrupt is appropriate.
 		 * Return back to original instruction, and continue.
 		 */
+	printk("%s called at %d\n", __func__, __LINE__);
 		return;
 	} else if (cur) {
 		/* We probably hit a jprobe.  Call its break handler. */
+	printk("%s called at %d\n", __func__, __LINE__);
 		if (cur->break_handler && cur->break_handler(cur, regs)) {
 			kcb->kprobe_status = KPROBE_HIT_SS;
 			setup_singlestep(cur, regs, kcb, 0);
+	printk("%s called at %d\n", __func__, __LINE__);
 			return;
 		}
 	} else {
 		/* breakpoint is removed, now in a race
 		 * Return back to original instruction & continue.
 		 */
+	printk("%s called at %d\n", __func__, __LINE__);
 	}
 }
 
 static int __kprobes
 kprobe_ss_hit(struct kprobe_ctlblk *kcb, unsigned long addr)
 {
+	printk("%s called at %d with match_addr %lx and addr %lx\n", __func__, __LINE__, kcb->ss_ctx.match_addr, addr);
 	if ((kcb->ss_ctx.ss_status == KPROBES_STEP_PENDING)
 	    && (kcb->ss_ctx.match_addr == addr)) {
 		clear_ss_context(kcb);	/* clear pending ss */
+	printk("%s called at %d\n", __func__, __LINE__);
 		return DBG_HOOK_HANDLED;
 	}
 	/* not ours, kprobes should ignore it */
+	printk("%s called at %d\n", __func__, __LINE__);
 	return DBG_HOOK_ERROR;
 }
 
@@ -480,6 +546,7 @@ kprobe_single_step_handler(struct pt_regs *regs, unsigned int esr)
 	retval = kprobe_ss_hit(kcb, instruction_pointer(regs));
 
 	if (retval == DBG_HOOK_HANDLED) {
+		c_log_debug_entry(24, esr);
 		kprobes_restore_local_irqflag(regs);
 		kernel_disable_single_step();
 
@@ -495,6 +562,8 @@ kprobe_single_step_handler(struct pt_regs *regs, unsigned int esr)
 static int __kprobes
 kprobe_breakpoint_handler(struct pt_regs *regs, unsigned int esr)
 {
+	c_log_debug_entry(23, esr);
+	print_debug_log_buf();
 	kprobe_handler(regs);
 	return DBG_HOOK_HANDLED;
 }
@@ -505,12 +574,14 @@ int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 	long stack_ptr = stack_pointer(regs);
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	kcb->jprobe_saved_regs = *regs;
 	memcpy(kcb->jprobes_stack, (void *)stack_ptr,
 	       MIN_STACK_SIZE(stack_ptr));
 
 	instruction_pointer_set(regs, (long)jp->entry);
 	preempt_disable();
+	printk("%s called at %d\n", __func__, __LINE__);
 	return 1;
 }
 
@@ -533,6 +604,7 @@ void __kprobes jprobe_return(void)
 		      : "r"(&kcb->jprobe_saved_regs.sp),
 		      "I"(BRK64_ESR_KPROBES)
 		      : "memory");
+	printk("%s called at %d\n", __func__, __LINE__);
 }
 
 int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
@@ -542,10 +614,13 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 	long orig_sp = stack_pointer(regs);
 	struct jprobe *jp = container_of(p, struct jprobe, kp);
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	if (regs->regs[0] == JPROBES_MAGIC_NUM) {
+	printk("%s called at %d\n", __func__, __LINE__);
 		if (orig_sp != stack_addr) {
 			struct pt_regs *saved_regs =
 			    (struct pt_regs *)kcb->jprobe_saved_regs.sp;
+	printk("%s called at %d\n", __func__, __LINE__);
 			pr_err("current sp %lx does not match saved sp %lx\n",
 			       orig_sp, stack_addr);
 			pr_err("Saved registers for jprobe %p\n", jp);
@@ -558,8 +633,10 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 		memcpy((void *)stack_addr, kcb->jprobes_stack,
 		       MIN_STACK_SIZE(stack_addr));
 		preempt_enable_no_resched();
+	printk("%s called at %d\n", __func__, __LINE__);
 		return 1;
 	}
+	printk("%s called at %d\n", __func__, __LINE__);
 	return 0;
 }
 
@@ -586,6 +663,7 @@ static void __used kretprobe_trampoline_holder(void)
 			"kretprobe_trampoline:\n"
 			"NOP\n\t"
 			"NOP\n\t");
+	printk("%s called at %d\n", __func__, __LINE__);
 }
 
 static int __kprobes
@@ -614,6 +692,7 @@ trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
 	 *       real return address, and all the rest will point to
 	 *       kretprobe_trampoline
 	 */
+	printk("%s called at %d\n", __func__, __LINE__);
 	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
 		if (ri->task != current)
 			/* another task is sharing our hash bucket */
@@ -652,12 +731,14 @@ trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
 	kprobes_restore_local_irqflag(regs);
 
 	/* return 1 so that post handlers not called */
+	printk("%s called at %d\n", __func__, __LINE__);
 	return 1;
 }
 
 void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
+	printk("%s called at %d\n", __func__, __LINE__);
 	ri->ret_addr = (kprobe_opcode_t *)regs->regs[30];
 
 	/* replace return addr (x30) with trampoline */
diff --git a/arch/arm64/kernel/uprobes.c b/arch/arm64/kernel/uprobes.c
index 97e9d17d22b6..ad891d17faee 100644
--- a/arch/arm64/kernel/uprobes.c
+++ b/arch/arm64/kernel/uprobes.c
@@ -19,6 +19,7 @@ void arch_uprobe_copy_ixol(struct page *page, unsigned long vaddr,
 	void *xol_page_kaddr = kmap_atomic(page);
 	void *dst = xol_page_kaddr + (vaddr & ~PAGE_MASK);
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	preempt_disable();
 
 	/* Initialize the slot */
@@ -34,6 +35,7 @@ void arch_uprobe_copy_ixol(struct page *page, unsigned long vaddr,
 
 unsigned long uprobe_get_swbp_addr(struct pt_regs *regs)
 {
+	printk("%s called at %d\n", __func__, __LINE__);
 	return instruction_pointer(regs);
 }
 
@@ -49,17 +51,21 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 
 	insn = *(kprobe_opcode_t *)(&auprobe->insn[0]);
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	switch (arm_kprobe_decode_insn(insn, &auprobe->ainsn)) {
 	case INSN_REJECTED:
+	printk("%s called at %d\n", __func__, __LINE__);
 		return -EINVAL;
 
 	case INSN_GOOD_NO_SLOT:
+	printk("%s called at %d\n", __func__, __LINE__);
 		auprobe->simulate = true;
 		if (auprobe->ainsn.prepare)
 			auprobe->ainsn.prepare(insn, &auprobe->ainsn);
 		break;
 
 	case INSN_GOOD:
+	printk("%s called at %d\n", __func__, __LINE__);
 	default:
 		break;
 	}
@@ -71,6 +77,7 @@ int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 	struct uprobe_task *utask = current->utask;
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	/* saved fault code is restored in post_xol */
 	utask->autask.saved_fault_code = current->thread.fault_code;
 
@@ -99,6 +106,7 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 
 	user_disable_single_step(current);
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	return 0;
 }
 bool arch_uprobe_xol_was_trapped(struct task_struct *t)
@@ -109,9 +117,11 @@ bool arch_uprobe_xol_was_trapped(struct task_struct *t)
 	 * invalid fault code which is being set in arch_uprobe_pre_xol and
 	 * restored in arch_uprobe_post_xol.
 	 */
+	printk("%s called at %d\n", __func__, __LINE__);
 	if (t->thread.fault_code != UPROBE_INV_FAULT_CODE)
 		return true;
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	return false;
 }
 
@@ -120,6 +130,7 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	kprobe_opcode_t insn;
 	unsigned long addr;
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	if (!auprobe->simulate)
 		return false;
 
@@ -129,6 +140,7 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	if (auprobe->ainsn.handler)
 		auprobe->ainsn.handler(insn, addr, regs);
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	return true;
 }
 
@@ -136,6 +148,7 @@ void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 	struct uprobe_task *utask = current->utask;
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	current->thread.fault_code = utask->autask.saved_fault_code;
 	/*
 	 * Task has received a fatal signal, so reset back to probbed
@@ -152,6 +165,7 @@ arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr,
 {
 	unsigned long orig_ret_vaddr;
 
+	printk("%s called at %d\n", __func__, __LINE__);
 	orig_ret_vaddr = procedure_link_pointer(regs);
 	/* Replace the return addr with trampoline addr */
 	procedure_link_pointer_set(regs, trampoline_vaddr);
@@ -165,24 +179,28 @@ int arch_uprobe_exception_notify(struct notifier_block *self,
 	return NOTIFY_DONE;
 }
 
-static int __kprobes uprobe_breakpoint_handler(struct pt_regs *regs,
+static int uprobe_breakpoint_handler(struct pt_regs *regs,
 		unsigned int esr)
 {
-	if (user_mode(regs) && uprobe_pre_sstep_notifier(regs))
+	if (user_mode(regs) && uprobe_pre_sstep_notifier(regs)) {
+		c_log_debug_entry(21, esr);
 		return DBG_HOOK_HANDLED;
+	}
 
 	return DBG_HOOK_ERROR;
 }
 
-static int __kprobes uprobe_single_step_handler(struct pt_regs *regs,
+static int uprobe_single_step_handler(struct pt_regs *regs,
 		unsigned int esr)
 {
 	if (user_mode(regs)) {
 		WARN_ON(instruction_pointer(regs) !=
 				current->utask->xol_vaddr + 4);
 
-		if (uprobe_post_sstep_notifier(regs))
+		if (uprobe_post_sstep_notifier(regs)) {
+			c_log_debug_entry(22, esr);
 			return DBG_HOOK_HANDLED;
+		}
 	}
 
 	return DBG_HOOK_ERROR;
-- 
2.1.0


--------------010001090602030009040608--
