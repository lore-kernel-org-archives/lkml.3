Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab3G3J6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:58:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52994 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298Ab3G3Jcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 018/106] perf: Fix perf_lock_task_context() vs RCU
Date: Tue, 30 Jul 2013 10:30:37 +0100
Message-Id: <1375176725-5825-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 058ebd0eba3aff16b144eabf4510ed9510e1416e upstream.

Jiri managed to trigger this warning:

 [] ======================================================
 [] [ INFO: possible circular locking dependency detected ]
 [] 3.10.0+ #228 Tainted: G        W
 [] -------------------------------------------------------
 [] p/6613 is trying to acquire lock:
 []  (rcu_node_0){..-...}, at: [<ffffffff810ca797>] rcu_read_unlock_special+0xa7/0x250
 []
 [] but task is already holding lock:
 []  (&ctx->lock){-.-...}, at: [<ffffffff810f2879>] perf_lock_task_context+0xd9/0x2c0
 []
 [] which lock already depends on the new lock.
 []
 [] the existing dependency chain (in reverse order) is:
 []
 [] -> #4 (&ctx->lock){-.-...}:
 [] -> #3 (&rq->lock){-.-.-.}:
 [] -> #2 (&p->pi_lock){-.-.-.}:
 [] -> #1 (&rnp->nocb_gp_wq[1]){......}:
 [] -> #0 (rcu_node_0){..-...}:

Paul was quick to explain that due to preemptible RCU we cannot call
rcu_read_unlock() while holding scheduler (or nested) locks when part
of the read side critical section was preemptible.

Therefore solve it by making the entire RCU read side non-preemptible.

Also pull out the retry from under the non-preempt to play nice with RT.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Helped-out-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/events/core.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index cccd51c..00aa7e3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -723,8 +723,18 @@ perf_lock_task_context(struct task_struct *task, int ctxn, unsigned long *flags)
 {
 	struct perf_event_context *ctx;
 
-	rcu_read_lock();
 retry:
+	/*
+	 * One of the few rules of preemptible RCU is that one cannot do
+	 * rcu_read_unlock() while holding a scheduler (or nested) lock when
+	 * part of the read side critical section was preemptible -- see
+	 * rcu_read_unlock_special().
+	 *
+	 * Since ctx->lock nests under rq->lock we must ensure the entire read
+	 * side critical section is non-preemptible.
+	 */
+	preempt_disable();
+	rcu_read_lock();
 	ctx = rcu_dereference(task->perf_event_ctxp[ctxn]);
 	if (ctx) {
 		/*
@@ -740,6 +750,8 @@ retry:
 		raw_spin_lock_irqsave(&ctx->lock, *flags);
 		if (ctx != rcu_dereference(task->perf_event_ctxp[ctxn])) {
 			raw_spin_unlock_irqrestore(&ctx->lock, *flags);
+			rcu_read_unlock();
+			preempt_enable();
 			goto retry;
 		}
 
@@ -749,6 +761,7 @@ retry:
 		}
 	}
 	rcu_read_unlock();
+	preempt_enable();
 	return ctx;
 }
 
-- 
1.8.3.2

