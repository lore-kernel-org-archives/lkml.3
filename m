Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab3ETOih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:38:37 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:51062 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311Ab3ETOib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:38:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/8] rcu: Make __note_new_gpnum() check for ends of prior grace periods
Date: Mon, 20 May 2013 07:38:09 -0700
Message-Id: <1369060695-29679-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369060695-29679-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130520143739.GA29365@linux.vnet.ibm.com>
 <1369060695-29679-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-3620-0000-0000-000002940EFC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The current implementation can detect the beginning of a new grace period
before noting the end of a previous grace period.  Although the current
implementation correctly handles this sort of nonsense, it would be
good to reduce RCU's state space by making such nonsense unnecessary,
which is now possible thanks to the fact that RCU's callback groups are
now numbered.

This commit therefore makes __note_new_gpnum() invoke
__rcu_process_gp_end() in order to note the ends of prior grace
periods before noting the beginnings of new grace periods.
Of course, this now means that note_new_gpnum() notes both the
beginnings and ends of grace periods, and could therefore be
used in place of rcu_process_gp_end().  But that is a job for
later commits.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 9b6df03..46f3062 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1309,6 +1309,9 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
  */
 static void __note_new_gpnum(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
 {
+	/* Handle the ends of any preceding grace periods first. */
+	__rcu_process_gp_end(rsp, rnp, rdp);
+
 	if (rdp->gpnum != rnp->gpnum) {
 		/*
 		 * If the current grace period is waiting for this CPU,
-- 
1.8.1.5

