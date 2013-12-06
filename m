Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760029Ab3LFXYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:24:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49034 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423031Ab3LFXUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:20:53 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 063/152] ARM: entry: move disable_irq_notrace into svc_exit
Date: Fri,  6 Dec 2013 15:09:47 -0800
Message-Id: <1386371476-2477-64-git-send-email-kamal@canonical.com>
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

commit f8f02ec25ce3eafb049feeb3abf34fcd6e338241 upstream.

All svc exit paths need IRQs off.  Rather than placing this before
every user of svc_exit, combine it into this macro.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
[ kamal: 3.8 stable prereq for
  e16b31b ARM: 7876/1: clear Thumb-2 IT state on exception handling ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/kernel/entry-armv.S   | 18 ------------------
 arch/arm/kernel/entry-header.S |  6 ++++++
 2 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index a716ea9..a7de792 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -192,11 +192,6 @@ __dabt_svc:
 	svc_entry
 	mov	r2, sp
 	dabt_helper
-
-	@
-	@ IRQs off again before pulling preserved data off the stack
-	@
-	disable_irq_notrace
 	svc_exit r5				@ return from exception
  UNWIND(.fnend		)
 ENDPROC(__dabt_svc)
@@ -283,15 +278,7 @@ __und_svc_fault:
 	mov	r0, sp				@ struct pt_regs *regs
 	bl	__und_fault
 
-	@
-	@ IRQs off again before pulling preserved data off the stack
-	@
 __und_svc_finish:
-	disable_irq_notrace
-
-	@
-	@ restore SPSR and restart the instruction
-	@
 	ldr	r5, [sp, #S_PSR]		@ Get SVC cpsr
 	svc_exit r5				@ return from exception
  UNWIND(.fnend		)
@@ -302,11 +289,6 @@ __pabt_svc:
 	svc_entry
 	mov	r2, sp				@ regs
 	pabt_helper
-
-	@
-	@ IRQs off again before pulling preserved data off the stack
-	@
-	disable_irq_notrace
 	svc_exit r5				@ return from exception
  UNWIND(.fnend		)
 ENDPROC(__pabt_svc)
diff --git a/arch/arm/kernel/entry-header.S b/arch/arm/kernel/entry-header.S
index 0bf15e5..57a1631 100644
--- a/arch/arm/kernel/entry-header.S
+++ b/arch/arm/kernel/entry-header.S
@@ -76,12 +76,15 @@
 #ifndef CONFIG_THUMB2_KERNEL
 	.macro	svc_exit, rpsr, irq = 0
 	.if	\irq != 0
+	@ IRQs already off
 #ifdef CONFIG_TRACE_IRQFLAGS
 	@ The parent context IRQs must have been enabled to get here in
 	@ the first place, so there's no point checking the PSR I bit.
 	bl	trace_hardirqs_on
 #endif
 	.else
+	@ IRQs off again before pulling preserved data off the stack
+	disable_irq_notrace
 #ifdef CONFIG_TRACE_IRQFLAGS
 	tst	\rpsr, #PSR_I_BIT
 	bleq	trace_hardirqs_on
@@ -136,12 +139,15 @@
 #else	/* CONFIG_THUMB2_KERNEL */
 	.macro	svc_exit, rpsr, irq = 0
 	.if	\irq != 0
+	@ IRQs already off
 #ifdef CONFIG_TRACE_IRQFLAGS
 	@ The parent context IRQs must have been enabled to get here in
 	@ the first place, so there's no point checking the PSR I bit.
 	bl	trace_hardirqs_on
 #endif
 	.else
+	@ IRQs off again before pulling preserved data off the stack
+	disable_irq_notrace
 #ifdef CONFIG_TRACE_IRQFLAGS
 	tst	\rpsr, #PSR_I_BIT
 	bleq	trace_hardirqs_on
-- 
1.8.3.2

