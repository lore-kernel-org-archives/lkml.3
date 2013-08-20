Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab3HTCm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:42:29 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:39645 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3HTCmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:42:25 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 5/9] rcu: Avoid redundant grace-period kthread wakeups
Date: Mon, 19 Aug 2013 19:42:10 -0700
Message-Id: <1376966534-30775-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376966534-30775-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130820024148.GA30283@linux.vnet.ibm.com>
 <1376966534-30775-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082002-2398-0000-0000-000001A46F1C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

When setting up an in-the-future "advanced" grace period, the code needs
to wake up the relevant grace-period kthread, which it currently does
unconditionally.  However, this results in needless wakeups in the case
where the advanced grace period is being set up by the grace-period
kthread itself, which is a non-uncommon situation.  This commit therefore
checks to see if the running thread is the grace-period kthread, and
avoids doing the irq_work_queue()-mediated wakeup in that case.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 9184056..c6a064a 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1576,10 +1576,12 @@ rcu_start_gp_advanced(struct rcu_state *rsp, struct rcu_node *rnp,
 
 	/*
 	 * We can't do wakeups while holding the rnp->lock, as that
-	 * could cause possible deadlocks with the rq->lock. Deter
-	 * the wakeup to interrupt context.
+	 * could cause possible deadlocks with the rq->lock. Defer
+	 * the wakeup to interrupt context.  And don't bother waking
+	 * up the running kthread.
 	 */
-	irq_work_queue(&rsp->wakeup_work);
+	if (current != rsp->gp_kthread)
+		irq_work_queue(&rsp->wakeup_work);
 }
 
 /*
-- 
1.8.1.5

