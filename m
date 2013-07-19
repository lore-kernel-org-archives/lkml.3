Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030273Ab3GSHxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:53:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35884 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965772Ab3GSHx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:53:28 -0400
Date: Fri, 19 Jul 2013 00:53:03 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-5936678e7da5f8d2944a2ad45d66c88b4a7ccb67@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, trenn@suse.de, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, trenn@suse.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1373556513-3000-3-git-send-email-jolsa@redhat.com>
References: <1373556513-3000-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf timechart:
  Remove event types framework only user
Git-Commit-ID: 5936678e7da5f8d2944a2ad45d66c88b4a7ccb67
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:53:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5936678e7da5f8d2944a2ad45d66c88b4a7ccb67
Gitweb:     http://git.kernel.org/tip/5936678e7da5f8d2944a2ad45d66c88b4a7ccb67
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 11 Jul 2013 17:28:30 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 15 Jul 2013 16:14:47 -0300

perf timechart: Remove event types framework only user

The only user of the event types data is 'perf timechart' command and
uses this info to identify proper tracepoints based on its name.

Switching this code to use tracepoint callbacks handlers same as another
commands like builtin-{kmem,lock,sched}.c using the
perf_session__set_tracepoints_handlers function.

This way we get rid of the only event types user and can remove them
completely in next patches.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Renninger <trenn@suse.de>
Link: http://lkml.kernel.org/r/1373556513-3000-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
