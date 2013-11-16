Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab3KPAYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:24:16 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:52515 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab3KPAXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:23:47 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 11/16] rcu: Warn on allegedly impossible rcu_read_unlock_special() from irq
Date: Fri, 15 Nov 2013 16:23:33 -0800
Message-Id: <1384561418-30575-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384561418-30575-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116002316.GA29049@linux.vnet.ibm.com>
 <1384561418-30575-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-3532-0000-0000-0000031122A0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

After commit #10f39bb1b2c1 (rcu: protect __rcu_read_unlock() against
scheduler-using irq handlers), it is no longer possible to enter
the main body of rcu_read_lock_special() from an NMI, interrupt, or
softirq handler.  In theory, this implies that the check for "in_irq()
|| in_serving_softirq()" must always fail, so that in theory this check
could be removed entirely.

In practice, this commit wraps this condition with a WARN_ON_ONCE().
If this warning never triggers, then the condition will be removed
entirely.

[ paulmck: And one way of triggering the WARN_ON() is if a scheduling
  clock interrupt occurs in an RCU read-side critical section, setting
  RCU_READ_UNLOCK_NEED_QS, which is handled by rcu_read_unlock_special().
  Updated this commit to return if only that bit was set. ]

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Merge with 14b8cc88f674 (rcu: Warn on allegedly impossible rcu_read_unlock_special() from irq)

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree_plugin.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 59a3a17a0c57..29335faf96e7 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -361,10 +361,14 @@ void rcu_read_unlock_special(struct task_struct *t)
 	special = t->rcu_read_unlock_special;
 	if (special & RCU_READ_UNLOCK_NEED_QS) {
 		rcu_preempt_qs(smp_processor_id());
+		if (!t->rcu_read_unlock_special) {
+			local_irq_restore(flags);
+			return;
+		}
 	}
 
-	/* Hardware IRQ handlers cannot block. */
-	if (in_irq() || in_serving_softirq()) {
+	/* Hardware IRQ handlers cannot block, complain if they get here. */
+	if (WARN_ON_ONCE(in_irq() || in_serving_softirq())) {
 		local_irq_restore(flags);
 		return;
 	}
-- 
1.8.1.5

