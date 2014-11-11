Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaKKOWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:22:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:38869 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbaKKOUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:20:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="630152316"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 23/25] perf inject: Add Instruction Tracing support
Date: Tue, 11 Nov 2014 16:17:01 +0200
Message-Id: <1415715423-15563-24-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
References: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for decoding an Instruction Trace.  The
Instruction Tracing events are stripped and replaced
by synthesized events.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-inject.txt | 27 ++++++++++++
 tools/perf/builtin-inject.c              | 71 +++++++++++++++++++++++++++++++-
 2 files changed, 96 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-inject.txt b/tools/perf/Documentation/perf-inject.txt
index dc7442c..9f49c43 100644
--- a/tools/perf/Documentation/perf-inject.txt
+++ b/tools/perf/Documentation/perf-inject.txt
@@ -44,6 +44,33 @@ OPTIONS
 --kallsyms=<file>::
 	kallsyms pathname
 
+-Z::
+--itrace::
+	Decode Instruction Tracing data, replacing it with synthesized events.
+	Options are:
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
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-report[1], linkperf:perf-archive[1]
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 29e0840..c3323ea 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -16,6 +16,7 @@
 #include "util/debug.h"
 #include "util/build-id.h"
 #include "util/data.h"
+#include "util/itrace.h"
 
 #include "util/parse-options.h"
 
@@ -30,6 +31,7 @@ struct perf_inject {
 	struct perf_data_file	output;
 	u64			bytes_written;
 	struct list_head	samples;
+	struct itrace_synth_opts itrace_synth_opts;
 };
 
 struct event_entry {
@@ -198,6 +200,32 @@ static int perf_event__repipe_fork(struct perf_tool *tool,
 	return err;
 }
 
+static int perf_event__repipe_comm(struct perf_tool *tool,
+				   union perf_event *event,
+				   struct perf_sample *sample,
+				   struct machine *machine)
+{
+	int err;
+
+	err = perf_event__process_comm(tool, event, sample, machine);
+	perf_event__repipe(tool, event, sample, machine);
+
+	return err;
+}
+
+static int perf_event__repipe_exit(struct perf_tool *tool,
+				   union perf_event *event,
+				   struct perf_sample *sample,
+				   struct machine *machine)
+{
+	int err;
+
+	err = perf_event__process_exit(tool, event, sample, machine);
+	perf_event__repipe(tool, event, sample, machine);
+
+	return err;
+}
+
 static int perf_event__repipe_tracing_data(struct perf_tool *tool,
 					   union perf_event *event,
 					   struct perf_session *session)
@@ -210,6 +238,18 @@ static int perf_event__repipe_tracing_data(struct perf_tool *tool,
 	return err;
 }
 
+static int perf_event__repipe_id_index(struct perf_tool *tool,
+				       union perf_event *event,
+				       struct perf_session *session)
+{
+	int err;
+
+	perf_event__repipe_synth(tool, event);
+	err = perf_event__process_id_index(tool, event, session);
+
+	return err;
+}
+
 static int dso__read_build_id(struct dso *dso)
 {
 	if (dso->has_build_id)
@@ -393,16 +433,20 @@ static int __cmd_inject(struct perf_inject *inject)
 	int ret = -EINVAL;
 	struct perf_session *session = inject->session;
 	struct perf_data_file *file_out = &inject->output;
+	u64 output_data_offset;
 
 	signal(SIGINT, sig_handler);
 
-	if (inject->build_ids || inject->sched_stat) {
+	if (inject->build_ids || inject->sched_stat ||
+	    inject->itrace_synth_opts.set) {
 		inject->tool.mmap	  = perf_event__repipe_mmap;
 		inject->tool.mmap2	  = perf_event__repipe_mmap2;
 		inject->tool.fork	  = perf_event__repipe_fork;
 		inject->tool.tracing_data = perf_event__repipe_tracing_data;
 	}
 
+	output_data_offset = session->header.data_offset;
+
 	if (inject->build_ids) {
 		inject->tool.sample = perf_event__inject_buildid;
 	} else if (inject->sched_stat) {
@@ -423,10 +467,22 @@ static int __cmd_inject(struct perf_inject *inject)
 			else if (!strncmp(name, "sched:sched_stat_", 17))
 				evsel->handler = perf_inject__sched_stat;
 		}
+	} else if (inject->itrace_synth_opts.set) {
+		session->itrace_synth_opts = &inject->itrace_synth_opts;
+		inject->itrace_synth_opts.inject = true;
+		inject->tool.comm	    = perf_event__repipe_comm;
+		inject->tool.exit	    = perf_event__repipe_exit;
+		inject->tool.id_index	    = perf_event__repipe_id_index;
+		inject->tool.itrace_info    = perf_event__process_itrace_info;
+		inject->tool.itrace	    = perf_event__process_itrace;
+		inject->tool.ordered_events = true;
+		inject->tool.ordering_requires_timestamps = true;
+		/* Allow space in the header for new attributes */
+		output_data_offset = 4096;
 	}
 
 	if (!file_out->is_pipe)
-		lseek(file_out->fd, session->header.data_offset, SEEK_SET);
+		lseek(file_out->fd, output_data_offset, SEEK_SET);
 
 	ret = perf_session__process_events(session, &inject->tool);
 
@@ -434,6 +490,14 @@ static int __cmd_inject(struct perf_inject *inject)
 		if (inject->build_ids)
 			perf_header__set_feat(&session->header,
 					      HEADER_BUILD_ID);
+		/*
+		 * The instruction traces have been removed and replaced with
+		 * synthesized hardware events, so clear the feature flag.
+		 */
+		if (inject->itrace_synth_opts.set)
+			perf_header__clear_feat(&session->header,
+						HEADER_ITRACE);
+		session->header.data_offset = output_data_offset;
 		session->header.data_size = inject->bytes_written;
 		perf_session__write_header(session, session->evlist, file_out->fd, true);
 	}
@@ -490,6 +554,9 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 			 "be more verbose (show build ids, etc)"),
 		OPT_STRING(0, "kallsyms", &symbol_conf.kallsyms_name, "file",
 			   "kallsyms pathname"),
+		OPT_CALLBACK_OPTARG('Z', "itrace", &inject.itrace_synth_opts,
+				    NULL, "opts", "Instruction Tracing options",
+				    itrace_parse_synth_opts),
 		OPT_END()
 	};
 	const char * const inject_usage[] = {
-- 
1.9.1

