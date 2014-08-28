Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaH1Sk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:40:28 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43115 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbaH1Sii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:38:38 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 11/14] rcu: Don't track sysidle state if no nohz_full= CPUs
Date: Thu, 28 Aug 2014 11:38:14 -0700
Message-Id: <1409251097-26734-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409251097-26734-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828183754.GA25488@linux.vnet.ibm.com>
 <1409251097-26734-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-6688-0000-0000-0000045B6A53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

If there are no nohz_full= CPUs, then there is currently no reason to
track sysidle state.  This commit therefore short-circuits this state
tracking if !tick_nohz_full_enabled().

Note that these checks will need to be revisited if nohz_full= state
can ever be changed at runtime.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/rcu/tree_plugin.h | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 010f63ee6ee8..a63b54e0e617 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2707,6 +2707,10 @@ static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq)
 {
 	unsigned long j;
 
+	/* If there are no nohz_full= CPUs, no need to track this. */
+	if (!tick_nohz_full_enabled())
+		return;
+
 	/* Adjust nesting, check for fully idle. */
 	if (irq) {
 		rdtp->dynticks_idle_nesting--;
@@ -2772,6 +2776,10 @@ void rcu_sysidle_force_exit(void)
  */
 static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
 {
+	/* If there are no nohz_full= CPUs, no need to track this. */
+	if (!tick_nohz_full_enabled())
+		return;
+
 	/* Adjust nesting, check for already non-idle. */
 	if (irq) {
 		rdtp->dynticks_idle_nesting++;
@@ -2826,6 +2834,10 @@ static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
 	unsigned long j;
 	struct rcu_dynticks *rdtp = rdp->dynticks;
 
+	/* If there are no nohz_full= CPUs, don't check system-wide idleness. */
+	if (!tick_nohz_full_enabled())
+		return;
+
 	/*
 	 * If some other CPU has already reported non-idle, if this is
 	 * not the flavor of RCU that tracks sysidle state, or if this
@@ -2952,6 +2964,10 @@ static void rcu_sysidle_report(struct rcu_state *rsp, int isidle,
 static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
 				  unsigned long maxj)
 {
+	/* If there are no nohz_full= CPUs, no need to track this. */
+	if (!tick_nohz_full_enabled())
+		return;
+
 	rcu_sysidle_report(rsp, isidle, maxj, true);
 }
 
@@ -2978,7 +2994,8 @@ static void rcu_sysidle_cb(struct rcu_head *rhp)
 
 /*
  * Check to see if the system is fully idle, other than the timekeeping CPU.
- * The caller must have disabled interrupts.
+ * The caller must have disabled interrupts.  This is not intended to be
+ * called unless tick_nohz_full_enabled().
  */
 bool rcu_sys_is_idle(void)
 {
-- 
1.8.1.5

