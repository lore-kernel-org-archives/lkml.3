Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3LKMqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:46:10 -0500
Received: from mga03.intel.com ([143.182.124.21]:59606 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab3LKMnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:43:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="442370065"
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
Subject: [PATCH v0 63/71] perf tools: Add Instruction Tracing index
Date: Wed, 11 Dec 2013 14:37:15 +0200
Message-Id: <1386765443-26966-64-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add an index of Instruction Tracing events within
a perf.data file.

Instruction Tracing events contain data that can
span back to the very beginning of the recording
period.  Consequently decoding cannot begin until
all events are sorted.  By adding an index,
Instruction Tracing events can be found in advance
and decoding can begin earlier.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-inject.c |  15 +++
 tools/perf/builtin-record.c |  18 +++-
 tools/perf/util/header.c    |  23 ++++-
 tools/perf/util/itrace.c    | 224 ++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/itrace.h    |  35 +++++++
 tools/perf/util/session.c   |   2 +
 tools/perf/util/session.h   |   1 +
 7 files changed, 313 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index ed2b48f..ce1f298 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -120,6 +120,18 @@ static s64 perf_event__repipe_itrace(struct perf_tool *tool,
 						  tool);
 	int ret;
 
+	if (!inject->pipe_output) {
+		off_t offset;
+
+		offset = lseek(inject->output, 0, SEEK_CUR);
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
@@ -523,6 +535,9 @@ static int __cmd_inject(struct perf_inject *inject)
 		output_data_offset = 4096;
 	}
 
+	if (!inject->itrace_synth_opts.set)
+		itrace_index__free(&session->itrace_index);
+
 	if (!inject->pipe_output)
 		lseek(inject->output, output_data_offset, SEEK_SET);
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 46c451c..b35963f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -157,9 +157,24 @@ static int perf_record__process_itrace(struct perf_tool *tool,
 				       size_t len1, void *data2, size_t len2)
 {
 	struct perf_record *rec = container_of(tool, struct perf_record, tool);
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
 	padding = (len1 + len2) & 7;
 	if (padding)
 		padding = 8 - padding;
@@ -395,7 +410,8 @@ static int perf_record__mmap_read_all(struct perf_record *rec)
 		}
 	}
 
-	if (perf_header__has_feat(&rec->session->header, HEADER_TRACING_DATA))
+	if (perf_header__has_feat(&rec->session->header, HEADER_TRACING_DATA) ||
+	    perf_header__has_feat(&rec->session->header, HEADER_ITRACE))
 		rc = perf_record__write(rec, &finished_round_event,
 					sizeof(finished_round_event));
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 72bcca9..dd1a1f9 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1188,11 +1188,14 @@ static int write_branch_stack(int fd __maybe_unused,
 	return 0;
 }
 
