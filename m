Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaHKFb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:31:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:49307 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbaHKFb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:31:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,839,1400050800"; 
   d="scan'208";a="586295616"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v3 12/23] perf: add ITRACE_START record to indicate that tracing has started
Date: Mon, 11 Aug 2014 08:19:41 +0300
Message-Id: <1407734392-31097-13-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For counters such as instruction tracing, it is useful for the decoder
to know which tasks are running when the event is first scheduled in,
before the first sched_switch.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/linux/perf_event.h      |  3 +++
 include/uapi/linux/perf_event.h | 11 +++++++++++
 kernel/events/core.c            | 41 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index cb8c92e041..46137cb4d6 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -126,6 +126,9 @@ struct hw_perf_event {
 			/* for tp_event->class */
 			struct list_head	tp_list;
 		};
+		struct { /* itrace */
+			int			itrace_started;
+		};
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 		struct { /* breakpoint */
 			/*
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index b14b1f57c1..500e18b8e9 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -758,6 +758,17 @@ enum perf_event_type {
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
index 2de7d40cb6..d4b5e33b74 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1671,6 +1671,7 @@ static void perf_set_shadow_time(struct perf_event *event,
 #define MAX_INTERRUPTS (~0ULL)
 
 static void perf_log_throttle(struct perf_event *event, int enable);
+static void perf_log_itrace_start(struct perf_event *event);
 
 static int
 event_sched_in(struct perf_event *event,
@@ -1705,6 +1706,8 @@ event_sched_in(struct perf_event *event,
 
 	perf_pmu_disable(event->pmu);
 
+	perf_log_itrace_start(event);
+
 	if (event->pmu->add(event, PERF_EF_START)) {
 		event->state = PERF_EVENT_STATE_INACTIVE;
 		event->oncpu = -1;
@@ -5524,6 +5527,44 @@ static void perf_log_throttle(struct perf_event *event, int enable)
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
2.1.0.rc1

