Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbaD1X5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:57:04 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50983 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034AbaD1X4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:56:46 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Iulia Manda <iulia.manda21@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 05/19] rcu: Remove unused rcu_data structure field
Date: Mon, 28 Apr 2014 16:56:18 -0700
Message-Id: <1398729392-15087-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140428235600.GA12200@linux.vnet.ibm.com>
 <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042823-0928-0000-0000-0000018CF5BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Iulia Manda <iulia.manda21@gmail.com>

The ->preemptible field in rcu_data is only initialized in the function
rcu_init_percpu_data(), and never used.  This commit therefore removes
this field.

Signed-off-by: Iulia Manda <iulia.manda21@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 6 ++----
 kernel/rcu/tree.h | 1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index b4688993e956..2cc39c781085 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3180,7 +3180,7 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
  * that this CPU cannot possibly have any RCU callbacks in flight yet.
  */
 static void
-rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
+rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
 {
 	unsigned long flags;
 	unsigned long mask;
@@ -3193,7 +3193,6 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 	/* Set up local state, ensuring consistent view of global state. */
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	rdp->beenonline = 1;	 /* We have now been online. */
-	rdp->preemptible = preemptible;
 	rdp->qlen_last_fqs_check = 0;
 	rdp->n_force_qs_snap = rsp->n_force_qs;
 	rdp->blimit = blimit;
@@ -3237,8 +3236,7 @@ static void rcu_prepare_cpu(int cpu)
 	struct rcu_state *rsp;
 
 	for_each_rcu_flavor(rsp)
-		rcu_init_percpu_data(cpu, rsp,
-				     strcmp(rsp->name, "rcu_preempt") == 0);
+		rcu_init_percpu_data(cpu, rsp);
 }
 
 /*
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 7b572c5c65e1..13766ad2f4ee 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -252,7 +252,6 @@ struct rcu_data {
 	bool		passed_quiesce;	/* User-mode/idle loop etc. */
 	bool		qs_pending;	/* Core waits for quiesc state. */
 	bool		beenonline;	/* CPU online at least once. */
-	bool		preemptible;	/* Preemptible RCU? */
 	struct rcu_node *mynode;	/* This CPU's leaf of hierarchy */
 	unsigned long grpmask;		/* Mask to apply to leaf qsmask. */
 #ifdef CONFIG_RCU_CPU_STALL_INFO
-- 
1.8.1.5

