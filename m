Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964909Ab3GLNa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:30:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59589 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964857Ab3GLNaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:30:22 -0400
Date: Fri, 12 Jul 2013 06:29:09 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-67516844625f45f0ce148a01c27bf41f591872b2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <1373388991-9711-1-git-send-email-jolsa@redhat.com>
References: <1373388991-9711-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Remove the 'match'
  callback for auxiliary events processing
Git-Commit-ID: 67516844625f45f0ce148a01c27bf41f591872b2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 06:29:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  67516844625f45f0ce148a01c27bf41f591872b2
Gitweb:     http://git.kernel.org/tip/67516844625f45f0ce148a01c27bf41f591872b2
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 9 Jul 2013 18:56:31 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 12 Jul 2013 13:50:36 +0200

perf: Remove the 'match' callback for auxiliary events processing

It gives the following benefits:

  - only one function pointer is passed along the way

  - the 'match' function is called within output function
    and could be inlined by the compiler

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1373388991-9711-1-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 79 ++++++++++++++++++++++++++--------------------------
 1 file changed, 39 insertions(+), 40 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index eba8fb5..708ab70 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4680,12 +4680,10 @@ perf_event_read_event(struct perf_event *event,
 	perf_output_end(&handle);
 }
 
-typedef int  (perf_event_aux_match_cb)(struct perf_event *event, void *data);
 typedef void (perf_event_aux_output_cb)(struct perf_event *event, void *data);
 
 static void
 perf_event_aux_ctx(struct perf_event_context *ctx,
-		   perf_event_aux_match_cb match,
 		   perf_event_aux_output_cb output,
 		   void *data)
 {
@@ -4696,15 +4694,12 @@ perf_event_aux_ctx(struct perf_event_context *ctx,
 			continue;
 		if (!event_filter_match(event))
 			continue;
-		if (match(event, data))
-			output(event, data);
+		output(event, data);
 	}
 }
 
 static void
