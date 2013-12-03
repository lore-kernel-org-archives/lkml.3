Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab3LCXpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:45:52 -0500
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:48846 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755455Ab3LCXjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:39:04 -0500
Message-Id: <20131203233256.509969629@linux.com>
User-Agent: quilt/0.60-1
Date: Tue, 03 Dec 2013 17:32:54 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 22/41] rcu: Replace __this_cpu_ptr uses with raw_cpu_ptr
References: <20131203233232.928771708@linux.com>
Content-Disposition: inline; filename=this_rcu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__this_cpu_ptr is being phased out.

One special case is increment_cpu_stall_ticks().
A per cpu variable is incremented so use raw_cpu_inc().

Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/kernel/rcu/tree.c
===================================================================
--- linux.orig/kernel/rcu/tree.c	2013-12-02 16:07:53.894519622 -0600
+++ linux/kernel/rcu/tree.c	2013-12-02 16:07:53.894519622 -0600
@@ -1904,7 +1904,7 @@ rcu_send_cbs_to_orphanage(int cpu, struc
 static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
 {
 	int i;
-	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
+	struct rcu_data *rdp = raw_cpu_ptr(rsp->rda);
 
 	/* No-CBs CPUs are handled specially. */
 	if (rcu_nocb_adopt_orphan_cbs(rsp, rdp))
@@ -2283,7 +2283,7 @@ static void
 __rcu_process_callbacks(struct rcu_state *rsp)
 {
 	unsigned long flags;
-	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
+	struct rcu_data *rdp = raw_cpu_ptr(rsp->rda);
 
 	WARN_ON_ONCE(rdp->beenonline == 0);
 
@@ -2871,7 +2871,7 @@ static void rcu_barrier_callback(struct
 static void rcu_barrier_func(void *type)
 {
 	struct rcu_state *rsp = type;
-	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
+	struct rcu_data *rdp = raw_cpu_ptr(rsp->rda);
 
 	_rcu_barrier_trace(rsp, "IRQ", -1, rsp->n_barrier_done);
 	atomic_inc(&rsp->barrier_cpu_count);
Index: linux/kernel/rcu/tree_plugin.h
===================================================================
--- linux.orig/kernel/rcu/tree_plugin.h	2013-12-02 16:07:53.894519622 -0600
+++ linux/kernel/rcu/tree_plugin.h	2013-12-02 16:07:53.894519622 -0600
@@ -1830,7 +1830,7 @@ static void rcu_oom_notify_cpu(void *unu
 	struct rcu_data *rdp;
 
 	for_each_rcu_flavor(rsp) {
-		rdp = __this_cpu_ptr(rsp->rda);
+		rdp = raw_cpu_ptr(rsp->rda);
 		if (rdp->qlen_lazy != 0) {
 			atomic_inc(&oom_callback_count);
 			rsp->call(&rdp->oom_head, rcu_oom_callback);
@@ -1971,7 +1971,7 @@ static void increment_cpu_stall_ticks(vo
 	struct rcu_state *rsp;
 
 	for_each_rcu_flavor(rsp)
-		__this_cpu_ptr(rsp->rda)->ticks_this_gp++;
+		raw_cpu_inc(rsp->rda->ticks_this_gp);
 }
 
 #else /* #ifdef CONFIG_RCU_CPU_STALL_INFO */

