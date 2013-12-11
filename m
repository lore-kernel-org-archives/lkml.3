Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab3LKMsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:48:17 -0500
Received: from mga14.intel.com ([143.182.124.37]:18915 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636Ab3LKMmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:42:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="442369685"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 53/71] perf script: Add Instruction Tracing support
Date: Wed, 11 Dec 2013 14:37:05 +0200
Message-Id: <1386765443-26966-54-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add support for decoding an Instruction Trace.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-script.txt | 21 +++++++++++++++++++++
 tools/perf/builtin-script.c              | 11 +++++++++++
 2 files changed, 32 insertions(+)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index cfdbb1e..f9ad25e 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -209,6 +209,27 @@ OPTIONS
 --show-mmap-events
 	Display mmap related events (e.g. MMAP, MMAP2).
 
+-Z::
+--itrace::
+	Options for decoding Instruction Tracing data. The options are:
+
+		i	synthesize instructions events
+		b	synthesize branches events
+		e	synthesize error events
+
+	The default is all events i.e. the same as -Zibe
+
+	In addition, the period (default 1000) for instructions events can be
+	specified in units of:
+
+		i	instructions (default)
+		t	ticks
+		ms	milliseconds
+		us	microseconds
+		ns	nanoseconds
+
+	To disable decoding entirely, use --no-itrace.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script-perl[1],
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 4484886..96cdcd8 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -16,6 +16,7 @@
 #include "util/evsel.h"
 #include "util/sort.h"
 #include "util/data.h"
+#include "util/itrace.h"
 #include <linux/bitmap.h>
 
 static char const		*script_name;
@@ -1487,6 +1488,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 	char *rec_script_path = NULL;
 	char *rep_script_path = NULL;
 	struct perf_session *session;
+	struct itrace_synth_opts itrace_synth_opts = {0};
 	char *script_path = NULL;
 	const char **__argv;
 	int i, j, err;
@@ -1501,6 +1503,10 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 			.attr		 = process_attr,
 			.tracing_data	 = perf_event__process_tracing_data,
 			.build_id	 = perf_event__process_build_id,
+			.id_index	 = perf_event__process_id_index,
+			.itrace_info	 = perf_event__process_itrace_info,
+			.itrace		 = perf_event__process_itrace,
+			.itrace_error	 = perf_event__process_itrace_error,
 			.ordered_samples = true,
 			.ordering_requires_timestamps = true,
 		},
@@ -1550,6 +1556,9 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Show the fork/comm/exit events"),
 	OPT_BOOLEAN('\0', "show-mmap-events", &script.show_mmap_events,
 		    "Show the mmap events"),
+	OPT_CALLBACK_OPTARG('Z', "itrace", &itrace_synth_opts, NULL, "opts",
+			    "Instruction Tracing options",
+			    itrace_parse_synth_opts),
 	OPT_END()
 	};
 	const char * const script_usage[] = {
@@ -1740,6 +1749,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	script.session = session;
 
+	session->itrace_synth_opts = &itrace_synth_opts;
+
 	if (cpu_list) {
 		if (perf_session__cpu_bitmap(session, cpu_list, cpu_bitmap))
 			return -1;
-- 
1.8.5.1

