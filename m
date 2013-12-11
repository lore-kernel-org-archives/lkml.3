Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab3LKMlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:41:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:35759 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab3LKMlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:41:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="442369321"
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
Subject: [PATCH v0 43/71] perf record: Add basic Instruction Tracing support
Date: Wed, 11 Dec 2013 14:36:55 +0200
Message-Id: <1386765443-26966-44-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Amend the perf record tool to read the
Instruction Tracing mmap and synthesize
Instruction Tracing events.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-record.c | 103 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 87 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d93e2ee..4613f55 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -25,6 +25,7 @@
 #include "util/cpumap.h"
 #include "util/thread_map.h"
 #include "util/data.h"
+#include "util/itrace.h"
 
 #include <unistd.h>
 #include <sched.h>
@@ -67,6 +68,7 @@ struct perf_record {
 	struct perf_record_opts	opts;
 	u64			bytes_written;
 	struct perf_data_file	file;
+	struct itrace_record	*itr;
 	struct perf_evlist	*evlist;
 	struct perf_session	*session;
 	const char		*progname;
@@ -150,6 +152,42 @@ out:
 	return rc;
 }
 
+static int perf_record__process_itrace(struct perf_tool *tool,
+				       union perf_event *event, void *data1,
+				       size_t len1, void *data2, size_t len2)
+{
+	struct perf_record *rec = container_of(tool, struct perf_record, tool);
+	size_t padding;
+	u8 pad[8] = {0};
+
+	padding = (len1 + len2) & 7;
+	if (padding)
+		padding = 8 - padding;
+
+	perf_record__write(rec, event, event->header.size);
+	perf_record__write(rec, data1, len1);
+	perf_record__write(rec, data2, len2);
+	perf_record__write(rec, &pad, padding);
+
+	return 0;
+}
+
+static int perf_record__itrace_mmap_read(struct perf_record *rec,
+					 struct itrace_mmap *mm)
+{
+	int ret;
+
+	ret = itrace_mmap__read(mm, rec->itr, &rec->tool,
+				perf_record__process_itrace);
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
@@ -218,13 +256,16 @@ try_again:
 		goto out;
 	}
 
-	if (perf_evlist__mmap(evlist, opts->mmap_pages, false) < 0) {
+	if (perf_evlist__mmap_ex(evlist, opts->mmap_pages, false,
+				 opts->itrace_mmap_pages,
+				 false) < 0) {
 		if (errno == EPERM) {
 			pr_err("Permission error mapping pages.\n"
 			       "Consider increasing "
 			       "/proc/sys/kernel/perf_event_mlock_kb,\n"
 			       "or try again with a smaller value of -m/--mmap_pages.\n"
-			       "(current value: %d)\n", opts->mmap_pages);
+			       "(current value: %u,%u)\n",
+			       opts->mmap_pages, opts->itrace_mmap_pages);
 			rc = -errno;
 		} else {
 			pr_err("failed to mmap with %d (%s)\n", errno, strerror(errno));
@@ -318,12 +359,20 @@ static int perf_record__mmap_read_all(struct perf_record *rec)
 	int rc = 0;
 
 	for (i = 0; i < rec->evlist->nr_mmaps; i++) {
+		struct itrace_mmap *mm = &rec->evlist->mmap[i].itrace_mmap;
+
 		if (rec->evlist->mmap[i].base) {
 			if (perf_record__mmap_read(rec, &rec->evlist->mmap[i]) != 0) {
 				rc = -1;
 				goto out;
 			}
 		}
+
+		if (mm->base &&
+		    perf_record__itrace_mmap_read(rec, mm) != 0) {
+			rc = -1;
+			goto out;
+		}
 	}
 
 	if (perf_header__has_feat(&rec->session->header, HEADER_TRACING_DATA))
@@ -351,6 +400,9 @@ static void perf_record__init_features(struct perf_record *rec)
 
 	if (!rec->opts.branch_stack)
 		perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
+
+	if (!rec->opts.full_itrace)
+		perf_header__clear_feat(&session->header, HEADER_ITRACE);
 }
 
 static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
@@ -455,6 +507,13 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
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
 						 machine, "_text");
 	if (err < 0)
@@ -536,16 +595,17 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	if (quiet || signr == SIGUSR1)
 		return 0;
 
-	fprintf(stderr, "[ perf record: Woken up %ld times to write data ]\n", waking);
-
-	/*
-	 * Approximate RIP event size: 24 bytes.
-	 */
-	fprintf(stderr,
-		"[ perf record: Captured and wrote %.3f MB %s (~%" PRIu64 " samples) ]\n",
-		(double)rec->bytes_written / 1024.0 / 1024.0,
-		file->path,
-		rec->bytes_written / 24);
+	fprintf(stderr, "[ perf record: Woken up %ld times to write data ]\n",
+		waking);
+	fprintf(stderr, "[ perf record: Captured and wrote %.3f MB %s",
+		(double)rec->bytes_written / 1024.0 / 1024.0, file->path);
+	if (rec->opts.full_itrace) {
+		fprintf(stderr, " ]\n");
+	} else {
+		/* Approximate RIP event size: 24 bytes */
+		fprintf(stderr, " (~%" PRIu64 " samples) ]\n",
+			rec->bytes_written / 24);
+	}
 
 	return 0;
 
@@ -889,14 +949,19 @@ const struct option record_options[] = {
 
 int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 {
-	int err = -ENOMEM;
+	int err;
 	struct perf_evlist *evsel_list;
 	struct perf_record *rec = &record;
 	char errbuf[BUFSIZ];
 
+	rec->itr = itrace_record__init(&err);
+	if (err)
+		return err;
+
+	err = -ENOMEM;
 	evsel_list = perf_evlist__new();
 	if (evsel_list == NULL)
-		return -ENOMEM;
+		goto out_itrace_free;
 
 	rec->evlist = evsel_list;
 
@@ -956,18 +1021,24 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (perf_evlist__create_maps(evsel_list, &rec->opts.target) < 0)
 		usage_with_options(record_usage, record_options);
 
+	err = itrace_record__options(rec->itr, evsel_list, &rec->opts);
+	if (err)
+		goto out_symbol_exit;
+
 	if (perf_record_opts__config(&rec->opts)) {
 		err = -EINVAL;
-		goto out_free_fd;
+		goto out_delete_maps;
 	}
 
 	err = __cmd_record(&record, argc, argv);
 
 	perf_evlist__munmap(evsel_list);
 	perf_evlist__close(evsel_list);
-out_free_fd:
+out_delete_maps:
 	perf_evlist__delete_maps(evsel_list);
 out_symbol_exit:
 	symbol__exit();
+out_itrace_free:
+	itrace_record__free(rec->itr);
 	return err;
 }
-- 
1.8.5.1

