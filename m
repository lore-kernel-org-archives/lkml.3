Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935Ab3D2TSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:18:30 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:32985 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062Ab3D2TS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:18:28 -0400
Message-ID: <517EC781.5050600@gmail.com>
Date: Mon, 29 Apr 2013 15:18:25 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Olivier Langlois <olivier@trillion01.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        kosaki.motohiro@gmail.com
Subject: [PATCH 4/2] sched: task_sched_runtime introduce micro optimization
References: <1367216762-3933-1-git-send-email-kosaki.motohiro@gmail.com>
In-Reply-To: <1367216762-3933-1-git-send-email-kosaki.motohiro@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