-static int write_itrace(int fd __maybe_unused,
-			struct perf_header *h __maybe_unused,
+static int write_itrace(int fd, struct perf_header *h,
 			struct perf_evlist *evlist __maybe_unused)
 {
-	return 0;
+	struct perf_session *session;
+
+	session = container_of(h, struct perf_session, header);
+
+	return itrace_index__write(fd, &session->itrace_index);
 }
 
 static void print_hostname(struct perf_header *ph, int fd __maybe_unused,
@@ -2168,6 +2171,18 @@ out_free:
 	return ret;
 }
 
+static int process_itrace(struct perf_file_section *section,
+			  struct perf_header *ph, int fd,
+			  void *data __maybe_unused)
+{
+	struct perf_session *session;
+
+	session = container_of(ph, struct perf_session, header);
+
+	return itrace_index__process(fd, section->size, session,
+				     ph->needs_swap);
+}
+
 struct feature_ops {
 	int (*write)(int fd, struct perf_header *h, struct perf_evlist *evlist);
 	void (*print)(struct perf_header *h, int fd, FILE *fp);
@@ -2208,7 +2223,7 @@ static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
 	FEAT_OPA(HEADER_BRANCH_STACK,	branch_stack),
 	FEAT_OPP(HEADER_PMU_MAPPINGS,	pmu_mappings),
 	FEAT_OPP(HEADER_GROUP_DESC,	group_desc),
-	FEAT_OPA(HEADER_ITRACE,		itrace),
+	FEAT_OPP(HEADER_ITRACE,		itrace),
 };
 
 struct header_print_data {
diff --git a/tools/perf/util/itrace.c b/tools/perf/util/itrace.c
index da2f175..28455f8 100644
--- a/tools/perf/util/itrace.c
+++ b/tools/perf/util/itrace.c
@@ -321,6 +321,40 @@ int itrace_queues__add_event(struct itrace_queues *queues,
 	return itrace_queues__add_buffer(queues, event->itrace.idx, buffer);
 }
 
+static int itrace_queues__add_indexed_event(struct itrace_queues *queues,
+					    struct perf_session *session,
+					    off_t file_offset, size_t sz)
+{
+	union perf_event *event;
+	struct itrace_event buf;
+
+	if (session->one_mmap && !session->header.needs_swap) {
+		event = file_offset - session->one_mmap_offset +
+			session->one_mmap_addr;
+	} else {
+		int fd = perf_data_file__fd(session->file);
+
+		if (sz > sizeof(struct itrace_event))
+			sz = sizeof(struct itrace_event);
+		else if (sz < sizeof(struct itrace_event))
+			memset(&buf, 0, sizeof(struct itrace_event));
+
+		if (lseek(fd, file_offset, SEEK_SET) == (off_t)-1 ||
+		    readn(fd, &buf, sz) != (ssize_t)sz)
+			return -EINVAL;
+
+		event = (union perf_event *)&buf;
+
+		if (session->header.needs_swap) {
+			perf_event_header__bswap(&event->header);
+			perf_event__itrace_swap(event, true);
+		}
+	}
+
+	return itrace_queues__add_event(queues, session, event,
+					file_offset + event->header.size, NULL);
+}
+
 struct itrace_queue *itrace_queues__sample_queue(struct itrace_queues *queues,
 						 struct perf_sample *sample,
 						 struct perf_session *session)
@@ -636,6 +670,196 @@ struct itrace_record *__attribute__ ((weak)) itrace_record__init(int *err)
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
+	int err;
+
+	for (i = 0; i < itrace_index->nr; i++) {
+		index.file_offset = itrace_index->entries[i].file_offset;
+		index.sz = itrace_index->entries[i].sz;
+		err = writen(fd, &index, sizeof(index));
+		if (err)
+			return err;
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
+	err = writen(fd, &total, sizeof(total));
+	if (err)
+		return err;
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
index 9ff633c..1005715 100644
--- a/tools/perf/util/itrace.h
+++ b/tools/perf/util/itrace.h
@@ -75,6 +75,32 @@ struct itrace_synth_opts {
 	enum itrace_period_type	period_type;
 };
 
+/**
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
 struct itrace {
 	int (*process_event)(struct perf_session *session,
 			     union perf_event *event,
@@ -320,6 +346,8 @@ int itrace_queues__add_sample(struct itrace_queues *queues,
 			      struct perf_session *session,
 			      unsigned int *queue_nr, u64 ref);
 void itrace_queues__free(struct itrace_queues *queues);
+int itrace_queues__process_index(struct itrace_queues *queues,
+				 struct perf_session *session);
 struct itrace_buffer *itrace_buffer__next(struct itrace_queue *queue,
 					  struct itrace_buffer *buffer);
 void *itrace_buffer__get_data(struct itrace_buffer *buffer, int fd);
@@ -352,6 +380,13 @@ int itrace_record__find_snapshot(struct itrace_record *itr, int idx,
 				 unsigned char *data, u64 *head, u64 *old);
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
index c60238a..8d5f457 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -80,6 +80,7 @@ struct perf_session *perf_session__new(struct perf_data_file *file,
 	INIT_LIST_HEAD(&session->ordered_samples.samples);
 	INIT_LIST_HEAD(&session->ordered_samples.sample_cache);
 	INIT_LIST_HEAD(&session->ordered_samples.to_free);
+	INIT_LIST_HEAD(&session->itrace_index);
 	machines__init(&session->machines);
 
 	if (file) {
@@ -150,6 +151,7 @@ static void perf_session_env__delete(struct perf_session_env *env)
 void perf_session__delete(struct perf_session *session)
 {
 	itrace__free(session);
+	itrace_index__free(&session->itrace_index);
 	perf_session__destroy_kernel_maps(session);
 	perf_session__delete_dead_threads(session);
 	perf_session__delete_threads(session);
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 25aa9e7..9cf3840 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -38,6 +38,7 @@ struct perf_session {
 	struct perf_evlist	*evlist;
 	struct itrace		*itrace;
 	struct itrace_synth_opts *itrace_synth_opts;
+	struct list_head	itrace_index;
 	struct trace_event	tevent;
 	struct events_stats	stats;
 	bool			repipe;
-- 
1.8.5.1

