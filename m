Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837Ab3IYBue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:50:34 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:52010 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab3IYBuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:50:25 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/6] rcu: Throttle rcu_try_advance_all_cbs() execution
Date: Tue, 24 Sep 2013 18:50:12 -0700
Message-Id: <1380073816-32381-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380073816-32381-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925014954.GA32109@linux.vnet.ibm.com>
 <1380073816-32381-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-3532-0000-0000-000001ADD52D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The rcu_try_advance_all_cbs() function is invoked on each attempted
entry to and every exit from idle.  If this function determines that
there are callbacks ready to invoke, the caller will invoke the RCU
core, which in turn will result in a pair of context switches.  If a
CPU enters and exits idle extremely frequently, this can result in
an excessive number of context switches and high CPU overhead.

This commit therefore causes rcu_try_advance_all_cbs() to throttle
itself, refusing to do work more than once per jiffy.

Reported-by: Tibor Billes <tbilles@gmx.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Tibor Billes <tbilles@gmx.com>
---
 kernel/rcutree.h        |  2 ++
 kernel/rcutree_plugin.h | 12 +++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 5f97eab..52be957 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -104,6 +104,8 @@ struct rcu_dynticks {
 				    /* idle-period nonlazy_posted snapshot. */
 	unsigned long last_accelerate;
 				    /* Last jiffy CBs were accelerated. */
+	unsigned long last_advance_all;
+				    /* Last jiffy CBs were all advanced. */
 	int tick_nohz_enabled_snap; /* Previously seen value from sysfs. */
 #endif /* #ifdef CONFIG_RCU_FAST_NO_HZ */
 };
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 18d9c91..d81e385 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1630,17 +1630,23 @@ module_param(rcu_idle_lazy_gp_delay, int, 0644);
 extern int tick_nohz_enabled;
 
 /*
- * Try to advance callbacks for all flavors of RCU on the current CPU.
- * Afterwards, if there are any callbacks ready for immediate invocation,
- * return true.
+ * Try to advance callbacks for all flavors of RCU on the current CPU, but
+ * only if it has been awhile since the last time we did so.  Afterwards,
+ * if there are any callbacks ready for immediate invocation, return true.
  */
 static bool rcu_try_advance_all_cbs(void)
 {
 	bool cbs_ready = false;
 	struct rcu_data *rdp;
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 	struct rcu_node *rnp;
 	struct rcu_state *rsp;
 
+	/* Exit early if we advanced recently. */
+	if (jiffies == rdtp->last_advance_all)
+		return 0;
+	rdtp->last_advance_all = jiffies;
+
 	for_each_rcu_flavor(rsp) {
 		rdp = this_cpu_ptr(rsp->rda);
 		rnp = rdp->mynode;
-- 
1.8.1.5

