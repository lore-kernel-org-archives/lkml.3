Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915AbaD1X6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:58:01 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:55919 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbaD1X4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:56:44 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Christoph Lameter <cl@linux.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 18/19] rcu: Replace __this_cpu_ptr() uses with raw_cpu_ptr()
Date: Mon, 28 Apr 2014 16:56:31 -0700
Message-Id: <1398729392-15087-18-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140428235600.GA12200@linux.vnet.ibm.com>
 <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042823-7164-0000-0000-0000015FB508
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux.com>

__this_cpu_ptr is being phased out.

One special case is increment_cpu_stall_ticks().
A per cpu variable is incremented so use raw_cpu_inc().

Cc: Dipankar Sarma <dipankar@in.ibm.com>
Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c        | 6 +++---
 kernel/rcu/tree_plugin.h | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index ecd7e046de76..d3e023e24c6f 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2008,7 +2008,7 @@ rcu_send_cbs_to_orphanage(int cpu, struct rcu_state *rsp,
 static void rcu_adopt_orphan_cbs(struct rcu_state *rsp, unsigned long flags)
 {
 	int i;
-	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
+	struct rcu_data *rdp = raw_cpu_ptr(rsp->rda);
 
 	/* No-CBs CPUs are handled specially. */
 	if (rcu_nocb_adopt_orphan_cbs(rsp, rdp, flags))
@@ -2392,7 +2392,7 @@ __rcu_process_callbacks(struct rcu_state *rsp)
 {
 	unsigned long flags;
 	bool needwake;
-	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
+	struct rcu_data *rdp = raw_cpu_ptr(rsp->rda);
 
 	WARN_ON_ONCE(rdp->beenonline == 0);
 
@@ -3066,7 +3066,7 @@ static void rcu_barrier_callback(struct rcu_head *rhp)
 static void rcu_barrier_func(void *type)
 {
 	struct rcu_state *rsp = type;
-	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
+	struct rcu_data *rdp = raw_cpu_ptr(rsp->rda);
 
 	_rcu_barrier_trace(rsp, "IRQ", -1, rsp->n_barrier_done);
 	atomic_inc(&rsp->barrier_cpu_count);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index f7593c2536b0..2e579c38bd91 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1809,7 +1809,7 @@ static void rcu_oom_notify_cpu(void *unused)
 	struct rcu_data *rdp;
 
 	for_each_rcu_flavor(rsp) {
-		rdp = __this_cpu_ptr(rsp->rda);
+		rdp = raw_cpu_ptr(rsp->rda);
 		if (rdp->qlen_lazy != 0) {
 			atomic_inc(&oom_callback_count);
 			rsp->call(&rdp->oom_head, rcu_oom_callback);
@@ -1951,7 +1951,7 @@ static void increment_cpu_stall_ticks(void)
 	struct rcu_state *rsp;
 
 	for_each_rcu_flavor(rsp)
-		__this_cpu_ptr(rsp->rda)->ticks_this_gp++;
+		raw_cpu_inc(rsp->rda->ticks_this_gp);
 }
 
 #else /* #ifdef CONFIG_RCU_CPU_STALL_INFO */
-- 
1.8.1.5

