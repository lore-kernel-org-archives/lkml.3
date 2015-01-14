Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbbANM1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 07:27:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:46060 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbbANM1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 07:27:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,755,1413270000"; 
   d="scan'208";a="661683849"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        Kaixu Xia <kaixu.xia@linaro.org>, acme@infradead.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v9 14/14] perf: add ITRACE_START record to indicate that tracing has started
Date: Wed, 14 Jan 2015 14:18:23 +0200
Message-Id: <1421237903-181015-15-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421237903-181015-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1421237903-181015-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For counters that generate AUX data that is bound to the context of a
running task, such as instruction tracing, the decoder needs to know
exactly which task is running when the event is first scheduled in,
before the first sched_switch. The decoder's need to know this stems
from the fact that instruction flow trace decoding will almost always
require program's object code in order to reconstruct said flow and
for that we need at least its pid/tid in the perf stream.

To single out such instruction tracing pmus, this patch introduces
ITRACE PMU capability. The reason this is not part of RECORD_AUX
record is that not all pmus capable of generating AUX data need this,
and the opposite is *probably* also true.

While sched_switch covers for most cases, there are two problems with it:
the consumer will need to process events out of order (that is, having
found RECORD_AUX, it will have to skip forward to the nearest sched_switch
to figure out which task it was, then go back to the actual trace to
decode it) and it completely misses the case when the tracing is enabled
and disabled before sched_switch, for example, via PERF_EVENT_IOC_DISABLE.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/linux/perf_event.h      |  4 ++++
 include/uapi/linux/perf_event.h | 11 +++++++++++
 kernel/events/core.c            | 41 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index b042732df7..3b6456279b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -127,6 +127,9 @@ struct hw_perf_event {
 			/* for tp_event->class */
 			struct list_head	tp_list;
 		};
+		struct { /* itrace */
+			int			itrace_started;
+		};
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 		struct { /* breakpoint */
 			/*
@@ -174,6 +177,7 @@ struct perf_event;
 #define PERF_PMU_CAP_AUX_NO_SG			0x02
 #define PERF_PMU_CAP_AUX_SW_DOUBLEBUF		0x04
 #define PERF_PMU_CAP_EXCLUSIVE			0x08
+#define PERF_PMU_CAP_ITRACE			0x10
 
 /**
  * struct pmu - generic performance monitoring unit
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 143d961857..955536d977 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -764,6 +764,17 @@ enum perf_event_type {
 	 */
 	PERF_RECORD_AUX				= 11,
 
+	/*
+	 * Indicates that instruction trace has started
+	 *
+	 * struct {
+	 *	struct perf_event_header	header;
+	 *	u32				pid;
+	 *	u32				tid;
+	 * };
+	 */
+	PERF_RECORD_ITRACE_START		= 12,
+
 	PERF_RECORD_MAX,			/* non-ABI */
 };
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index a7f3eec481..309970663c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1735,6 +1735,7 @@ static void perf_set_shadow_time(struct perf_event *event,
 #define MAX_INTERRUPTS (~0ULL)
 
 static void perf_log_throttle(struct perf_event *event, int enable);
+static void perf_log_itrace_start(struct perf_event *event);
 
 static int
 event_sched_in(struct perf_event *event,
@@ -1769,6 +1770,8 @@ event_sched_in(struct perf_event *event,
 
 	perf_pmu_disable(event->pmu);
 
+	perf_log_itrace_start(event);
+
 	if (event->pmu->add(event, PERF_EF_START)) {
 		event->state = PERF_EVENT_STATE_INACTIVE;
 		event->oncpu = -1;
@@ -5723,6 +5726,44 @@ static void perf_log_throttle(struct perf_event *event, int enable)
 	perf_output_end(&handle);
 }
 
+static void perf_log_itrace_start(struct perf_event *event)
+{
+	struct perf_output_handle handle;
+	struct perf_sample_data sample;
+	struct perf_aux_event {
+		struct perf_event_header        header;
+		u32				pid;
+		u32				tid;
+	} rec;
+	int ret;
+
+	if (event->parent)
+		event = event->parent;
+
+	if (!(event->pmu->capabilities & PERF_PMU_CAP_ITRACE) ||
+	    event->hw.itrace_started)
+		return;
+
+	event->hw.itrace_started = 1;
+
+	rec.header.type	= PERF_RECORD_ITRACE_START;
+	rec.header.misc	= 0;
+	rec.header.size	= sizeof(rec);
+	rec.pid	= perf_event_pid(event, current);
+	rec.tid	= perf_event_tid(event, current);
+
+	perf_event_header__init_id(&rec.header, &sample, event);
+	ret = perf_output_begin(&handle, event, rec.header.size);
+
+	if (ret)
+		return;
+
+	perf_output_put(&handle, rec);
+	perf_event__output_id_sample(event, &handle, &sample);
+
+	perf_output_end(&handle);
+}
+
 /*
  * Generic event overflow handling, sampling.
  */
-- 
2.1.4

