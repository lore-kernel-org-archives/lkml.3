Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab3IAKjf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:39:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757402Ab3IAKiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:38:00 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 24/25] perf tools: Add multi file '-M' option for record command
Date: Sun,  1 Sep 2013 12:36:35 +0200
Message-Id: <1378031796-17892-25-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
References: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

split event data into multiple files based on the file
size or time delta specified as an argument to the option.

Adding multi file '-M' option for record command to store
output perf.data into multiple files based on the size
threshold.

The threshold is specified either as size (B/K/M/G) or time
(s/m/h) by appending the size with appropriate unit, like:
  -M 5M for 5 megabytes threshold
  -M 1h for 1 hour threshold
The generated name for each data file is appended with sequential
number (prepended by 5 zeros).For default output file name it
will be:
  perf.data-00000
  perf.data-00001
  perf.data-00002
  ...

Also watermark/wakeup_watermark is set accordingly to get
wake ups more often so we could get close enough to the
file size promise.

Example:
  $ perf record -M 5M yes > /dev/null
  ^C[ perf record: Woken up 228 times to write data ]
  [ perf record: Captured and wrote 20.246 MB perf.data-[0-4](~884542 samples) ]
  yes: Interrupt
  $ ls -l perf.data-0*
  -rw------- 1 jolsa jolsa 5289856 Aug 16 16:07 perf.data-00000
  -rw------- 1 jolsa jolsa 5296008 Aug 16 16:08 perf.data-00001
  -rw------- 1 jolsa jolsa 5344968 Aug 16 16:09 perf.data-00002
  -rw------- 1 jolsa jolsa 5309144 Aug 16 16:09 perf.data-00003
  -rw------- 1 jolsa jolsa 2358268 Aug 16 16:09 perf.data-00004
  $ ./perf diff perf.data-0000*
  # Event 'cycles'
  #
  # Data files:
  #  [0] perf.data-00000 (Baseline)
  #  [1] perf.data-00001
  #  [2] perf.data-00002
  #  [3] perf.data-00003
  #  [4] perf.data-00004
  #
  # Baseline/0  Delta/1  Delta/2  Delta/3  Delta/4      Shared Object                                      Symbol
  # ..........  .......  .......  .......  .......  .................  ..........................................
  #
        37.70%   -0.17%   -0.42%   -0.24%   -0.31%  libc-2.15.so       [.] _IO_file_xsputn@@GLIBC_2.2.5
        30.31%   +0.28%   +0.22%   +0.07%   +0.06%  yes                [.] main
        16.73%   +0.02%   +0.10%   -0.03%   +0.11%  libc-2.15.so       [.] __strlen_sse2
        14.22%   -0.30%   -0.10%   -0.31%   -0.14%  libc-2.15.so       [.] fputs_unlocked
         0.39%                              -0.01%  yes                [.] fputs_unlocked@plt
         0.06%                                      [kernel.kallsyms]  [k] system_call
         0.06%                     +0.01%           [kernel.kallsyms]  [k] __srcu_read_lock
         0.05%                     +0.01%           [kernel.kallsyms]  [k] __srcu_read_unlock
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
 tools/perf/Documentation/perf-record.txt |  14 ++
 tools/perf/builtin-record.c              | 246 ++++++++++++++++++++++++++++---
 tools/perf/perf.h                        |  14 ++
 tools/perf/util/evlist.c                 |   2 +-
 tools/perf/util/evlist.h                 |   2 +
 tools/perf/util/evsel.c                  |  24 +++
 6 files changed, 280 insertions(+), 22 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 400e9bb..f77658b 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -184,6 +184,20 @@ Enable weightened sampling. An additional weight is recorded per sample and can
 displayed with the weight and local_weight sort keys.  This currently works for TSX
 abort events and some memory events in precise mode on modern Intel CPUs.
 
+-M::
+--multi::
+Store output perf.data into multiple files based on the size threshold.
+The threshold is specified either as size (B/K/M/G) or time (s/m/h)
+by appending the size with appropriate unit, like:
+  -M 5M for 5 megabytes threshold
+  -M 1h for 1 hour threshold
+The generated name for each data file is appended with sequential number
+(prepended by 5 zeros).  For default output file name it will be:
+  perf.data-00000
+  perf.data-00001
+  perf.data-00002
+  ...
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 046ddda..b0c5937 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -66,6 +66,9 @@ struct perf_record {
 	struct perf_tool	tool;
 	struct perf_record_opts	opts;
 	u64			bytes_written;
+	u64			multi_bytes_written;
+	unsigned int		multi_idx;
+	time_t			multi_time;
 	struct perf_data_file	file_base;
 	struct perf_data_file	*file;
 	struct perf_evlist	*evlist;
@@ -249,11 +252,10 @@ out:
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
@@ -263,6 +265,19 @@ static int process_buildids(struct perf_record *rec)
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
@@ -272,12 +287,8 @@ static void perf_record__exit(int status, void *arg)
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
@@ -402,6 +413,172 @@ static int synthesize_record(struct perf_record *rec)
 	return err ? err : synthesize_record_file(rec);
 }
 
