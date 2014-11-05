Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbaKERmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:42:11 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:59087 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbaKERlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:41:45 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 07/10] rcu: Shorten irq-disable region in rcu_cleanup_dead_cpu()
Date: Wed,  5 Nov 2014 09:41:31 -0800
Message-Id: <1415209294-2534-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1415209294-2534-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141105174109.GA1306@linux.vnet.ibm.com>
 <1415209294-2534-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110517-0021-0000-0000-000005ECE48B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Now that we are not migrating callbacks, there is no need to hold the
->orphan_lock across the the ->qsmaskinit bit-clearing process.
This commit therefore releases ->orphan_lock immediately after adopting
the orphaned RCU callbacks.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index e870b0f5e1b9..3c23e921b438 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2257,14 +2257,14 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 	/* Orphan the dead CPU's callbacks, and adopt them if appropriate. */
 	rcu_send_cbs_to_orphanage(cpu, rsp, rnp, rdp);
 	rcu_adopt_orphan_cbs(rsp, flags);
+	raw_spin_unlock_irqrestore(&rsp->orphan_lock, flags);
 
 	/* Remove outgoing CPU from mask in the leaf rcu_node structure. */
-	raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
+	raw_spin_lock_irqsave(&rnp->lock, flags);
 	smp_mb__after_unlock_lock();	/* Enforce GP memory-order guarantee. */
 	rnp->qsmaskinit &= ~rdp->grpmask;
 	if (rnp->qsmaskinit == 0 && !rcu_preempt_has_tasks(rnp))
 		rcu_cleanup_dead_rnp(rnp);
-	raw_spin_unlock(&rsp->orphan_lock); /* irqs remain disabled. */
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	WARN_ONCE(rdp->qlen != 0 || rdp->nxtlist != NULL,
 		  "rcu_cleanup_dead_cpu: Callbacks on offline CPU %d: qlen=%lu, nxtlist=%p\n",
-- 
1.8.1.5

