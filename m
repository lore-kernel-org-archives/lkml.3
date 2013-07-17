Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964904Ab3GQRvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:51:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964830Ab3GQRvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:51:40 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 21/23] perf tools: Separating data file properties from session
Date: Wed, 17 Jul 2013 19:50:01 +0200
Message-Id: <1374083403-14591-22-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing 'fd, fd_pipe, filename, size' from struct perf_session
and replacing it with struct perf_data_file.

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
 tools/perf/builtin-annotate.c     |  2 +-
 tools/perf/builtin-buildid-list.c |  2 +-
 tools/perf/builtin-record.c       |  2 --
 tools/perf/builtin-report.c       |  8 +++++---
 tools/perf/builtin-script.c       |  2 +-
 tools/perf/util/data.h            | 15 +++++++++++++++
 tools/perf/util/header.c          | 30 ++++++++++++++++++++----------
 tools/perf/util/header.h          |  1 +
 tools/perf/util/session.c         | 36 +++++++++++++++++++-----------------
 tools/perf/util/session.h         |  5 +----
 10 files changed, 64 insertions(+), 39 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 048576f..a032a28 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -247,7 +247,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
 	}
 
 	if (total_nr_samples == 0) {
-		ui__error("The %s file has no samples!\n", session->filename);
+		ui__error("The %s file has no samples!\n", file.path);
 		goto out_delete;
 	}
 
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 0164c1c..ed3873b 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -73,7 +73,7 @@ static int perf_session__list_build_ids(bool force, bool with_hits)
 	 * in pipe-mode, the only way to get the buildids is to parse
 	 * the record stream. Buildids are stored as RECORD_HEADER_BUILD_ID
 	 */
