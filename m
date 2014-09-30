Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbaI3VhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:37:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60907 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbaI3VhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:37:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 070/103] ARM: 8129/1: errata: work around Cortex-A15 erratum 830321 using dummy strex
Date: Tue, 30 Sep 2014 14:31:15 -0700
Message-Id: <1412112708-27356-71-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.13-stable: no mcpm-exynos.c in 3.13 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/include/asm/cacheflush.h |  1 -
 arch/arm/kernel/entry-header.S    | 29 +++++++++++++++--------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index ab91ebb..d892637 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -472,7 +472,6 @@ static inline void __sync_cache_range_r(volatile void *p, size_t size)
 	"mcr	p15, 0, r0, c1, c0, 0	@ set SCTLR \n\t" \
 	"isb	\n\t" \
 	"bl	v7_flush_dcache_"__stringify(level)" \n\t" \
-	"clrex	\n\t" \
 	"mrc	p15, 0, r0, c1, c0, 1	@ get ACTLR \n\t" \
 	"bic	r0, r0, #(1 << 6)	@ disable local coherency \n\t" \
 	"mcr	p15, 0, r0, c1, c0, 1	@ set ACTLR \n\t" \
diff --git a/arch/arm/kernel/entry-header.S b/arch/arm/kernel/entry-header.S
index 88c6bab..48d0242 100644
--- a/arch/arm/kernel/entry-header.S
+++ b/arch/arm/kernel/entry-header.S
@@ -208,26 +208,21 @@
 #endif
 	.endif
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
@@ -272,7 +267,10 @@
 	.endif
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
@@ -293,13 +291,16 @@
 	.endm
 #else	/* ifdef CONFIG_CPU_V7M */
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
-- 
1.9.1

