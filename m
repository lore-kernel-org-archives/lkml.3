Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbaHKWuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 18:50:13 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:37467 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbaHKWtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 18:49:16 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v5 tip/core/rcu 13/16] rcu: Make rcu_tasks_kthread()'s GP-wait loop allow preemption
Date: Mon, 11 Aug 2014 15:49:02 -0700
Message-Id: <1407797345-28227-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081122-0928-0000-0000-000003FE0201
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The grace-period-wait loop in rcu_tasks_kthread() is under (unnecessary)
RCU protection, and therefore has no preemption points in a PREEMPT=n
kernel.  This commit therefore removes the RCU protection and inserts
cond_resched().

Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/update.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index a4140f25cf1a..2ae6fb8752d4 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -470,7 +470,7 @@ static void check_holdout_task(struct task_struct *t,
 	    (IS_ENABLED(CONFIG_NO_HZ_FULL) &&
 	     !is_idle_task(t) && t->rcu_tasks_idle_cpu >= 0)) {
 		ACCESS_ONCE(t->rcu_tasks_holdout) = 0;
-		list_del_rcu(&t->rcu_tasks_holdout_list);
+		list_del_init(&t->rcu_tasks_holdout_list);
 		put_task_struct(t);
 		return;
 	}
@@ -576,6 +576,7 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 			bool firstreport;
 			bool needreport;
 			int rtst;
+			struct task_struct *t1;
 
 			schedule_timeout_interruptible(HZ);
 			rtst = ACCESS_ONCE(rcu_task_stall_timeout);
@@ -585,11 +586,11 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 				lastreport = jiffies;
 			firstreport = true;
 			WARN_ON(signal_pending(current));
-			rcu_read_lock();
-			list_for_each_entry_rcu(t, &rcu_tasks_holdouts,
-						rcu_tasks_holdout_list)
+			list_for_each_entry_safe(t, t1, &rcu_tasks_holdouts,
+						rcu_tasks_holdout_list) {
 				check_holdout_task(t, needreport, &firstreport);
-			rcu_read_unlock();
+				cond_resched();
+			}
 		}
 
 		/*
-- 
1.8.1.5

