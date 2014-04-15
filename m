Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbaDONeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:34:14 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:9461 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751070AbaDONcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:32:53 -0400
X-IronPort-AV: E=Sophos;i="4.97,863,1389715200"; 
   d="scan'208";a="29292486"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <rostedt@goodmis.org>, <fweisbec@gmail.com>, <mingo@redhat.com>,
        <peterz@infradead.org>, <acme@ghostprotocols.net>
CC: <linux-kernel@vger.kernel.org>, Dongsheng <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 4/8] sched/core: Skip wakeup when task is already running.
Date: Tue, 15 Apr 2014 21:32:53 +0900
Message-ID: <51238bf1648b1f4c66d3547a49cf949d1679d068.1397562542.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng <yangds.fnst@cn.fujitsu.com>

It is pointless to wake up a running task. Currently, we can
see it in perf sched latency.

	# perf sched record sleep 10
	[ perf record: Woken up 2 times to write data ]
	[ perf record: Captured and wrote 21.170 MB perf.data (~924950 samples) ]
	# perf sched latency |tail
	  ksoftirqd/13:57       |      0.011 ms |        1 | avg:    0.003 ms | max:    0.003 ms | max at: 254123.512011 s
	  khelper:6423          |      0.059 ms |        3 | avg:    0.003 ms | max:    0.005 ms | max at: 254124.947110 s
	  ksoftirqd/3:17        |      0.042 ms |        2 | avg:    0.003 ms | max:    0.003 ms | max at: 254126.478175 s
	  automount:6465        |      0.480 ms |        1 | avg:    0.000 ms | max:    0.000 ms | max at:  0.000000 s
	  automount:6618        |      0.465 ms |        1 | avg:    0.000 ms | max:    0.000 ms | max at:  0.000000 s
	 -----------------------------------------------------------------------------------------
	  TOTAL:                |   3535.020 ms |    28477 |
	 ---------------------------------------------------
	  INFO: 0.922% state machine bugs (259 out of 28092)

Signed-off-by: Dongsheng <yangds.fnst@cn.fujitsu.com>
---
 kernel/sched/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 268a45e..fc6b644 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1416,6 +1416,9 @@ static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
 static void
 ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 {
+	if (p->state == TASK_RUNNING)
+		return;
+
 	check_preempt_curr(rq, p, wake_flags);
 	trace_sched_wakeup(p, true);
 
-- 
1.8.2.1

