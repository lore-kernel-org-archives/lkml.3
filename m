Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab3ETOiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:38:52 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:51188 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001Ab3ETOim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:38:42 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 7/8] rcu: Inline trivial wrapper function rcu_start_gp_per_cpu()
Date: Mon, 20 May 2013 07:38:14 -0700
Message-Id: <1369060695-29679-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369060695-29679-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130520143739.GA29365@linux.vnet.ibm.com>
 <1369060695-29679-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-3620-0000-0000-000002940F17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Given the changes that introduce note_gp_change(), rcu_start_gp_per_cpu()
is now a trivial wrapper function with only one caller.  This commit
therefore inlines it into its sole call site.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 60ff232..14fa927 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1308,18 +1308,6 @@ static void note_gp_changes(struct rcu_state *rsp, struct rcu_data *rdp)
 }
 
 /*
- * Do per-CPU grace-period initialization for running CPU.  The caller
- * must hold the lock of the leaf rcu_node structure corresponding to
- * this CPU.
- */
-static void
-rcu_start_gp_per_cpu(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
-{
-	/* Set state so that this CPU will detect the next quiescent state. */
-	__note_gp_changes(rsp, rnp, rdp);
-}
-
-/*
  * Initialize a new grace period.
  */
 static int rcu_gp_init(struct rcu_state *rsp)
@@ -1367,7 +1355,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 		WARN_ON_ONCE(rnp->completed != rsp->completed);
 		ACCESS_ONCE(rnp->completed) = rsp->completed;
 		if (rnp == rdp->mynode)
-			rcu_start_gp_per_cpu(rsp, rnp, rdp);
+			__note_gp_changes(rsp, rnp, rdp);
 		rcu_preempt_boost_start_gp(rnp);
 		trace_rcu_grace_period_init(rsp->name, rnp->gpnum,
 					    rnp->level, rnp->grplo,
-- 
1.8.1.5

