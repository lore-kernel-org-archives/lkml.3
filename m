Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964923Ab3GQRxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:53:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964778Ab3GQRxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:53:30 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 22/23] perf tools: Add multi file '-M' option for record command
Date: Wed, 17 Jul 2013 19:50:02 +0200
Message-Id: <1374083403-14591-23-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding multi file '-M' option for record command to store
split event data into multiple files based on the file
size specified as an argument to the option.

Also watermark/wakeup_watermark is set to get wake ups
more often so we could get close enough to the file size
promise.

Example:
  $ ./perf record -M 100000 -e cycles:u yes > /dev/null
  ^C[ perf record: Woken up 25 times to write data ]
  [ perf record: Captured and wrote 0.630 MB perf-[0-7].data(~27531 samples) ]
  yes: Interrupt
  $ ls -l perf-0000*
  -rw------- 1 jolsa jolsa 111828 Jul 17 18:23 perf-00000.data
  -rw------- 1 jolsa jolsa 115240 Jul 17 18:23 perf-00001.data
  -rw------- 1 jolsa jolsa 112020 Jul 17 18:23 perf-00002.data
  -rw------- 1 jolsa jolsa 112020 Jul 17 18:23 perf-00003.data
  -rw------- 1 jolsa jolsa 112120 Jul 17 18:23 perf-00004.data
  -rw------- 1 jolsa jolsa 112120 Jul 17 18:23 perf-00005.data
  -rw------- 1 jolsa jolsa  18900 Jul 17 18:23 perf-00006.data
  $ ./perf diff perf-0000*
  # Event 'cycles:u'
  #
  # Data files:
  #  [0] perf-00000.data (Baseline)
  #  [1] perf-00001.data
  #  [2] perf-00002.data
  #  [3] perf-00003.data
  #  [4] perf-00004.data
  #  [5] perf-00005.data
  #  [6] perf-00006.data
  #
  # Baseline/0  Delta/1  Delta/2  Delta/3  Delta/4  Delta/5  Delta/6      Shared Object                              Symbol
  # ..........  .......  .......  .......  .......  .......  .......  .................  ..................................
  #
        37.03%   +1.23%   +0.12%   +0.61%   +1.12%   +0.93%   -7.53%  libc-2.15.so       [.] _IO_file_xsputn@@GLIBC_2.2.5
        31.40%   -0.55%   -0.79%   -1.00%   -0.66%   -0.59%   +4.09%  yes                [.] main
        16.36%   -0.18%   +1.39%   +1.07%   +0.66%   +0.23%   +1.72%  libc-2.15.so       [.] __strlen_sse2
        14.66%   -0.61%   -0.81%   -0.58%   -1.18%   -0.26%   +1.66%  libc-2.15.so       [.] fputs_unlocked
         0.24%   +0.34%   +0.27%   +0.08%   +0.24%   -0.12%   +0.35%  yes                [.] fputs_unlocked@plt
         0.12%                     -0.08%   -0.08%   -0.08%           libc-2.15.so       [.] _IO_file_write@@GLIBC_2.2.5
         0.08%                                                        libc-2.15.so       [.] new_do_write
         0.04%                                                        libc-2.15.so       [.] _IO_default_xsputn
  ...

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-record.c | 167 ++++++++++++++++++++++++++++++++++++++------
 tools/perf/perf.h           |   1 +
 tools/perf/util/evsel.c     |   5 ++
 3 files changed, 152 insertions(+), 21 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 960908da..920d69a 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -66,6 +66,8 @@ struct perf_record {
 	struct perf_tool	tool;
 	struct perf_record_opts	opts;
 	u64			bytes_written;
+	u64			multi_bytes_written;
+	unsigned int		multi_idx;
 	struct perf_data_file	file_base;
 	struct perf_data_file	*file;
 	struct perf_evlist	*evlist;
@@ -253,11 +255,10 @@ out:
 	return rc;
 }
 
-static int process_buildids(struct perf_record *rec)
+static int process_buildids(struct perf_session *session)
 {
-	struct perf_session *session = rec->session;
-	u64 data_offset              = PERF_FILE_HEADER__DATA_OFFSET;
-	u64 size                     = session->header.data_size;
+	u64 data_offset = PERF_FILE_HEADER__DATA_OFFSET;
+	u64 size        = session->header.data_size;
 
 	if (size == 0)
 		return 0;
@@ -267,6 +268,19 @@ static int process_buildids(struct perf_record *rec)
 					      &build_id__mark_dso_hit_ops);
 }
 
