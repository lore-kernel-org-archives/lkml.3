Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab3ETOjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:39:03 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42020 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757015Ab3ETOi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:38:59 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 8/8] rcu: Move redundant call to note_gp_changes() into called function
Date: Mon, 20 May 2013 07:38:15 -0700
Message-Id: <1369060695-29679-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369060695-29679-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130520143739.GA29365@linux.vnet.ibm.com>
 <1369060695-29679-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-5806-0000-0000-000021399369
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The __rcu_process_callbacks() invokes note_gp_changes() immediately
before invoking rcu_check_quiescent_state(), which conditionally
invokes that same function.  This commit therefore eliminates the
call to note_gp_changes() in __rcu_process_callbacks() in favor of
making unconditional to call from rcu_check_quiescent_state() to
note_gp_changes().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 14fa927..34db855 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1704,11 +1704,8 @@ rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp)
 static void
 rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
 {
-	/* If there is now a new grace period, record and return. */
-	if (rdp->gpnum != rsp->gpnum) {
-		note_gp_changes(rsp, rdp);
-		return;
-	}
+	/* Check for grace-period ends and beginnings. */
+	note_gp_changes(rsp, rdp);
 
 	/*
 	 * Does this CPU still need to do its part for current grace period?
@@ -2172,9 +2169,6 @@ __rcu_process_callbacks(struct rcu_state *rsp)
 
 	WARN_ON_ONCE(rdp->beenonline == 0);
 
-	/* Handle the end of a grace period that some other CPU ended.  */
-	note_gp_changes(rsp, rdp);
-
 	/* Update RCU state based on any recent quiescent states. */
 	rcu_check_quiescent_state(rsp, rdp);
 
-- 
1.8.1.5

