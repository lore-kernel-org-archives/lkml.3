Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab3GAQFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:05:06 -0400
Received: from multi.imgtec.com ([194.200.65.239]:10441 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab3GAQFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:05:02 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 4/5] metag: kick: prevent nested kick handlers
Date: Mon, 1 Jul 2013 17:04:18 +0100
Message-ID: <1372694659-30176-5-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372694659-30176-1-git-send-email-james.hogan@imgtec.com>
References: <1372694659-30176-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_07_01_17_05_00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main kick trigger handler iterates a list of kick handlers and calls
each one. This is done with the kick_handlers_lock spin lock held, but
this causes a problem on SMP where IPIs are implemented with kicks. A
reschedule IPI calls scheduler_ipi() which uses irq_enter() and
irq_exit(). This results in the scheduler being invoked with
kick_handlers_lock held which can result in a nested kick trigger
attempting to acquire the lock, resulting in deadlock.

irq_enter() and irq_exit() can nest, so call them from the main kick
interrupt handler so that softirqs are only handled after
kick_handlers_lock is released.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/kernel/kick.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/metag/kernel/kick.c b/arch/metag/kernel/kick.c
index 50fcbec..beb3776 100644
--- a/arch/metag/kernel/kick.c
+++ b/arch/metag/kernel/kick.c
@@ -26,6 +26,8 @@
  * pass it as an argument.
  */
 #include <linux/export.h>
+#include <linux/hardirq.h>
+#include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/types.h>
@@ -66,6 +68,7 @@ EXPORT_SYMBOL(kick_unregister_func);
 TBIRES
 kick_handler(TBIRES State, int SigNum, int Triggers, int Inst, PTBI pTBI)
 {
+	struct pt_regs *old_regs;
 	struct kick_irq_handler *kh;
 	struct list_head *lh;
 	int handled = 0;
@@ -79,6 +82,9 @@ kick_handler(TBIRES State, int SigNum, int Triggers, int Inst, PTBI pTBI)
 
 	trace_hardirqs_off();
 
+	old_regs = set_irq_regs((struct pt_regs *)State.Sig.pCtx);
+	irq_enter();
+
 	/*
 	 * There is no need to disable interrupts here because we
 	 * can't nest KICK interrupts in a KICK interrupt handler.
@@ -97,5 +103,8 @@ kick_handler(TBIRES State, int SigNum, int Triggers, int Inst, PTBI pTBI)
 
 	WARN_ON(!handled);
 
+	irq_exit();
+	set_irq_regs(old_regs);
+
 	return tail_end(ret);
 }
-- 
1.8.1.2


