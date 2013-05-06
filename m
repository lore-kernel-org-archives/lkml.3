Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab3EFQ2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 12:28:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379Ab3EFQ2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 12:28:05 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH 1/2] perf: Fix EXIT event notification
Date: Mon,  6 May 2013 18:27:17 +0200
Message-Id: <1367857638-27631-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1367857638-27631-1-git-send-email-jolsa@redhat.com>
References: <1367857638-27631-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf_event_task_ctx needs to be called with preemption
disabled, since it's checking for currently scheduled cpu
against event cpu.

We disable preemption for task related perf event context
if there's one defined, leaving up to the chance which cpu
it gets scheduled in.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Borislav Petkov <bp@alien8.de>
---
 kernel/events/core.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 6b41c18..38b68a0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4474,7 +4474,7 @@ static void perf_event_task_ctx(struct perf_event_context *ctx,
 static void perf_event_task_event(struct perf_task_event *task_event)
 {
 	struct perf_cpu_context *cpuctx;
-	struct perf_event_context *ctx;
+	struct perf_event_context *ctx, *task_ctx = task_event->task_ctx;
 	struct pmu *pmu;
 	int ctxn;
 
@@ -4485,20 +4485,22 @@ static void perf_event_task_event(struct perf_task_event *task_event)
 			goto next;
 		perf_event_task_ctx(&cpuctx->ctx, task_event);
 
-		ctx = task_event->task_ctx;
-		if (!ctx) {
-			ctxn = pmu->task_ctx_nr;
-			if (ctxn < 0)
-				goto next;
-			ctx = rcu_dereference(current->perf_event_ctxp[ctxn]);
-			if (ctx)
-				perf_event_task_ctx(ctx, task_event);
-		}
+		if (task_ctx)
+			goto next;
+		ctxn = pmu->task_ctx_nr;
+		if (ctxn < 0)
+			goto next;
+		ctx = rcu_dereference(current->perf_event_ctxp[ctxn]);
+		if (ctx)
+			perf_event_task_ctx(ctx, task_event);
 next:
 		put_cpu_ptr(pmu->pmu_cpu_context);
 	}
-	if (task_event->task_ctx)
-		perf_event_task_ctx(task_event->task_ctx, task_event);
+	if (task_ctx) {
+		preempt_disable();
+		perf_event_task_ctx(task_ctx, task_event);
+		preempt_enable();
+	}
 
 	rcu_read_unlock();
 }
-- 
1.7.11.7

