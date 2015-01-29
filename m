Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbbA2ITR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:19:17 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51201 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbbA2IKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:06 -0500
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
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 14/42] perf record: Add --index option for building index table
Date: Thu, 29 Jan 2015 17:06:55 +0900
Message-Id: <1422518843-25818-15-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new --index option will create indexed data file which can be
processed by multiple threads parallelly.  It saves meta event and
sample data in separate files and merges them with an index table.

To build an index table, it needs to know exact offsets and sizes for
each sample data.  However the offset only can be calculated after the
feature data is fixed, and to save feature data it needs to access to
the sample data because it needs to mark used DSOs for build-id table.

So I ended up with reserving 1MB hole for the feature data area and then
put sample data and calculated offsets.  Now an indexed perf data file
will look like below:

        +---------------------+
        |     file header     |
        |---------------------|
        |                     |
        |     meta events     |
        |                     |
        |---------------------|
        |     feature data    |
        |   (contains index) -+--+
        |---------------------|  |
        |      ~1MB hole      |  |
        |---------------------|  |
        |                     |  |
        |    sample data[1] <-+--+
        |                     |  |
        |---------------------|  |
        |                     |  |
        |    sample data[2] <-|--+
        |                     |  |
        |---------------------|  |
        |         ...         | ...
        +---------------------+

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-record.txt |   4 +
 tools/perf/builtin-data.c                |   0
 tools/perf/builtin-record.c              | 165 +++++++++++++++++++++++++++++--
 tools/perf/perf.h                        |   1 +
 tools/perf/util/session.c                |   1 +
 5 files changed, 161 insertions(+), 10 deletions(-)
 delete mode 100644 tools/perf/builtin-data.c

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 31e977459c51..1fe8736cc0ff 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -235,6 +235,10 @@ Capture machine state (registers) at interrupt, i.e., on counter overflows for
 each sample. List of captured registers depends on the architecture. This option
 is off by default.
 
