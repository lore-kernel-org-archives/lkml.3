Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab3GBK1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 06:27:35 -0400
Received: from multi.imgtec.com ([194.200.65.239]:38662 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932521Ab3GBK1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 06:27:34 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2] metag: kick: add missing irq_enter/exit to kick_handler()
Date: Tue, 2 Jul 2013 10:56:53 +0100
Message-ID: <1372759013-29911-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_07_02_11_26_27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kick_handler() doesn't have an irq_enter/exit pair, but it's used for
handling SMP IPIs which require work to be done in softirqs, which are
invoked from irq_exit() when the hard irq nest count reaches 0.

The scheduler_ipi() callback in the IPI handler calls irq_enter/exit
itself, but this is inside kick_handler()'s spin lock critical section,
so if an invoked softirq issues an IPI the kick_handler() will be
re-entered on the same CPU and will deadlock.

This is easily fixed by adding the missing irq_enter/exit to
kick_handler() so that the hard irq nest count doesn't reach 0 until
after the spin lock has been released.

Ideally the spin lock protected handler list will also be replaced by a
lockless RCU protected list since it is certainly mostly read. That can
be done in a later change though.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
Changes in v2:
 - Reworded commit message to hopefully be less confusing (previously
   "metag: kick: prevent nested kick handlers").

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


