Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbaIEJsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:48:33 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:48547 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954AbaIEJsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:48:30 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com
Cc: dsaxena@linaro.org, Vijaya.Kumar@caviumnetworks.com,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [RFC] arm64: kgdb: fix single stepping
Date: Fri,  5 Sep 2014 18:47:43 +0900
Message-Id: <1409910463-30936-1-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried to verify kgdb in vanilla kernel on fast model, but it seems that
the single stepping with kgdb doesn't work correctly since its first
appearance at v3.15.

On v3.15, 'stepi' command after breaking the kernel at some breakpoint
steps forward to the next instruction, but the succeeding 'stepi' never
goes beyond that.
On v3.16, 'stepi' moves forward to the second instruction just after call of
do_debug_execption() in el1_dbg, and never goes beyond that. This variance
of behavior seems to come in with the following patch in v3.16:

    commit 2a2830703a23 ("arm64: debug: avoid accessing mdscr_el1 on fault
    paths where possible")

I cannot deny the possibility that this migh be a bug of fast model, but
this patch works for me better than vanilla, and hopefully will help you
see what's happening behind this issue.

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/include/asm/assembler.h |    7 +++++++
 arch/arm64/kernel/entry.S          |    4 ++--
 arch/arm64/kernel/kgdb.c           |   15 ++++++---------
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 5901480..a345973 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -87,6 +87,13 @@
 9990:
 	.endm
 
+	.macro  enable_dbg_if_not_stepping, tmp
+	mrs     \tmp, mdscr_el1
+	tbnz    \tmp, #0, 9990f
+	enable_dbg
+9990:
+	.endm
+
 /*
  * Enable both debug exceptions and interrupts. This is likely to be
  * faster than two daifclr operations, since writes to this register
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index d5eb447..b882f5d 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -325,7 +325,7 @@ el1_dbg:
 	mrs	x0, far_el1
 	mov	x2, sp				// struct pt_regs
 	bl	do_debug_exception
-	enable_dbg
+	enable_dbg_if_not_stepping x2
 	kernel_exit 1
 el1_inv:
 	// TODO: add support for undefined instructions in kernel mode
@@ -339,7 +339,7 @@ ENDPROC(el1_sync)
 	.align	6
 el1_irq:
 	kernel_entry 1
-	enable_dbg
+	enable_dbg_if_not_stepping x2
 #ifdef CONFIG_TRACE_IRQFLAGS
 	bl	trace_hardirqs_off
 #endif
diff --git a/arch/arm64/kernel/kgdb.c b/arch/arm64/kernel/kgdb.c
index 75c9cf1..bbc085f 100644
--- a/arch/arm64/kernel/kgdb.c
+++ b/arch/arm64/kernel/kgdb.c
@@ -176,14 +176,6 @@ int kgdb_arch_handle_exception(int exception_vector, int signo,
 		 * over and over again.
 		 */
 		kgdb_arch_update_addr(linux_regs, remcom_in_buffer);
-		atomic_set(&kgdb_cpu_doing_single_step, -1);
-		kgdb_single_step =  0;
-
-		/*
-		 * Received continue command, disable single step
-		 */
-		if (kernel_active_single_step())
-			kernel_disable_single_step();
 
 		err = 0;
 		break;
@@ -198,13 +190,13 @@ int kgdb_arch_handle_exception(int exception_vector, int signo,
 		 */
 		kgdb_arch_update_addr(linux_regs, remcom_in_buffer);
 		atomic_set(&kgdb_cpu_doing_single_step, raw_smp_processor_id());
-		kgdb_single_step =  1;
 
 		/*
 		 * Enable single step handling
 		 */
 		if (!kernel_active_single_step())
 			kernel_enable_single_step(linux_regs);
+
 		err = 0;
 		break;
 	default:
@@ -229,7 +221,12 @@ static int kgdb_compiled_brk_fn(struct pt_regs *regs, unsigned int esr)
 
 static int kgdb_step_brk_fn(struct pt_regs *regs, unsigned int esr)
 {
+	kernel_disable_single_step();
+
 	kgdb_handle_exception(1, SIGTRAP, 0, regs);
+
+	atomic_set(&kgdb_cpu_doing_single_step, -1);
+
 	return 0;
 }
 
-- 
1.7.9.5

