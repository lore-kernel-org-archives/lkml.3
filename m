Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbbAGRcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:32:55 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:52042 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150AbbAGRcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:32:46 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/14] rcu: Don't bother affinitying rcub kthreads away from offline CPUs
Date: Wed,  7 Jan 2015 09:32:29 -0800
Message-Id: <1420651953-2651-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107173215.GA897@linux.vnet.ibm.com>
 <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0025-0000-0000-00000791CDF4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

When rcu_boost_kthread_setaffinity() sees that all CPUs for a given
rcu_node structure are now offline, it affinities the corresponding
RCU-boost ("rcub") kthread away from those CPUs.  This is pointless
because the kthread cannot run on those offline CPUs in any case.
This commit therefore removes this unneeded code.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree_plugin.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 3e64bb197b1a..1fac68220999 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1322,12 +1322,8 @@ static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
 	for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask >>= 1)
 		if ((mask & 0x1) && cpu != outgoingcpu)
 			cpumask_set_cpu(cpu, cm);
-	if (cpumask_weight(cm) == 0) {
+	if (cpumask_weight(cm) == 0)
 		cpumask_setall(cm);
-		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++)
-			cpumask_clear_cpu(cpu, cm);
-		WARN_ON_ONCE(cpumask_weight(cm) == 0);
-	}
 	set_cpus_allowed_ptr(t, cm);
 	free_cpumask_var(cm);
 }
-- 
1.8.1.5

