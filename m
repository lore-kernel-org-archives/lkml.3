Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab3GIQu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:50:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab3GIQuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:50:22 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Renninger <trenn@suse.de>
Subject: [PATCH 1/4] perf tools: Remove event types framework only user
Date: Tue,  9 Jul 2013 18:48:56 +0200
Message-Id: <1373388539-9347-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1373388539-9347-1-git-send-email-jolsa@redhat.com>
References: <1373388539-9347-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only user of the event types data is 'perf timechart'
command and uses this info to identify proper tracepoints
based on its name.

Switching this code to use traceevent library API to obtain
IDs for needed tracepoints. This should also make the samples
processing faster as we no longer compare strings but numbers.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Thomas Renninger <trenn@suse.de>
---
 tools/perf/builtin-timechart.c | 94 +++++++++++++++++++++++-------------------
 1 file changed, 51 insertions(+), 43 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 4536a92..852f11ed 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -12,6 +12,8 @@
  * of the License.
  */
 
+#include <traceevent/event-parse.h>
+
 #include "builtin.h"
 
 #include "util/util.h"
@@ -47,6 +49,16 @@ static u64		first_time, last_time;
 
 static bool		power_only;
 
+static u32 tp_power_cpu_idle;
+static u32 tp_power_cpu_frequency;
+static u32 tp_sched_sched_wakeup;
+static u32 tp_sched_sched_switch;
+
+#ifdef SUPPORT_OLD_POWER_EVENTS
+static u32 tp_power_power_start;
+static u32 tp_power_power_end;
+static u32 tp_power_power_frequency;
+#endif
 
 struct per_pid;
 struct per_pidcomm;
@@ -328,25 +340,6 @@ struct wakeup_entry {
 	int   success;
 };
 
-/*
- * trace_flag_type is an enumeration that holds different
- * states when a trace occurs. These are:
- *  IRQS_OFF            - interrupts were disabled
- *  IRQS_NOSUPPORT      - arch does not support irqs_disabled_flags
- *  NEED_RESCED         - reschedule is requested
- *  HARDIRQ             - inside an interrupt handler
- *  SOFTIRQ             - inside a softirq handler
- */
-enum trace_flag_type {
-	TRACE_FLAG_IRQS_OFF		= 0x01,
-	TRACE_FLAG_IRQS_NOSUPPORT	= 0x02,
-	TRACE_FLAG_NEED_RESCHED		= 0x04,
-	TRACE_FLAG_HARDIRQ		= 0x08,
-	TRACE_FLAG_SOFTIRQ		= 0x10,
-};
-
-
-
 struct sched_switch {
 	struct trace_entry te;
 	char prev_comm[TASK_COMM_LEN];
@@ -497,59 +490,42 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 
 	te = (void *)sample->raw_data;
 	if ((evsel->attr.sample_type & PERF_SAMPLE_RAW) && sample->raw_size > 0) {
-		char *event_str;
 #ifdef SUPPORT_OLD_POWER_EVENTS
 		struct power_entry_old *peo;
 		peo = (void *)te;
 #endif
-		/*
-		 * FIXME: use evsel, its already mapped from id to perf_evsel,
-		 * remove perf_header__find_event infrastructure bits.
-		 * Mapping all these "power:cpu_idle" strings to the tracepoint
-		 * ID and then just comparing against evsel->attr.config.
-		 *
-		 * e.g.:
-		 *
-		 * if (evsel->attr.config == power_cpu_idle_id)
-		 */
-		event_str = perf_header__find_event(te->type);
-
-		if (!event_str)
-			return 0;
 
 		if (sample->cpu > numcpus)
 			numcpus = sample->cpu;
 
-		if (strcmp(event_str, "power:cpu_idle") == 0) {
+		if (evsel->attr.config == tp_power_cpu_idle) {
 			struct power_processor_entry *ppe = (void *)te;
 			if (ppe->state == (u32)PWR_EVENT_EXIT)
 				c_state_end(ppe->cpu_id, sample->time);
 			else
 				c_state_start(ppe->cpu_id, sample->time,
 					      ppe->state);
-		}
-		else if (strcmp(event_str, "power:cpu_frequency") == 0) {
+		} else if (evsel->attr.config == tp_power_cpu_frequency) {
 			struct power_processor_entry *ppe = (void *)te;
 			p_state_change(ppe->cpu_id, sample->time, ppe->state);
 		}
 
-		else if (strcmp(event_str, "sched:sched_wakeup") == 0)
+		else if (evsel->attr.config == tp_sched_sched_wakeup)
 			sched_wakeup(sample->cpu, sample->time, sample->pid, te);
 
-		else if (strcmp(event_str, "sched:sched_switch") == 0)
+		else if (evsel->attr.config == tp_sched_sched_switch)
 			sched_switch(sample->cpu, sample->time, te);
 
 #ifdef SUPPORT_OLD_POWER_EVENTS
 		if (use_old_power_events) {
-			if (strcmp(event_str, "power:power_start") == 0)
+			if (evsel->attr.config == tp_power_power_start)
 				c_state_start(peo->cpu_id, sample->time,
 					      peo->value);
 
-			else if (strcmp(event_str, "power:power_end") == 0)
+			else if (evsel->attr.config == tp_power_power_end)
 				c_state_end(sample->cpu, sample->time);
 
-			else if (strcmp(event_str,
-					"power:power_frequency") == 0)
+			else if (evsel->attr.config == tp_power_power_frequency)
 				p_state_change(peo->cpu_id, sample->time,
 					       peo->value);
 		}
@@ -965,6 +941,35 @@ static void write_svg_file(const char *filename)
 	svg_close();
 }
 
+static int get_id(const char *sys, const char *name, u32 *id)
+{
+	struct event_format *format;
+
+	format = event_format__new(sys, name);
+	if (!format)
+		return -1;
+
+	*id = format->id;
+	pevent_free_format(format);
+	return 0;
+}
+
+static int resolve_tracepoints(void)
+{
+	if (get_id("power", "cpu_idle", &tp_power_cpu_idle) ||
+	    get_id("power", "cpu_frequency", &tp_power_cpu_frequency) ||
+	    get_id("sched", "sched_wakeup", &tp_sched_sched_wakeup) ||
+#ifdef SUPPORT_OLD_POWER_EVENTS
+	    get_id("power", "power_start", &tp_power_power_start) ||
+	    get_id("power", "power_end", &tp_power_power_end) ||
+	    get_id("power", "power_frequency", &tp_power_power_frequency) ||
+#endif
+	    get_id("sched", "sched_switch", &tp_sched_sched_switch))
+		return -1;
+
+	return 0;
+}
+
 static int __cmd_timechart(const char *output_name)
 {
 	struct perf_tool perf_timechart = {
@@ -984,6 +989,9 @@ static int __cmd_timechart(const char *output_name)
 	if (!perf_session__has_traces(session, "timechart record"))
 		goto out_delete;
 
+	if (resolve_tracepoints())
+		goto out_delete;
+
 	ret = perf_session__process_events(session, &perf_timechart);
 	if (ret)
 		goto out_delete;
-- 
1.7.11.7

