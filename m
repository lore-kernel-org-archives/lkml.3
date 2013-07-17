Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359Ab3GQWvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:51:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56319 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932573Ab3GQWvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:51:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 135/145] perf: Fix perf_lock_task_context() vs RCU
Date: Wed, 17 Jul 2013 15:47:47 -0700
Message-Id: <1374101277-7915-136-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/events/core.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d28d8d0..9c53789 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -729,8 +729,18 @@ perf_lock_task_context(struct task_struct *task, int ctxn, unsigned long *flags)
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
@@ -746,6 +756,8 @@ retry:
 		raw_spin_lock_irqsave(&ctx->lock, *flags);
 		if (ctx != rcu_dereference(task->perf_event_ctxp[ctxn])) {
 			raw_spin_unlock_irqrestore(&ctx->lock, *flags);
+			rcu_read_unlock();
+			preempt_enable();
 			goto retry;
 		}
 
@@ -755,6 +767,7 @@ retry:
 		}
 	}
 	rcu_read_unlock();
+	preempt_enable();
 	return ctx;
 }
 
-- 
1.8.1.2