+--index::
+Build an index table for sample data.  This will speed up perf report by
+parallel processing.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-data.c b/tools/perf/builtin-data.c
deleted file mode 100644
index e69de29bb2d1..000000000000
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b057e2caa5f1..0db47c97446b 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -38,6 +38,7 @@ struct record {
 	struct record_opts	opts;
 	u64			bytes_written;
 	struct perf_data_file	file;
+	int			*fds;
 	struct perf_evlist	*evlist;
 	struct perf_session	*session;
 	const char		*progname;
@@ -47,14 +48,23 @@ struct record {
 	long			samples;
 };
 
-static int record__write(struct record *rec, void *bf, size_t size)
+static int record__write(struct record *rec, void *bf, size_t size, int idx)
 {
-	if (perf_data_file__write(rec->session->file, bf, size) < 0) {
+	int fd;
+
+	if (rec->fds && idx >= 0) {
+		fd = rec->fds[idx];
+		/* do not update data size for index files */
+	} else {
+		fd = perf_data_file__fd(rec->session->file);
+		rec->bytes_written += size;
+	}
+
+	if (writen(fd, bf, size) < 0) {
 		pr_err("failed to write perf data, error: %m\n");
 		return -1;
 	}
 
-	rec->bytes_written += size;
 	return 0;
 }
 
@@ -64,7 +74,7 @@ static int process_synthesized_event(struct perf_tool *tool,
 				     struct machine *machine __maybe_unused)
 {
 	struct record *rec = container_of(tool, struct record, tool);
-	return record__write(rec, event, event->header.size);
+	return record__write(rec, event, event->header.size, -1);
 }
 
 static int record__mmap_read(struct record *rec, int idx)
@@ -89,7 +99,7 @@ static int record__mmap_read(struct record *rec, int idx)
 		size = md->mask + 1 - (old & md->mask);
 		old += size;
 
-		if (record__write(rec, buf, size) < 0) {
+		if (record__write(rec, buf, size, idx) < 0) {
 			rc = -1;
 			goto out;
 		}
@@ -99,7 +109,7 @@ static int record__mmap_read(struct record *rec, int idx)
 	size = head - old;
 	old += size;
 
-	if (record__write(rec, buf, size) < 0) {
+	if (record__write(rec, buf, size, idx) < 0) {
 		rc = -1;
 		goto out;
 	}
@@ -111,6 +121,113 @@ static int record__mmap_read(struct record *rec, int idx)
 	return rc;
 }
 
+#define INDEX_FILE_FMT  "%s.dir/perf.data.%d"
+
+static int record__create_index_files(struct record *rec, int nr_index)
+{
+	int i = 0;
+	int ret = -1;
+	char path[PATH_MAX];
+	struct perf_data_file *file = &rec->file;
+
+	rec->fds = malloc(nr_index * sizeof(int));
+	if (rec->fds == NULL)
+		return -ENOMEM;
+
+	scnprintf(path, sizeof(path), "%s.dir", file->path);
+	if (mkdir(path, S_IRWXU) < 0)
+		goto out_err;
+
+	for (i = 0; i < nr_index; i++) {
+		scnprintf(path, sizeof(path), INDEX_FILE_FMT, file->path, i);
+		ret = open(path, O_RDWR|O_CREAT|O_TRUNC, S_IRUSR|S_IWUSR);
+		if (ret < 0)
+			goto out_err;
+
+		rec->fds[i] = ret;
+	}
+	return 0;
+
+out_err:
+	while (--i >= 0)
+		close(rec->fds[i]);
+	zfree(&rec->fds);
+
+	scnprintf(path, sizeof(path), "%s.dir", file->path);
+	rm_rf(path);
+
+	return ret;
+}
+
+static int record__merge_index_files(struct record *rec, int nr_index)
+{
+	int i;
+	int ret = -1;
+	u64 offset;
+	char path[PATH_MAX];
+	struct perf_file_section *idx;
+	struct perf_data_file *file = &rec->file;
+	struct perf_session *session = rec->session;
+	int output_fd = perf_data_file__fd(file);
+
+	idx = calloc(nr_index, sizeof(*idx));
+	if (idx == NULL)
+		goto out_close;
+
+	/* index data will be placed after header */
+	offset = lseek(output_fd, 0, SEEK_END);
+	if (offset == (u64)(loff_t) -1)
+		goto out_close;
+
+	/*
+	 * increase the offset for header features (including index).
+	 * which set later.  we cannot know exact size at this stage,
+	 * but I guess 1MB should be enough..
+	 */
+	offset += 1024 * 1024;
+	offset = PERF_ALIGN(offset, page_size);
+
+	for (i = 0; i < nr_index; i++) {
+		struct stat stbuf;
+		int fd = rec->fds[i];
+
+		if (fstat(fd, &stbuf) < 0)
+			goto out_close;
+
+		idx[i].offset = offset;
+		idx[i].size   = stbuf.st_size;
+
+		offset += PERF_ALIGN(stbuf.st_size, page_size);
+	}
+
+	session->header.index = idx;
+	session->header.nr_index = nr_index;
+
+	/* copy sample events */
+	for (i = 0; i < nr_index; i++) {
+		int fd = rec->fds[i];
+
+		if (idx[i].size == 0)
+			continue;
+
+		if (copyfile_offset(fd, 0, output_fd, idx[i].offset,
+				    idx[i].size) < 0)
+			goto out_close;
+	}
+
+	ret = 0;
+
+out_close:
+	for (i = 0; i < nr_index; i++)
+		close(rec->fds[i]);
+
+	scnprintf(path, sizeof(path), "%s.dir", file->path);
+	rm_rf(path);
+
+	zfree(&rec->fds);
+	return ret;
+}
+
 static volatile int done = 0;
 static volatile int signr = -1;
 static volatile int child_finished = 0;
@@ -170,7 +287,7 @@ static int record__open(struct record *rec)
 	}
 
 	if (perf_evlist__mmap_track(evlist, opts->mmap_pages, false,
-				    false) < 0) {
+				    opts->index) < 0) {
 		if (errno == EPERM) {
 			pr_err("Permission error mapping pages.\n"
 			       "Consider increasing "
@@ -186,6 +303,12 @@ static int record__open(struct record *rec)
 		goto out;
 	}
 
+	if (opts->index) {
+		rc = record__create_index_files(rec, evlist->nr_mmaps);
+		if (rc < 0)
+			goto out;
+	}
+
 	session->evlist = evlist;
 	perf_session__set_id_hdr_size(session);
 out:
@@ -210,7 +333,8 @@ static int process_buildids(struct record *rec)
 	struct perf_data_file *file  = &rec->file;
 	struct perf_session *session = rec->session;
 
-	u64 size = lseek(perf_data_file__fd(file), 0, SEEK_CUR);
+	/* update file size after merging sample files with index */
+	u64 size = lseek(perf_data_file__fd(file), 0, SEEK_END);
 	if (size == 0)
 		return 0;
 
@@ -290,7 +414,8 @@ static int record__mmap_read_all(struct record *rec)
 	 * at least one event.
 	 */
 	if (bytes_written != rec->bytes_written)
-		rc = record__write(rec, &finished_round_event, sizeof(finished_round_event));
+		rc = record__write(rec, &finished_round_event,
+				   sizeof(finished_round_event), -1);
 
 out:
 	return rc;
@@ -313,7 +438,8 @@ static void record__init_features(struct record *rec)
 	if (!rec->opts.branch_stack)
 		perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
 
-	perf_header__clear_feat(&session->header, HEADER_DATA_INDEX);
+	if (!rec->opts.index)
+		perf_header__clear_feat(&session->header, HEADER_DATA_INDEX);
 }
 
 static volatile int workload_exec_errno;
@@ -375,6 +501,11 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		}
 	}
 
