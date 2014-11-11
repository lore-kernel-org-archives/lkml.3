Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaKKOUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:20:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:38869 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbaKKOUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:20:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="630152252"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 19/25] perf script: Add Instruction Tracing support
Date: Tue, 11 Nov 2014 16:16:57 +0200
Message-Id: <1415715423-15563-20-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
References: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for decoding an Instruction Trace.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-script.txt | 28 ++++++++++++++++++++++++++++
 tools/perf/builtin-script.c              | 11 +++++++++++
 2 files changed, 39 insertions(+)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 2149480..f89f3be 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -215,6 +215,34 @@ OPTIONS
 --header-only
 	Show only perf.data header.
 
+-Z::
+--itrace::
+	Options for decoding Instruction Tracing data. The options are:
+
+		i	synthesize instructions events
+		b	synthesize branches events
+		c	synthesize branches events (calls only)
+		r	synthesize branches events (returns only)
+		e	synthesize error events
+		d	create a debug log
+		g	synthesize a call chain for instructions events
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
+	Also the call chain size (default 16, max. 1024) for instructions
+	events can be specified.
+
+	To disable decoding entirely, use --no-itrace.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script-perl[1],
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index ce304df..dbffd00 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -16,6 +16,7 @@
 #include "util/evsel.h"
 #include "util/sort.h"
 #include "util/data.h"
+#include "util/itrace.h"
 #include <linux/bitmap.h>
 
 static char const		*script_name;
@@ -1505,6 +1506,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 	char *rec_script_path = NULL;
 	char *rep_script_path = NULL;
 	struct perf_session *session;
+	struct itrace_synth_opts itrace_synth_opts = {0};
 	char *script_path = NULL;
 	const char **__argv;
 	int i, j, err = 0;
@@ -1519,6 +1521,10 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 			.attr		 = process_attr,
 			.tracing_data	 = perf_event__process_tracing_data,
 			.build_id	 = perf_event__process_build_id,
+			.id_index	 = perf_event__process_id_index,
+			.itrace_info	 = perf_event__process_itrace_info,
+			.itrace		 = perf_event__process_itrace,
+			.itrace_error	 = perf_event__process_itrace_error,
 			.ordered_events	 = true,
 			.ordering_requires_timestamps = true,
 		},
@@ -1570,6 +1576,9 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Show the fork/comm/exit events"),
 	OPT_BOOLEAN('\0', "show-mmap-events", &script.show_mmap_events,
 		    "Show the mmap events"),
+	OPT_CALLBACK_OPTARG('Z', "itrace", &itrace_synth_opts, NULL, "opts",
+			    "Instruction Tracing options",
+			    itrace_parse_synth_opts),
 	OPT_END()
 	};
 	const char * const script_usage[] = {
@@ -1767,6 +1776,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	script.session = session;
 
+	session->itrace_synth_opts = &itrace_synth_opts;
+
 	if (cpu_list) {
 		err = perf_session__cpu_bitmap(session, cpu_list, cpu_bitmap);
 		if (err < 0)
-- 
1.9.1

