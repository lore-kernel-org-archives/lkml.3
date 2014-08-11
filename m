Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbaHKWuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 18:50:09 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:36117 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875AbaHKWtQ (ORCPT
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
Subject: [PATCH v5 tip/core/rcu 15/16] rcu: Make RCU-tasks wait for idle tasks
Date: Mon, 11 Aug 2014 15:49:04 -0700
Message-Id: <1407797345-28227-15-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081122-7164-0000-0000-000003BF2E1E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Because idle-task code may need to be patched, RCU-tasks need to wait
for idle tasks to schedule.  This commit therefore detects this case
via context switch.  Block CPU hotplug during this time to avoid sending
IPIs to offline CPUs.

Note that checking for changes in the dyntick-idle counters is tempting,
but wrong.  The reason that it is wrong is that a interrupt or NMI can
increment these counters without necessarily allowing the idle tasks to
make any forward progress.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/update.c | 65 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 54 insertions(+), 11 deletions(-)

diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 2ae6fb8752d4..9ea2a26487c5 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -48,6 +48,7 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/kthread.h>
+#include "../sched/sched.h" /* cpu_rq()->idle */
 
 #define CREATE_TRACE_POINTS
 
@@ -464,15 +465,33 @@ EXPORT_SYMBOL_GPL(rcu_barrier_tasks);
 static void check_holdout_task(struct task_struct *t,
 			       bool needreport, bool *firstreport)
 {
-	if (!ACCESS_ONCE(t->rcu_tasks_holdout) ||
-	    t->rcu_tasks_nvcsw != ACCESS_ONCE(t->nvcsw) ||
-	    !ACCESS_ONCE(t->on_rq) ||
-	    (IS_ENABLED(CONFIG_NO_HZ_FULL) &&
-	     !is_idle_task(t) && t->rcu_tasks_idle_cpu >= 0)) {
-		ACCESS_ONCE(t->rcu_tasks_holdout) = 0;
-		list_del_init(&t->rcu_tasks_holdout_list);
-		put_task_struct(t);
-		return;
+	if (!ACCESS_ONCE(t->rcu_tasks_holdout))
+		goto not_holdout; /* Other detection of non-holdout status. */
+	if (t->rcu_tasks_nvcsw != ACCESS_ONCE(t->nvcsw))
+		goto not_holdout; /* Voluntary context switch. */
+	if (!ACCESS_ONCE(t->on_rq))
+		goto not_holdout; /* Not on runqueue. */
+	if (IS_ENABLED(CONFIG_NO_HZ_FULL) &&
+	    !is_idle_task(t) && t->rcu_tasks_idle_cpu >= 0)
+		goto not_holdout; /* NO_HZ_FULL userspace execution. */
+	if (is_idle_task(t)) {
+		int cpu;
+
+		cpu = task_cpu(t);
+		if (cpu >= 0 && cpu_curr(cpu) != t)
+			goto not_holdout; /* Idle task not running. */
+
+		if (cpu >= 0) {
+			/*
+			 * We must schedule on the idle CPU.  Note that
+			 * checking for changes in dyntick-idle counters
+			 * is not sufficient, as an interrupt or NMI can
+			 * change these counters without guaranteeing that
+			 * the underlying idle task has made progress.
+			 */
+			set_cpus_allowed_ptr(current, cpumask_of(cpu));
+			set_cpus_allowed_ptr(current, cpu_online_mask);
+		}
 	}
 	if (!needreport)
 		return;
@@ -481,11 +500,17 @@ static void check_holdout_task(struct task_struct *t,
 		*firstreport = false;
 	}
 	sched_show_task(t);
+	return;
+not_holdout:
+	ACCESS_ONCE(t->rcu_tasks_holdout) = 0;
+	list_del_init(&t->rcu_tasks_holdout_list);
+	put_task_struct(t);
 }
 
 /* RCU-tasks kthread that detects grace periods and invokes callbacks. */
 static int __noreturn rcu_tasks_kthread(void *arg)
 {
+	int cpu;
 	unsigned long flags;
 	struct task_struct *g, *t;
 	unsigned long lastreport;
@@ -546,8 +571,7 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 		 */
 		rcu_read_lock();
 		for_each_process_thread(g, t) {
-			if (t != current && ACCESS_ONCE(t->on_rq) &&
-			    !is_idle_task(t)) {
+			if (t != current && ACCESS_ONCE(t->on_rq)) {
 				get_task_struct(t);
 				t->rcu_tasks_nvcsw = ACCESS_ONCE(t->nvcsw);
 				ACCESS_ONCE(t->rcu_tasks_holdout) = 1;
@@ -558,6 +582,24 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 		rcu_read_unlock();
 
 		/*
+		 * Next, queue up any currently running idle tasks.
+		 * Exclude CPU hotplug during the time we are working
+		 * with idle tasks, as it is considered bad form to
+		 * send IPIs to offline CPUs.
+		 */
+		get_online_cpus();
+		for_each_online_cpu(cpu) {
+			t = cpu_rq(cpu)->idle;
+			if (t == cpu_curr(cpu)) {
+				get_task_struct(t);
+				t->rcu_tasks_nvcsw = ACCESS_ONCE(t->nvcsw);
+				ACCESS_ONCE(t->rcu_tasks_holdout) = 1;
+				list_add(&t->rcu_tasks_holdout_list,
+					 &rcu_tasks_holdouts);
+			}
+		}
+
+		/*
 		 * Wait for tasks that are in the process of exiting.
 		 * This does only part of the job, ensuring that all
 		 * tasks that were previously exiting reach the point
@@ -592,6 +634,7 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 				cond_resched();
 			}
 		}
+		put_online_cpus();
 
 		/*
 		 * Because ->on_rq and ->nvcsw are not guaranteed
-- 
1.8.1.5

