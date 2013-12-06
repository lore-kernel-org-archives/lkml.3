Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759709Ab3LFXVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:21:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49086 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423086Ab3LFXVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:21:05 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 062/152] ARM: entry: move IRQ tracing exit into svc_exit
Date: Fri,  6 Dec 2013 15:09:46 -0800
Message-Id: <1386371476-2477-63-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 9b56febea22003c424f11248908b534eba0f1eeb upstream.

The IRQ tracing exit path is much the same between all SVC mode
exits, so move this into the svc_exit macro.  Use a macro parameter
to identify the IRQ case, which is the only different case there is.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
[ kamal: 3.8 stable prereq for
  e16b31b ARM: 7876/1: clear Thumb-2 IT state on exception handling ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/kernel/entry-armv.S   | 27 +--------------------------
 arch/arm/kernel/entry-header.S | 32 ++++++++++++++++++++++++++++++--
 2 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 5492d72..a716ea9 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -197,13 +197,6 @@ __dabt_svc:
 	@ IRQs off again before pulling preserved data off the stack
 	@
 	disable_irq_notrace
-
-#ifdef CONFIG_TRACE_IRQFLAGS
-	tst	r5, #PSR_I_BIT
-	bleq	trace_hardirqs_on
-	tst	r5, #PSR_I_BIT
-	blne	trace_hardirqs_off
-#endif
 	svc_exit r5				@ return from exception
  UNWIND(.fnend		)
 ENDPROC(__dabt_svc)
@@ -223,12 +216,7 @@ __irq_svc:
 	blne	svc_preempt
 #endif
 
-#ifdef CONFIG_TRACE_IRQFLAGS
-	@ The parent context IRQs must have been enabled to get here in
-	@ the first place, so there's no point checking the PSR I bit.
-	bl	trace_hardirqs_on
-#endif
-	svc_exit r5				@ return from exception
+	svc_exit r5, irq = 1			@ return from exception
  UNWIND(.fnend		)
 ENDPROC(__irq_svc)
 
@@ -305,12 +293,6 @@ __und_svc_finish:
 	@ restore SPSR and restart the instruction
 	@
 	ldr	r5, [sp, #S_PSR]		@ Get SVC cpsr
-#ifdef CONFIG_TRACE_IRQFLAGS
-	tst	r5, #PSR_I_BIT
-	bleq	trace_hardirqs_on
-	tst	r5, #PSR_I_BIT
-	blne	trace_hardirqs_off
-#endif
 	svc_exit r5				@ return from exception
  UNWIND(.fnend		)
 ENDPROC(__und_svc)
@@ -325,13 +307,6 @@ __pabt_svc:
 	@ IRQs off again before pulling preserved data off the stack
 	@
 	disable_irq_notrace
-
-#ifdef CONFIG_TRACE_IRQFLAGS
-	tst	r5, #PSR_I_BIT
-	bleq	trace_hardirqs_on
-	tst	r5, #PSR_I_BIT
-	blne	trace_hardirqs_off
-#endif
 	svc_exit r5				@ return from exception
  UNWIND(.fnend		)
 ENDPROC(__pabt_svc)
diff --git a/arch/arm/kernel/entry-header.S b/arch/arm/kernel/entry-header.S
index 9a8531e..0bf15e5 100644
--- a/arch/arm/kernel/entry-header.S
+++ b/arch/arm/kernel/entry-header.S
@@ -74,7 +74,21 @@
 	.endm
 
 #ifndef CONFIG_THUMB2_KERNEL
-	.macro	svc_exit, rpsr
+	.macro	svc_exit, rpsr, irq = 0
+	.if	\irq != 0
+#ifdef CONFIG_TRACE_IRQFLAGS
+	@ The parent context IRQs must have been enabled to get here in
+	@ the first place, so there's no point checking the PSR I bit.
+	bl	trace_hardirqs_on
+#endif
+	.else
+#ifdef CONFIG_TRACE_IRQFLAGS
+	tst	\rpsr, #PSR_I_BIT
+	bleq	trace_hardirqs_on
+	tst	\rpsr, #PSR_I_BIT
+	blne	trace_hardirqs_off
+#endif
+	.endif
 	msr	spsr_cxsf, \rpsr
 #if defined(CONFIG_CPU_V6)
 	ldr	r0, [sp]
@@ -120,7 +134,21 @@
 	mov	pc, \reg
 	.endm
 #else	/* CONFIG_THUMB2_KERNEL */
-	.macro	svc_exit, rpsr
+	.macro	svc_exit, rpsr, irq = 0
+	.if	\irq != 0
+#ifdef CONFIG_TRACE_IRQFLAGS
+	@ The parent context IRQs must have been enabled to get here in
+	@ the first place, so there's no point checking the PSR I bit.
+	bl	trace_hardirqs_on
+#endif
+	.else
+#ifdef CONFIG_TRACE_IRQFLAGS
+	tst	\rpsr, #PSR_I_BIT
+	bleq	trace_hardirqs_on
+	tst	\rpsr, #PSR_I_BIT
+	blne	trace_hardirqs_off
+#endif
+	.endif
 	ldr	lr, [sp, #S_SP]			@ top of the stack
 	ldrd	r0, r1, [sp, #S_LR]		@ calling lr and pc
 	clrex					@ clear the exclusive monitor
-- 
1.8.3.2

