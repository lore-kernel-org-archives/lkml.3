Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbaGaAlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 20:41:49 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:57555 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102AbaGaAjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 20:39:52 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v2 tip/core/rcu 08/10] rcu: Improve RCU-tasks energy efficiency
Date: Wed, 30 Jul 2014 17:39:40 -0700
Message-Id: <1406767182-4356-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1406767182-4356-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140731003914.GA3872@linux.vnet.ibm.com>
 <1406767182-4356-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073100-1542-0000-0000-000003A82F94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The current RCU-tasks implementation uses strict polling to detect
callback arrivals.  This works quite well, but is not so good for
energy efficiency.  This commit therefore replaces the strict polling
with a wait queue.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/update.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index aef581854239..030494690c93 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -371,6 +371,7 @@ static LIST_HEAD(rcu_tasks_holdouts);
 /* Global list of callbacks and associated lock. */
 static struct rcu_head *rcu_tasks_cbs_head;
 static struct rcu_head **rcu_tasks_cbs_tail = &rcu_tasks_cbs_head;
+static DECLARE_WAIT_QUEUE_HEAD(rcu_tasks_cbs_wq);
 static DEFINE_RAW_SPINLOCK(rcu_tasks_cbs_lock);
 
 /* Control stall timeouts.  Disable with <= 0, otherwise jiffies till stall. */
@@ -381,13 +382,17 @@ module_param(rcu_task_stall_timeout, int, 0644);
 void call_rcu_tasks(struct rcu_head *rhp, void (*func)(struct rcu_head *rhp))
 {
 	unsigned long flags;
+	bool needwake;
 
 	rhp->next = NULL;
 	rhp->func = func;
 	raw_spin_lock_irqsave(&rcu_tasks_cbs_lock, flags);
+	needwake = !rcu_tasks_cbs_head;
 	*rcu_tasks_cbs_tail = rhp;
 	rcu_tasks_cbs_tail = &rhp->next;
 	raw_spin_unlock_irqrestore(&rcu_tasks_cbs_lock, flags);
+	if (needwake)
+		wake_up(&rcu_tasks_cbs_wq);
 }
 EXPORT_SYMBOL_GPL(call_rcu_tasks);
 
@@ -497,8 +502,12 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 
 		/* If there were none, wait a bit and start over. */
 		if (!list) {
-			schedule_timeout_interruptible(HZ);
-			flush_signals(current);
+			wait_event_interruptible(rcu_tasks_cbs_wq,
+						 rcu_tasks_cbs_head);
+			if (!rcu_tasks_cbs_head) {
+				flush_signals(current);
+				schedule_timeout_interruptible(HZ/10);
+			}
 			continue;
 		}
 
@@ -584,6 +593,7 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 			list = next;
 			cond_resched();
 		}
+		schedule_timeout_uninterruptible(HZ/10);
 	}
 }
 
-- 
1.8.1.5

