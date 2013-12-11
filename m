Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab3LKMqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:46:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:13714 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab3LKMnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:43:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="442369976"
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
Subject: [PATCH v0 61/71] perf inject: Add Instruction Tracing support
Date: Wed, 11 Dec 2013 14:37:13 +0200
Message-Id: <1386765443-26966-62-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add support for decoding an Instruction Trace.  The
Instruction Tracing events are stripped and replaced
by synthesized events.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-inject.txt | 20 +++++++++
 tools/perf/builtin-inject.c              | 71 +++++++++++++++++++++++++++++++-
 2 files changed, 89 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-inject.txt b/tools/perf/Documentation/perf-inject.txt
index a00a342..c64cfea 100644
--- a/tools/perf/Documentation/perf-inject.txt
+++ b/tools/perf/Documentation/perf-inject.txt
@@ -41,6 +41,26 @@ OPTIONS
 	tasks slept. sched_switch contains a callchain where a task slept and
 	sched_stat contains a timeslice how long a task slept.
 
+-Z::
+--itrace::
+	Decode Instruction Tracing data, replacing it with synthesized events.
+	Options are:
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
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-report[1], linkperf:perf-archive[1]
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 8c47982..feeeb56 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -16,6 +16,7 @@
 #include "util/debug.h"
 #include "util/build-id.h"
 #include "util/data.h"
+#include "util/itrace.h"
 
 #include "util/parse-options.h"
 
@@ -30,6 +31,7 @@ struct perf_inject {
 			 output;
 	u64		 bytes_written;
 	struct list_head samples;
+	struct itrace_synth_opts itrace_synth_opts;
 };
 
 struct event_entry {
@@ -202,6 +204,32 @@ static int perf_event__repipe_fork(struct perf_tool *tool,
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
@@ -214,6 +242,18 @@ static int perf_event__repipe_tracing_data(struct perf_tool *tool,
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
@@ -402,10 +442,12 @@ static int __cmd_inject(struct perf_inject *inject)
 		.path = inject->input_name,
 		.mode = PERF_DATA_MODE_READ,
 	};
+	u64 output_data_offset;
 
 	signal(SIGINT, sig_handler);
 
-	if (inject->build_ids || inject->sched_stat) {
+	if (inject->build_ids || inject->sched_stat ||
+	    inject->itrace_synth_opts.set) {
 		inject->tool.mmap	  = perf_event__repipe_mmap;
 		inject->tool.mmap2	  = perf_event__repipe_mmap2;
 		inject->tool.fork	  = perf_event__repipe_fork;
@@ -416,6 +458,8 @@ static int __cmd_inject(struct perf_inject *inject)
 	if (session == NULL)
 		return -ENOMEM;
 
+	output_data_offset = session->header.data_offset;
+
 	if (inject->build_ids) {
 		inject->tool.sample = perf_event__inject_buildid;
 	} else if (inject->sched_stat) {
@@ -436,14 +480,34 @@ static int __cmd_inject(struct perf_inject *inject)
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
+		inject->tool.ordered_samples = true;
+		inject->tool.ordering_requires_timestamps = true;
+		/* Allow space in the header for new attributes */
+		output_data_offset = 4096;
 	}
 
 	if (!inject->pipe_output)
-		lseek(inject->output, session->header.data_offset, SEEK_SET);
+		lseek(inject->output, output_data_offset, SEEK_SET);
 
 	ret = perf_session__process_events(session, &inject->tool);
 
 	if (!inject->pipe_output) {
+		/*
+		 * The instruction traces have been removed and replaced with
+		 * synthesized hardware events, so clear the feature flag.
+		 */
+		if (inject->itrace_synth_opts.set)
+			perf_header__clear_feat(&session->header,
+						HEADER_ITRACE);
+		session->header.data_offset = output_data_offset;
 		session->header.data_size = inject->bytes_written;
 		perf_session__write_header(session, session->evlist, inject->output, true);
 	}
@@ -493,6 +557,9 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 			    "where and how long tasks slept"),
 		OPT_INCR('v', "verbose", &verbose,
 			 "be more verbose (show build ids, etc)"),
+		OPT_CALLBACK_OPTARG('Z', "itrace", &inject.itrace_synth_opts,
+				    NULL, "opts", "Instruction Tracing options",
+				    itrace_parse_synth_opts),
 		OPT_END()
 	};
 	const char * const inject_usage[] = {
-- 
1.8.5.1

