Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaKKOXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:23:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:38869 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbaKKOUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:20:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="630152279"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 21/25] perf report: Add Instruction Tracing support
Date: Tue, 11 Nov 2014 16:16:59 +0200
Message-Id: <1415715423-15563-22-git-send-email-adrian.hunter@intel.com>
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
 tools/perf/Documentation/perf-report.txt | 28 ++++++++++++++++++++++++++++
 tools/perf/builtin-report.c              | 12 ++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 0927bf4..34530db 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -308,6 +308,34 @@ OPTIONS
 --header-only::
 	Show only perf.data header (forces --stdio).
 
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
 linkperf:perf-stat[1], linkperf:perf-annotate[1]
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 140a6cd..1b92c3d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -36,6 +36,8 @@
 #include "util/data.h"
 #include "arch/common.h"
 
+#include "util/itrace.h"
+
 #include <dlfcn.h>
 #include <linux/bitmap.h>
 
@@ -572,6 +574,7 @@ parse_percent_limit(const struct option *opt, const char *str,
 int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	struct perf_session *session;
+	struct itrace_synth_opts itrace_synth_opts = {0};
 	struct stat st;
 	bool has_br_stack = false;
 	int branch_mode = -1;
@@ -593,6 +596,10 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 			.attr		 = perf_event__process_attr,
 			.tracing_data	 = perf_event__process_tracing_data,
 			.build_id	 = perf_event__process_build_id,
+			.id_index	 = perf_event__process_id_index,
+			.itrace_info	 = perf_event__process_itrace_info,
+			.itrace		 = perf_event__process_itrace,
+			.itrace_error	 = perf_event__count_itrace_error,
 			.ordered_events	 = true,
 			.ordering_requires_timestamps = true,
 		},
@@ -696,6 +703,9 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		     "Don't show entries under that percent", parse_percent_limit),
 	OPT_CALLBACK(0, "percentage", NULL, "relative|absolute",
 		     "how to display percentage of filtered entries", parse_filter_percentage),
+	OPT_CALLBACK_OPTARG('Z', "itrace", &itrace_synth_opts, NULL, "opts",
+			    "Instruction Tracing options",
+			    itrace_parse_synth_opts),
 	OPT_END()
 	};
 	struct perf_data_file file = {
@@ -740,6 +750,8 @@ repeat:
 					       report.queue_size);
 	}
 
+	session->itrace_synth_opts = &itrace_synth_opts;
+
 	report.session = session;
 
 	has_br_stack = perf_header__has_feat(&session->header,
-- 
1.9.1

