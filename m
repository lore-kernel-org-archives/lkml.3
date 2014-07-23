Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbaGWQaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:30:00 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:53294 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518AbaGWQ37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:29:59 -0400
Date: Wed, 23 Jul 2014 09:29:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: [PATCH RFC tip/core/rcu 2/2] Don't track sysidle state if no
 nohz_full= CPUs
Message-ID: <20140723162951.GA17743@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140723162851.GA17665@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723162851.GA17665@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072316-0928-0000-0000-0000039CF892
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there are no nohz_full= CPUs, then there is currently no reason to
track sysidle state.  This commit therefore short-circuits this state
tracking if !tick_nohz_full_enabled().

Note that these checks will need to be revisited if nohz_full= state
can ever be changed at runtime.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index e31fa71c4d3a..c31eb28ae8bb 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2679,6 +2679,10 @@ static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq)
 {
 	unsigned long j;
 
+	/* If there are no nohz_full= CPUs, no need to track this. */
+	if (!tick_nohz_full_enabled())
+		return;
+
 	/* Adjust nesting, check for fully idle. */
 	if (irq) {
 		rdtp->dynticks_idle_nesting--;
@@ -2744,6 +2748,10 @@ void rcu_sysidle_force_exit(void)
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
@@ -2798,6 +2806,10 @@ static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
 	unsigned long j;
 	struct rcu_dynticks *rdtp = rdp->dynticks;
 
+	/* If there are no nohz_full= CPUs, don't check system-wide idleness. */
+	if (!tick_nohz_full_enabled())
+		return;
+
 	/*
 	 * If some other CPU has already reported non-idle, if this is
 	 * not the flavor of RCU that tracks sysidle state, or if this
@@ -2924,6 +2936,10 @@ static void rcu_sysidle_report(struct rcu_state *rsp, int isidle,
 static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
 				  unsigned long maxj)
 {
+	/* If there are no nohz_full= CPUs, no need to track this. */
+	if (!tick_nohz_full_enabled())
+		return;
+
 	rcu_sysidle_report(rsp, isidle, maxj, true);
 }
 
@@ -2950,7 +2966,8 @@ static void rcu_sysidle_cb(struct rcu_head *rhp)
 
 /*
  * Check to see if the system is fully idle, other than the timekeeping CPU.
- * The caller must have disabled interrupts.
+ * The caller must have disabled interrupts.  This is not intended to be
+ * called unless tick_nohz_full_enabled().
  */
 bool rcu_sys_is_idle(void)
 {

