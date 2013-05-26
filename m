Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab3EZVhe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 17:37:34 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:41493 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab3EZVhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 17:37:31 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Olivier Langlois <olivier@trillion01.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 6/8] sched: task_sched_runtime introduce micro optimization
Date: Sun, 26 May 2013 17:35:47 -0400
Message-Id: <1369604149-13016-9-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1369604149-13016-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1369604149-13016-1-git-send-email-kosaki.motohiro@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

rq lock in task_sched_runtime() is necessary for two reasons. 1)
accessing se.sum_exec_runtime is not atomic on 32bit and 2)
do_task_delta_exec() require it.

So, 64bit can avoid holding rq lock when add_delta is false and
delta_exec is 0.

Cc: Olivier Langlois <olivier@trillion01.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Suggested-by: Paul Turner <pjt@google.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/sched/core.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 96512e9..0f859cc 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2692,6 +2692,21 @@ unsigned long long task_sched_runtime(struct task_struct *p, bool add_delta)
 	struct rq *rq;
 	u64 ns = 0;
 
+#ifdef CONFIG_64BIT
+	/*
+	 * 64-bit doesn't need locks to atomically read a 64bit value. So we
+	 * have two optimization chances, 1) when caller doesn't need
+	 * delta_exec and 2) when the task's delta_exec is 0. The former is
+	 * obvious. The latter is complicated. reading ->on_cpu is racy, but
+	 * this is ok. If we race with it leaving cpu, we'll take a lock. So
+	 * we're correct. If we race with it entering cpu, unaccounted time
+	 * is 0. This is indistinguishable from the read occurring a few
+	 * cycles earlier.
+	 */
+	if (!add_delta || !p->on_cpu)
+		return p->se.sum_exec_runtime;
+#endif
+
 	rq = task_rq_lock(p, &flags);
 	ns = p->se.sum_exec_runtime;
 	if (add_delta)
-- 
1.7.1

