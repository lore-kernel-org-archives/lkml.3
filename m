Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbbA2IKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:10:00 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50929 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbbA2IJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:09:57 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Milian Wolff <mail@milianw.de>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 03/42] perf record: Show precise number of samples
Date: Thu, 29 Jan 2015 17:06:44 +0900
Message-Id: <1422518843-25818-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After perf record finishes, it prints file size and number of samples
in the file but this info is wrong since it assumes typical sample
size of 24 bytes and divides file size by the value.

However as we post-process recorded samples for build-id, it can show
correct number like below.  If build-id post-processing is not requested
just omit the wrong number of samples.

  $ perf record noploop 1
    [ perf record: Woken up 1 times to write data ]
    [ perf record: Captured and wrote 0.159 MB perf.data (3989 samples) ]

  $ perf report --stdio -n
  # To display the perf.data header info, please use --header/--header-only options.
  #
  # Samples: 3K of event 'cycles'
  # Event count (approx.): 3771330663
  #
  # Overhead       Samples  Command  Shared Object     Symbol
  # ........  ............  .......  ................  ..........................
  #
      99.90%          3982  noploop  noploop           [.] main
       0.09%             1  noploop  ld-2.17.so        [.] _dl_check_map_versions
       0.01%             1  noploop  [kernel.vmlinux]  [k] setup_arg_pages
       0.00%             5  noploop  [kernel.vmlinux]  [k] intel_pmu_enable_all

Reported-by: Milian Wolff <mail@milianw.de>
Reviewed-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c | 51 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 1134de22979e..9900b433e861 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -190,6 +190,19 @@ static int record__open(struct record *rec)
 	return rc;
 }
 
+static int process_sample_event(struct perf_tool *tool,
+				union perf_event *event,
+				struct perf_sample *sample,
+				struct perf_evsel *evsel,
+				struct machine *machine)
+{
+	struct record *rec = container_of(tool, struct record, tool);
+
+	rec->samples++;
+
+	return build_id__mark_dso_hit(tool, event, sample, evsel, machine);
+}
+
 static int process_buildids(struct record *rec)
 {
 	struct perf_data_file *file  = &rec->file;
@@ -212,7 +225,7 @@ static int process_buildids(struct record *rec)
 	 */
 	symbol_conf.ignore_vmlinux_buildid = true;
 
-	return perf_session__process_events(session, &build_id__mark_dso_hit_ops);
+	return perf_session__process_events(session, &rec->tool);
 }
 
 static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
@@ -503,19 +516,9 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		goto out_child;
 	}
 
-	if (!quiet) {
+	if (!quiet)
 		fprintf(stderr, "[ perf record: Woken up %ld times to write data ]\n", waking);
 
-		/*
-		 * Approximate RIP event size: 24 bytes.
-		 */
-		fprintf(stderr,
-			"[ perf record: Captured and wrote %.3f MB %s (~%" PRIu64 " samples) ]\n",
-			(double)rec->bytes_written / 1024.0 / 1024.0,
-			file->path,
-			rec->bytes_written / 24);
-	}
-
 out_child:
 	if (forks) {
 		int exit_status;
@@ -534,6 +537,9 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	} else
 		status = err;
 
+	/* this will be recalculated during process_buildids() */
+	rec->samples = 0;
+
 	if (!err && !file->is_pipe) {
 		rec->session->header.data_size += rec->bytes_written;
 
@@ -543,6 +549,20 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 					   file->fd, true);
 	}
 
+	if (!err && !quiet) {
+		char samples[128];
+
+		if (rec->samples)
+			scnprintf(samples, sizeof(samples),
+				  " (%" PRIu64 " samples)", rec->samples);
+		else
+			samples[0] = '\0';
+
+		fprintf(stderr,	"[ perf record: Captured and wrote %.3f MB %s%s ]\n",
+			perf_data_file__size(file) / 1024.0 / 1024.0,
+			file->path, samples);
+	}
+
 out_delete_session:
 	perf_session__delete(session);
 	return status;
@@ -719,6 +739,13 @@ static struct record record = {
 			.default_per_cpu = true,
 		},
 	},
+	.tool = {
+		.sample		= process_sample_event,
+		.fork		= perf_event__process_fork,
+		.comm		= perf_event__process_comm,
+		.mmap		= perf_event__process_mmap,
+		.mmap2		= perf_event__process_mmap2,
+	},
 };
 
 #define CALLCHAIN_HELP "setup and enables call-graph (stack chain/backtrace) recording: "
-- 
2.2.2

