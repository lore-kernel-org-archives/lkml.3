Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab3GXOYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:24:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45753 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066Ab3GXOGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:40 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ingo Molnar" <mingo@kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Jiri Olsa" <jolsa@redhat.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.440409753@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [76/85] perf: Fix perf_lock_task_context() vs RCU
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/events/core.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -714,8 +714,18 @@ perf_lock_task_context(struct task_struc
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
@@ -731,6 +741,8 @@ retry:
 		raw_spin_lock_irqsave(&ctx->lock, *flags);
 		if (ctx != rcu_dereference(task->perf_event_ctxp[ctxn])) {
 			raw_spin_unlock_irqrestore(&ctx->lock, *flags);
+			rcu_read_unlock();
+			preempt_enable();
 			goto retry;
 		}
 
@@ -740,6 +752,7 @@ retry:
 		}
 	}
 	rcu_read_unlock();
+	preempt_enable();
 	return ctx;
 }
 

