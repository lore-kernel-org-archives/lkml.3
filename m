Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbaHKWuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 18:50:12 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:37469 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861AbaHKWtQ (ORCPT
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
Subject: [PATCH v5 tip/core/rcu 16/16] rcu: Additional information on RCU-tasks stall-warning messages
Date: Mon, 11 Aug 2014 15:49:05 -0700
Message-Id: <1407797345-28227-16-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081122-0928-0000-0000-000003FE0203
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/update.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 9ea2a26487c5..43ea9c37bbd0 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -465,6 +465,8 @@ EXPORT_SYMBOL_GPL(rcu_barrier_tasks);
 static void check_holdout_task(struct task_struct *t,
 			       bool needreport, bool *firstreport)
 {
+	int cpu;
+
 	if (!ACCESS_ONCE(t->rcu_tasks_holdout))
 		goto not_holdout; /* Other detection of non-holdout status. */
 	if (t->rcu_tasks_nvcsw != ACCESS_ONCE(t->nvcsw))
@@ -475,8 +477,6 @@ static void check_holdout_task(struct task_struct *t,
 	    !is_idle_task(t) && t->rcu_tasks_idle_cpu >= 0)
 		goto not_holdout; /* NO_HZ_FULL userspace execution. */
 	if (is_idle_task(t)) {
-		int cpu;
-
 		cpu = task_cpu(t);
 		if (cpu >= 0 && cpu_curr(cpu) != t)
 			goto not_holdout; /* Idle task not running. */
@@ -499,6 +499,12 @@ static void check_holdout_task(struct task_struct *t,
 		pr_err("INFO: rcu_tasks detected stalls on tasks:\n");
 		*firstreport = false;
 	}
+	cpu = task_cpu(t);
+	pr_alert("%p: %c%c nvcsw: %lu/%lu holdout: %d idle_cpu: %d/%d\n",
+		 t, ".I"[is_idle_task(t)],
+		 "N."[cpu < 0 || !tick_nohz_full_cpu(cpu)],
+		 t->rcu_tasks_nvcsw, t->nvcsw, t->rcu_tasks_holdout,
+		 t->rcu_tasks_idle_cpu, cpu);
 	sched_show_task(t);
 	return;
 not_holdout:
-- 
1.8.1.5

