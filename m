Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbbAGRcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:32:53 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:52052 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbbAGRcq (ORCPT
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
Subject: [PATCH tip/core/rcu 11/14] rcu: Note quiescent state when CPU goes offline
Date: Wed,  7 Jan 2015 09:32:30 -0800
Message-Id: <1420651953-2651-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107173215.GA897@linux.vnet.ibm.com>
 <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0025-0000-0000-00000791CDF3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The rcu_cleanup_dead_cpu() function (called after a CPU has gone
completely offline) has not reported a quiescent state because there
was probably at least one synchronize_rcu() between the time the CPU
went offline and the CPU_DEAD notifier, and this would have detected
the CPU's offline state via quiescent-state forcing.  However, the plan
is for CPUs to take themselves offline, at which point it makes sense
for them to report their own quiescent state.  This commit makes this
change in preparation for the new CPU-hotplug setup.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 5a0a4c969d38..24d3c67f7be7 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2297,7 +2297,7 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 	rnp->qsmaskinit &= ~rdp->grpmask;
 	if (rnp->qsmaskinit == 0 && !rcu_preempt_has_tasks(rnp))
 		rcu_cleanup_dead_rnp(rnp);
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	rcu_report_qs_rnp(rdp->grpmask, rsp, rnp, flags); /* Rlses rnp->lock. */
 	WARN_ONCE(rdp->qlen != 0 || rdp->nxtlist != NULL,
 		  "rcu_cleanup_dead_cpu: Callbacks on offline CPU %d: qlen=%lu, nxtlist=%p\n",
 		  cpu, rdp->qlen, rdp->nxtlist);
-- 
1.8.1.5