-	if (with_hits || session->fd_pipe)
+	if (with_hits || perf_data_file__is_pipe(&file))
 		perf_session__process_events(session, &build_id__mark_dso_hit_ops);
 
 	perf_session__fprintf_dsos_buildid(session, stdout, dso__skip_buildid, with_hits);
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4754ec2..960908da 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -255,7 +255,6 @@ out:
 
 static int process_buildids(struct perf_record *rec)
 {
-	struct perf_data_file *file  = rec->file;
 	struct perf_session *session = rec->session;
 	u64 data_offset              = PERF_FILE_HEADER__DATA_OFFSET;
 	u64 size                     = session->header.data_size;
@@ -263,7 +262,6 @@ static int process_buildids(struct perf_record *rec)
 	if (size == 0)
 		return 0;
 
-	rec->session->fd = file->fd;
 	return __perf_session__process_events(session, data_offset,
 					      size - data_offset, size,
 					      &build_id__mark_dso_hit_ops);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 7904173..f90f4d6 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -369,8 +369,9 @@ static int perf_report__setup_sample_type(struct perf_report *rep)
 {
 	struct perf_session *self = rep->session;
 	u64 sample_type = perf_evlist__sample_type(self->evlist);
+	bool is_pipe = perf_data_file__is_pipe(self->file);
 
-	if (!self->fd_pipe && !(sample_type & PERF_SAMPLE_CALLCHAIN)) {
+	if (!is_pipe && !(sample_type & PERF_SAMPLE_CALLCHAIN)) {
 		if (sort__has_parent) {
 			ui__error("Selected --sort parent, but no "
 				    "callchain data. Did you call "
@@ -393,7 +394,7 @@ static int perf_report__setup_sample_type(struct perf_report *rep)
 	}
 
 	if (sort__mode == SORT_MODE__BRANCH) {
-		if (!self->fd_pipe &&
+		if (!is_pipe &&
 		    !(sample_type & PERF_SAMPLE_BRANCH_STACK)) {
 			ui__error("Selected -b but no branch data. "
 				  "Did you call perf record without -b?\n");
@@ -491,6 +492,7 @@ static int __cmd_report(struct perf_report *rep)
 	struct map *kernel_map;
 	struct kmap *kernel_kmap;
 	const char *help = "For a higher level overview, try: perf report --sort comm,dso";
+	struct perf_data_file *file = session->file;
 
 	signal(SIGINT, sig_handler);
 
@@ -572,7 +574,7 @@ static int __cmd_report(struct perf_report *rep)
 	}
 
 	if (nr_samples == 0) {
-		ui__error("The %s file has no samples!\n", session->filename);
+		ui__error("The %s file has no samples!\n", file->path);
 		return 0;
 	}
 
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index bbd524c..e0269bf 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1501,7 +1501,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 			return -1;
 		}
 
-		input = open(session->filename, O_RDONLY);	/* input_name */
+		input = open(file.path, O_RDONLY);	/* input_name */
 		if (input < 0) {
 			perror("failed to open file");
 			return -1;
diff --git a/tools/perf/util/data.h b/tools/perf/util/data.h
index d6c262e..8c2df80 100644
--- a/tools/perf/util/data.h
+++ b/tools/perf/util/data.h
@@ -27,6 +27,21 @@ static inline bool perf_data_file__is_write(struct perf_data_file *file)
 	return file->mode == PERF_DATA_MODE_WRITE;
 }
 
+static inline int perf_data_file__is_pipe(struct perf_data_file *file)
+{
+	return file->is_pipe;
+}
+
+static inline int perf_data_file__fd(struct perf_data_file *file)
+{
+	return file->fd;
+}
+
+static inline unsigned long perf_data_file__size(struct perf_data_file *file)
+{
+	return file->size;
+}
+
 int perf_data_file__open(struct perf_data_file *file);
 void perf_data_file__close(struct perf_data_file *file);
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index f5b7529..cb986b5 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2174,7 +2174,7 @@ int perf_header__fprintf_info(struct perf_session *session, FILE *fp, bool full)
 {
 	struct header_print_data hd;
 	struct perf_header *header = &session->header;
-	int fd = session->fd;
+	int fd = perf_data_file__fd(session->file);
 	hd.fp = fp;
 	hd.full = full;
 
@@ -2642,8 +2642,10 @@ static int perf_header__read_pipe(struct perf_session *session)
 {
 	struct perf_header *header = &session->header;
 	struct perf_pipe_file_header f_header;
+	struct perf_data_file *file = session->file;
 
-	if (perf_file_header__read_pipe(&f_header, header, session->fd,
+	if (perf_file_header__read_pipe(&f_header, header,
+					perf_data_file__fd(file),
 					session->repipe) < 0) {
 		pr_debug("incompatible file format\n");
 		return -EINVAL;
@@ -2745,12 +2747,13 @@ static int perf_evlist__prepare_tracepoint_events(struct perf_evlist *evlist,
 static int __perf_session__read_header_v2(struct perf_session *session,
 					  struct perf_file_header *header)
 {
+	struct perf_data_file		*file = session->file;
 	struct perf_header		*ph = &session->header;
 	struct perf_file_header_v2	*v2 = &header->v2;
 	struct perf_file_attr		f_attr;
 	u64				f_id;
 	int nr_attrs, nr_ids, i, j;
-	int fd = session->fd;
+	int fd = perf_data_file__fd(file);
 
 	session->evlist = perf_evlist__new();
 	if (session->evlist == NULL)
@@ -2844,6 +2847,8 @@ static int perf_session__read_header_v3(struct perf_session *session,
 {
 	struct perf_header *ph = &session->header;
 	struct perf_file_header_v3 *v3 = &header->v3;
+	struct perf_data_file *file = session->file;
+	int fd = perf_data_file__fd(file);
 
 	memcpy(&ph->adds_features, &v3->adds_features,
 	       sizeof(ph->adds_features));
@@ -2852,7 +2857,7 @@ static int perf_session__read_header_v3(struct perf_session *session,
 	ph->data_size	 = v3->data.size;
 	ph->feat_offset  = v3->features.offset;
 
-	perf_header__process_sections(ph, session->fd, &session->pevent,
+	perf_header__process_sections(ph, fd, &session->pevent,
 				      perf_file_section__process);
 
 	return 0;
@@ -2862,8 +2867,10 @@ static int perf_header_read_file(struct perf_session *session)
 {
 	struct perf_file_header header;
 	struct perf_header *ph = &session->header;
+	struct perf_data_file *file = session->file;
 
-	if (perf_file_header__read(&header, &session->header, session->fd))
+	if (perf_file_header__read(&header, &session->header,
+				   perf_data_file__fd(file)))
 		return -1;
 
 	/* read version specific data */
@@ -2875,7 +2882,9 @@ static int perf_header_read_file(struct perf_session *session)
 
 int perf_session__read_header(struct perf_session *session)
 {
-	if (session->fd_pipe)
+	struct perf_data_file *file = session->file;
+
+	if (perf_data_file__is_pipe(file))
 		return perf_header__read_pipe(session);
 
 	return perf_header_read_file(session) < 0 ? -EINVAL : 0;
@@ -3025,18 +3034,19 @@ int perf_event__process_tracing_data(struct perf_tool *tool __maybe_unused,
 				     struct perf_session *session)
 {
 	ssize_t size_read, padding, size = event->tracing_data.size;
-	off_t offset = lseek(session->fd, 0, SEEK_CUR);
+	int fd = perf_data_file__fd(session->file);
+	off_t offset = lseek(fd, 0, SEEK_CUR);
 	char buf[BUFSIZ];
 
 	/* setup for reading amidst mmap */
-	lseek(session->fd, offset + sizeof(struct tracing_data_event),
+	lseek(fd, offset + sizeof(struct tracing_data_event),
 	      SEEK_SET);
 
-	size_read = trace_report(session->fd, &session->pevent,
+	size_read = trace_report(fd, &session->pevent,
 				 session->repipe);
 	padding = PERF_ALIGN(size_read, sizeof(u64)) - size_read;
 
-	if (readn(session->fd, buf, padding) < 0) {
+	if (readn(fd, buf, padding) < 0) {
 		pr_err("%s: reading input file", __func__);
 		return -1;
 	}
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 4982e04..a5875f2 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -6,6 +6,7 @@
 #include <stdbool.h>
 #include "types.h"
 #include "event.h"
+#include "data.h"
 
 #include <linux/bitmap.h>
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index cfd9735..7a92450 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -18,17 +18,16 @@
 
 static int perf_session__open(struct perf_session *self)
 {
-	if (self->fd_pipe) {
-		if (perf_session__read_header(self) < 0)
-			pr_err("incompatible file format (rerun with -v to learn more)");
-		return 0;
-	}
+	struct perf_data_file *file = self->file;
 
 	if (perf_session__read_header(self) < 0) {
 		pr_err("incompatible file format (rerun with -v to learn more)");
 		goto out_close;
 	}
 
+	if (perf_data_file__is_pipe(file))
+		return 0;
+
 	if (!perf_evlist__valid_sample_type(self->evlist)) {
 		pr_err("non matching sample_type");
 		goto out_close;
@@ -85,10 +84,7 @@ struct perf_session *perf_session__new(struct perf_data_file *file,
 		if (perf_data_file__open(file))
 			goto out_delete;
 
-		self->fd       = file->fd;
-		self->fd_pipe  = file->is_pipe;
-		self->filename = file->path;
-		self->size     = file->size;
+		self->file = file;
 
 		if (perf_data_file__is_read(file)) {
 			if (perf_session__open(self) < 0)
@@ -156,7 +152,8 @@ void perf_session__delete(struct perf_session *self)
 	perf_session__delete_threads(self);
 	perf_session_env__delete(&self->header.env);
 	machines__exit(&self->machines);
-	close(self->fd);
+	if (self->file)
+		perf_data_file__close(self->file);
 	free(self);
 	vdso__exit();
 }
@@ -876,6 +873,7 @@ static int perf_session__preprocess_sample(struct perf_session *session,
 static int perf_session__process_user_event(struct perf_session *session, union perf_event *event,
 					    struct perf_tool *tool, u64 file_offset)
 {
+	int fd = perf_data_file__fd(session->file);
 	int err;
 
 	dump_event(session, event, file_offset, NULL);
@@ -889,7 +887,7 @@ static int perf_session__process_user_event(struct perf_session *session, union
 		return err;
 	case PERF_RECORD_HEADER_TRACING_DATA:
 		/* setup for reading amidst mmap */
-		lseek(session->fd, file_offset, SEEK_SET);
+		lseek(fd, file_offset, SEEK_SET);
 		return tool->tracing_data(tool, event, session);
 	case PERF_RECORD_HEADER_BUILD_ID:
 		return tool->build_id(tool, event, session);
@@ -1020,6 +1018,7 @@ volatile int session_done;
 static int __perf_session__process_pipe_events(struct perf_session *self,
 					       struct perf_tool *tool)
 {
+	int fd = perf_data_file__fd(self->file);
 	union perf_event *event;
 	uint32_t size, cur_size = 0;
 	void *buf = NULL;
@@ -1038,7 +1037,7 @@ static int __perf_session__process_pipe_events(struct perf_session *self,
 		return -errno;
 more:
 	event = buf;
-	err = readn(self->fd, event, sizeof(struct perf_event_header));
+	err = readn(fd, event, sizeof(struct perf_event_header));
 	if (err <= 0) {
 		if (err == 0)
 			goto done;
@@ -1070,7 +1069,7 @@ more:
 	p += sizeof(struct perf_event_header);
 
 	if (size - sizeof(struct perf_event_header)) {
-		err = readn(self->fd, p, size - sizeof(struct perf_event_header));
+		err = readn(fd, p, size - sizeof(struct perf_event_header));
 		if (err <= 0) {
 			if (err == 0) {
 				pr_err("unexpected end of event stream\n");
@@ -1149,6 +1148,7 @@ int __perf_session__process_events(struct perf_session *session,
 				   u64 data_offset, u64 data_size,
 				   u64 file_size, struct perf_tool *tool)
 {
+	int fd = perf_data_file__fd(session->file);
 	u64 head, page_offset, file_offset, file_pos, progress_next;
 	int err, mmap_prot, mmap_flags, map_idx = 0;
 	size_t	mmap_size;
@@ -1181,7 +1181,7 @@ int __perf_session__process_events(struct perf_session *session,
 		mmap_flags = MAP_PRIVATE;
 	}
 remap:
-	buf = mmap(NULL, mmap_size, mmap_prot, mmap_flags, session->fd,
+	buf = mmap(NULL, mmap_size, mmap_prot, mmap_flags, fd,
 		   file_offset);
 	if (buf == MAP_FAILED) {
 		pr_err("failed to mmap file\n");
@@ -1243,16 +1243,17 @@ out_err:
 int perf_session__process_events(struct perf_session *self,
 				 struct perf_tool *tool)
 {
+	u64 size = perf_data_file__size(self->file);
 	int err;
 
 	if (perf_session__register_idle_thread(self) == NULL)
 		return -ENOMEM;
 
-	if (!self->fd_pipe)
+	if (!perf_data_file__is_pipe(self->file))
 		err = __perf_session__process_events(self,
 						     self->header.data_offset,
 						     self->header.data_size,
-						     self->size, tool);
+						     size, tool);
 	else
 		err = __perf_session__process_pipe_events(self, tool);
 
@@ -1454,13 +1455,14 @@ int perf_session__cpu_bitmap(struct perf_session *session,
 void perf_session__fprintf_info(struct perf_session *session, FILE *fp,
 				bool full)
 {
+	int fd = perf_data_file__fd(session->file);
 	struct stat st;
 	int ret;
 
 	if (session == NULL || fp == NULL)
 		return;
 
-	ret = fstat(session->fd, &st);
+	ret = fstat(fd, &st);
 	if (ret == -1)
 		return;
 
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index aa8fc69..650ce35 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -30,16 +30,13 @@ struct ordered_samples {
 
 struct perf_session {
 	struct perf_header	header;
-	unsigned long		size;
 	struct machines		machines;
 	struct perf_evlist	*evlist;
 	struct pevent		*pevent;
 	struct events_stats	stats;
-	int			fd;
-	bool			fd_pipe;
 	bool			repipe;
 	struct ordered_samples	ordered_samples;
-	const char		*filename;
+	struct perf_data_file	*file;
 };
 
 struct perf_tool;
-- 
1.7.11.7

