Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab3GKP3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 11:29:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756235Ab3GKP3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 11:29:10 -0400
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
Subject: [PATCH 2/5] perf tools: Remove event types framework only user
Date: Thu, 11 Jul 2013 17:28:30 +0200
Message-Id: <1373556513-3000-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1373556513-3000-1-git-send-email-jolsa@redhat.com>
References: <1373556513-3000-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only user of the event types data is 'perf timechart'
command and uses this info to identify proper tracepoints
based on its name.

Switching this code to use tracepoint callbacks handlers
same as another commands like builtin-{kmem,lock,sched}.c
using the perf_session__set_tracepoints_handlers function.

This way we get rid of the only event types user and can
remove them completely in next patches.

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
 tools/perf/builtin-timechart.c | 155 ++++++++++++++++++++++++++---------------
 1 file changed, 97 insertions(+), 58 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index a512009..c2e0231 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -21,6 +21,7 @@
 #include "util/color.h"
 #include <linux/list.h>
 #include "util/cache.h"
+#include "util/evlist.h"
 #include "util/evsel.h"
 #include <linux/rbtree.h>
 #include "util/symbol.h"
@@ -462,6 +463,8 @@ static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te)
 	}
 }
 
+typedef int (*tracepoint_handler)(struct perf_evsel *evsel,
+				  struct perf_sample *sample);
 
 static int process_sample_event(struct perf_tool *tool __maybe_unused,
 				union perf_event *event __maybe_unused,
@@ -469,8 +472,6 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 				struct perf_evsel *evsel,
 				struct machine *machine __maybe_unused)
 {
-	struct trace_entry *te;
-
 	if (evsel->attr.sample_type & PERF_SAMPLE_TIME) {
 		if (!first_time || first_time > sample->time)
 			first_time = sample->time;
@@ -478,69 +479,90 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 			last_time = sample->time;
 	}
 
-	te = (void *)sample->raw_data;
-	if ((evsel->attr.sample_type & PERF_SAMPLE_RAW) && sample->raw_size > 0) {
-		char *event_str;
-#ifdef SUPPORT_OLD_POWER_EVENTS
-		struct power_entry_old *peo;
-		peo = (void *)te;
-#endif
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
-
-		if (sample->cpu > numcpus)
-			numcpus = sample->cpu;
-
-		if (strcmp(event_str, "power:cpu_idle") == 0) {
-			struct power_processor_entry *ppe = (void *)te;
-			if (ppe->state == (u32)PWR_EVENT_EXIT)
-				c_state_end(ppe->cpu_id, sample->time);
-			else
-				c_state_start(ppe->cpu_id, sample->time,
-					      ppe->state);
-		}
-		else if (strcmp(event_str, "power:cpu_frequency") == 0) {
-			struct power_processor_entry *ppe = (void *)te;
-			p_state_change(ppe->cpu_id, sample->time, ppe->state);
-		}
+	if (sample->cpu > numcpus)
+		numcpus = sample->cpu;
+
+	if (evsel->handler.func != NULL) {
+		tracepoint_handler f = evsel->handler.func;
+		return f(evsel, sample);
+	}
+
+	return 0;
+}
+
+static int
+process_sample_cpu_idle(struct perf_evsel *evsel __maybe_unused,
+			struct perf_sample *sample)
+{
+	struct power_processor_entry *ppe = sample->raw_data;
+
+	if (ppe->state == (u32) PWR_EVENT_EXIT)
+		c_state_end(ppe->cpu_id, sample->time);
+	else
+		c_state_start(ppe->cpu_id, sample->time, ppe->state);
+	return 0;
+}
+
+static int
+process_sample_cpu_frequency(struct perf_evsel *evsel __maybe_unused,
+			     struct perf_sample *sample)
+{
+	struct power_processor_entry *ppe = sample->raw_data;
+
+	p_state_change(ppe->cpu_id, sample->time, ppe->state);
+	return 0;
+}
 
-		else if (strcmp(event_str, "sched:sched_wakeup") == 0)
-			sched_wakeup(sample->cpu, sample->time, sample->pid, te);
+static int
+process_sample_sched_wakeup(struct perf_evsel *evsel __maybe_unused,
+			    struct perf_sample *sample)
+{
+	struct trace_entry *te = sample->raw_data;
 
-		else if (strcmp(event_str, "sched:sched_switch") == 0)
-			sched_switch(sample->cpu, sample->time, te);
+	sched_wakeup(sample->cpu, sample->time, sample->pid, te);
+	return 0;
+}
+
+static int
+process_sample_sched_switch(struct perf_evsel *evsel __maybe_unused,
+			    struct perf_sample *sample)
+{
+	struct trace_entry *te = sample->raw_data;
+
+	sched_switch(sample->cpu, sample->time, te);
+	return 0;
+}
 
 #ifdef SUPPORT_OLD_POWER_EVENTS
-		if (use_old_power_events) {
-			if (strcmp(event_str, "power:power_start") == 0)
-				c_state_start(peo->cpu_id, sample->time,
-					      peo->value);
-
-			else if (strcmp(event_str, "power:power_end") == 0)
-				c_state_end(sample->cpu, sample->time);
-
-			else if (strcmp(event_str,
-					"power:power_frequency") == 0)
-				p_state_change(peo->cpu_id, sample->time,
-					       peo->value);
-		}
-#endif
-	}
+static int
+process_sample_power_start(struct perf_evsel *evsel __maybe_unused,
+			   struct perf_sample *sample)
+{
+	struct power_entry_old *peo = sample->raw_data;
+
+	c_state_start(peo->cpu_id, sample->time, peo->value);
 	return 0;
 }
 
