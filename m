Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab3LEVXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 16:23:21 -0500
Received: from a9-50.smtp-out.amazonses.com ([54.240.9.50]:34600 "EHLO
	a9-50.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752388Ab3LEVXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 16:23:20 -0500
X-Greylist: delayed 984 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Dec 2013 16:23:20 EST
Date: Thu, 5 Dec 2013 21:06:55 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org
Subject: rcu: Avoid irq disable in rcu_cpu_kthread
Message-ID: <00000142c495b75b-c1878909-baf9-42a8-9ba7-62d216d806a7-000000@email.amazonses.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.05-54.240.9.50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once we have the per cpu patchset merged we could do the following [it
even works without that patchset but the __this_cpu ops will not do
preemption checks]. Would this work?


Subject: rcu: Avoid irq disable in rcu_cpu_kthread

The use of this_cpu ops avoids numerous address calculations
and allows to avoid the irq enable/disable sequence through a
low latency non locking this_cpu_xchg.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/kernel/rcu/tree_plugin.h
===================================================================
--- linux.orig/kernel/rcu/tree_plugin.h	2013-12-03 11:32:23.322999660 -0600
+++ linux/kernel/rcu/tree_plugin.h	2013-12-03 11:32:23.312999941 -0600
@@ -1417,33 +1417,29 @@ static int rcu_cpu_kthread_should_run(un
  */
 static void rcu_cpu_kthread(unsigned int cpu)
 {
-	unsigned int *statusp = this_cpu_ptr(&rcu_cpu_kthread_status);
-	char work, *workp = this_cpu_ptr(&rcu_cpu_has_work);
+	char work;
 	int spincnt;

 	for (spincnt = 0; spincnt < 10; spincnt++) {
 		trace_rcu_utilization(TPS("Start CPU kthread@rcu_wait"));
 		local_bh_disable();
-		*statusp = RCU_KTHREAD_RUNNING;
-		this_cpu_inc(rcu_cpu_kthread_loops);
-		local_irq_disable();
-		work = *workp;
-		*workp = 0;
-		local_irq_enable();
+		__this_cpu_write(rcu_cpu_kthread_status, RCU_KTHREAD_RUNNING);
+		__this_cpu_inc(rcu_cpu_kthread_loops);
+		work = this_cpu_xchg(rcu_cpu_has_work, 0);
 		if (work)
 			rcu_kthread_do_work();
 		local_bh_enable();
-		if (*workp == 0) {
+		if (__this_cpu_read(rcu_cpu_has_work) == 0) {
 			trace_rcu_utilization(TPS("End CPU kthread@rcu_wait"));
-			*statusp = RCU_KTHREAD_WAITING;
+			__this_cpu_write(rcu_cpu_kthread_status, RCU_KTHREAD_WAITING);
 			return;
 		}
 	}
-	*statusp = RCU_KTHREAD_YIELDING;
+	__this_cpu_write(rcu_cpu_kthread_status, RCU_KTHREAD_YIELDING);
 	trace_rcu_utilization(TPS("Start CPU kthread@rcu_yield"));
 	schedule_timeout_interruptible(2);
 	trace_rcu_utilization(TPS("End CPU kthread@rcu_yield"));
-	*statusp = RCU_KTHREAD_WAITING;
+	__this_cpu_write(rcu_cpu_kthread_status, RCU_KTHREAD_WAITING);
 }

 /*
