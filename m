Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbaIWCke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:40:34 -0400
Received: from mail.kernel.org ([198.145.19.201]:38446 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818AbaIWCkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:40:25 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 32/45] ARM: 8129/1: errata: work around Cortex-A15 erratum 830321 using dummy strex
Date: Tue, 23 Sep 2014 10:31:34 +0800
Message-Id: <1411439507-30391-32-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
[lizf: Backported to 3.4:
 - Drop changes to arch/arm/include/asm/cacheflush.h and
   arch/arm/mach-exynos/mcpm-exynos.c]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/arm/kernel/entry-header.S |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/arm/kernel/entry-header.S b/arch/arm/kernel/entry-header.S
index 9a8531e..9d95a46 100644
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
-- 
1.7.9.5

