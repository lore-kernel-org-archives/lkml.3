Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507AbaD2Aaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:30:52 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59717 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933081AbaD2AZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:50 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 37/45] rcutorture: Explicitly test synchronous grace-period primitives
Date: Mon, 28 Apr 2014 17:25:25 -0700
Message-Id: <1398731133-18925-37-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-0928-0000-0000-0000018D138C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The original rcu_torture_writer() avoided testing the synchronous
grace-period primitives because they were simply wrappers around
call_rcu() invocations.  The testing of these synchronous primitives
was delegated to the fake writers.  However, there really is no excuse
not to test them, especially in the case of SRCU, where the wrappering
is somewhat more elaborate.  This commit therefore makes the default
rcutorture parameters cause rcu_torture_writer() to include synchronous
grace-period primitives in its testing.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/rcutorture.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 9f344ec32e69..576d12263c81 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -62,6 +62,7 @@ torture_param(bool, gp_cond, false, "Use conditional/async GP wait primitives");
 torture_param(bool, gp_exp, false, "Use expedited GP wait primitives");
 torture_param(bool, gp_normal, false,
 	     "Use normal (non-expedited) GP wait primitives");
+torture_param(bool, gp_sync, false, "Use synchronous GP wait primitives");
 torture_param(int, irqreader, 1, "Allow RCU readers from irq handlers");
 torture_param(int, n_barrier_cbs, 0,
 	     "# of callbacks/kthreads for barrier testing");
@@ -147,8 +148,9 @@ static int rcu_torture_writer_state;
 #define RTWS_EXP_SYNC		4
 #define RTWS_COND_GET		5
 #define RTWS_COND_SYNC		6
-#define RTWS_STUTTER		7
-#define RTWS_STOPPING		8
+#define RTWS_SYNC		7
+#define RTWS_STUTTER		8
+#define RTWS_STOPPING		9
 
 #if defined(MODULE) || defined(CONFIG_RCU_TORTURE_TEST_RUNNABLE)
 #define RCUTORTURE_RUNNABLE_INIT 1
@@ -745,19 +747,21 @@ rcu_torture_writer(void *arg)
 {
 	unsigned long gp_snap;
 	bool gp_cond1 = gp_cond, gp_exp1 = gp_exp, gp_normal1 = gp_normal;
+	bool gp_sync1 = gp_sync;
 	int i;
 	struct rcu_torture *rp;
 	struct rcu_torture *old_rp;
 	static DEFINE_TORTURE_RANDOM(rand);
-	int synctype[] = { RTWS_DEF_FREE, RTWS_EXP_SYNC, RTWS_COND_GET };
+	int synctype[] = { RTWS_DEF_FREE, RTWS_EXP_SYNC,
+			   RTWS_COND_GET, RTWS_SYNC };
 	int nsynctypes = 0;
 
 	VERBOSE_TOROUT_STRING("rcu_torture_writer task started");
 	set_user_nice(current, MAX_NICE);
 
 	/* Initialize synctype[] array.  If none set, take default. */
-	if (!gp_cond1 && !gp_exp1 && !gp_normal1)
-		gp_cond1 = gp_exp1 = gp_normal1 = true;
+	if (!gp_cond1 && !gp_exp1 && !gp_normal1 && !gp_sync)
+		gp_cond1 = gp_exp1 = gp_normal1 = gp_sync1 = true;
 	if (gp_cond1 && cur_ops->get_state && cur_ops->cond_sync)
 		synctype[nsynctypes++] = RTWS_COND_GET;
 	else if (gp_cond && (!cur_ops->get_state || !cur_ops->cond_sync))
@@ -770,8 +774,17 @@ rcu_torture_writer(void *arg)
 		synctype[nsynctypes++] = RTWS_DEF_FREE;
 	else if (gp_normal && !cur_ops->deferred_free)
 		pr_alert("rcu_torture_writer: gp_normal without primitives.\n");
+	if (gp_sync1 && cur_ops->sync)
+		synctype[nsynctypes++] = RTWS_SYNC;
+	else if (gp_sync && !cur_ops->sync)
+		pr_alert("rcu_torture_writer: gp_sync without primitives.\n");
 	if (WARN_ONCE(nsynctypes == 0,
 		      "rcu_torture_writer: No update-side primitives.\n")) {
+		/*
+		 * No updates primitives, so don't try updating.
+		 * The resulting test won't be testing much, hence the
+		 * above WARN_ONCE().
+		 */
 		rcu_torture_writer_state = RTWS_STOPPING;
 		torture_kthread_stopping("rcu_torture_writer");
 	}
@@ -818,6 +831,11 @@ rcu_torture_writer(void *arg)
 				cur_ops->cond_sync(gp_snap);
 				rcu_torture_pipe_update(old_rp);
 				break;
+			case RTWS_SYNC:
+				rcu_torture_writer_state = RTWS_SYNC;
+				cur_ops->sync();
+				rcu_torture_pipe_update(old_rp);
+				break;
 			default:
 				WARN_ON_ONCE(1);
 				break;
-- 
1.8.1.5

