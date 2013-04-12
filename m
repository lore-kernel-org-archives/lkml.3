Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab3DLXcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 19:32:52 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:34774 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab3DLXcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 19:32:47 -0400
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
Date: Fri, 12 Apr 2013 16:32:31 -0700
Message-Id: <1365809557-22575-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1365809557-22575-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130412233211.GA20993@linux.vnet.ibm.com>
 <1365809557-22575-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041223-3620-0000-0000-000002038A09
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
---
 kernel/rcutree.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 8ebc3ff..a57bac3 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1299,6 +1299,9 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
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

