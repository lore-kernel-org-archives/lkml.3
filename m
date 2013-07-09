Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab3GIQ5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:57:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab3GIQ5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:57:05 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf: Remove match callback for auxiliary events processing
Date: Tue,  9 Jul 2013 18:56:31 +0200
Message-Id: <1373388991-9711-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing match callback for auxiliary events processing
with following benefits:
  - only one function pointer is passed along the way
  - the match function is called within output function
    and could be inlined by compiler

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/events/core.c | 79 ++++++++++++++++++++++++++--------------------------
 1 file changed, 39 insertions(+), 40 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1833bc5..bce961a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4658,12 +4658,10 @@ perf_event_read_event(struct perf_event *event,
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
@@ -4674,15 +4672,12 @@ perf_event_aux_ctx(struct perf_event_context *ctx,
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
@@ -4695,7 +4690,7 @@ perf_event_aux(perf_event_aux_match_cb match,
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
 		if (cpuctx->unique_pmu != pmu)
 			goto next;
-		perf_event_aux_ctx(&cpuctx->ctx, match, output, data);
+		perf_event_aux_ctx(&cpuctx->ctx, output, data);
 		if (task_ctx)
 			goto next;
 		ctxn = pmu->task_ctx_nr;
@@ -4703,14 +4698,14 @@ perf_event_aux(perf_event_aux_match_cb match,
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
@@ -4737,6 +4732,12 @@ struct perf_task_event {
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
@@ -4746,6 +4747,9 @@ static void perf_event_task_output(struct perf_event *event,
 	struct task_struct *task = task_event->task;
 	int ret, size = task_event->event_id.header.size;
 
+	if (!perf_event_task_match(event))
+		return;
+
 	perf_event_header__init_id(&task_event->event_id.header, &sample, event);
 
 	ret = perf_output_begin(&handle, event,
@@ -4768,13 +4772,6 @@ out:
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
@@ -4803,8 +4800,7 @@ static void perf_event_task(struct task_struct *task,
 		},
 	};
 
-	perf_event_aux(perf_event_task_match,
-		       perf_event_task_output,
+	perf_event_aux(perf_event_task_output,
 		       &task_event,
 		       task_ctx);
 }
@@ -4831,6 +4827,11 @@ struct perf_comm_event {
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
@@ -4840,6 +4841,9 @@ static void perf_event_comm_output(struct perf_event *event,
 	int size = comm_event->event_id.header.size;
 	int ret;
 
+	if (!perf_event_comm_match(event))
+		return;
+
 	perf_event_header__init_id(&comm_event->event_id.header, &sample, event);
 	ret = perf_output_begin(&handle, event,
 				comm_event->event_id.header.size);
@@ -4861,12 +4865,6 @@ out:
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
@@ -4881,8 +4879,7 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
 
 	comm_event->event_id.header.size = sizeof(comm_event->event_id) + size;
 
-	perf_event_aux(perf_event_comm_match,
-		       perf_event_comm_output,
+	perf_event_aux(perf_event_comm_output,
 		       comm_event,
 		       NULL);
 }
@@ -4945,6 +4942,17 @@ struct perf_mmap_event {
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
@@ -4954,6 +4962,9 @@ static void perf_event_mmap_output(struct perf_event *event,
 	int size = mmap_event->event_id.header.size;
 	int ret;
 
+	if (!perf_event_mmap_match(event, data))
+		return;
+
 	perf_event_header__init_id(&mmap_event->event_id.header, &sample, event);
 	ret = perf_output_begin(&handle, event,
 				mmap_event->event_id.header.size);
@@ -4974,17 +4985,6 @@ out:
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
@@ -5048,8 +5048,7 @@ got_name:
 
 	mmap_event->event_id.header.size = sizeof(mmap_event->event_id) + size;
 
-	perf_event_aux(perf_event_mmap_match,
-		       perf_event_mmap_output,
+	perf_event_aux(perf_event_mmap_output,
 		       mmap_event,
 		       NULL);
 
-- 
1.7.11.7

