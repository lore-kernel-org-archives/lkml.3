Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaKKOUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:20:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:38869 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbaKKOUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:20:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="630152330"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 24/25] perf tools: Add Instruction Tracing index
Date: Tue, 11 Nov 2014 16:17:02 +0200
Message-Id: <1415715423-15563-25-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
References: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an index of Instruction Tracing events within
a perf.data file.

perf record uses a special user event
PERF_RECORD_FINISHED_ROUND to enable sorting of
events in chunks instead of having to sort all
events altogether.

Instruction Tracing events contain data that can
span back to the very beginning of the recording
period. i.e. they do not obey the rules of
PERF_RECORD_FINISHED_ROUND.

By adding an index, Instruction Tracing events
can be found in advance and the
PERF_RECORD_FINISHED_ROUND approach works as
usual.

The index is recorded with the itrace feature
in the perf.data file.  A session reads the index
but does not process it.  An Instruction Trace
decoder can queue all the Instruction Trace data
in advance using itrace_queues__process_index()
or otherwise process the index in some custom
manner.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-inject.c |  15 ++++
 tools/perf/builtin-record.c |  15 ++++
 tools/perf/util/header.c    |  30 ++++++-
 tools/perf/util/itrace.c    | 214 ++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/itrace.h    |  35 ++++++++
 tools/perf/util/session.c   |   2 +
 tools/perf/util/session.h   |   1 +
 7 files changed, 308 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index c3323ea..4d0fe53 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -115,6 +115,18 @@ static s64 perf_event__repipe_itrace(struct perf_tool *tool,
 						  tool);
 	int ret;
 
+	if (!inject->output.is_pipe) {
+		off_t offset;
+
+		offset = lseek(inject->output.fd, 0, SEEK_CUR);
+		if (offset == -1)
+			return -errno;
+		ret = itrace_index__itrace_event(&session->itrace_index, event,
+						 offset);
+		if (ret < 0)
+			return ret;
+	}
+
 	if (perf_data_file__is_pipe(session->file) || !session->one_mmap) {
 		ret = output_bytes(inject, event, event->header.size);
 		if (ret < 0)
@@ -481,6 +493,9 @@ static int __cmd_inject(struct perf_inject *inject)
 		output_data_offset = 4096;
 	}
 
