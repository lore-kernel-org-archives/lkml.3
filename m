Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326AbaD2A15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:27:57 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52051 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933120AbaD2AZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:52 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 36/45] rcutorture:  Add tests for get_state_synchronize_rcu()
Date: Mon, 28 Apr 2014 17:25:24 -0700
Message-Id: <1398731133-18925-36-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-8236-0000-0000-000001E64AA3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds rcutorture testing for get_state_synchronize_rcu()
and cond_synchronize_rcu().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/rcutorture.c | 130 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 95 insertions(+), 35 deletions(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index cf231f508139..9f344ec32e69 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -58,6 +58,7 @@ torture_param(int, fqs_duration, 0,
 	      "Duration of fqs bursts (us), 0 to disable");
 torture_param(int, fqs_holdoff, 0, "Holdoff time within fqs bursts (us)");
 torture_param(int, fqs_stutter, 3, "Wait time between fqs bursts (s)");
+torture_param(bool, gp_cond, false, "Use conditional/async GP wait primitives");
 torture_param(bool, gp_exp, false, "Use expedited GP wait primitives");
 torture_param(bool, gp_normal, false,
 	     "Use normal (non-expedited) GP wait primitives");
@@ -144,8 +145,10 @@ static int rcu_torture_writer_state;
 #define RTWS_REPLACE		2
 #define RTWS_DEF_FREE		3
 #define RTWS_EXP_SYNC		4
-#define RTWS_STUTTER		5
-#define RTWS_STOPPING		6
+#define RTWS_COND_GET		5
+#define RTWS_COND_SYNC		6
+#define RTWS_STUTTER		7
+#define RTWS_STOPPING		8
 
 #if defined(MODULE) || defined(CONFIG_RCU_TORTURE_TEST_RUNNABLE)
 #define RCUTORTURE_RUNNABLE_INIT 1
@@ -232,6 +235,8 @@ struct rcu_torture_ops {
 	void (*deferred_free)(struct rcu_torture *p);
 	void (*sync)(void);
 	void (*exp_sync)(void);
+	unsigned long (*get_state)(void);
+	void (*cond_sync)(unsigned long oldstate);
 	void (*call)(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
 	void (*cb_barrier)(void);
 	void (*fqs)(void);
@@ -283,10 +288,48 @@ static int rcu_torture_completed(void)
 	return rcu_batches_completed();
 }
 
+/*
+ * Update callback in the pipe.  This should be invoked after a grace period.
+ */
+static bool
+rcu_torture_pipe_update_one(struct rcu_torture *rp)
+{
+	int i;
+
+	i = rp->rtort_pipe_count;
+	if (i > RCU_TORTURE_PIPE_LEN)
+		i = RCU_TORTURE_PIPE_LEN;
+	atomic_inc(&rcu_torture_wcount[i]);
+	if (++rp->rtort_pipe_count >= RCU_TORTURE_PIPE_LEN) {
+		rp->rtort_mbtest = 0;
+		return true;
+	}
+	return false;
+}
+
+/*
+ * Update all callbacks in the pipe.  Suitable for synchronous grace-period
+ * primitives.
+ */
+static void
+rcu_torture_pipe_update(struct rcu_torture *old_rp)
+{
+	struct rcu_torture *rp;
+	struct rcu_torture *rp1;
+
+	if (old_rp)
+		list_add(&old_rp->rtort_free, &rcu_torture_removed);
+	list_for_each_entry_safe(rp, rp1, &rcu_torture_removed, rtort_free) {
+		if (rcu_torture_pipe_update_one(rp)) {
+			list_del(&rp->rtort_free);
+			rcu_torture_free(rp);
+		}
+	}
+}
+
 static void
 rcu_torture_cb(struct rcu_head *p)
 {
-	int i;
 	struct rcu_torture *rp = container_of(p, struct rcu_torture, rtort_rcu);
 
 	if (torture_must_stop_irq()) {
@@ -294,16 +337,10 @@ rcu_torture_cb(struct rcu_head *p)
 		/* The next initialization will pick up the pieces. */
 		return;
 	}
-	i = rp->rtort_pipe_count;
-	if (i > RCU_TORTURE_PIPE_LEN)
-		i = RCU_TORTURE_PIPE_LEN;
-	atomic_inc(&rcu_torture_wcount[i]);
-	if (++rp->rtort_pipe_count >= RCU_TORTURE_PIPE_LEN) {
-		rp->rtort_mbtest = 0;
+	if (rcu_torture_pipe_update_one(rp))
 		rcu_torture_free(rp);
-	} else {
+	else
 		cur_ops->deferred_free(rp);
-	}
 }
 
 static int rcu_no_completed(void)
@@ -331,6 +368,8 @@ static struct rcu_torture_ops rcu_ops = {
 	.deferred_free	= rcu_torture_deferred_free,
 	.sync		= synchronize_rcu,
 	.exp_sync	= synchronize_rcu_expedited,
+	.get_state	= get_state_synchronize_rcu,
+	.cond_sync	= cond_synchronize_rcu,
 	.call		= call_rcu,
 	.cb_barrier	= rcu_barrier,
 	.fqs		= rcu_force_quiescent_state,
@@ -704,16 +743,39 @@ rcu_torture_fqs(void *arg)
 static int
 rcu_torture_writer(void *arg)
 {
-	bool exp;
+	unsigned long gp_snap;
+	bool gp_cond1 = gp_cond, gp_exp1 = gp_exp, gp_normal1 = gp_normal;
 	int i;
 	struct rcu_torture *rp;
-	struct rcu_torture *rp1;
 	struct rcu_torture *old_rp;
 	static DEFINE_TORTURE_RANDOM(rand);
+	int synctype[] = { RTWS_DEF_FREE, RTWS_EXP_SYNC, RTWS_COND_GET };
+	int nsynctypes = 0;
 
 	VERBOSE_TOROUT_STRING("rcu_torture_writer task started");
 	set_user_nice(current, MAX_NICE);
 
+	/* Initialize synctype[] array.  If none set, take default. */
+	if (!gp_cond1 && !gp_exp1 && !gp_normal1)
+		gp_cond1 = gp_exp1 = gp_normal1 = true;
+	if (gp_cond1 && cur_ops->get_state && cur_ops->cond_sync)
+		synctype[nsynctypes++] = RTWS_COND_GET;
+	else if (gp_cond && (!cur_ops->get_state || !cur_ops->cond_sync))
+		pr_alert("rcu_torture_writer: gp_cond without primitives.\n");
+	if (gp_exp1 && cur_ops->exp_sync)
+		synctype[nsynctypes++] = RTWS_EXP_SYNC;
+	else if (gp_exp && !cur_ops->exp_sync)
+		pr_alert("rcu_torture_writer: gp_exp without primitives.\n");
+	if (gp_normal1 && cur_ops->deferred_free)
+		synctype[nsynctypes++] = RTWS_DEF_FREE;
+	else if (gp_normal && !cur_ops->deferred_free)
+		pr_alert("rcu_torture_writer: gp_normal without primitives.\n");
+	if (WARN_ONCE(nsynctypes == 0,
+		      "rcu_torture_writer: No update-side primitives.\n")) {
+		rcu_torture_writer_state = RTWS_STOPPING;
+		torture_kthread_stopping("rcu_torture_writer");
+	}
+
 	do {
 		rcu_torture_writer_state = RTWS_FIXED_DELAY;
 		schedule_timeout_uninterruptible(1);
@@ -735,32 +797,30 @@ rcu_torture_writer(void *arg)
 				i = RCU_TORTURE_PIPE_LEN;
 			atomic_inc(&rcu_torture_wcount[i]);
 			old_rp->rtort_pipe_count++;
-			if (gp_normal == gp_exp)
-				exp = !!(torture_random(&rand) & 0x80);
-			else
-				exp = gp_exp;
-			if (!exp) {
+			switch (synctype[torture_random(&rand) % nsynctypes]) {
+			case RTWS_DEF_FREE:
 				rcu_torture_writer_state = RTWS_DEF_FREE;
 				cur_ops->deferred_free(old_rp);
-			} else {
+				break;
+			case RTWS_EXP_SYNC:
 				rcu_torture_writer_state = RTWS_EXP_SYNC;
 				cur_ops->exp_sync();
-				list_add(&old_rp->rtort_free,
-					 &rcu_torture_removed);
-				list_for_each_entry_safe(rp, rp1,
-							 &rcu_torture_removed,
-							 rtort_free) {
-					i = rp->rtort_pipe_count;
-					if (i > RCU_TORTURE_PIPE_LEN)
-						i = RCU_TORTURE_PIPE_LEN;
-					atomic_inc(&rcu_torture_wcount[i]);
-					if (++rp->rtort_pipe_count >=
-					    RCU_TORTURE_PIPE_LEN) {
-						rp->rtort_mbtest = 0;
-						list_del(&rp->rtort_free);
-						rcu_torture_free(rp);
-					}
-				 }
+				rcu_torture_pipe_update(old_rp);
+				break;
+			case RTWS_COND_GET:
+				rcu_torture_writer_state = RTWS_COND_GET;
+				gp_snap = cur_ops->get_state();
+				i = torture_random(&rand) % 16;
+				if (i != 0)
+					schedule_timeout_interruptible(i);
+				udelay(torture_random(&rand) % 1000);
+				rcu_torture_writer_state = RTWS_COND_SYNC;
+				cur_ops->cond_sync(gp_snap);
+				rcu_torture_pipe_update(old_rp);
+				break;
+			default:
+				WARN_ON_ONCE(1);
+				break;
 			}
 		}
 		rcutorture_record_progress(++rcu_torture_current_version);
-- 
1.8.1.5

