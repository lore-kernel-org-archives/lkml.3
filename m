Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab3KKR3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:29:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40299 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab3KKR3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:29:43 -0500
Date: Mon, 11 Nov 2013 18:29:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com, pjt@google.com
Subject: [PATCH] sched: Optimize task_sched_runtime()
Message-ID: <20131111172925.GG26898@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: Optimize task_sched_runtime()
From: Peter Zijlstra <peterz@infradead.org>
Date: Mon Nov 11 18:21:56 CET 2013

Large multi-threaded apps like to hit this using do_sys_times() and
then queue up on the rq->lock.

Avoid when possible.

Larry reported ~20% performance increase his test case.

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reported-by: Larry Woodman <lwoodman@redhat.com>
Suggested-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-m3prfhn4woqzrg4w029obww8@git.kernel.org
---
 kernel/sched/core.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2253,6 +2253,20 @@ unsigned long long task_sched_runtime(st
 	struct rq *rq;
 	u64 ns = 0;
 
+#if defined(CONFIG_64BIT) && defined(CONFIG_SMP)
+	/*
+	 * 64-bit doesn't need locks to atomically read a 64bit value.
+	 * So we have a optimization chance when the task's delta_exec is 0.
+	 * Reading ->on_cpu is racy, but this is ok.
+	 *
+	 * If we race with it leaving cpu, we'll take a lock. So we're correct.
+	 * If we race with it entering cpu, unaccounted time is 0. This is
+	 * indistinguishable from the read occurring a few cycles earlier.
+	 */
+	if (!p->on_cpu)
+		return p->se.sum_exec_runtime;
+#endif
+
 	rq = task_rq_lock(p, &flags);
 	ns = p->se.sum_exec_runtime + do_task_delta_exec(p, rq);
 	task_rq_unlock(rq, p, &flags);
