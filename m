Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429Ab3IDShx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:37:53 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:53388 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab3IDShw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:37:52 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/3] perf trace: Add option to show full timestamp
Date: Wed,  4 Sep 2013 12:37:43 -0600
Message-Id: <1378319865-55695-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current timestamp shown for output is time relative to firt sample. This
patch adds an option to show the absolute perf_clock timestamp which is
useful when comparing output across commands (e.g., perf-trace to
perf-script).

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Documentation/perf-trace.txt |    4 ++++
 tools/perf/builtin-trace.c              |    7 +++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index daccd2c..a93e91a 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -78,6 +78,10 @@ the thread executes on the designated CPUs. Default is to monitor all CPUs.
 --input
 	Process events from a given perf data file.
 
+-T
+--time
+	Print full timestamp rather time relative to first sample.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script[1]
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 6730862..9ef489c 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -605,6 +605,7 @@ struct trace {
 	struct perf_record_opts opts;
 	struct machine		host;
 	u64			base_time;
+	bool			full_time;
 	FILE			*output;
 	unsigned long		nr_events;
 	struct strlist		*ev_qualifier;
@@ -1047,7 +1048,7 @@ static int trace__process_sample(struct perf_tool *tool,
 	if (skip_sample(trace, sample))
 		return 0;
 
-	if (trace->base_time == 0)
+	if (!trace->full_time && trace->base_time == 0)
 		trace->base_time = sample->time;
 
 	if (handler)
@@ -1176,7 +1177,7 @@ again:
 				continue;
 			}
 
-			if (trace->base_time == 0)
+			if (!trace->full_time && trace->base_time == 0)
 				trace->base_time = sample.time;
 
 			if (type != PERF_RECORD_SAMPLE) {
@@ -1413,6 +1414,8 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 		     trace__set_duration),
 	OPT_BOOLEAN(0, "sched", &trace.sched, "show blocking scheduler events"),
 	OPT_INCR('v', "verbose", &verbose, "be more verbose"),
+	OPT_BOOLEAN('T', "time", &trace.full_time,
+		    "Show full timestamp, not time relative to first start"),
 	OPT_END()
 	};
 	int err;
-- 
1.7.10.1

