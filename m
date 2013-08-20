Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab3HTCuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:50:00 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:51991 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3HTCrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:47:32 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 7/9] nohz_full: Add full-system-idle arguments to API
Date: Mon, 19 Aug 2013 19:47:19 -0700
Message-Id: <1376966841-31774-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376966841-31774-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130820024700.GA31075@linux.vnet.ibm.com>
 <1376966841-31774-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082002-7606-0000-0000-00000E75E1D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds an isidle and jiffies argument to force_qs_rnp(),
dyntick_save_progress_counter(), and rcu_implicit_dynticks_qs() to enable
RCU's force-quiescent-state process to check for full-system idle.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
[ paulmck: Use true and false for boolean constants per Lai Jiangshan. ]
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index b0d2cc3..7b5be56 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -246,7 +246,10 @@ module_param(jiffies_till_next_fqs, ulong, 0644);
 
 static void rcu_start_gp_advanced(struct rcu_state *rsp, struct rcu_node *rnp,
 				  struct rcu_data *rdp);
-static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *));
+static void force_qs_rnp(struct rcu_state *rsp,
+			 int (*f)(struct rcu_data *rsp, bool *isidle,
+				  unsigned long *maxj),
+			 bool *isidle, unsigned long *maxj);
 static void force_quiescent_state(struct rcu_state *rsp);
 static int rcu_pending(int cpu);
 
@@ -727,7 +730,8 @@ static int rcu_is_cpu_rrupt_from_idle(void)
  * credit them with an implicit quiescent state.  Return 1 if this CPU
  * is in dynticks idle mode, which is an extended quiescent state.
  */
-static int dyntick_save_progress_counter(struct rcu_data *rdp)
+static int dyntick_save_progress_counter(struct rcu_data *rdp,
+					 bool *isidle, unsigned long *maxj)
 {
 	rdp->dynticks_snap = atomic_add_return(0, &rdp->dynticks->dynticks);
 	return (rdp->dynticks_snap & 0x1) == 0;
@@ -739,7 +743,8 @@ static int dyntick_save_progress_counter(struct rcu_data *rdp)
  * idle state since the last call to dyntick_save_progress_counter()
  * for this same CPU, or by virtue of having been offline.
  */
-static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
+static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
+				    bool *isidle, unsigned long *maxj)
 {
 	unsigned int curr;
 	unsigned int snap;
@@ -1361,16 +1366,19 @@ static int rcu_gp_init(struct rcu_state *rsp)
 int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 {
 	int fqs_state = fqs_state_in;
+	bool isidle = false;
+	unsigned long maxj;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	rsp->n_force_qs++;
 	if (fqs_state == RCU_SAVE_DYNTICK) {
 		/* Collect dyntick-idle snapshots. */
-		force_qs_rnp(rsp, dyntick_save_progress_counter);
+		force_qs_rnp(rsp, dyntick_save_progress_counter,
+			     &isidle, &maxj);
 		fqs_state = RCU_FORCE_QS;
 	} else {
 		/* Handle dyntick-idle and offline CPUs. */
-		force_qs_rnp(rsp, rcu_implicit_dynticks_qs);
+		force_qs_rnp(rsp, rcu_implicit_dynticks_qs, &isidle, &maxj);
 	}
 	/* Clear flag to prevent immediate re-entry. */
 	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
@@ -2069,7 +2077,10 @@ void rcu_check_callbacks(int cpu, int user)
  *
  * The caller must have suppressed start of new grace periods.
  */
-static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
+static void force_qs_rnp(struct rcu_state *rsp,
+			 int (*f)(struct rcu_data *rsp, bool *isidle,
+				  unsigned long *maxj),
+			 bool *isidle, unsigned long *maxj)
 {
 	unsigned long bit;
 	int cpu;
@@ -2093,7 +2104,7 @@ static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 		bit = 1;
 		for (; cpu <= rnp->grphi; cpu++, bit <<= 1) {
 			if ((rnp->qsmask & bit) != 0 &&
-			    f(per_cpu_ptr(rsp->rda, cpu)))
+			    f(per_cpu_ptr(rsp->rda, cpu), isidle, maxj))
 				mask |= bit;
 		}
 		if (mask != 0) {
-- 
1.8.1.5