-perf_event_aux(perf_event_aux_match_cb match,
-	       perf_event_aux_output_cb output,
-	       void *data,
+perf_event_aux(perf_event_aux_output_cb output, void *data,
 	       struct perf_event_context *task_ctx)
 {
 	struct perf_cpu_context *cpuctx;
@@ -4717,7 +4712,7 @@ perf_event_aux(perf_event_aux_match_cb match,
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
 		if (cpuctx->unique_pmu != pmu)
 			goto next;
-		perf_event_aux_ctx(&cpuctx->ctx, match, output, data);
+		perf_event_aux_ctx(&cpuctx->ctx, output, data);
 		if (task_ctx)
 			goto next;
 		ctxn = pmu->task_ctx_nr;
@@ -4725,14 +4720,14 @@ perf_event_aux(perf_event_aux_match_cb match,
 			goto next;
 		ctx = rcu_dereference(current->perf_event_ctxp[ctxn]);
 		if (ctx)
-			perf_event_aux_ctx(ctx, match, output, data);
+			perf_event_aux_ctx(ctx, output, data);
 next:
 		put_cpu_ptr(pmu->pmu_cpu_context);
 	}
 
 	if (task_ctx) {
 		preempt_disable();
-		perf_event_aux_ctx(task_ctx, match, output, data);
+		perf_event_aux_ctx(task_ctx, output, data);
 		preempt_enable();
 	}
 	rcu_read_unlock();
@@ -4759,6 +4754,12 @@ struct perf_task_event {
 	} event_id;
 };
 
+static int perf_event_task_match(struct perf_event *event)
+{
+	return event->attr.comm || event->attr.mmap ||
+	       event->attr.mmap_data || event->attr.task;
+}
+
 static void perf_event_task_output(struct perf_event *event,
 				   void *data)
 {
@@ -4768,6 +4769,9 @@ static void perf_event_task_output(struct perf_event *event,
 	struct task_struct *task = task_event->task;
 	int ret, size = task_event->event_id.header.size;
 
+	if (!perf_event_task_match(event))
+		return;
+
 	perf_event_header__init_id(&task_event->event_id.header, &sample, event);
 
 	ret = perf_output_begin(&handle, event,
@@ -4790,13 +4794,6 @@ out:
 	task_event->event_id.header.size = size;
 }
 
-static int perf_event_task_match(struct perf_event *event,
-				 void *data __maybe_unused)
-{
-	return event->attr.comm || event->attr.mmap ||
-	       event->attr.mmap_data || event->attr.task;
-}
-
 static void perf_event_task(struct task_struct *task,
 			      struct perf_event_context *task_ctx,
 			      int new)
@@ -4825,8 +4822,7 @@ static void perf_event_task(struct task_struct *task,
 		},
 	};
 
-	perf_event_aux(perf_event_task_match,
-		       perf_event_task_output,
+	perf_event_aux(perf_event_task_output,
 		       &task_event,
 		       task_ctx);
 }
@@ -4853,6 +4849,11 @@ struct perf_comm_event {
 	} event_id;
 };
 
+static int perf_event_comm_match(struct perf_event *event)
+{
+	return event->attr.comm;
+}
+
 static void perf_event_comm_output(struct perf_event *event,
 				   void *data)
 {
@@ -4862,6 +4863,9 @@ static void perf_event_comm_output(struct perf_event *event,
 	int size = comm_event->event_id.header.size;
 	int ret;
 
+	if (!perf_event_comm_match(event))
+		return;
+
 	perf_event_header__init_id(&comm_event->event_id.header, &sample, event);
 	ret = perf_output_begin(&handle, event,
 				comm_event->event_id.header.size);
@@ -4883,12 +4887,6 @@ out:
 	comm_event->event_id.header.size = size;
 }
 
-static int perf_event_comm_match(struct perf_event *event,
-				 void *data __maybe_unused)
-{
-	return event->attr.comm;
-}
-
 static void perf_event_comm_event(struct perf_comm_event *comm_event)
 {
 	char comm[TASK_COMM_LEN];
@@ -4903,8 +4901,7 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
 
 	comm_event->event_id.header.size = sizeof(comm_event->event_id) + size;
 
-	perf_event_aux(perf_event_comm_match,
-		       perf_event_comm_output,
+	perf_event_aux(perf_event_comm_output,
 		       comm_event,
 		       NULL);
 }
@@ -4967,6 +4964,17 @@ struct perf_mmap_event {
 	} event_id;
 };
 
+static int perf_event_mmap_match(struct perf_event *event,
+				 void *data)
+{
+	struct perf_mmap_event *mmap_event = data;
+	struct vm_area_struct *vma = mmap_event->vma;
+	int executable = vma->vm_flags & VM_EXEC;
+
+	return (!executable && event->attr.mmap_data) ||
+	       (executable && event->attr.mmap);
+}
+
 static void perf_event_mmap_output(struct perf_event *event,
 				   void *data)
 {
@@ -4976,6 +4984,9 @@ static void perf_event_mmap_output(struct perf_event *event,
 	int size = mmap_event->event_id.header.size;
 	int ret;
 
+	if (!perf_event_mmap_match(event, data))
+		return;
+
 	perf_event_header__init_id(&mmap_event->event_id.header, &sample, event);
 	ret = perf_output_begin(&handle, event,
 				mmap_event->event_id.header.size);
@@ -4996,17 +5007,6 @@ out:
 	mmap_event->event_id.header.size = size;
 }
 
-static int perf_event_mmap_match(struct perf_event *event,
-				 void *data)
-{
-	struct perf_mmap_event *mmap_event = data;
-	struct vm_area_struct *vma = mmap_event->vma;
-	int executable = vma->vm_flags & VM_EXEC;
-
-	return (!executable && event->attr.mmap_data) ||
-	       (executable && event->attr.mmap);
-}
-
 static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 {
 	struct vm_area_struct *vma = mmap_event->vma;
@@ -5070,8 +5070,7 @@ got_name:
 
 	mmap_event->event_id.header.size = sizeof(mmap_event->event_id) + size;
 
-	perf_event_aux(perf_event_mmap_match,
-		       perf_event_mmap_output,
+	perf_event_aux(perf_event_mmap_output,
 		       mmap_event,
 		       NULL);
 