+static int file_finish(struct perf_record *rec,
+		       struct perf_data_file *file,
+		       struct perf_session *session,
+		       u64 bytes_written)
+{
+	session->header.data_size = bytes_written;
+
+	if (!rec->no_buildid)
+		process_buildids(session);
+
+	return perf_session__write_header(session, session->evlist, file->fd);
+}
+
 static void perf_record__exit(int status, void *arg)
 {
 	struct perf_record *rec = arg;
@@ -276,12 +290,8 @@ static void perf_record__exit(int status, void *arg)
 		return;
 
 	if (!file->is_pipe) {
-		rec->session->header.data_size += rec->bytes_written;
-
-		if (!rec->no_buildid)
-			process_buildids(rec);
-		perf_session__write_header(rec->session, rec->evlist,
-					   file->fd);
+		file_finish(rec, rec->file, rec->session,
+			    rec->bytes_written);
 		perf_session__delete(rec->session);
 		perf_evlist__delete(rec->evlist);
 		symbol__exit();
@@ -410,6 +420,98 @@ static int synthesize_record(struct perf_record *rec)
 	return err ? err : synthesize_record_file(rec);
 }
 
+static const char *multi_file_base(struct perf_data_file *file)
+{
+	static const char *base;
+
+	if (!base)
+		base = file->path;
+	if (!base)
+		base = "perf";
+
+	return base;
+}
+
+static int multi_file_name(struct perf_data_file *file, unsigned int idx)
+{
+	char path[PATH_MAX];
+
+	snprintf(path, PATH_MAX, "%s-%05u.data",
+		 multi_file_base(file), idx);
+	file->path = strdup(path);
+
+	return file->path ? 0 : -ENOMEM;
+}
+
+static int multi_file_finish(struct perf_record *rec)
+{
+	struct perf_data_file *file = rec->file;
+	struct perf_session *session;
+	int err;
+
+	/* TODO create perf_session__dup(session) */
+	session = perf_session__new(NULL, false, NULL);
+	if (!session)
+		return -ENOMEM;
+
+	session->evlist = rec->evlist;
+	session->file   = file;
+	session->header = rec->session->header;
+
+	err = file_finish(rec, file, session, rec->bytes_written);
+	if (!err)
+		pr_debug("multi: written file %s [%s]\n",
+			 file->path, err ? "failed" : "ok");
+
+	perf_session__delete(session);
+	return err;
+}
+
+static int multi_file_init(struct perf_record *rec)
+{
+	struct perf_data_file *file = rec->file;
+	int err;
+
+	if (multi_file_name(rec->file, rec->multi_idx++))
+		return -ENOMEM;
+
+	err = perf_data_file__open(file);
+	if (err)
+		return err;
+
+	err = perf_session__prepare_header(file->fd);
+	if (err)
+		goto out_close;
+
+	err = synthesize_record_file(rec);
+	if (err)
+		goto out_close;
+
+	return 0;
+
+ out_close:
+	perf_data_file__close(file);
+	return err;
+}
+
+static int multi_file_threshold(struct perf_record *rec)
+{
+	unsigned int limit = rec->opts.data_size_limit;
+	int err;
+
+	if (!limit || rec->bytes_written < limit)
+		return 0;
+
+	pr_debug("multi: file limit crossed %lu B\n", rec->bytes_written);
+
+	err = multi_file_finish(rec);
+
+	rec->multi_bytes_written += rec->bytes_written;
+	rec->bytes_written = 0;
+
+	return err ? err : multi_file_init(rec);
+}
+
 static struct perf_event_header finished_round_event = {
 	.size = sizeof(struct perf_event_header),
 	.type = PERF_RECORD_FINISHED_ROUND,
@@ -427,6 +529,9 @@ static int perf_record__mmap_read_all(struct perf_record *rec)
 				goto out;
 			}
 		}
+
+		if (multi_file_threshold(rec))
+			return -1;
 	}
 
 	if (perf_header__has_feat(&rec->session->header, HEADER_TRACING_DATA))
@@ -437,6 +542,28 @@ out:
 	return rc;
 }
 
+static void display_exit_msg(struct perf_record *rec, unsigned long waking)
+{
+	struct perf_data_file *file = rec->file;
+	bool multi = rec->opts.data_size_limit > 0;
+	char buf[PATH_MAX];
+	u64  bytes = multi ? rec->multi_bytes_written : rec->bytes_written;
+	char *path = multi ? buf : (char *) file->path;
+
+	if (multi)
+		snprintf(path, PATH_MAX, "%s-[0-%u].data",
+			 multi_file_base(file), rec->multi_idx);
+
+	fprintf(stderr, "[ perf record: Woken up %ld times to write data ]\n", waking);
+
+	/*
+	 * Approximate RIP event size: 24 bytes.
+	 */
+	fprintf(stderr,
+		"[ perf record: Captured and wrote %.3f MB %s(~%" PRIu64 " samples) ]\n",
+		(double) bytes / 1024.0 / 1024.0, path, bytes / 24);
+}
+
 static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 {
 	int err, feat;
@@ -458,6 +585,12 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	signal(SIGUSR1, sig_handler);
 	signal(SIGTERM, sig_handler);
 
+	if (rec->opts.data_size_limit &&
+	    multi_file_name(file, rec->multi_idx++)) {
+		pr_err("Not enough memory\n");
+		return -1;
+	}
+
 	session = perf_session__new(file, false, NULL);
 	if (session == NULL) {
 		pr_err("Not enough memory for reading perf file header\n");
@@ -577,17 +710,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
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
-
+	display_exit_msg(rec, waking);
 	return 0;
 
 out_delete_session:
@@ -852,6 +975,8 @@ const struct option record_options[] = {
 	OPT_UINTEGER('F', "freq", &record.opts.user_freq, "profile at this frequency"),
 	OPT_UINTEGER('m', "mmap-pages", &record.opts.mmap_pages,
 		     "number of mmap data pages"),
+	OPT_UINTEGER('M', "multi", &record.opts.data_size_limit,
+		     "split data into more data files"),
 	OPT_BOOLEAN(0, "group", &record.opts.group,
 		    "put the counters into a counter group"),
 	OPT_CALLBACK_DEFAULT('g', "call-graph", &record.opts,
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 95b2903..d06331f 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -222,6 +222,7 @@ struct perf_record_opts {
 	bool	     period;
 	unsigned int freq;
 	unsigned int mmap_pages;
+	unsigned int data_size_limit;
 	unsigned int user_freq;
 	u64          branch_stack;
 	u64	     default_interval;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a635461..05408e5 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -566,6 +566,11 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		attr->branch_sample_type = opts->branch_stack;
 	}
 
+	if (opts->data_size_limit) {
+		attr->watermark = 1;
+		attr->wakeup_watermark = opts->data_size_limit / 4;
+	}
+
 	if (opts->sample_weight)
 		attr->sample_type	|= PERF_SAMPLE_WEIGHT;
 
-- 
1.7.11.7

