Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbaIKMw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:52:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51597 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755416AbaIKMeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mark Rutland" <mark.rutland@arm.com>,
        "Russell King" <rmk+kernel@arm.linux.org.uk>,
        "Will Deacon" <will.deacon@arm.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.65235503@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 092/131] ARM: 8129/1: errata: work around Cortex-A15
 erratum 830321 using dummy strex
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit 2c32c65e3726c773760038910be30cce1b4d4149 upstream.

On revisions of Cortex-A15 prior to r3p3, a CLREX instruction at PL1 may
falsely trigger a watchpoint exception, leading to potential data aborts
during exception return and/or livelock.

This patch resolves the issue in the following ways:

  - Replacing our uses of CLREX with a dummy STREX sequence instead (as
    we did for v6 CPUs).

  - Removing the clrex code from v7_exit_coherency_flush and derivatives,
    since this only exists as a minor performance improvement when
    non-cached exclusives are in use (Linux doesn't use these).

Benchmarking on a variety of ARM cores revealed no measurable
performance difference with this change applied, so the change is
performed unconditionally and no new Kconfig entry is added.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
[bwh: Backported to 3.2:
 - Drop inapplicable changes to arch/arm/include/asm/cacheflush.h and
   arch/arm/mach-exynos/mcpm-exynos.c]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/arm/kernel/entry-header.S
+++ b/arch/arm/kernel/entry-header.S
@@ -76,26 +76,21 @@
 #ifndef CONFIG_THUMB2_KERNEL
 	.macro	svc_exit, rpsr
 	msr	spsr_cxsf, \rpsr
-#if defined(CONFIG_CPU_V6)
-	ldr	r0, [sp]
-	strex	r1, r2, [sp]			@ clear the exclusive monitor
-	ldmib	sp, {r1 - pc}^			@ load r1 - pc, cpsr
-#elif defined(CONFIG_CPU_32v6K)
-	clrex					@ clear the exclusive monitor
-	ldmia	sp, {r0 - pc}^			@ load r0 - pc, cpsr
-#else
-	ldmia	sp, {r0 - pc}^			@ load r0 - pc, cpsr
+#if defined(CONFIG_CPU_V6) || defined(CONFIG_CPU_32v6K)
+	@ We must avoid clrex due to Cortex-A15 erratum #830321
+	sub	r0, sp, #4			@ uninhabited address
+	strex	r1, r2, [r0]			@ clear the exclusive monitor
 #endif
+	ldmia	sp, {r0 - pc}^			@ load r0 - pc, cpsr
 	.endm
 
 	.macro	restore_user_regs, fast = 0, offset = 0
 	ldr	r1, [sp, #\offset + S_PSR]	@ get calling cpsr
 	ldr	lr, [sp, #\offset + S_PC]!	@ get pc
 	msr	spsr_cxsf, r1			@ save in spsr_svc
-#if defined(CONFIG_CPU_V6)
+#if defined(CONFIG_CPU_V6) || defined(CONFIG_CPU_32v6K)
+	@ We must avoid clrex due to Cortex-A15 erratum #830321
 	strex	r1, r2, [sp]			@ clear the exclusive monitor
-#elif defined(CONFIG_CPU_32v6K)
-	clrex					@ clear the exclusive monitor
 #endif
 	.if	\fast
 	ldmdb	sp, {r1 - lr}^			@ get calling r1 - lr
@@ -123,7 +118,10 @@
 	.macro	svc_exit, rpsr
 	ldr	lr, [sp, #S_SP]			@ top of the stack
 	ldrd	r0, r1, [sp, #S_LR]		@ calling lr and pc
-	clrex					@ clear the exclusive monitor
+
+	@ We must avoid clrex due to Cortex-A15 erratum #830321
+	strex	r2, r1, [sp, #S_LR]		@ clear the exclusive monitor
+
 	stmdb	lr!, {r0, r1, \rpsr}		@ calling lr and rfe context
 	ldmia	sp, {r0 - r12}
 	mov	sp, lr
@@ -132,13 +130,16 @@
 	.endm
 
 	.macro	restore_user_regs, fast = 0, offset = 0
-	clrex					@ clear the exclusive monitor
 	mov	r2, sp
 	load_user_sp_lr r2, r3, \offset + S_SP	@ calling sp, lr
 	ldr	r1, [sp, #\offset + S_PSR]	@ get calling cpsr
 	ldr	lr, [sp, #\offset + S_PC]	@ get pc
 	add	sp, sp, #\offset + S_SP
 	msr	spsr_cxsf, r1			@ save in spsr_svc
+
+	@ We must avoid clrex due to Cortex-A15 erratum #830321
+	strex	r1, r2, [sp]			@ clear the exclusive monitor
+
 	.if	\fast
 	ldmdb	sp, {r1 - r12}			@ get calling r1 - r12
 	.else

