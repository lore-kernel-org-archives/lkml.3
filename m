Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaHOQcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:32:06 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:40840 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaHOQ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:28:56 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v6 tip/core/rcu 09/17] rcu: Improve RCU-tasks energy efficiency
Date: Fri, 15 Aug 2014 09:28:37 -0700
Message-Id: <1408120125-30479-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1408120125-30479-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140815162820.GA28967@linux.vnet.ibm.com>
 <1408120125-30479-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081516-6688-0000-0000-0000040AF657
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
index ced80324b6c8..ff01b3c3e1f6 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -368,6 +368,7 @@ early_initcall(check_cpu_stall_init);
 /* Global list of callbacks and associated lock. */
 static struct rcu_head *rcu_tasks_cbs_head;
 static struct rcu_head **rcu_tasks_cbs_tail = &rcu_tasks_cbs_head;
+static DECLARE_WAIT_QUEUE_HEAD(rcu_tasks_cbs_wq);
 static DEFINE_RAW_SPINLOCK(rcu_tasks_cbs_lock);
 
 /* Track exiting tasks in order to allow them to be waited for. */
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
 
@@ -498,8 +503,12 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 
 		/* If there were none, wait a bit and start over. */
 		if (!list) {
-			schedule_timeout_interruptible(HZ);
-			WARN_ON(signal_pending(current));
+			wait_event_interruptible(rcu_tasks_cbs_wq,
+						 rcu_tasks_cbs_head);
+			if (!rcu_tasks_cbs_head) {
+				WARN_ON(signal_pending(current));
+				schedule_timeout_interruptible(HZ/10);
+			}
 			continue;
 		}
 
@@ -605,6 +614,7 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 			list = next;
 			cond_resched();
 		}
+		schedule_timeout_uninterruptible(HZ/10);
 	}
 }
 
-- 
1.8.1.5

