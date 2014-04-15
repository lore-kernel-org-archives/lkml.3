Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbaDORfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:35:18 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:50148 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016AbaDORfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:35:15 -0400
Date: Tue, 15 Apr 2014 12:35:13 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org
Subject: rcu: Replace __this_cpu_ptr uses with raw_cpu_ptr
Message-ID: <alpine.DEB.2.10.1404151234030.27440@gentwo.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-rc1 has raw_cpu operations. So this patch that you acked before will
now apply.


Subject: rcu: Replace __this_cpu_ptr uses with raw_cpu_ptr

__this_cpu_ptr is being phased out.

One special case is increment_cpu_stall_ticks().
A per cpu variable is incremented so use raw_cpu_inc().

Cc: Dipankar Sarma <dipankar@in.ibm.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/kernel/rcu/tree.c
===================================================================
--- linux.orig/kernel/rcu/tree.c	2014-04-14 13:24:55.189353922 -0500
+++ linux/kernel/rcu/tree.c	2014-04-14 13:24:55.185354000 -0500
@@ -1951,7 +1951,7 @@
 static void rcu_adopt_orphan_cbs(struct rcu_state *rsp, unsigned long flags)
 {
 	int i;
-	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
+	struct rcu_data *rdp = raw_cpu_ptr(rsp->rda);

 	/* No-CBs CPUs are handled specially. */
 	if (rcu_nocb_adopt_orphan_cbs(rsp, rdp, flags))
@@ -2334,7 +2334,7 @@
 __rcu_process_callbacks(struct rcu_state *rsp)
 {
 	unsigned long flags;
-	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
+	struct rcu_data *rdp = raw_cpu_ptr(rsp->rda);

 	WARN_ON_ONCE(rdp->beenonline == 0);

@@ -2988,7 +2988,7 @@
 static void rcu_barrier_func(void *type)
 {
 	struct rcu_state *rsp = type;
-	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
+	struct rcu_data *rdp = raw_cpu_ptr(rsp->rda);

 	_rcu_barrier_trace(rsp, "IRQ", -1, rsp->n_barrier_done);
 	atomic_inc(&rsp->barrier_cpu_count);
Index: linux/kernel/rcu/tree_plugin.h
===================================================================
--- linux.orig/kernel/rcu/tree_plugin.h	2014-04-14 13:24:55.189353922 -0500
+++ linux/kernel/rcu/tree_plugin.h	2014-04-14 13:24:55.185354000 -0500
@@ -1855,7 +1855,7 @@
 	struct rcu_data *rdp;

 	for_each_rcu_flavor(rsp) {
-		rdp = __this_cpu_ptr(rsp->rda);
+		rdp = raw_cpu_ptr(rsp->rda);
 		if (rdp->qlen_lazy != 0) {
 			atomic_inc(&oom_callback_count);
 			rsp->call(&rdp->oom_head, rcu_oom_callback);
@@ -1997,7 +1997,7 @@
 	struct rcu_state *rsp;

 	for_each_rcu_flavor(rsp)
-		__this_cpu_ptr(rsp->rda)->ticks_this_gp++;
+		raw_cpu_inc(rsp->rda->ticks_this_gp);
 }

 #else /* #ifdef CONFIG_RCU_CPU_STALL_INFO */
