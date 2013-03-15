Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab3COH1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 03:27:20 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52174 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab3COH1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 03:27:19 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-56-5142cd5431e4
From: Namhyung Kim <namhyung@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH] perf: Generate EXIT event only once per task context
Date: Fri, 15 Mar 2013 16:27:13 +0900
Message-Id: <1363332433-7637-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

perf_event_task_event() iterates pmu list and generate events for each
eligible pmu context.  But if task_event has task_ctx like in EXIT
it'll generate events even though the pmu doesn't have an eligible one.
Fix it by moving the code to proper places.

Before this patch:

  $ perf record -n true
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.006 MB perf.data (~248 samples) ]

  $ perf report -D | tail
  Aggregated stats:
             TOTAL events:         73
              MMAP events:         67
              COMM events:          2
              EXIT events:          4
  cycles stats:
             TOTAL events:         73
              MMAP events:         67
              COMM events:          2
              EXIT events:          4

After this patch:

  $ perf report -D | tail
  Aggregated stats:
             TOTAL events:         70
              MMAP events:         67
              COMM events:          2
              EXIT events:          1
  cycles stats:
             TOTAL events:         70
              MMAP events:         67
              COMM events:          2
              EXIT events:          1

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/events/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 53ac21cc4012..73ea6fcacf52 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4432,12 +4432,15 @@ static void perf_event_task_event(struct perf_task_event *task_event)
 			if (ctxn < 0)
 				goto next;
 			ctx = rcu_dereference(current->perf_event_ctxp[ctxn]);
+			if (ctx)
+				perf_event_task_ctx(ctx, task_event);
 		}
-		if (ctx)
-			perf_event_task_ctx(ctx, task_event);
 next:
 		put_cpu_ptr(pmu->pmu_cpu_context);
 	}
+	if (task_event->task_ctx)
+		perf_event_task_ctx(task_event->task_ctx, task_event);
+
 	rcu_read_unlock();
 }
 
-- 
1.7.11.7

