Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928Ab3EOTLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 15:11:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:58854 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab3EOTLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 15:11:11 -0400
Date: Wed, 15 May 2013 21:11:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: [GIT pull] perf fixes for 3.10
Message-ID: <alpine.LFD.2.02.1305152108100.1388@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

Content:

  * Fix for a task exit cleanup race caused by a missing a preempt
    disable

  * Cleanup of the event notification functions with a massive
    reduction of duplicated code

Thanks,

	tglx

------------------>
Jiri Olsa (2):
      perf: Fix EXIT event notification
      perf: Factor out auxiliary events notification


 kernel/events/core.c |  240 +++++++++++++++++++-------------------------------
 1 files changed, 89 insertions(+), 151 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 6b41c18..9dc297f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4394,6 +4394,64 @@ perf_event_read_event(struct perf_event *event,
 	perf_output_end(&handle);
 }
 
+typedef int  (perf_event_aux_match_cb)(struct perf_event *event, void *data);
+typedef void (perf_event_aux_output_cb)(struct perf_event *event, void *data);
+
+static void
+perf_event_aux_ctx(struct perf_event_context *ctx,
+		   perf_event_aux_match_cb match,
+		   perf_event_aux_output_cb output,
+		   void *data)
+{
+	struct perf_event *event;
+
+	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
+		if (event->state < PERF_EVENT_STATE_INACTIVE)
+			continue;
+		if (!event_filter_match(event))
+			continue;
+		if (match(event, data))
+			output(event, data);
+	}
+}
+
+static void
+perf_event_aux(perf_event_aux_match_cb match,
+	       perf_event_aux_output_cb output,
+	       void *data,
+	       struct perf_event_context *task_ctx)
+{
+	struct perf_cpu_context *cpuctx;
+	struct perf_event_context *ctx;
+	struct pmu *pmu;
+	int ctxn;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
+		if (cpuctx->unique_pmu != pmu)
+			goto next;
+		perf_event_aux_ctx(&cpuctx->ctx, match, output, data);
+		if (task_ctx)
+			goto next;
+		ctxn = pmu->task_ctx_nr;
+		if (ctxn < 0)
+			goto next;
+		ctx = rcu_dereference(current->perf_event_ctxp[ctxn]);
+		if (ctx)
+			perf_event_aux_ctx(ctx, match, output, data);
+next:
+		put_cpu_ptr(pmu->pmu_cpu_context);
+	}
+
+	if (task_ctx) {
+		preempt_disable();
+		perf_event_aux_ctx(task_ctx, match, output, data);
+		preempt_enable();
+	}
+	rcu_read_unlock();
+}
+
 /*
  * task tracking -- fork/exit
  *
@@ -4416,8 +4474,9 @@ struct perf_task_event {
 };
 
 static void perf_event_task_output(struct perf_event *event,
-				     struct perf_task_event *task_event)
+				   void *data)
 {
+	struct perf_task_event *task_event = data;
 	struct perf_output_handle handle;
 	struct perf_sample_data	sample;
 	struct task_struct *task = task_event->task;
@@ -4445,62 +4504,11 @@ out:
 	task_event->event_id.header.size = size;
 }
 
-static int perf_event_task_match(struct perf_event *event)
-{
-	if (event->state < PERF_EVENT_STATE_INACTIVE)
-		return 0;
-
-	if (!event_filter_match(event))
-		return 0;
-
-	if (event->attr.comm || event->attr.mmap ||
-	    event->attr.mmap_data || event->attr.task)
-		return 1;
-
-	return 0;
-}
-
-static void perf_event_task_ctx(struct perf_event_context *ctx,
-				  struct perf_task_event *task_event)
+static int perf_event_task_match(struct perf_event *event,
+				 void *data __maybe_unused)
 {
-	struct perf_event *event;
-
-	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
-		if (perf_event_task_match(event))
-			perf_event_task_output(event, task_event);
-	}
-}
-
-static void perf_event_task_event(struct perf_task_event *task_event)
-{
-	struct perf_cpu_context *cpuctx;
-	struct perf_event_context *ctx;
-	struct pmu *pmu;
-	int ctxn;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(pmu, &pmus, entry) {
-		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
-		if (cpuctx->unique_pmu != pmu)
-			goto next;
-		perf_event_task_ctx(&cpuctx->ctx, task_event);
-
-		ctx = task_event->task_ctx;
-		if (!ctx) {
-			ctxn = pmu->task_ctx_nr;
-			if (ctxn < 0)
-				goto next;
-			ctx = rcu_dereference(current->perf_event_ctxp[ctxn]);
-			if (ctx)
-				perf_event_task_ctx(ctx, task_event);
-		}
-next:
-		put_cpu_ptr(pmu->pmu_cpu_context);
-	}
-	if (task_event->task_ctx)
-		perf_event_task_ctx(task_event->task_ctx, task_event);
-
-	rcu_read_unlock();
+	return event->attr.comm || event->attr.mmap ||
+	       event->attr.mmap_data || event->attr.task;
 }
 
 static void perf_event_task(struct task_struct *task,
@@ -4531,7 +4539,10 @@ static void perf_event_task(struct task_struct *task,
 		},
 	};
 
-	perf_event_task_event(&task_event);
+	perf_event_aux(perf_event_task_match,
+		       perf_event_task_output,
+		       &task_event,
+		       task_ctx);
 }
 
 void perf_event_fork(struct task_struct *task)
@@ -4557,8 +4568,9 @@ struct perf_comm_event {
 };
 
 static void perf_event_comm_output(struct perf_event *event,
-				     struct perf_comm_event *comm_event)
+				   void *data)
 {
+	struct perf_comm_event *comm_event = data;
 	struct perf_output_handle handle;
 	struct perf_sample_data sample;
 	int size = comm_event->event_id.header.size;
@@ -4585,39 +4597,16 @@ out:
 	comm_event->event_id.header.size = size;
 }
 
-static int perf_event_comm_match(struct perf_event *event)
-{
-	if (event->state < PERF_EVENT_STATE_INACTIVE)
-		return 0;
-
-	if (!event_filter_match(event))
-		return 0;
-
-	if (event->attr.comm)
-		return 1;
-
-	return 0;
-}
-
-static void perf_event_comm_ctx(struct perf_event_context *ctx,
-				  struct perf_comm_event *comm_event)
+static int perf_event_comm_match(struct perf_event *event,
+				 void *data __maybe_unused)
 {
-	struct perf_event *event;
-
-	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
-		if (perf_event_comm_match(event))
-			perf_event_comm_output(event, comm_event);
-	}
+	return event->attr.comm;
 }
 
 static void perf_event_comm_event(struct perf_comm_event *comm_event)
 {
-	struct perf_cpu_context *cpuctx;
-	struct perf_event_context *ctx;
 	char comm[TASK_COMM_LEN];
 	unsigned int size;
-	struct pmu *pmu;
-	int ctxn;
 
 	memset(comm, 0, sizeof(comm));
 	strlcpy(comm, comm_event->task->comm, sizeof(comm));
@@ -4627,24 +4616,11 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
 	comm_event->comm_size = size;
 
 	comm_event->event_id.header.size = sizeof(comm_event->event_id) + size;
-	rcu_read_lock();
-	list_for_each_entry_rcu(pmu, &pmus, entry) {
-		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
-		if (cpuctx->unique_pmu != pmu)
-			goto next;
-		perf_event_comm_ctx(&cpuctx->ctx, comm_event);
 
-		ctxn = pmu->task_ctx_nr;
-		if (ctxn < 0)
-			goto next;
-
-		ctx = rcu_dereference(current->perf_event_ctxp[ctxn]);
-		if (ctx)
-			perf_event_comm_ctx(ctx, comm_event);
-next:
-		put_cpu_ptr(pmu->pmu_cpu_context);
-	}
-	rcu_read_unlock();
+	perf_event_aux(perf_event_comm_match,
+		       perf_event_comm_output,
+		       comm_event,
+		       NULL);
 }
 
 void perf_event_comm(struct task_struct *task)
@@ -4706,8 +4682,9 @@ struct perf_mmap_event {
 };
 
 static void perf_event_mmap_output(struct perf_event *event,
-				     struct perf_mmap_event *mmap_event)
+				   void *data)
 {
+	struct perf_mmap_event *mmap_event = data;
 	struct perf_output_handle handle;
 	struct perf_sample_data sample;
 	int size = mmap_event->event_id.header.size;
@@ -4734,46 +4711,24 @@ out:
 }
 
 static int perf_event_mmap_match(struct perf_event *event,
-				   struct perf_mmap_event *mmap_event,
-				   int executable)
-{
-	if (event->state < PERF_EVENT_STATE_INACTIVE)
-		return 0;
-
-	if (!event_filter_match(event))
-		return 0;
-
-	if ((!executable && event->attr.mmap_data) ||
-	    (executable && event->attr.mmap))
-		return 1;
-
-	return 0;
-}
-
-static void perf_event_mmap_ctx(struct perf_event_context *ctx,
-				  struct perf_mmap_event *mmap_event,
-				  int executable)
+				 void *data)
 {
-	struct perf_event *event;
+	struct perf_mmap_event *mmap_event = data;
+	struct vm_area_struct *vma = mmap_event->vma;
+	int executable = vma->vm_flags & VM_EXEC;
 
-	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
-		if (perf_event_mmap_match(event, mmap_event, executable))
-			perf_event_mmap_output(event, mmap_event);
-	}
+	return (!executable && event->attr.mmap_data) ||
+	       (executable && event->attr.mmap);
 }
 
 static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 {
-	struct perf_cpu_context *cpuctx;
-	struct perf_event_context *ctx;
 	struct vm_area_struct *vma = mmap_event->vma;
 	struct file *file = vma->vm_file;
 	unsigned int size;
 	char tmp[16];
 	char *buf = NULL;
 	const char *name;
-	struct pmu *pmu;
-	int ctxn;
 
 	memset(tmp, 0, sizeof(tmp));
 
@@ -4829,27 +4784,10 @@ got_name:
 
 	mmap_event->event_id.header.size = sizeof(mmap_event->event_id) + size;
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(pmu, &pmus, entry) {
-		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
-		if (cpuctx->unique_pmu != pmu)
-			goto next;
-		perf_event_mmap_ctx(&cpuctx->ctx, mmap_event,
-					vma->vm_flags & VM_EXEC);
-
-		ctxn = pmu->task_ctx_nr;
-		if (ctxn < 0)
-			goto next;
-
-		ctx = rcu_dereference(current->perf_event_ctxp[ctxn]);
-		if (ctx) {
-			perf_event_mmap_ctx(ctx, mmap_event,
-					vma->vm_flags & VM_EXEC);
-		}
-next:
-		put_cpu_ptr(pmu->pmu_cpu_context);
-	}
-	rcu_read_unlock();
+	perf_event_aux(perf_event_mmap_match,
+		       perf_event_mmap_output,
+		       mmap_event,
+		       NULL);
 
 	kfree(buf);
 }
