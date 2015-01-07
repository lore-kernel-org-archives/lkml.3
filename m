Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbbAGRxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:53:03 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:52086 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042AbbAGRw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:52:57 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/10] rcu: Make RCU_CPU_STALL_INFO include number of fqs attempts
Date: Wed,  7 Jan 2015 09:52:41 -0800
Message-Id: <1420653168-6434-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420653168-6434-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107175225.GA4237@linux.vnet.ibm.com>
 <1420653168-6434-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0013-0000-0000-000007B536FF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

One way that an RCU CPU stall warning can happen is if the grace-period
kthread is not allowed to execute.  One proxy for this kthread's
forward progress is the number of force-quiescent-state (fqs) scans.
This commit therefore adds the number of fqs scans to the RCU CPU stall
warning printouts when CONFIG_RCU_CPU_STALL_INFO=y.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c        | 1 +
 kernel/rcu/tree.h        | 2 ++
 kernel/rcu/tree_plugin.h | 3 ++-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 4c106fcc0d54..654b15be1e36 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1043,6 +1043,7 @@ static void record_gp_stall_check_time(struct rcu_state *rsp)
 	j1 = rcu_jiffies_till_stall_check();
 	ACCESS_ONCE(rsp->jiffies_stall) = j + j1;
 	rsp->jiffies_resched = j + j1 / 2;
+	rsp->n_force_qs_gpstart = ACCESS_ONCE(rsp->n_force_qs);
 }
 
 /*
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 8e7b1843896e..e300848cc0cf 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -492,6 +492,8 @@ struct rcu_state {
 						/*  for CPU stalls. */
 	unsigned long jiffies_resched;		/* Time at which to resched */
 						/*  a reluctant CPU. */
+	unsigned long n_force_qs_gpstart;	/* Snapshot of n_force_qs at */
+						/*  GP start. */
 	unsigned long gp_max;			/* Maximum GP duration in */
 						/*  jiffies. */
 	const char *name;			/* Name of structure. */
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 3ec85cb5d544..769384d77437 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1898,11 +1898,12 @@ static void print_cpu_stall_info(struct rcu_state *rsp, int cpu)
 		ticks_value = rsp->gpnum - rdp->gpnum;
 	}
 	print_cpu_stall_fast_no_hz(fast_no_hz, cpu);
-	pr_err("\t%d: (%lu %s) idle=%03x/%llx/%d softirq=%u/%u %s\n",
+	pr_err("\t%d: (%lu %s) idle=%03x/%llx/%d softirq=%u/%u fqs=%ld %s\n",
 	       cpu, ticks_value, ticks_title,
 	       atomic_read(&rdtp->dynticks) & 0xfff,
 	       rdtp->dynticks_nesting, rdtp->dynticks_nmi_nesting,
 	       rdp->softirq_snap, kstat_softirqs_cpu(RCU_SOFTIRQ, cpu),
+	       ACCESS_ONCE(rsp->n_force_qs) - rsp->n_force_qs_gpstart,
 	       fast_no_hz);
 }
 
-- 
1.8.1.5

