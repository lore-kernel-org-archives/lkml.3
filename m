Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789Ab3JNU0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:26:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38925 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757668Ab3JNUDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:04 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 064/161] perf trace: Add option to show full timestamp
Date: Mon, 14 Oct 2013 17:00:53 -0300
Message-Id: <1381780950-25642-65-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

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
Link: http://lkml.kernel.org/r/1378319865-55695-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-trace.txt | 4 ++++
 tools/perf/builtin-trace.c              | 7 +++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index daccd2c0a48f..a93e91aad583 100644
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
index 7ce036ee863b..bc21140ac782 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -624,6 +624,7 @@ struct trace {
 	struct perf_record_opts opts;
 	struct machine		host;
 	u64			base_time;
+	bool			full_time;
 	FILE			*output;
 	unsigned long		nr_events;
 	struct strlist		*ev_qualifier;
@@ -1066,7 +1067,7 @@ static int trace__process_sample(struct perf_tool *tool,
 	if (skip_sample(trace, sample))
 		return 0;
 
-	if (trace->base_time == 0)
+	if (!trace->full_time && trace->base_time == 0)
 		trace->base_time = sample->time;
 
 	if (handler)
@@ -1195,7 +1196,7 @@ again:
 				continue;
 			}
 
-			if (trace->base_time == 0)
+			if (!trace->full_time && trace->base_time == 0)
 				trace->base_time = sample.time;
 
 			if (type != PERF_RECORD_SAMPLE) {
@@ -1433,6 +1434,8 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 		     trace__set_duration),
 	OPT_BOOLEAN(0, "sched", &trace.sched, "show blocking scheduler events"),
 	OPT_INCR('v', "verbose", &verbose, "be more verbose"),
+	OPT_BOOLEAN('T', "time", &trace.full_time,
+		    "Show full timestamp, not time relative to first start"),
 	OPT_END()
 	};
 	int err;
-- 
1.8.1.4

