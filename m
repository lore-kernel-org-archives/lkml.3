Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbbA2L73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:59:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:54514 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbbA2L71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:59:27 -0500
Date: Thu, 29 Jan 2015 12:59:18 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        Kaixu Xia <kaixu.xia@linaro.org>, acme@infradead.org
Subject: Re: [PATCH v9 12/14] x86: perf: intel_pt: Intel PT PMU driver
Message-ID: <20150129115918.GA26304@twins.programming.kicks-ass.net>
References: <1421237903-181015-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1421237903-181015-13-git-send-email-alexander.shishkin@linux.intel.com>
 <20150115090659.GQ23965@worktop.programming.kicks-ass.net>
 <87egqwmdhe.fsf@ashishki-desk.ger.corp.intel.com>
 <87twzllhbz.fsf@ashishki-desk.ger.corp.intel.com>
 <20150126165536.GA23038@twins.programming.kicks-ass.net>
 <87zj9485j0.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zj9485j0.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 08:03:47PM +0200, Alexander Shishkin wrote:
> +static int account_per_task_counter(struct perf_event *event)
> +{
> +	struct pmu *pmu = event->pmu;
> +
> +	if (!(pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE))
> +		return 0;
> +
> +	/*
> +	 * Prevent co-existence of per-task and cpu-wide events on the
> +	 * same exclusive pmu.
> +	 *
> +	 * Negative pmu::nr_per_task_events means there are cpu-wide
> +	 * events on this "exclusive" pmu, positive means there are
> +	 * per-task events.
> +	 */
> +	if (event->cpu == -1 &&
> +	    !atomic_inc_unless_negative(&pmu->nr_per_task_events))
> +		return -EBUSY;
> +	else if (!(event->attach_state & PERF_ATTACH_TASK) &&
> +		 !atomic_dec_unless_positive(&pmu->nr_per_task_events))
> +		return -EBUSY;
> +
> +	return 0;
> +}

I think that logic fails for per-task events that have a cpu set.


> +static bool exclusive_event_ok(struct perf_event *event,
> +			       struct perf_event_context *ctx)
> +{
> +	struct pmu *pmu = event->pmu;
> +	bool ret = true;
> +
> +	if (!(pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE))
> +		return true;
> +
> +	if (!__exclusive_event_ok(event, ctx))
> +		return false;
> +
> +	if (ctx->task) {
> +		if (event->cpu != -1) {
> +			struct perf_event_context *cpuctx;
> +
> +			cpuctx = &per_cpu_ptr(pmu->pmu_cpu_context, event->cpu)->ctx;
> +
> +			mutex_lock(&cpuctx->mutex);
> +			ret = __exclusive_event_ok(event, cpuctx);
> +			mutex_unlock(&cpuctx->mutex);

We're already holding ctx->mutex, this should have made lockdep scream.

> +		}
> +	}
> +
> +	return ret;
> +}


Would something like this work?

---
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -168,6 +168,7 @@ struct perf_event;
 #define PERF_PMU_CAP_NO_INTERRUPT		0x01
 #define PERF_PMU_CAP_AUX_NO_SG			0x02
 #define PERF_PMU_CAP_AUX_SW_DOUBLEBUF		0x04
+#define PERF_PMU_CAP_EXCLUSIVE			0x08
 
 /**
  * struct pmu - generic performance monitoring unit
@@ -188,6 +189,7 @@ struct pmu {
 
 	int * __percpu			pmu_disable_count;
 	struct perf_cpu_context * __percpu pmu_cpu_context;
+	atomic_t			exclusive_cnt; /* <0: cpu, >0: tsk */
 	int				task_ctx_nr;
 	int				hrtimer_interval_ms;
 
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3487,6 +3487,9 @@ static void __free_event(struct perf_eve
 	if (event->destroy)
 		event->destroy(event);
 
+	if (event->pmu && event->ctx)
+		exclusive_event_release(event);
+
 	if (event->ctx)
 		put_ctx(event->ctx);
 
@@ -7092,6 +7095,7 @@ int perf_pmu_register(struct pmu *pmu, c
 		pmu->event_idx = perf_event_idx_default;
 
 	list_add_rcu(&pmu->entry, &pmus);
+	atomic_set(&pmu->exclusive_cnt, 0);
 	ret = 0;
 unlock:
 	mutex_unlock(&pmus_lock);
@@ -7537,6 +7541,78 @@ perf_event_set_output(struct perf_event
 	return ret;
 }
 
+static bool exclusive_event_match(struct perf_event *e1, struct perf_event *e2)
+{
+	if ((e1->pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE) &&
+	    (e1->cpu == e2->cpu ||
+	     e1->cpu == -1 ||
+	     e2->cpu == -1))
+		return true;
+	return false;
+}
+
+static bool __exclusive_event_ok(struct perf_event *event,
+				 struct perf_event_context *ctx)
+{
+	struct perf_event *iter_event;
+
+	list_for_each_entry(iter_event, &ctx->event_list, event_entry) {
+		if (exclusive_event_match(iter_event, event))
+			return false;
+	}
+
+	return true;
+}
+
+static bool exclusive_event_ok(struct perf_event *event,
+			       struct perf_event_context *ctx)
+{
+	struct pmu *pmu = event->pmu;
+	bool ret;
+
+	if (!(pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE))
+		return true;
+
+	/*
+	 * exclusive_cnt <0: cpu
+	 *               >0: tsk
+	 */
+	if (ctx->task) {
+		if (!atomic_inc_unless_negative(&pmu->exclusive_cnt))
+			return false;
+	} else {
+		if (!atomic_dec_unless_positive(&pmu->exclusive_cnt))
+			return false;
+	}
+
+	mutex_lock(&ctx->lock);
+	ret = __exclusive_event_ok(event, ctx);
+	mutex_unlock(&ctx->lock);
+
+	if (!ret) {
+		if (ctx->task)
+			atomic_dec(&pmu->exclusive_cnt);
+		else
+			atomic_inc(&pmu->exclusive_cnt);
+	}
+
+	return ret;
+}
+
+static void exclusive_event_release(struct perf_event *event)
+{
+	struct perf_event_context *ctx = event->ctx;
+	struct pmu *pmu = event->pmu;
+
+	if (!(pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE))
+		return;
+
+	if (ctx->task)
+		atomic_dec(&pmu->exclusive_cnt);
+	else
+		atomic_inc(&pmu->exclusive_cnt);
+}
+
 static void mutex_lock_double(struct mutex *a, struct mutex *b)
 {
 	if (b < a)
@@ -7702,6 +7778,15 @@ SYSCALL_DEFINE5(perf_event_open,
 		task = NULL;
 	}
 
+	if (pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE) {
+		err = -EBUSY;
+		if (group_leader)
+			goto err_context;
+
+		if (!exclusive_event_ok(event, ctx))
+			goto err_context;
+	}
+
 	/*
 	 * Look up the group leader (we will attach this event to it):
 	 */
@@ -7903,6 +7988,11 @@ perf_event_create_kernel_counter(struct
 		goto err_free;
 	}
 
+	if (!exclusive_event_ok(event, ctx)) {
+		err = -EBUSY;
+		goto err_context;
+	}
+
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
 	perf_install_in_context(ctx, event, cpu);
@@ -7911,6 +8001,9 @@ perf_event_create_kernel_counter(struct
 
 	return event;
 
+err_context:
+	perf_unpin_context(ctx);
+	put_ctx(ctx);
 err_free:
 	free_event(event);
 err:
