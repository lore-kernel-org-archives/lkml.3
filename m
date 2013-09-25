Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810Ab3IYBnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:43:05 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:41757 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757695Ab3IYBmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:42:55 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 01/10] rcu: Improve grace-period start logic
Date: Tue, 24 Sep 2013 18:42:30 -0700
Message-Id: <1380073359-31959-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20130925014210.GA31690@linux.vnet.ibm.com>
References: <20130925014210.GA31690@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-0320-0000-0000-0000011DA9AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit improves grace-period start logic by checking ->gp_flags
under the lock and by issuing a warning if a grace period is already
in progress.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 32618b3..d679a52 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1297,7 +1297,7 @@ static void note_gp_changes(struct rcu_state *rsp, struct rcu_data *rdp)
 }
 
 /*
- * Initialize a new grace period.
+ * Initialize a new grace period.  Return 0 if no grace period required.
  */
 static int rcu_gp_init(struct rcu_state *rsp)
 {
@@ -1306,10 +1306,18 @@ static int rcu_gp_init(struct rcu_state *rsp)
 
 	rcu_bind_gp_kthread();
 	raw_spin_lock_irq(&rnp->lock);
+	if (rsp->gp_flags == 0) {
+		/* Spurious wakeup, tell caller to go back to sleep.  */
+		raw_spin_unlock_irq(&rnp->lock);
+		return 0;
+	}
 	rsp->gp_flags = 0; /* Clear all flags: New grace period. */
 
-	if (rcu_gp_in_progress(rsp)) {
-		/* Grace period already in progress, don't start another.  */
+	if (WARN_ON_ONCE(rcu_gp_in_progress(rsp))) {
+		/*
+		 * Grace period already in progress, don't start another.
+		 * Not supposed to be able to happen.
+		 */
 		raw_spin_unlock_irq(&rnp->lock);
 		return 0;
 	}
@@ -1474,8 +1482,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
 			wait_event_interruptible(rsp->gp_wq,
 						 rsp->gp_flags &
 						 RCU_GP_FLAG_INIT);
-			if ((rsp->gp_flags & RCU_GP_FLAG_INIT) &&
-			    rcu_gp_init(rsp))
+			if (rcu_gp_init(rsp))
 				break;
 			cond_resched();
 			flush_signals(current);
-- 
1.8.1.5

