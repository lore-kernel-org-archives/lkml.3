Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaL3OCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 09:02:32 -0500
Received: from sym2.noone.org ([178.63.92.236]:41035 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbaL3OCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 09:02:30 -0500
From: Tobias Klauser <tklauser@distanz.ch>
To: Ley Foon Tan <lftan@altera.com>
Cc: nios2-dev@lists.rocketboards.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] nios2: Use preempt_schedule_irq
Date: Tue, 30 Dec 2014 15:02:27 +0100
Message-Id: <1419948147-19123-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow aa0d53260596 ("ia64: Use preempt_schedule_irq") and use
preempt_schedule_irq instead of enabling/disabling interrupts and messing around
with PREEMPT_ACTIVE in the nios2 low-level preemption code ourselves. Also get
rid of the now needless re-check for TIF_NEED_RESCHED, preempt_schedule_irq
will already take care of rescheduling.

This also fixes the following build error when building with CONFIG_PREEMPT:

arch/nios2/kernel/built-in.o: In function `need_resched':
arch/nios2/kernel/entry.S:374: undefined reference to `PREEMPT_ACTIVE'

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 arch/nios2/kernel/entry.S | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/arch/nios2/kernel/entry.S b/arch/nios2/kernel/entry.S
index 83bca17..0bdfd13 100644
--- a/arch/nios2/kernel/entry.S
+++ b/arch/nios2/kernel/entry.S
@@ -365,30 +365,14 @@ ENTRY(ret_from_interrupt)
 	GET_THREAD_INFO	r1
 	ldw	r4, TI_PREEMPT_COUNT(r1)
 	bne	r4, r0, restore_all
-
-need_resched:
 	ldw	r4, TI_FLAGS(r1)		/* ? Need resched set */
 	BTBZ	r10, r4, TIF_NEED_RESCHED, restore_all
 	ldw	r4, PT_ESTATUS(sp)	/* ? Interrupts off */
 	andi	r10, r4, ESTATUS_EPIE
 	beq	r10, r0, restore_all
-	movia	r4, PREEMPT_ACTIVE
-	stw	r4, TI_PREEMPT_COUNT(r1)
-	rdctl	r10, status		/* enable intrs again */
-	ori	r10, r10 ,STATUS_PIE
-	wrctl	status, r10
-	PUSH	r1
-	call	schedule
-	POP	r1
-	mov	r4, r0
-	stw	r4, TI_PREEMPT_COUNT(r1)
-	rdctl	r10, status		/* disable intrs */
-	andi	r10, r10, %lo(~STATUS_PIE)
-	wrctl	status, r10
-	br	need_resched
-#else
-	br	restore_all
+	call	preempt_schedule_irq
 #endif
+	br	restore_all
 
 /***********************************************************************
  * A few syscall wrappers
-- 
2.2.0

