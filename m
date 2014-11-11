Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaKKOTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:19:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:55261 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbaKKOTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:19:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="630151750"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 08/25] perf record: Add basic Instruction Tracing support
Date: Tue, 11 Nov 2014 16:16:46 +0200
Message-Id: <1415715423-15563-9-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
References: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amend the perf record tool to read the
Instruction Tracing mmap and synthesize
Instruction Tracing events.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-record.c | 99 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 85 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 582c4da..783b5ba 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -27,6 +27,7 @@
 #include "util/cpumap.h"
 #include "util/thread_map.h"
 #include "util/data.h"
+#include "util/itrace.h"
 
 #include <unistd.h>
 #include <sched.h>
@@ -38,6 +39,7 @@ struct record {
 	struct record_opts	opts;
 	u64			bytes_written;
 	struct perf_data_file	file;
+	struct itrace_record	*itr;
 	struct perf_evlist	*evlist;
 	struct perf_session	*session;
 	const char		*progname;
@@ -110,6 +112,43 @@ out:
 	return rc;
 }
 
+static int record__process_itrace(struct perf_tool *tool,
+				  union perf_event *event, void *data1,
+				  size_t len1, void *data2, size_t len2)
+{
+	struct record *rec = container_of(tool, struct record, tool);
+	size_t padding;
+	u8 pad[8] = {0};
+
+	/* event.itrace.size includes padding, see __itrace_mmap__read() */
+	padding = (len1 + len2) & 7;
+	if (padding)
+		padding = 8 - padding;
+
+	record__write(rec, event, event->header.size);
+	record__write(rec, data1, len1);
+	record__write(rec, data2, len2);
+	record__write(rec, &pad, padding);
+
+	return 0;
+}
+
+static int record__itrace_mmap_read(struct record *rec,
+				    struct itrace_mmap *mm)
+{
+	int ret;
+
+	ret = itrace_mmap__read(mm, rec->itr, &rec->tool,
+				record__process_itrace);
+	if (ret < 0)
+		return ret;
+
+	if (ret)
+		rec->samples++;
+
+	return 0;
+}
+
 static volatile int done = 0;
 static volatile int signr = -1;
 static volatile int child_finished = 0;
@@ -168,13 +207,15 @@ try_again:
 		goto out;
 	}
 
-	if (perf_evlist__mmap(evlist, opts->mmap_pages, false) < 0) {
+	if (perf_evlist__mmap_ex(evlist, opts->mmap_pages, false,
+				 opts->itrace_mmap_pages, false) < 0) {
 		if (errno == EPERM) {
 			pr_err("Permission error mapping pages.\n"
 			       "Consider increasing "
 			       "/proc/sys/kernel/perf_event_mlock_kb,\n"
 			       "or try again with a smaller value of -m/--mmap_pages.\n"
-			       "(current value: %u)\n", opts->mmap_pages);
+			       "(current value: %u,%u)\n",
+			       opts->mmap_pages, opts->itrace_mmap_pages);
 			rc = -errno;
 		} else {
 			pr_err("failed to mmap with %d (%s)\n", errno,
@@ -257,12 +298,20 @@ static int record__mmap_read_all(struct record *rec)
 	int rc = 0;
 
 	for (i = 0; i < rec->evlist->nr_mmaps; i++) {
+		struct itrace_mmap *mm = &rec->evlist->mmap[i].itrace_mmap;
+
 		if (rec->evlist->mmap[i].base) {
 			if (record__mmap_read(rec, i) != 0) {
 				rc = -1;
 				goto out;
 			}
 		}
+
+		if (mm->base &&
+		    record__itrace_mmap_read(rec, mm) != 0) {
+			rc = -1;
+			goto out;
+		}
 	}
 
 	/*
@@ -292,6 +341,9 @@ static void record__init_features(struct record *rec)
 
 	if (!rec->opts.branch_stack)
 		perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
+
+	if (!rec->opts.full_itrace)
+		perf_header__clear_feat(&session->header, HEADER_ITRACE);
 }
 
 static volatile int workload_exec_errno;
@@ -407,6 +459,13 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		}
 	}
 
+	if (rec->opts.full_itrace) {
+		err = perf_event__synthesize_itrace_info(rec->itr, tool,
+					session, process_synthesized_event);
+		if (err)
+			goto out_delete_session;
+	}
+
 	err = perf_event__synthesize_kernel_mmap(tool, process_synthesized_event,
 						 machine);
 	if (err < 0)
@@ -505,16 +564,17 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	}
 
 	if (!quiet) {
-		fprintf(stderr, "[ perf record: Woken up %ld times to write data ]\n", waking);
-
-		/*
-		 * Approximate RIP event size: 24 bytes.
-		 */
-		fprintf(stderr,
-			"[ perf record: Captured and wrote %.3f MB %s (~%" PRIu64 " samples) ]\n",
-			(double)rec->bytes_written / 1024.0 / 1024.0,
-			file->path,
-			rec->bytes_written / 24);
+		fprintf(stderr, "[ perf record: Woken up %ld times to write data ]\n",
+			waking);
+		fprintf(stderr, "[ perf record: Captured and wrote %.3f MB %s",
+			(double)rec->bytes_written / 1024.0 / 1024.0, file->path);
+		if (rec->opts.full_itrace) {
+			fprintf(stderr, " ]\n");
+		} else {
+			/* Approximate RIP event size: 24 bytes */
+			fprintf(stderr, " (~%" PRIu64 " samples) ]\n",
+				rec->bytes_written / 24);
+		}
 	}
 
 out_child:
@@ -818,13 +878,18 @@ struct option *record_options = __record_options;
 
 int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 {
-	int err = -ENOMEM;
+	int err;
 	struct record *rec = &record;
 	char errbuf[BUFSIZ];
 
+	rec->itr = itrace_record__init(&err);
+	if (err)
+		return err;
+
+	err = -ENOMEM;
 	rec->evlist = perf_evlist__new();
 	if (rec->evlist == NULL)
-		return -ENOMEM;
+		goto out_itrace_free;
 
 	perf_config(perf_record_config, rec);
 
@@ -884,6 +949,10 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (perf_evlist__create_maps(rec->evlist, &rec->opts.target) < 0)
 		usage_with_options(record_usage, record_options);
 
+	err = itrace_record__options(rec->itr, rec->evlist, &rec->opts);
+	if (err)
+		goto out_symbol_exit;
+
 	if (record_opts__config(&rec->opts)) {
 		err = -EINVAL;
 		goto out_symbol_exit;
@@ -893,5 +962,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 out_symbol_exit:
 	perf_evlist__delete(rec->evlist);
 	symbol__exit();
+out_itrace_free:
+	itrace_record__free(rec->itr);
 	return err;
 }
-- 
1.9.1