+static int
+process_sample_power_end(struct perf_evsel *evsel __maybe_unused,
+			 struct perf_sample *sample)
+{
+	c_state_end(sample->cpu, sample->time);
+	return 0;
+}
+
+static int
+process_sample_power_frequency(struct perf_evsel *evsel __maybe_unused,
+			       struct perf_sample *sample)
+{
+	struct power_entry_old *peo = sample->raw_data;
+
+	p_state_change(peo->cpu_id, sample->time, peo->value);
+	return 0;
+}
+#endif /* SUPPORT_OLD_POWER_EVENTS */
+
 /*
  * After the last sample we need to wrap up the current C/P state
  * and close out each CPU for these.
@@ -957,6 +979,17 @@ static int __cmd_timechart(const char *output_name)
 		.sample		 = process_sample_event,
 		.ordered_samples = true,
 	};
+	const struct perf_evsel_str_handler power_tracepoints[] = {
+		{ "power:cpu_idle",		process_sample_cpu_idle },
+		{ "power:cpu_frequency",	process_sample_cpu_frequency },
+		{ "sched:sched_wakeup",		process_sample_sched_wakeup },
+		{ "sched:sched_switch",		process_sample_sched_switch },
+#ifdef SUPPORT_OLD_POWER_EVENTS
+		{ "power:power_start",		process_sample_power_start },
+		{ "power:power_end",		process_sample_power_end },
+		{ "power:power_frequency",	process_sample_power_frequency },
+#endif
+	};
 	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
 							 0, false, &perf_timechart);
 	int ret = -EINVAL;
@@ -967,6 +1000,12 @@ static int __cmd_timechart(const char *output_name)
 	if (!perf_session__has_traces(session, "timechart record"))
 		goto out_delete;
 
+	if (perf_session__set_tracepoints_handlers(session,
+						   power_tracepoints)) {
+		pr_err("Initializing session tracepoint handlers failed\n");
+		goto out_delete;
+	}
+
 	ret = perf_session__process_events(session, &perf_timechart);
 	if (ret)
 		goto out_delete;
-- 
1.7.11.7

