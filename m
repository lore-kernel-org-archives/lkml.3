Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab3IKEaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:30:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8009 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab3IKE3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:04 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=zON61FECXT4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Gpk2-J_fdpUA:10 a=JfrnYn6hAAAA:8 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=b4KrJKo_AAAA:8 a=MG5f_tbZKyYV26hUYocA:9 a=rY2aRBaYra8A:10 a=3Rfx1nUSh_UA:10 a=jEp0ucaQiEUA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042858.109752380@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, <stable@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [035/251] perf: Fix perf_lock_task_context() vs RCU
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0035-perf-Fix-perf_lock_task_context-vs-RCU.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 058ebd0eba3aff16b144eabf4510ed9510e1416e ]

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
Cc: <stable@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/events/core.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 63ffeb0..18ab244b 100644
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
1.7.10.4


