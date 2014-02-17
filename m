Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbaBQVgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:36:24 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:43190 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbaBQVgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:36:07 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/12] rcu: Remove ACCESS_ONCE() from jiffies
Date: Mon, 17 Feb 2014 13:35:50 -0800
Message-Id: <1392672959-6386-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217213533.GA5387@linux.vnet.ibm.com>
 <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021721-3532-0000-0000-000005BEA0D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Because jiffies is one of a very few variables marked "volatile", there
is no need to use ACCESS_ONCE() when accessing it.  This commit therefore
removes the redundant ACCESS_ONCE() wrappers.

Reported by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/torture.c | 4 ++--
 kernel/rcu/tree.c    | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/rcu/torture.c b/kernel/rcu/torture.c
index ab7dd192a50b..022c5312b725 100644
--- a/kernel/rcu/torture.c
+++ b/kernel/rcu/torture.c
@@ -1352,7 +1352,7 @@ rcu_torture_shutdown(void *arg)
 	unsigned long jiffies_snap;
 
 	VERBOSE_PRINTK_STRING("rcu_torture_shutdown task started");
-	jiffies_snap = ACCESS_ONCE(jiffies);
+	jiffies_snap = jiffies;
 	while (ULONG_CMP_LT(jiffies_snap, shutdown_time) &&
 	       !kthread_should_stop()) {
 		delta = shutdown_time - jiffies_snap;
@@ -1361,7 +1361,7 @@ rcu_torture_shutdown(void *arg)
 				 "rcu_torture_shutdown task: %lu jiffies remaining\n",
 				 torture_type, delta);
 		schedule_timeout_interruptible(delta);
-		jiffies_snap = ACCESS_ONCE(jiffies);
+		jiffies_snap = jiffies;
 	}
 	if (kthread_should_stop()) {
 		VERBOSE_PRINTK_STRING("rcu_torture_shutdown task stopping");
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 321feef0f5c0..73c3cd2b87ac 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -837,7 +837,7 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
 	 * to the next.  Only do this for the primary flavor of RCU.
 	 */
 	if (rdp->rsp == rcu_state &&
-	    ULONG_CMP_GE(ACCESS_ONCE(jiffies), rdp->rsp->jiffies_resched)) {
+	    ULONG_CMP_GE(jiffies, rdp->rsp->jiffies_resched)) {
 		rdp->rsp->jiffies_resched += 5;
 		resched_cpu(rdp->cpu);
 	}
@@ -847,7 +847,7 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
 
 static void record_gp_stall_check_time(struct rcu_state *rsp)
 {
-	unsigned long j = ACCESS_ONCE(jiffies);
+	unsigned long j = jiffies;
 	unsigned long j1;
 
 	rsp->gp_start = j;
@@ -1005,7 +1005,7 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	if (rcu_cpu_stall_suppress || !rcu_gp_in_progress(rsp))
 		return;
-	j = ACCESS_ONCE(jiffies);
+	j = jiffies;
 
 	/*
 	 * Lots of memory barriers to reject false positives.
-- 
1.8.1.5

