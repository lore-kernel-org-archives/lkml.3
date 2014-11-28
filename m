Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270AbaK1HOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 02:14:24 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55911 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaK1HOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 02:14:23 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>, Milian Wolff <mail@milianw.de>
Subject: [PATCH v2 2/2] perf record: Show precise number of samples
Date: Fri, 28 Nov 2014 16:14:19 +0900
Message-Id: <1417158859-31538-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1417158708-31401-2-git-send-email-namhyung@kernel.org>
References: <1417158708-31401-2-git-send-email-namhyung@kernel.org>
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
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c | 53 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 1134de22979e..f88f5ccb96dc 100644
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
@@ -200,6 +213,7 @@ static int process_buildids(struct record *rec)
 		return 0;
 
 	file->size = size;
+	rec->samples = 0;
 
 	/*
 	 * During this process, it'll load kernel map and replace the
@@ -212,7 +226,7 @@ static int process_buildids(struct record *rec)
 	 */
 	symbol_conf.ignore_vmlinux_buildid = true;
 
-	return perf_session__process_events(session, &build_id__mark_dso_hit_ops);
+	return perf_session__process_events(session, &rec->tool);
 }
 
 static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
@@ -503,19 +517,9 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
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
@@ -535,10 +539,26 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		status = err;
 
 	if (!err && !file->is_pipe) {
+		bool print_nr_samples = false;
+
 		rec->session->header.data_size += rec->bytes_written;
 
-		if (!rec->no_buildid)
+		if (!rec->no_buildid) {
 			process_buildids(rec);
+			print_nr_samples = true;
+		}
+
+		if (!quiet) {
+			fprintf(stderr,	"[ perf record: Captured and wrote %.3f MB %s",
+				(double)rec->bytes_written / 1024.0 / 1024.0,
+				file->path);
+
+			if (print_nr_samples)
+				fprintf(stderr, " (%"PRIu64" samples)", rec->samples);
+
+			fputs(" ]\n", stderr);
+		}
+
 		perf_session__write_header(rec->session, rec->evlist,
 					   file->fd, true);
 	}
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
2.1.2