+	if (file->is_pipe && opts->index) {
+		pr_warning("Indexing is disabled for pipe output\n");
+		opts->index = false;
+	}
+
 	if (record__open(rec) != 0) {
 		err = -1;
 		goto out_child;
@@ -554,6 +685,9 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	if (!err && !file->is_pipe) {
 		rec->session->header.data_size += rec->bytes_written;
 
+		if (rec->opts.index)
+			record__merge_index_files(rec, rec->evlist->nr_mmaps);
+
 		if (!rec->no_buildid)
 			process_buildids(rec);
 		perf_session__write_header(rec->session, rec->evlist, fd, true);
@@ -849,6 +983,8 @@ struct option __record_options[] = {
 		    "use per-thread mmaps"),
 	OPT_BOOLEAN('I', "intr-regs", &record.opts.sample_intr_regs,
 		    "Sample machine registers on interrupt"),
+	OPT_BOOLEAN(0, "index", &record.opts.index,
+		    "make index for sample data to speed-up processing"),
 	OPT_END()
 };
 
@@ -898,6 +1034,15 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 		goto out_symbol_exit;
 	}
 
+	if (rec->opts.index) {
+		if (!rec->opts.sample_time) {
+			pr_err("Sample timestamp is required for indexing\n");
+			goto out_symbol_exit;
+		}
+
+		perf_evlist__add_dummy_tracking(rec->evlist);
+	}
+
 	if (rec->opts.target.tid && !rec->opts.no_inherit_set)
 		rec->opts.no_inherit = true;
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 1dabb8553499..b0fad99c9252 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -53,6 +53,7 @@ struct record_opts {
 	bool	     sample_time;
 	bool	     period;
 	bool	     sample_intr_regs;
+	bool	     index;
 	unsigned int freq;
 	unsigned int mmap_pages;
 	unsigned int user_freq;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ff4d5913220c..e7b59fbebbc4 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -173,6 +173,7 @@ void perf_session__delete(struct perf_session *session)
 	machines__exit(&session->machines);
 	if (session->file)
 		perf_data_file__close(session->file);
+	free(session->header.index);
 	free(session);
 }
 
-- 
2.2.2