+static void set_multi_value(struct perf_record_opts *opts,
+			    u64 value, int type)
+{
+	if ((type == MULTI_TYPE__SIZE) &&
+	    (value < MULTI_LIMIT__MIN_SIZE)) {
+		pr_info("setting size to minimal size of the data file %dK\n",
+			MULTI_LIMIT__MIN_SIZE / 1024);
+		value = MULTI_LIMIT__MIN_SIZE;
+	}
+
+	pr_debug("-M/--multi value %lu (%s)\n",
+		 value, type == MULTI_TYPE__SIZE ? "size" : "time");
+
+	opts->multi_limit = true;
+	opts->multi_value = value;
+	opts->multi_type  = type;
+}
+
+static int parse_multi(const struct option *opt, const char *str,
+		       int unset __maybe_unused)
+{
+	static struct parse_tag tags_size[] = {
+		{ .tag  = 'B', .mult = 1       },
+		{ .tag  = 'K', .mult = 1 << 10 },
+		{ .tag  = 'M', .mult = 1 << 20 },
+		{ .tag  = 'G', .mult = 1 << 30 },
+		{ .tag  = 0 },
+	};
+	static struct parse_tag tags_time[] = {
+		{ .tag  = 's', .mult = 1    },
+		{ .tag  = 'm', .mult = 60   },
+		{ .tag  = 'h', .mult = 3600 },
+		{ .tag  = 0 },
+	};
+	struct perf_record_opts *opts = opt->value;
+	unsigned long value;
+
+	value = parse_tag_value(str, tags_size);
+	if (value != (unsigned long) -1) {
+		set_multi_value(opts, value, MULTI_TYPE__SIZE);
+		return 0;
+	}
+
+	value = parse_tag_value(str, tags_time);
+	if (value != (unsigned long) -1) {
+		set_multi_value(opts, value, MULTI_TYPE__TIME);
+		return 0;
+	}
+
+	pr_err("failed to parse -M/--multi size value\n");
+	return -1;
+}
+
+static const char *multi_file_base(struct perf_data_file *file)
+{
+	static const char *base;
+
+	if (!base)
+		base = file->path;
+	if (!base)
+		base = "perf.data";
+
+	return base;
+}
+
+static int multi_file_name(struct perf_data_file *file, unsigned int idx)
+{
+	char path[PATH_MAX];
+
+	snprintf(path, PATH_MAX, "%s-%05u",
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
+static bool multi_trigger(struct perf_record *rec)
+{
+	u64 value = rec->opts.multi_value;
+	time_t now;
+
+	switch (rec->opts.multi_type) {
+	case MULTI_TYPE__SIZE:
+		return rec->bytes_written > value;
+
+	case MULTI_TYPE__TIME:
+		now = time(NULL);
+		return (now - rec->multi_time) > (time_t) value;
+	default:
+		BUG_ON(1);
+	};
+}
+
+/*
+ * TODO Setup SIGALRM to wakeup for time threshold
+ * even if there's no data.
+ * */
+static int multi_file_threshold(struct perf_record *rec)
+{
+	int err;
+
+	if (!rec->opts.multi_limit || !multi_trigger(rec))
+		return 0;
+
+	pr_debug("multi: file limit crossed %lu B\n", rec->bytes_written);
+
+	err = multi_file_finish(rec);
+
+	rec->multi_bytes_written += rec->bytes_written;
+	rec->bytes_written = 0;
+	rec->multi_time    = time(NULL);
+
+	return err ? err : multi_file_init(rec);
+}
+
 static struct perf_event_header finished_round_event = {
 	.size = sizeof(struct perf_event_header),
 	.type = PERF_RECORD_FINISHED_ROUND,
@@ -421,6 +598,9 @@ static int perf_record__mmap_read_all(struct perf_record *rec)
 		}
 	}
 
+	if (multi_file_threshold(rec))
+		return -1;
+
 	if (perf_header__has_feat(&rec->session->header, HEADER_TRACING_DATA))
 		rc = write_output(rec, &finished_round_event,
 				  sizeof(finished_round_event));
@@ -429,6 +609,28 @@ out:
 	return rc;
 }
 
