Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaHOQcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:32:09 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:52359 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaHOQ24 (ORCPT
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
Subject: [PATCH v6 tip/core/rcu 08/17] rcu: Add stall-warning checks for RCU-tasks
Date: Fri, 15 Aug 2014 09:28:36 -0700
Message-Id: <1408120125-30479-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1408120125-30479-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140815162820.GA28967@linux.vnet.ibm.com>
 <1408120125-30479-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081516-3532-0000-0000-000003E07BAB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds a ten-minute RCU-tasks stall warning.  The actual
time is controlled by the boot/sysfs parameter rcu_task_stall_timeout,
with values less than or equal to zero disabling the stall warnings.
The default value is three minutes, which means that the tasks that
have not yet responded will get their stacks dumped every ten minutes,
until they pass through a voluntary context switch.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/kernel-parameters.txt |  5 +++++
 kernel/rcu/update.c                 | 29 +++++++++++++++++++++++++----
 2 files changed, 30 insertions(+), 4 deletions(-)

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
index 33084d5749d0..ced80324b6c8 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -374,7 +374,7 @@ static DEFINE_RAW_SPINLOCK(rcu_tasks_cbs_lock);
 DEFINE_SRCU(tasks_rcu_exit_srcu);
 
 /* Control stall timeouts.  Disable with <= 0, otherwise jiffies till stall. */
-static int rcu_task_stall_timeout __read_mostly = HZ * 60 * 3;
+static int rcu_task_stall_timeout __read_mostly = HZ * 60 * 10;
 module_param(rcu_task_stall_timeout, int, 0644);
 
 /* Post an RCU-tasks callback. */
@@ -448,8 +448,9 @@ void rcu_barrier_tasks(void)
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_tasks);
 
-/* See if the current task has stopped holding out, remove from list if so. */
-static void check_holdout_task(struct task_struct *t)
+/* See if tasks are still holding out, complain if so. */
+static void check_holdout_task(struct task_struct *t,
+			       bool needreport, bool *firstreport)
 {
 	if (!ACCESS_ONCE(t->rcu_tasks_holdout) ||
 	    t->rcu_tasks_nvcsw != ACCESS_ONCE(t->nvcsw) ||
@@ -457,7 +458,15 @@ static void check_holdout_task(struct task_struct *t)
 		ACCESS_ONCE(t->rcu_tasks_holdout) = false;
 		list_del_rcu(&t->rcu_tasks_holdout_list);
 		put_task_struct(t);
+		return;
 	}
+	if (!needreport)
+		return;
+	if (*firstreport) {
+		pr_err("INFO: rcu_tasks detected stalls on tasks:\n");
+		*firstreport = false;
+	}
+	sched_show_task(t);
 }
 
 /* RCU-tasks kthread that detects grace periods and invokes callbacks. */
@@ -465,6 +474,7 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 {
 	unsigned long flags;
 	struct task_struct *g, *t;
+	unsigned long lastreport;
 	struct rcu_head *list;
 	struct rcu_head *next;
 	LIST_HEAD(rcu_tasks_holdouts);
@@ -543,13 +553,24 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 		 * of holdout tasks, removing any that are no longer
 		 * holdouts.  When the list is empty, we are done.
 		 */
+		lastreport = jiffies;
 		while (!list_empty(&rcu_tasks_holdouts)) {
+			bool firstreport;
+			bool needreport;
+			int rtst;
+
 			schedule_timeout_interruptible(HZ);
+			rtst = ACCESS_ONCE(rcu_task_stall_timeout);
+			needreport = rtst > 0 &&
+				     time_after(jiffies, lastreport + rtst);
+			if (needreport)
+				lastreport = jiffies;
+			firstreport = true;
 			WARN_ON(signal_pending(current));
 			rcu_read_lock();
 			list_for_each_entry_rcu(t, &rcu_tasks_holdouts,
 						rcu_tasks_holdout_list)
-				check_holdout_task(t);
+				check_holdout_task(t, needreport, &firstreport);
 			rcu_read_unlock();
 		}
 
-- 
1.8.1.5

