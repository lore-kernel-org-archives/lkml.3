Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab3ETOis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:38:48 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:51189 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003Ab3ETOin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:38:43 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 6/8] rcu: Eliminate check_for_new_grace_period() wrapper function
Date: Mon, 20 May 2013 07:38:13 -0700
Message-Id: <1369060695-29679-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369060695-29679-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130520143739.GA29365@linux.vnet.ibm.com>
 <1369060695-29679-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-3620-0000-0000-000002940F12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

One of the calls to check_for_new_grace_period() is now redundant due to
an immediately preceding call to note_gp_changes().  Eliminating this
redundant call leaves a single caller, which is simpler if inlined.
This commit therefore eliminates the redundant call and inlines the
body of check_for_new_grace_period() into the single remaining call site.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c | 25 +++----------------------
 1 file changed, 3 insertions(+), 22 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 26befd0..60ff232 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1308,26 +1308,6 @@ static void note_gp_changes(struct rcu_state *rsp, struct rcu_data *rdp)
 }
 
 /*
- * Did someone else start a new RCU grace period start since we last
- * checked?  Update local state appropriately if so.  Must be called
- * on the CPU corresponding to rdp.
- */
-static int
-check_for_new_grace_period(struct rcu_state *rsp, struct rcu_data *rdp)
-{
-	unsigned long flags;
-	int ret = 0;
-
-	local_irq_save(flags);
-	if (rdp->gpnum != rsp->gpnum) {
-		note_gp_changes(rsp, rdp);
-		ret = 1;
-	}
-	local_irq_restore(flags);
-	return ret;
-}
-
-/*
  * Do per-CPU grace-period initialization for running CPU.  The caller
  * must hold the lock of the leaf rcu_node structure corresponding to
  * this CPU.
@@ -1737,8 +1717,10 @@ static void
 rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	/* If there is now a new grace period, record and return. */
-	if (check_for_new_grace_period(rsp, rdp))
+	if (rdp->gpnum != rsp->gpnum) {
+		note_gp_changes(rsp, rdp);
 		return;
+	}
 
 	/*
 	 * Does this CPU still need to do its part for current grace period?
@@ -2290,7 +2272,6 @@ static void __call_rcu_core(struct rcu_state *rsp, struct rcu_data *rdp,
 
 		/* Are we ignoring a completed grace period? */
 		note_gp_changes(rsp, rdp);
-		check_for_new_grace_period(rsp, rdp);
 
 		/* Start a new grace period if one not already started. */
 		if (!rcu_gp_in_progress(rsp)) {
-- 
1.8.1.5

