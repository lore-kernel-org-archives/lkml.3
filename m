Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138AbbA0SE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:04:28 -0500
Received: from mga03.intel.com ([134.134.136.65]:18587 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759092AbbA0SEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:04:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,476,1418112000"; 
   d="scan'208";a="676876464"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        Kaixu Xia <kaixu.xia@linaro.org>, acme@infradead.org
Subject: Re: [PATCH v9 12/14] x86: perf: intel_pt: Intel PT PMU driver
In-Reply-To: <20150126165536.GA23038@twins.programming.kicks-ass.net>
References: <1421237903-181015-1-git-send-email-alexander.shishkin@linux.intel.com> <1421237903-181015-13-git-send-email-alexander.shishkin@linux.intel.com> <20150115090659.GQ23965@worktop.programming.kicks-ass.net> <87egqwmdhe.fsf@ashishki-desk.ger.corp.intel.com> <87twzllhbz.fsf@ashishki-desk.ger.corp.intel.com> <20150126165536.GA23038@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.18.2 (http://notmuchmail.org) Emacs/24.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 27 Jan 2015 20:03:47 +0200
Message-ID: <87zj9485j0.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:
>
> Yes that'll work.

Ok, let me respin this last patch, with the per-task event counter to
prevent cpu-wide events together with per-task events. The idea is that
cpu-wide events are disallowed when per-task events exist on this pmu
and vice versa. It adds an atomic counter to struct pmu to account for
per-task events.

If this looks all right to you, I can resend the patchset.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/linux/perf_event.h |  1 +
 kernel/events/core.c       | 87 ++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 81 insertions(+), 7 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e00d59dc08..bdbba674de 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -189,6 +189,7 @@ struct pmu {
 
 	int * __percpu			pmu_disable_count;
 	struct perf_cpu_context * __percpu pmu_cpu_context;
+	atomic_t			nr_per_task_events;
 	int				task_ctx_nr;
 	int				hrtimer_interval_ms;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 35ed22a0d8..c0a0cd90ba 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3335,6 +3335,44 @@ static void unaccount_event(struct perf_event *event)
 	unaccount_event_cpu(event, event->cpu);
 }
 
+static int account_per_task_counter(struct perf_event *event)
+{
+	struct pmu *pmu = event->pmu;
+
+	if (!(pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE))
+		return 0;
+
+	/*
+	 * Prevent co-existence of per-task and cpu-wide events on the
+	 * same exclusive pmu.
+	 *
+	 * Negative pmu::nr_per_task_events means there are cpu-wide
+	 * events on this "exclusive" pmu, positive means there are
+	 * per-task events.
+	 */
+	if (event->cpu == -1 &&
+	    !atomic_inc_unless_negative(&pmu->nr_per_task_events))
+		return -EBUSY;
+	else if (!(event->attach_state & PERF_ATTACH_TASK) &&
+		 !atomic_dec_unless_positive(&pmu->nr_per_task_events))
+		return -EBUSY;
+
+	return 0;
+}
+
+static void unaccount_per_task_counter(struct perf_event *event)
+{
+	struct pmu *pmu = event->pmu;
+
+	if (!(pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE))
+		return 0;
+
+	if (event->cpu == -1)
+		atomic_dec(&pmu->nr_per_task_events);
+	else if (!(event->attach_state & PERF_ATTACH_TASK))
+		atomic_inc(&pmu->nr_per_task_events);
+}
+
 static void __free_event(struct perf_event *event)
 {
 	if (!event->parent) {
@@ -3348,8 +3386,11 @@ static void __free_event(struct perf_event *event)
 	if (event->ctx)
 		put_ctx(event->ctx);
 
-	if (event->pmu)
+	if (event->pmu) {
+		unaccount_per_task_counter(event);
+
 		module_put(event->pmu->module);
+	}
 
 	call_rcu(&event->rcu_head, free_event_rcu);
 }
@@ -6908,6 +6949,7 @@ got_cpu_context:
 		pmu->event_idx = perf_event_idx_default;
 
 	list_add_rcu(&pmu->entry, &pmus);
+	atomic_set(&pmu->nr_per_task_events, 0);
 	ret = 0;
 unlock:
 	mutex_unlock(&pmus_lock);
@@ -7143,16 +7185,23 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 		goto err_ns;
 	}
 
+	err = account_per_task_counter(event);
+	if (err)
+		goto err_pmu;
+
 	if (!event->parent) {
 		if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN) {
 			err = get_callchain_buffers();
 			if (err)
-				goto err_pmu;
+				goto err_per_task;
 		}
 	}
 
 	return event;
 
+err_per_task:
+	unaccount_per_task_counter(event);
+
 err_pmu:
 	if (event->destroy)
 		event->destroy(event);
@@ -7360,14 +7409,11 @@ static bool exclusive_event_match(struct perf_event *e1, struct perf_event *e2)
 	return false;
 }
 
-static bool exclusive_event_ok(struct perf_event *event,
-			      struct perf_event_context *ctx)
+static bool __exclusive_event_ok(struct perf_event *event,
+				 struct perf_event_context *ctx)
 {
 	struct perf_event *iter_event;
 
-	if (!(event->pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE))
-		return true;
-
 	list_for_each_entry(iter_event, &ctx->event_list, event_entry) {
 		if (exclusive_event_match(iter_event, event))
 			return false;
@@ -7376,6 +7422,33 @@ static bool exclusive_event_ok(struct perf_event *event,
 	return true;
 }
 
+static bool exclusive_event_ok(struct perf_event *event,
+			       struct perf_event_context *ctx)
+{
+	struct pmu *pmu = event->pmu;
+	bool ret = true;
+
+	if (!(pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE))
+		return true;
+
+	if (!__exclusive_event_ok(event, ctx))
+		return false;
+
+	if (ctx->task) {
+		if (event->cpu != -1) {
+			struct perf_event_context *cpuctx;
+
+			cpuctx = &per_cpu_ptr(pmu->pmu_cpu_context, event->cpu)->ctx;
+
+			mutex_lock(&cpuctx->mutex);
+			ret = __exclusive_event_ok(event, cpuctx);
+			mutex_unlock(&cpuctx->mutex);
+		}
+	}
+
+	return ret;
+}
+
 /**
  * sys_perf_event_open - open a performance event, associate it to a task/cpu
  *
-- 
2.1.4

