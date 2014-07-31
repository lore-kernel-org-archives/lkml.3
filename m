Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbaGaVz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 17:55:57 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:38922 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbaGaVzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 17:55:22 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v3 tip/core/rcu 7/9] rcu: Add stall-warning checks for RCU-tasks
Date: Thu, 31 Jul 2014 14:55:07 -0700
Message-Id: <1406843709-23396-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073121-0928-0000-0000-000003C3C96C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds a three-minute RCU-tasks stall warning.  The actual
time is controlled by the boot/sysfs parameter rcu_task_stall_timeout,
with values less than or equal to zero disabling the stall warnings.
The default value is three minutes, which means that the tasks that
have not yet responded will get their stacks dumped every three minutes,
until they pass through a voluntary context switch.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/kernel-parameters.txt |  5 ++++
 kernel/rcu/update.c                 | 50 +++++++++++++++++++++++++++++--------
 2 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 910c3829f81d..8cdbde7b17f5 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2921,6 +2921,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	rcupdate.rcu_cpu_stall_timeout= [KNL]
 			Set timeout for RCU CPU stall warning messages.
 
+	rcupdate.rcu_task_stall_timeout= [KNL]
+			Set timeout in jiffies for RCU task stall warning
+			messages.  Disable with a value less than or equal
+			to zero.
+
 	rdinit=		[KNL]
 			Format: <full_path>
 			Run specified binary instead of /init from the ramdisk,
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index b7694019e952..e940b86af4e8 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -373,6 +373,10 @@ static struct rcu_head *rcu_tasks_cbs_head;
 static struct rcu_head **rcu_tasks_cbs_tail = &rcu_tasks_cbs_head;
 static DEFINE_RAW_SPINLOCK(rcu_tasks_cbs_lock);
 
+/* Control stall timeouts.  Disable with <= 0, otherwise jiffies till stall. */
+static int rcu_task_stall_timeout __read_mostly = HZ * 60 * 3;
+module_param(rcu_task_stall_timeout, int, 0644);
+
 /* Post an RCU-tasks callback. */
 void call_rcu_tasks(struct rcu_head *rhp, void (*func)(struct rcu_head *rhp))
 {
@@ -444,11 +448,33 @@ void rcu_barrier_tasks(void)
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_tasks);
 
+/* See if tasks are still holding out, complain if so. */
+static void check_holdout_task(struct task_struct *t,
+			       bool needreport, bool *firstreport)
+{
+	if (!ACCESS_ONCE(t->rcu_tasks_holdout) ||
+	    t->rcu_tasks_nvcsw != ACCESS_ONCE(t->nvcsw) ||
+	    !ACCESS_ONCE(t->on_rq)) {
+		ACCESS_ONCE(t->rcu_tasks_holdout) = 0;
+		list_del_rcu(&t->rcu_tasks_holdout_list);
+		put_task_struct(t);
+		return;
+	}
+	if (!needreport)
+		return;
+	if (*firstreport) {
+		pr_err("INFO: rcu_tasks detected stalls on tasks:\n");
+		*firstreport = false;
+	}
+	sched_show_task(current);
+}
+
 /* RCU-tasks kthread that detects grace periods and invokes callbacks. */
 static int __noreturn rcu_tasks_kthread(void *arg)
 {
 	unsigned long flags;
 	struct task_struct *g, *t;
+	unsigned long lastreport;
 	struct rcu_head *list;
 	struct rcu_head *next;
 
@@ -518,22 +544,24 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 		 * of holdout tasks, removing any that are no longer
 		 * holdouts.  When the list is empty, we are done.
 		 */
+		lastreport = jiffies;
 		while (!list_empty(&rcu_tasks_holdouts)) {
+			bool firstreport;
+			bool needreport;
+			int rtst;
+
 			schedule_timeout_interruptible(HZ / 10);
+			rtst = ACCESS_ONCE(rcu_task_stall_timeout);
+			needreport = rtst > 0 &&
+				     time_after(jiffies, lastreport + rtst);
+			if (needreport)
+				lastreport = jiffies;
+			firstreport = true;
 			flush_signals(current);
 			rcu_read_lock();
 			list_for_each_entry_rcu(t, &rcu_tasks_holdouts,
-						rcu_tasks_holdout_list) {
-				if (ACCESS_ONCE(t->rcu_tasks_holdout)) {
-					if (t->rcu_tasks_nvcsw ==
-					    ACCESS_ONCE(t->nvcsw) &&
-					    ACCESS_ONCE(t->on_rq))
-						continue;
-					ACCESS_ONCE(t->rcu_tasks_holdout) = 0;
-				}
-				list_del_rcu(&t->rcu_tasks_holdout_list);
-				put_task_struct(t);
-			}
+						rcu_tasks_holdout_list)
+				check_holdout_task(t, needreport, &firstreport);
 			rcu_read_unlock();
 		}
 
-- 
1.8.1.5

