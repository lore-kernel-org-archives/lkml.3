Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3LKMmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:42:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:46009 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab3LKMmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:42:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="448281321"
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
Subject: [PATCH v0 55/71] perf report: Add Instruction Tracing support
Date: Wed, 11 Dec 2013 14:37:07 +0200
Message-Id: <1386765443-26966-56-git-send-email-alexander.shishkin@linux.intel.com>
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
 tools/perf/Documentation/perf-report.txt | 21 +++++++++++++++++++++
 tools/perf/builtin-report.c              | 12 ++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 10a2798..0c10bfb 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -237,6 +237,27 @@ OPTIONS
 	Do not show entries which have an overhead under that percent.
 	(Default: 0).
 
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
 linkperf:perf-stat[1], linkperf:perf-annotate[1]
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8cf8e66..97e3ee6 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -36,6 +36,8 @@
 #include "util/data.h"
 #include "arch/common.h"
 
+#include "util/itrace.h"
+
 #include <dlfcn.h>
 #include <linux/bitmap.h>
 
@@ -768,6 +770,7 @@ parse_percent_limit(const struct option *opt, const char *str,
 int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	struct perf_session *session;
+	struct itrace_synth_opts itrace_synth_opts = {0};
 	struct stat st;
 	bool has_br_stack = false;
 	int branch_mode = -1;
@@ -790,6 +793,10 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 			.attr		 = perf_event__process_attr,
 			.tracing_data	 = perf_event__process_tracing_data,
 			.build_id	 = perf_event__process_build_id,
+			.id_index	 = perf_event__process_id_index,
+			.itrace_info	 = perf_event__process_itrace_info,
+			.itrace		 = perf_event__process_itrace,
+			.itrace_error	 = perf_event__count_itrace_error,
 			.ordered_samples = true,
 			.ordering_requires_timestamps = true,
 		},
@@ -884,6 +891,9 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
 	OPT_CALLBACK(0, "percent-limit", &report, "percent",
 		     "Don't show entries under that percent", parse_percent_limit),
+	OPT_CALLBACK_OPTARG('Z', "itrace", &itrace_synth_opts, NULL, "opts",
+			    "Instruction Tracing options",
+			    itrace_parse_synth_opts),
 	OPT_END()
 	};
 	struct perf_data_file file = {
@@ -919,6 +929,8 @@ repeat:
 	if (session == NULL)
 		return -ENOMEM;
 
+	session->itrace_synth_opts = &itrace_synth_opts;
+
 	report.session = session;
 
 	has_br_stack = perf_header__has_feat(&session->header,
-- 
1.8.5.1