+	if (!inject->itrace_synth_opts.set)
+		itrace_index__free(&session->itrace_index);
+
 	if (!file_out->is_pipe)
 		lseek(file_out->fd, output_data_offset, SEEK_SET);
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 1e65d38..62211b9 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -117,9 +117,24 @@ static int record__process_itrace(struct perf_tool *tool,
 				  size_t len1, void *data2, size_t len2)
 {
 	struct record *rec = container_of(tool, struct record, tool);
+	struct perf_data_file *file = &rec->file;
 	size_t padding;
 	u8 pad[8] = {0};
 
+	if (!perf_data_file__is_pipe(file)) {
+		off_t file_offset;
+		int fd = perf_data_file__fd(file);
+		int err;
+
+		file_offset = lseek(fd, 0, SEEK_CUR);
+		if (file_offset == -1)
+			return -1;
+		err = itrace_index__itrace_event(&rec->session->itrace_index,
+						 event, file_offset);
+		if (err)
+			return err;
+	}
+
 	/* event.itrace.size includes padding, see __itrace_mmap__read() */
 	padding = (len1 + len2) & 7;
 	if (padding)
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 27f8fb5..b64a746 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -869,11 +869,18 @@ static int write_branch_stack(int fd __maybe_unused,
 	return 0;
 }
 
-static int write_itrace(int fd __maybe_unused,
-			struct perf_header *h __maybe_unused,
+static int write_itrace(int fd, struct perf_header *h,
 			struct perf_evlist *evlist __maybe_unused)
 {
-	return 0;
+	struct perf_session *session;
+	int err;
+
+	session = container_of(h, struct perf_session, header);
+
+	err = itrace_index__write(fd, &session->itrace_index);
+	if (err < 0)
+		pr_err("Failed to write itrace index\n");
+	return err;
 }
 
 static void print_hostname(struct perf_header *ph, int fd __maybe_unused,
@@ -1846,6 +1853,21 @@ out_free:
 	return ret;
 }
 
+static int process_itrace(struct perf_file_section *section,
+			  struct perf_header *ph, int fd,
+			  void *data __maybe_unused)
+{
+	struct perf_session *session;
+	int err;
+
+	session = container_of(ph, struct perf_session, header);
+
+	err = itrace_index__process(fd, section->size, session, ph->needs_swap);
+	if (err < 0)
+		pr_err("Failed to process itrace index\n");
+	return err;
+}
+
 struct feature_ops {
 	int (*write)(int fd, struct perf_header *h, struct perf_evlist *evlist);
 	void (*print)(struct perf_header *h, int fd, FILE *fp);
@@ -1886,7 +1908,7 @@ static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
 	FEAT_OPA(HEADER_BRANCH_STACK,	branch_stack),
 	FEAT_OPP(HEADER_PMU_MAPPINGS,	pmu_mappings),
 	FEAT_OPP(HEADER_GROUP_DESC,	group_desc),
-	FEAT_OPA(HEADER_ITRACE,		itrace),
+	FEAT_OPP(HEADER_ITRACE,		itrace),
 };
 
 struct header_print_data {
diff --git a/tools/perf/util/itrace.c b/tools/perf/util/itrace.c
index fd67a9a..b9bd27a 100644
--- a/tools/perf/util/itrace.c
+++ b/tools/perf/util/itrace.c
@@ -330,6 +330,33 @@ out_err:
 	return err;
 }
 
+static int itrace_queues__add_indexed_event(struct itrace_queues *queues,
+					    struct perf_session *session,
+					    off_t file_offset, size_t sz)
+{
+	union perf_event *event;
+	int err;
+	char buf[PERF_SAMPLE_MAX_SIZE];
+
+	err = perf_session__peek_event(session, file_offset, buf,
+				       PERF_SAMPLE_MAX_SIZE, &event, NULL);
+	if (err)
+		return err;
+
+	if (event->header.type == PERF_RECORD_ITRACE) {
+		if (event->header.size != sizeof(struct itrace_event) ||
+		    event->header.size != sz) {
+			err = -EINVAL;
+			goto out;
+		}
+		file_offset += event->header.size;
+		err = itrace_queues__add_event(queues, session, event,
+					       file_offset, NULL);
+	}
+out:
+	return err;
+}
+
 void itrace_queues__free(struct itrace_queues *queues)
 {
 	unsigned int i;
@@ -485,6 +512,193 @@ struct itrace_record * __weak itrace_record__init(int *err)
 	return NULL;
 }
 
+static int itrace_index__alloc(struct list_head *head)
+{
+	struct itrace_index *itrace_index;
+
+	itrace_index = malloc(sizeof(struct itrace_index));
+	if (!itrace_index)
+		return -ENOMEM;
+
+	itrace_index->nr = 0;
+	INIT_LIST_HEAD(&itrace_index->list);
+
+	list_add_tail(&itrace_index->list, head);
+
+	return 0;
+}
+
+void itrace_index__free(struct list_head *head)
+{
+	struct itrace_index *itrace_index, *n;
+
+	list_for_each_entry_safe(itrace_index, n, head, list) {
+		list_del(&itrace_index->list);
+		free(itrace_index);
+	}
+}
+
+static struct itrace_index *itrace_index__last(struct list_head *head)
+{
+	struct itrace_index *itrace_index;
+	int err;
+
+	if (list_empty(head)) {
+		err = itrace_index__alloc(head);
+		if (err)
+			return NULL;
+	}
+
+	itrace_index = list_entry(head->prev, struct itrace_index, list);
+
+	if (itrace_index->nr >= PERF_ITRACE_INDEX_ENTRY_COUNT) {
+		err = itrace_index__alloc(head);
+		if (err)
+			return NULL;
+		itrace_index = list_entry(head->prev, struct itrace_index,
+					  list);
+	}
+
+	return itrace_index;
+}
+
+int itrace_index__itrace_event(struct list_head *head, union perf_event *event,
+			       off_t file_offset)
+{
+	struct itrace_index *itrace_index;
+	size_t nr;
+
+	itrace_index = itrace_index__last(head);
+	if (!itrace_index)
+		return -ENOMEM;
+
+	nr = itrace_index->nr;
+	itrace_index->entries[nr].file_offset = file_offset;
+	itrace_index->entries[nr].sz = event->header.size;
+	itrace_index->nr += 1;
+
+	return 0;
+}
+
+static int itrace_index__do_write(int fd, struct itrace_index *itrace_index)
+{
+	struct itrace_index_entry index;
+	size_t i;
+
+	for (i = 0; i < itrace_index->nr; i++) {
+		index.file_offset = itrace_index->entries[i].file_offset;
+		index.sz = itrace_index->entries[i].sz;
+		if (writen(fd, &index, sizeof(index)) != sizeof(index))
+			return -errno;
+	}
+	return 0;
+}
+
+int itrace_index__write(int fd, struct list_head *head)
+{
+	struct itrace_index *itrace_index;
+	u64 total = 0;
+	int err;
+
+	list_for_each_entry(itrace_index, head, list)
+		total += itrace_index->nr;
+
+	if (writen(fd, &total, sizeof(total)) != sizeof(total))
+		return -errno;
+
+	list_for_each_entry(itrace_index, head, list) {
+		err = itrace_index__do_write(fd, itrace_index);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int itrace_index__process_entry(int fd, struct list_head *head,
+				       bool needs_swap)
+{
+	struct itrace_index *itrace_index;
+	struct itrace_index_entry index;
+	size_t nr;
+
+	if (readn(fd, &index, sizeof(index)) != sizeof(index))
+		return -1;
+
+	itrace_index = itrace_index__last(head);
+	if (!itrace_index)
+		return -1;
+
+	nr = itrace_index->nr;
+	if (needs_swap) {
+		itrace_index->entries[nr].file_offset =
+						bswap_64(index.file_offset);
+		itrace_index->entries[nr].sz = bswap_64(index.sz);
+	} else {
+		itrace_index->entries[nr].file_offset = index.file_offset;
+		itrace_index->entries[nr].sz = index.sz;
+	}
+
+	itrace_index->nr = nr + 1;
+
+	return 0;
+}
+
+int itrace_index__process(int fd, u64 size, struct perf_session *session,
+			  bool needs_swap)
+{
+	struct list_head *head = &session->itrace_index;
+	u64 nr;
+
+	if (readn(fd, &nr, sizeof(u64)) != sizeof(u64))
+		return -1;
+
+	if (needs_swap)
+		nr = bswap_64(nr);
+
+	if (sizeof(u64) + nr * sizeof(struct itrace_index_entry) != size)
+		return -1;
+
+	while (nr--) {
+		int err;
+
+		err = itrace_index__process_entry(fd, head, needs_swap);
+		if (err)
+			return -1;
+	}
+
+	return 0;
+}
+
+static int itrace_queues__process_index_entry(struct itrace_queues *queues,
+					      struct perf_session *session,
+					      struct itrace_index_entry *index)
+{
+	return itrace_queues__add_indexed_event(queues, session,
+						index->file_offset, index->sz);
+}
+
+int itrace_queues__process_index(struct itrace_queues *queues,
+				 struct perf_session *session)
+{
+	struct itrace_index *itrace_index;
+	struct itrace_index_entry *index;
+	size_t i;
+	int err;
+
+	list_for_each_entry(itrace_index, &session->itrace_index, list) {
+		for (i = 0; i < itrace_index->nr; i++) {
+			index = &itrace_index->entries[i];
+			err = itrace_queues__process_index_entry(queues,
+								 session,
+								 index);
+			if (err)
+				return err;
+		}
+	}
+	return 0;
+}
+
 struct itrace_buffer *itrace_buffer__next(struct itrace_queue *queue,
 					  struct itrace_buffer *buffer)
 {
diff --git a/tools/perf/util/itrace.h b/tools/perf/util/itrace.h
index e67fa34..02b6bed 100644
--- a/tools/perf/util/itrace.h
+++ b/tools/perf/util/itrace.h
@@ -82,6 +82,32 @@ struct itrace_synth_opts {
 };
 
 /**
+ * struct itrace_index_entry - indexes a Instruction Tracing event within a
+ *                             perf.data file.
+ * @file_offset: offset within the perf.data file
+ * @sz: size of the event
+ */
+struct itrace_index_entry {
+	u64			file_offset;
+	u64			sz;
+};
+
+#define PERF_ITRACE_INDEX_ENTRY_COUNT 256
+
+/**
+ * struct itrace_index - index of Instruction Tracing events within a perf.data
+ *                       file.
+ * @list: linking a number of arrays of entries
+ * @nr: number of entries
+ * @entries: array of entries
+ */
+struct itrace_index {
+	struct list_head	list;
+	size_t			nr;
+	struct itrace_index_entry entries[PERF_ITRACE_INDEX_ENTRY_COUNT];
+};
+
+/**
  * struct itrace - session callbacks to allow Instruction Trace data decoding.
  * @process_event: lets the decoder see all session events
  * @flush_events: process any remaining data
@@ -304,6 +330,8 @@ int itrace_queues__add_event(struct itrace_queues *queues,
 			     union perf_event *event, off_t data_offset,
 			     struct itrace_buffer **buffer_ptr);
 void itrace_queues__free(struct itrace_queues *queues);
+int itrace_queues__process_index(struct itrace_queues *queues,
+				 struct perf_session *session);
 struct itrace_buffer *itrace_buffer__next(struct itrace_queue *queue,
 					  struct itrace_buffer *buffer);
 void *itrace_buffer__get_data(struct itrace_buffer *buffer, int fd);
@@ -343,6 +371,13 @@ int itrace_record__info_fill(struct itrace_record *itr,
 void itrace_record__free(struct itrace_record *itr);
 u64 itrace_record__reference(struct itrace_record *itr);
 
+int itrace_index__itrace_event(struct list_head *head, union perf_event *event,
+			       off_t file_offset);
+int itrace_index__write(int fd, struct list_head *head);
+int itrace_index__process(int fd, u64 size, struct perf_session *session,
+			  bool needs_swap);
+void itrace_index__free(struct list_head *head);
+
 void itrace_synth_error(struct itrace_error_event *itrace_error, int type,
 			int code, int cpu, pid_t pid, pid_t tid, u64 ip,
 			const char *msg);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 1f03418..0af02a4 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -97,6 +97,7 @@ struct perf_session *perf_session__new(struct perf_data_file *file,
 
 	session->repipe = repipe;
 	ordered_events__init(&session->ordered_events);
+	INIT_LIST_HEAD(&session->itrace_index);
 	machines__init(&session->machines);
 
 	if (file) {
@@ -168,6 +169,7 @@ static void perf_session_env__delete(struct perf_session_env *env)
 void perf_session__delete(struct perf_session *session)
 {
 	itrace__free(session);
+	itrace_index__free(&session->itrace_index);
 	perf_session__destroy_kernel_maps(session);
 	perf_session__delete_dead_threads(session);
 	perf_session__delete_threads(session);
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index ccf6a75..01c4aa4 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -24,6 +24,7 @@ struct perf_session {
 	struct perf_evlist	*evlist;
 	struct itrace		*itrace;
 	struct itrace_synth_opts *itrace_synth_opts;
+	struct list_head	itrace_index;
 	struct trace_event	tevent;
 	struct events_stats	stats;
 	bool			repipe;
-- 
1.9.1

