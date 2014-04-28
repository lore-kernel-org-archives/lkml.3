Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbaD2ABV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:01:21 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56570 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbaD1X4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:56:43 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Iulia Manda <iulia.manda21@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/19] rcu: Protect uses of jiffies_stall field with ACCESS_ONCE()
Date: Mon, 28 Apr 2014 16:56:19 -0700
Message-Id: <1398729392-15087-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140428235600.GA12200@linux.vnet.ibm.com>
 <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042823-0928-0000-0000-000001808037
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Iulia Manda <iulia.manda21@gmail.com>

Some of the uses of the rcu_state structure's ->jiffies_stall field
do not use ACCESS_ONCE(), despite there being unprotected accesses.
This commit therefore uses the ACCESS_ONCE() macro to protect this field.

Signed-off-by: Iulia Manda <iulia.manda21@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 2cc39c781085..c624415f8386 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -865,7 +865,7 @@ static void record_gp_stall_check_time(struct rcu_state *rsp)
 	rsp->gp_start = j;
 	smp_wmb(); /* Record start time before stall time. */
 	j1 = rcu_jiffies_till_stall_check();
-	rsp->jiffies_stall = j + j1;
+	ACCESS_ONCE(rsp->jiffies_stall) = j + j1;
 	rsp->jiffies_resched = j + j1 / 2;
 }
 
@@ -904,12 +904,12 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	/* Only let one CPU complain about others per time interval. */
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	delta = jiffies - rsp->jiffies_stall;
+	delta = jiffies - ACCESS_ONCE(rsp->jiffies_stall);
 	if (delta < RCU_STALL_RAT_DELAY || !rcu_gp_in_progress(rsp)) {
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
-	rsp->jiffies_stall = jiffies + 3 * rcu_jiffies_till_stall_check() + 3;
+	ACCESS_ONCE(rsp->jiffies_stall) = jiffies + 3 * rcu_jiffies_till_stall_check() + 3;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	/*
@@ -992,8 +992,8 @@ static void print_cpu_stall(struct rcu_state *rsp)
 		dump_stack();
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	if (ULONG_CMP_GE(jiffies, rsp->jiffies_stall))
-		rsp->jiffies_stall = jiffies +
+	if (ULONG_CMP_GE(jiffies, ACCESS_ONCE(rsp->jiffies_stall)))
+		ACCESS_ONCE(rsp->jiffies_stall) = jiffies +
 				     3 * rcu_jiffies_till_stall_check() + 3;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
@@ -1077,7 +1077,7 @@ void rcu_cpu_stall_reset(void)
 	struct rcu_state *rsp;
 
 	for_each_rcu_flavor(rsp)
-		rsp->jiffies_stall = jiffies + ULONG_MAX / 2;
+		ACCESS_ONCE(rsp->jiffies_stall) = jiffies + ULONG_MAX / 2;
 }
 
 /*
-- 
1.8.1.5

