Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab3JFWcI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 18:32:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55151 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748Ab3JFWcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 18:32:06 -0400
From: Joel Fernandes <joelf@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: Joel Fernandes <joelf@ti.com>, Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Jonathan Austin <jonathan.austin@arm.com>,
        =?UTF-8?q?Andr=C3=A9=20Hentschel?= <nerv@dawncrow.de>
Subject: [RFC] ARM: kernel: irq: Simplify allocation of stack frame
Date: Sun, 6 Oct 2013 17:30:47 -0500
Message-ID: <1381098649-21417-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On receiving IRQ exception in SVC mode, all the SVC mode registers are saved
onto the stack very early on.

The stack frame allocation code for IRQ entry during SVC mode (svc_entry) is
hard to read as 4-less is allocated initially only to be allocated later
implicity using the mov r3, [sp, #-4]! instruction. We make code easier to read
by allocating the 4 bytes on the stack frame in the beginning itself and remove
all instances where 4 bytes is adjusted.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nico@linaro.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/kernel/entry-armv.S | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 9cbe70c..fc5ac2a 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -149,7 +149,7 @@ ENDPROC(__und_invalid)
 	.macro	svc_entry, stack_hole=0
  UNWIND(.fnstart		)
  UNWIND(.save {r0 - pc}		)
-	sub	sp, sp, #(S_FRAME_SIZE + \stack_hole - 4)
+	sub	sp, sp, #(S_FRAME_SIZE + \stack_hole)
 #ifdef CONFIG_THUMB2_KERNEL
  SPFIX(	str	r0, [sp]	)	@ temporarily saved
  SPFIX(	mov	r0, sp		)
@@ -159,14 +159,14 @@ ENDPROC(__und_invalid)
  SPFIX(	tst	sp, #4		)
 #endif
  SPFIX(	subeq	sp, sp, #4	)
-	stmia	sp, {r1 - r12}
+	stmia	sp, {r0 - r12}
 
 	ldmia	r0, {r3 - r5}
-	add	r7, sp, #S_SP - 4	@ here for interlock avoidance
+	add	r7, sp, #S_SP		@ here for interlock avoidance
 	mov	r6, #-1			@  ""  ""      ""       ""
-	add	r2, sp, #(S_FRAME_SIZE + \stack_hole - 4)
+	add	r2, sp, #(S_FRAME_SIZE + \stack_hole)
  SPFIX(	addeq	r2, r2, #4	)
-	str	r3, [sp, #-4]!		@ save the "real" r0 copied
+	str	r3, [sp]		@ save the "real" r0 copied
 					@ from the exception stack
 
 	mov	r3, lr
-- 
1.8.1.2

