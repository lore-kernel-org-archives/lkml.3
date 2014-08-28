Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbaH1TVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:21:31 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46684 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbaH1TUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 15:20:20 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v7 tip/core/rcu 15/17] rcu: Additional information on RCU-tasks stall-warning messages
Date: Thu, 28 Aug 2014 12:20:06 -0700
Message-Id: <1409253608-32538-15-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409253608-32538-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828191929.GA31795@linux.vnet.ibm.com>
 <1409253608-32538-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082819-9332-0000-0000-000001D6E9CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/update.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index f86d1ae50005..9487b4898e51 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -48,6 +48,7 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/kthread.h>
+#include <linux/tick.h>
 
 #define CREATE_TRACE_POINTS
 
@@ -461,6 +462,8 @@ EXPORT_SYMBOL_GPL(rcu_barrier_tasks);
 static void check_holdout_task(struct task_struct *t,
 			       bool needreport, bool *firstreport)
 {
+	int cpu;
+
 	if (!ACCESS_ONCE(t->rcu_tasks_holdout) ||
 	    t->rcu_tasks_nvcsw != ACCESS_ONCE(t->nvcsw) ||
 	    !ACCESS_ONCE(t->on_rq) ||
@@ -477,6 +480,12 @@ static void check_holdout_task(struct task_struct *t,
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
 }
 
-- 
1.8.1.5

