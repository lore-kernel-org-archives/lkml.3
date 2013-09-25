Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab3IYBnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:43:00 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36926 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757744Ab3IYBmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:42:55 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/10] rcu: Prevent spurious-wakeup DoS attack on rcu_gp_kthread()
Date: Tue, 24 Sep 2013 18:42:31 -0700
Message-Id: <1380073359-31959-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380073359-31959-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925014210.GA31690@linux.vnet.ibm.com>
 <1380073359-31959-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-0928-0000-0000-000001DB9FEF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Spurious wakeups in the force-quiescent-state loop in rcu_gp_kthread()
cause the timeout to be recalculated, which would prevent rcu_gp_fqs()
from ever being called.  This would in turn would prevent the grace period
from ever ending for as long as there was at least one CPU in an extended
quiescent state that had not yet passed through a quiescent state.

This commit therefore avoids recalculating the timeout unless the
previous pass's call to wait_event_interruptible_timeout() actually
did time out, thus preventing the above scenario.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d679a52..62b67b7 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1470,6 +1470,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 static int __noreturn rcu_gp_kthread(void *arg)
 {
 	int fqs_state;
+	int gf;
 	unsigned long j;
 	int ret;
 	struct rcu_state *rsp = arg;
@@ -1495,10 +1496,13 @@ static int __noreturn rcu_gp_kthread(void *arg)
 			j = HZ;
 			jiffies_till_first_fqs = HZ;
 		}
+		ret = 0;
 		for (;;) {
-			rsp->jiffies_force_qs = jiffies + j;
+			if (!ret)
+				rsp->jiffies_force_qs = jiffies + j;
 			ret = wait_event_interruptible_timeout(rsp->gp_wq,
-					(rsp->gp_flags & RCU_GP_FLAG_FQS) ||
+					((gf = ACCESS_ONCE(rsp->gp_flags)) &
+					 RCU_GP_FLAG_FQS) ||
 					(!ACCESS_ONCE(rnp->qsmask) &&
 					 !rcu_preempt_blocked_readers_cgp(rnp)),
 					j);
@@ -1507,7 +1511,8 @@ static int __noreturn rcu_gp_kthread(void *arg)
 			    !rcu_preempt_blocked_readers_cgp(rnp))
 				break;
 			/* If time for quiescent-state forcing, do it. */
-			if (ret == 0 || (rsp->gp_flags & RCU_GP_FLAG_FQS)) {
+			if (ULONG_CMP_GE(jiffies, rsp->jiffies_force_qs) ||
+			    (gf & RCU_GP_FLAG_FQS)) {
 				fqs_state = rcu_gp_fqs(rsp, fqs_state);
 				cond_resched();
 			} else {
-- 
1.8.1.5

