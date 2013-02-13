Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934517Ab3BMQQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:16:26 -0500
Received: from www.linutronix.de ([62.245.132.108]:59768 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934436Ab3BMQOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:14:07 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 02/12] softirq: Split handling function
Date: Wed, 13 Feb 2013 17:13:41 +0100
Message-Id: <1360772031-27186-3-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360772031-27186-1-git-send-email-bigeasy@linutronix.de>
References: <1360772031-27186-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Split out the inner handling function, so RT can reuse it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/softirq.c |   43 +++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 2980048..ad99de2 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -139,31 +139,34 @@ static void wakeup_softirqd(void)
 		wake_up_process(tsk);
 }
 
-static void handle_pending_softirqs(u32 pending, int cpu, int need_rcu_bh_qs)
+static void handle_softirq(unsigned int vec_nr, int cpu, int need_rcu_bh_qs)
 {
-	struct softirq_action *h = softirq_vec;
+	struct softirq_action *h = softirq_vec + vec_nr;
 	unsigned int prev_count = preempt_count();
 
-	local_irq_enable();
-	for ( ; pending; h++, pending >>= 1) {
-		unsigned int vec_nr = h - softirq_vec;
+	kstat_incr_softirqs_this_cpu(vec_nr);
+	trace_softirq_entry(vec_nr);
+	h->action(h);
+	trace_softirq_exit(vec_nr);
 
-		if (!(pending & 1))
-			continue;
+	if (unlikely(prev_count != preempt_count())) {
+		pr_err("softirq %u %s %p preempt count leak: %08x -> %08x\n",
+		       vec_nr, softirq_to_name[vec_nr], h->action,
+		       prev_count, (unsigned int) preempt_count());
+		preempt_count() = prev_count;
+	}
+	if (need_rcu_bh_qs)
+		rcu_bh_qs(cpu);
+}
 
-		kstat_incr_softirqs_this_cpu(vec_nr);
-		trace_softirq_entry(vec_nr);
-		h->action(h);
-		trace_softirq_exit(vec_nr);
-		if (unlikely(prev_count != preempt_count())) {
-			printk(KERN_ERR
- "huh, entered softirq %u %s %p with preempt_count %08x exited with %08x?\n",
-			       vec_nr, softirq_to_name[vec_nr], h->action,
-			       prev_count, (unsigned int) preempt_count());
-			preempt_count() = prev_count;
-		}
-		if (need_rcu_bh_qs)
-			rcu_bh_qs(cpu);
+static void handle_pending_softirqs(u32 pending, int cpu, int need_rcu_bh_qs)
+{
+	unsigned int vec_nr;
+
+	local_irq_enable();
+	for (vec_nr = 0; pending; vec_nr++, pending >>= 1) {
+		if (pending & 1)
+			handle_softirq(vec_nr, cpu, need_rcu_bh_qs);
 	}
 	local_irq_disable();
 }
-- 
1.7.10.4