+static void display_exit_msg(struct perf_record *rec, unsigned long waking)
+{
+	struct perf_data_file *file = rec->file;
+	bool multi = rec->opts.multi_limit > 0;
+	char buf[PATH_MAX];
+	u64  bytes = multi ? rec->multi_bytes_written : rec->bytes_written;
+	char *path = multi ? buf : (char *) file->path;
+
+	if (multi)
+		snprintf(path, PATH_MAX, "%s-[0-%u]",
+			 multi_file_base(file), rec->multi_idx - 1);
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
@@ -450,6 +652,12 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	signal(SIGUSR1, sig_handler);
 	signal(SIGTERM, sig_handler);
 
+	if (rec->opts.multi_limit &&
+	    multi_file_name(file, rec->multi_idx++)) {
+		pr_err("Not enough memory\n");
+		return -1;
+	}
+
 	session = perf_session__new(file, false, NULL);
 	if (session == NULL) {
 		pr_err("Not enough memory for reading perf file header\n");
@@ -515,6 +723,9 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	if (err)
 		goto out_delete_session;
 
+	if (rec->opts.multi_type == MULTI_TYPE__TIME)
+		rec->multi_time = time(NULL);
+
 	if (rec->realtime_prio) {
 		struct sched_param param;
 
@@ -569,17 +780,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
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
@@ -845,6 +1046,9 @@ const struct option record_options[] = {
 	OPT_CALLBACK('m', "mmap-pages", &record.opts.mmap_pages, "pages",
 		     "number of mmap data pages",
 		     perf_evlist__parse_mmap_pages),
+	OPT_CALLBACK('M', "multi", &record.opts, "spec",
+		     "split data into more data files",
+		     parse_multi),
 	OPT_BOOLEAN(0, "group", &record.opts.group,
 		    "put the counters into a counter group"),
 	OPT_CALLBACK_DEFAULT('g', "call-graph", &record.opts,
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 0914630..76b7ae0 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -210,6 +210,17 @@ enum perf_call_graph_mode {
 	CALLCHAIN_DWARF
 };
 
+enum perf_record_multi_limits {
+	MULTI_LIMIT__MIN_SIZE       = 100 * 1024, /* 100K */
+	MULTI_LIMIT__MIN_WATTERMARK = 10  * 1024, /* 10K */
+	MULTI_LIMIT__MAX_WATTERMARK = MULTI_LIMIT__MIN_SIZE,
+};
+
+enum perf_record_multi_type {
+	MULTI_TYPE__SIZE,
+	MULTI_TYPE__TIME,
+};
+
 struct perf_record_opts {
 	struct perf_target target;
 	int	     call_graph;
@@ -223,6 +234,7 @@ struct perf_record_opts {
 	bool	     sample_weight;
 	bool	     sample_time;
 	bool	     period;
+	bool	     multi_limit;
 	unsigned int freq;
 	unsigned int mmap_pages;
 	unsigned int user_freq;
@@ -230,6 +242,8 @@ struct perf_record_opts {
 	u64	     default_interval;
 	u64	     user_interval;
 	u16	     stack_dump_size;
+	u64	     multi_value;
+	int	     multi_type;
 };
 
 #endif
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 998e0d1..a862937 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -632,7 +632,7 @@ out_unmap:
 	return -1;
 }
 
-static size_t perf_evlist__mmap_size(unsigned long pages)
+size_t perf_evlist__mmap_size(unsigned long pages)
 {
 	/* 512 kiB: default amount of unprivileged mlocked memory */
 	if (pages == UINT_MAX)
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index ca016b1..59bcf52 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -104,6 +104,8 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 				  bool want_signal);
 int perf_evlist__start_workload(struct perf_evlist *evlist);
 
+size_t perf_evlist__mmap_size(unsigned long pages);
+
 int perf_evlist__parse_mmap_pages(const struct option *opt,
 				  const char *str,
 				  int unset);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index e8745fb..122511d 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -672,6 +672,30 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		attr->branch_sample_type = opts->branch_stack;
 	}
 
+	if (opts->multi_limit) {
+		u64 wm = MULTI_LIMIT__MIN_WATTERMARK;
+		attr->watermark = 1;
+
+		if (opts->multi_type == MULTI_TYPE__SIZE) {
+			/*
+			 * The watermark could not get under 10K because
+			 * of the minimal file limit and we are guarded
+			 * with 100K for max wattermark.
+			 */
+			wm = opts->multi_value;
+			wm = min(wm / 10, (u64) MULTI_LIMIT__MAX_WATTERMARK);
+
+			/*
+			 * We also dont want to have watermark close to the size
+			 * of the mmap to ensure data would always cross it and
+			 * we get poll notification.
+			 */
+			wm = min(wm, (u64) perf_evlist__mmap_size(opts->mmap_pages) - 100);
+		}
+
+		attr->wakeup_watermark = wm;
+	}
+
 	if (opts->sample_weight)
 		attr->sample_type	|= PERF_SAMPLE_WEIGHT;
 
-- 
1.7.11.7

