Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab3EGOQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:16:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56109 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab3EGOQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:16:00 -0400
Date: Tue, 7 May 2013 07:14:35 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-52d857a8784a09576215c71cebf368d61c12a754@git.kernel.org>
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
In-Reply-To: <1367857638-27631-3-git-send-email-jolsa@redhat.com>
References: <1367857638-27631-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Factor out auxiliary events notification
Git-Commit-ID: 52d857a8784a09576215c71cebf368d61c12a754
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

Commit-ID:  52d857a8784a09576215c71cebf368d61c12a754
Gitweb:     http://git.kernel.org/tip/52d857a8784a09576215c71cebf368d61c12a754
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 6 May 2013 18:27:18 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 7 May 2013 13:17:29 +0200

perf: Factor out auxiliary events notification

Add perf_event_aux() function to send out all types of
auxiliary events - mmap, task, comm events. For each type
there's match and output functions defined and used as
callbacks during perf_event_aux processing.

This way we can centralize the pmu/context iterating and
event matching logic. Also since lot of the code was
duplicated, this patch reduces the .text size about 2kB
on my setup:

  snipped output from 'objdump -x kernel/events/core.o'

  before:
  Idx Name          Size
    0 .text         0000d313

  after:
  Idx Name          Size
    0 .text         0000cad3

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1367857638-27631-3-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 242 +++++++++++++++++++--------------------------------
 1 file changed, 89 insertions(+), 153 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 38b68a0..9dc297f 100644
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
@@ -4445,64 +4504,11 @@ out:
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
-{
-	struct perf_event *event;
-
-	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
-		if (perf_event_task_match(event))
-			perf_event_task_output(event, task_event);
-	}
-}
-
-static void perf_event_task_event(struct perf_task_event *task_event)
+static int perf_event_task_match(struct perf_event *event,
+				 void *data __maybe_unused)
 {
-	struct perf_cpu_context *cpuctx;
-	struct perf_event_context *ctx, *task_ctx = task_event->task_ctx;
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
-		if (task_ctx)
-			goto next;
-		ctxn = pmu->task_ctx_nr;
-		if (ctxn < 0)
-			goto next;
-		ctx = rcu_dereference(current->perf_event_ctxp[ctxn]);
-		if (ctx)
-			perf_event_task_ctx(ctx, task_event);
-next:
-		put_cpu_ptr(pmu->pmu_cpu_context);
-	}
-	if (task_ctx) {
-		preempt_disable();
-		perf_event_task_ctx(task_ctx, task_event);
-		preempt_enable();
-	}
-
-	rcu_read_unlock();
+	return event->attr.comm || event->attr.mmap ||
+	       event->attr.mmap_data || event->attr.task;
 }
 
 static void perf_event_task(struct task_struct *task,
@@ -4533,7 +4539,10 @@ static void perf_event_task(struct task_struct *task,
 		},
 	};
 
-	perf_event_task_event(&task_event);
+	perf_event_aux(perf_event_task_match,
+		       perf_event_task_output,
+		       &task_event,
+		       task_ctx);
 }
 
 void perf_event_fork(struct task_struct *task)
@@ -4559,8 +4568,9 @@ struct perf_comm_event {
 };
 
 static void perf_event_comm_output(struct perf_event *event,
-				     struct perf_comm_event *comm_event)
+				   void *data)
 {
+	struct perf_comm_event *comm_event = data;
 	struct perf_output_handle handle;
 	struct perf_sample_data sample;
 	int size = comm_event->event_id.header.size;
@@ -4587,39 +4597,16 @@ out:
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
@@ -4629,24 +4616,11 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
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
@@ -4708,8 +4682,9 @@ struct perf_mmap_event {
 };
 
 static void perf_event_mmap_output(struct perf_event *event,
-				     struct perf_mmap_event *mmap_event)
+				   void *data)
 {
+	struct perf_mmap_event *mmap_event = data;
 	struct perf_output_handle handle;
 	struct perf_sample_data sample;
 	int size = mmap_event->event_id.header.size;
@@ -4736,46 +4711,24 @@ out:
 }
 
 static int perf_event_mmap_match(struct perf_event *event,
-				   struct perf_mmap_event *mmap_event,
-				   int executable)
+				 void *data)
 {
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
-{
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
 
@@ -4831,27 +4784,10 @@ got_name:
 
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
