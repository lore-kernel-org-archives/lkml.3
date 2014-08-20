Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaHTMmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:42:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:57745 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbaHTMms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:42:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,902,1400050800"; 
   d="scan'208";a="590749957"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v4 11/22] perf: add ITRACE_START record to indicate that tracing has started
Date: Wed, 20 Aug 2014 15:36:08 +0300
Message-Id: <1408538179-792-12-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For counters such as instruction tracing, it is useful for the decoder
to know which tasks are running when the event is first scheduled in,
before the first sched_switch.

To single out such instruction tracing pmus, this patch alse introduces
ITRACE PMU capability.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/linux/perf_event.h      |  4 ++++
 include/uapi/linux/perf_event.h | 11 +++++++++++
 kernel/events/core.c            | 41 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 63016a0e32..bcfd7a9d84 100644
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
index 507b5e1f5b..349c261f93 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -752,6 +752,17 @@ enum perf_event_type {
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
index c4551ac324..b82392911a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1722,6 +1722,7 @@ static void perf_set_shadow_time(struct perf_event *event,
 #define MAX_INTERRUPTS (~0ULL)
 
 static void perf_log_throttle(struct perf_event *event, int enable);
+static void perf_log_itrace_start(struct perf_event *event);
 
 static int
 event_sched_in(struct perf_event *event,
@@ -1756,6 +1757,8 @@ event_sched_in(struct perf_event *event,
 
 	perf_pmu_disable(event->pmu);
 
+	perf_log_itrace_start(event);
+
 	if (event->pmu->add(event, PERF_EF_START)) {
 		event->state = PERF_EVENT_STATE_INACTIVE;
 		event->oncpu = -1;
@@ -5623,6 +5626,44 @@ static void perf_log_throttle(struct perf_event *event, int enable)
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
2.1.0

