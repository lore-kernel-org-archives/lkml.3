Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaH1SlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:41:19 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:57261 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbaH1Sig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:38:36 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 12/14] rcu: Avoid misordering in __call_rcu_nocb_enqueue()
Date: Thu, 28 Aug 2014 11:38:15 -0700
Message-Id: <1409251097-26734-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409251097-26734-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828183754.GA25488@linux.vnet.ibm.com>
 <1409251097-26734-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-1344-0000-0000-000003CA8678
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The NOCB leader wakeup ordering depends on the store to the header
happening before the check for the leader already being awake.  However,
because atomic_long_add() does not return a value, it does not provide
ordering guarantees, the incorrect comment in wake_nocb_leader()
notwithstanding.  This commit therefore adds a smp_mb__after_atomic()
after the final atomic_long_add() to provide the needed ordering
guarantee.

Reported-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree_plugin.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index a63b54e0e617..304f42c6543b 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2042,7 +2042,7 @@ static void wake_nocb_leader(struct rcu_data *rdp, bool force)
 	if (!ACCESS_ONCE(rdp_leader->nocb_kthread))
 		return;
 	if (!ACCESS_ONCE(rdp_leader->nocb_leader_wake) || force) {
-		/* Prior xchg orders against prior callback enqueue. */
+		/* Prior smp_mb__after_atomic() orders against prior enqueue. */
 		ACCESS_ONCE(rdp_leader->nocb_leader_wake) = true;
 		wake_up(&rdp_leader->nocb_wq);
 	}
@@ -2071,6 +2071,7 @@ static void __call_rcu_nocb_enqueue(struct rcu_data *rdp,
 	ACCESS_ONCE(*old_rhpp) = rhp;
 	atomic_long_add(rhcount, &rdp->nocb_q_count);
 	atomic_long_add(rhcount_lazy, &rdp->nocb_q_count_lazy);
+	smp_mb__after_atomic(); /* Store *old_rhpp before _wake test. */
 
 	/* If we are not being polled and there is a kthread, awaken it ... */
 	t = ACCESS_ONCE(rdp->nocb_kthread);
-- 
1.8.1.5

