Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002Ab3D3DSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 23:18:53 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:46506 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758410Ab3D3DSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 23:18:51 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Olivier Langlois <olivier@trillion01.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 09/10] sched: task_sched_runtime introduce micro optimization
Date: Mon, 29 Apr 2013 23:17:17 -0400
Message-Id: <1367291838-5490-10-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1367291838-5490-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1367291838-5490-1-git-send-email-kosaki.motohiro@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

rq lock in task_sched_runtime() is necessary for two reasons. 1)
accessing se.sum_exec_runtime is inatomic on 32bit and 2)
do_task_delta_exec() require it.

And then, 64bit can avoid holds rq lock when add_delta is false.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/sched/core.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b817e6d..24ba1c6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2657,6 +2657,12 @@ unsigned long long task_sched_runtime(struct task_struct *p, bool add_delta)
 	struct rq *rq;
 	u64 ns = 0;
 
+	/* Micro optimization. */
+#ifdef CONFIG_64BIT
+	if (!add_delta)
+		return p->se.sum_exec_runtime;
+#endif
+
 	rq = task_rq_lock(p, &flags);
 	ns = p->se.sum_exec_runtime;
 	if (add_delta)
-- 
1.7.1

