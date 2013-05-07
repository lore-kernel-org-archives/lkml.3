Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab3EGONw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:13:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56070 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab3EGONt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:13:49 -0400
Date: Tue, 7 May 2013 07:13:18 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-524eff183f51d080a83b348d0ea97c08b3607b9a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, bp@alien8.de, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, bp@alien8.de,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1367857638-27631-2-git-send-email-jolsa@redhat.com>
References: <1367857638-27631-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix EXIT event notification
Git-Commit-ID: 524eff183f51d080a83b348d0ea97c08b3607b9a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  524eff183f51d080a83b348d0ea97c08b3607b9a
Gitweb:     http://git.kernel.org/tip/524eff183f51d080a83b348d0ea97c08b3607b9a
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 6 May 2013 18:27:17 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 7 May 2013 13:17:28 +0200

perf: Fix EXIT event notification

The perf_event_task_ctx() function needs to be called with
preemption disabled, since it's checking for currently
scheduled cpu against event cpu.

We disable preemption for task related perf event context
if there's one defined, leaving up to the chance which cpu
it gets scheduled in.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1367857638-27631-2-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
