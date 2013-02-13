Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934424Ab3BMQRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:17:50 -0500
Received: from www.linutronix.de ([62.245.132.108]:59718 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934265Ab3BMQNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:13:15 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 04/16] rcu: rcutiny: Prevent RCU stall
Date: Wed, 13 Feb 2013 17:11:59 +0100
Message-Id: <1360771932-27150-5-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de>
References: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

rcu_read_unlock_special() checks in_serving_softirq() and leaves early
when true. On RT this is obviously wrong as softirq processing context
can be preempted and therefor such a task can be on the gp_tasks
list. Leaving early here will leave the task on the list and therefor
block RCU processing forever.

This cannot happen on mainline because softirq processing context
cannot be preempted and therefor this can never happen at all.

In fact this check looks quite questionable in general. Neither irq
context nor softirq processing context in mainline can ever be
preempted in mainline so the special unlock case should not ever be
invoked in such context. Now the only explanation might be a
rcu_read_unlock() being interrupted and therefor leave the rcu nest
count at 0 before the special unlock bit has been cleared. That looks
fragile. At least it's missing a big fat comment. Paul ????

See mainline commits: ec433f0c5 and 8762705a for further enlightment.

Reported-by: Kristian Lehmann <krleit00@hs-esslingen.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bigeasy@linutronix: different in-irq check]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/rcutiny_plugin.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 2b0484a..bac1906 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -552,7 +552,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		rcu_preempt_cpu_qs();
 
 	/* Hardware IRQ handlers cannot block. */
-	if (in_irq()) {
+	if (preempt_count() & (HARDIRQ_MASK | SOFTIRQ_OFFSET)) {
 		local_irq_restore(flags);
 		return;
 	}
-- 
1.7.10.4

