Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab3LKMma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:42:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:46009 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab3LKMm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:42:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="448281346"
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
Subject: [PATCH v0 56/71] perf tools: Add Instruction Trace sampling support
Date: Wed, 11 Dec 2013 14:37:08 +0200
Message-Id: <1386765443-26966-57-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add functions to configure Instruction
Trace sampling and queue Instruction
Trace samples for processing

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/perf.h         |  10 ++++
 tools/perf/util/evsel.c   |   7 +++
 tools/perf/util/itrace.c  | 117 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/itrace.h  |  36 ++++++++++++++
 tools/perf/util/record.c  |   2 +-
 tools/perf/util/session.c |   6 ++-
 6 files changed, 176 insertions(+), 2 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index b68b469..c748383 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -262,6 +262,7 @@ struct perf_record_opts {
 	bool	     sample_time;
 	bool	     period;
 	bool	     full_itrace;
+	bool	     sample_itrace;
 	unsigned int freq;
 	unsigned int mmap_pages;
 	unsigned int itrace_mmap_pages;
@@ -269,8 +270,17 @@ struct perf_record_opts {
 	u64          branch_stack;
 	u64	     default_interval;
 	u64	     user_interval;
+	u64	     itrace_sample_config;
+	u32	     itrace_sample_type;
+	size_t	     itrace_sample_size;
 	u16	     stack_dump_size;
 	bool	     sample_transaction;
 };
 
+static
+inline bool perf_record_opts_itracing(const struct perf_record_opts *opts)
+{
+	return opts->full_itrace || opts->sample_itrace;
+}
+
 #endif
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 88b7edd..0972b20 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -640,6 +640,13 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	if (opts->sample_weight)
 		perf_evsel__set_sample_bit(evsel, WEIGHT);
 
+	if (opts->sample_itrace && !evsel->no_aux_samples) {
+		perf_evsel__set_sample_bit(evsel, ITRACE);
+		attr->itrace_config = opts->itrace_sample_config;
+		attr->itrace_sample_size = opts->itrace_sample_size;
+		attr->itrace_sample_type = opts->itrace_sample_type;
+	}
+
 	attr->mmap  = track;
 	attr->comm  = track;
 
diff --git a/tools/perf/util/itrace.c b/tools/perf/util/itrace.c
index 91f1fb5..d64dcb1 100644
--- a/tools/perf/util/itrace.c
+++ b/tools/perf/util/itrace.c
@@ -321,6 +321,108 @@ int itrace_queues__add_event(struct itrace_queues *queues,
 	return itrace_queues__add_buffer(queues, event->itrace.idx, buffer);
 }
 
+struct itrace_queue *itrace_queues__sample_queue(struct itrace_queues *queues,
+						 struct perf_sample *sample,
+						 struct perf_session *session)
+{
+	struct perf_sample_id *sid;
+	unsigned int idx;
+	u64 id;
+
+	id = sample->id;
+	if (!id)
+		return NULL;
+
+	sid = perf_evlist__id2sid(session->evlist, id);
+	if (!sid)
+		return NULL;
+
+	idx = sid->idx;
+
+	if (idx >= queues->nr_queues)
+		return NULL;
+
+	return &queues->queue_array[idx];
+}
+
+int itrace_queues__add_sample(struct itrace_queues *queues,
+			      struct perf_sample *sample,
+			      struct perf_session *session,
+			      unsigned int *queue_nr, u64 ref)
+{
+	struct itrace_buffer *buffer;
+	struct itrace_queue *queue;
+	struct perf_sample_id *sid;
+	unsigned int idx;
+	int err;
+	u64 id;
+
+	queues->populated = true;
+
+	id = sample->id;
+	if (!id)
+		return -EINVAL;
+
+	sid = perf_evlist__id2sid(session->evlist, id);
+	if (!sid)
+		return -ENOENT;
+
+	idx = sid->idx;
+
+	if (idx >= queues->nr_queues) {
+		err = itrace_queues__grow(queues, idx);
+		if (err)
+			return err;
+	}
+
+	queue = &queues->queue_array[idx];
+
+	if (!queue->set) {
+		queue->set = true;
+		queue->cpu = sid->cpu;
+		queue->tid = sid->tid;
+	} else if (sid->cpu != queue->cpu || sid->tid != queue->tid) {
+		pr_err("itrace queue conflicts with event (id %"PRIu64"):", id);
+		pr_err(" cpu %d, tid %d vs cpu %d, tid %d\n",
+		       queue->cpu, queue->tid, sid->cpu, sid->tid);
+		return -EINVAL;
+	}
+
+	buffer = zalloc(sizeof(struct itrace_buffer));
+	if (!buffer)
+		return -ENOMEM;
+
+	buffer->cpu = sample->cpu;
+	buffer->pid = sample->pid;
+	buffer->tid = sample->tid;
+	buffer->reference = ref;
+
+	if (perf_data_file__is_pipe(session->file) || !session->one_mmap) {
+		void *data = memdup(sample->itrace_sample.data,
+				    sample->itrace_sample.size);
+
+		if (!data) {
+			free(buffer);
+			return -ENOMEM;
+		}
+		buffer->size = sample->itrace_sample.size;
+		buffer->data = data;
+		buffer->data_needs_freeing = true;
+	} else {
+		buffer->size = sample->itrace_sample.size;
+		buffer->data = sample->itrace_sample.data;
+	}
+
+	list_add_tail(&buffer->list, &queue->head);
+
+	queues->new_data = true;
+
+	if (queue_nr)
+		*queue_nr = idx;
+
+	return 0;
+}
+
 void itrace_queues__free(struct itrace_queues *queues)
 {
 	unsigned int i;
@@ -475,6 +577,21 @@ u64 itrace_record__reference(struct itrace_record *itr)
 	return 0;
 }
 
+int itrace_parse_sample_options(const struct option *opt, const char *str,
+				int unset)
+{
+	struct itrace_record *itr = *(struct itrace_record **)opt->data;
+	struct perf_record_opts *opts = opt->value;
+
+	if (unset)
+		return 0;
+
+	if (itr)
+		return itr->parse_sample_options(itr, opts, str);
+
+	return itrace_not_supported();
+}
+
 struct itrace_record *__attribute__ ((weak)) itrace_record__init(int *err)
 {
 	*err = 0;
diff --git a/tools/perf/util/itrace.h b/tools/perf/util/itrace.h
index ec3b78a..2ebcdec 100644
--- a/tools/perf/util/itrace.h
+++ b/tools/perf/util/itrace.h
@@ -80,9 +80,14 @@ struct itrace {
 			     union perf_event *event,
 			     struct perf_sample *sample,
 			     struct perf_tool *tool);
+	int (*queue_event)(struct perf_session *session,
+			   union perf_event *event,
+			   struct perf_sample *sample);
 	int (*process_itrace_event)(struct perf_session *session,
 				    union perf_event *event,
 				    struct perf_tool *tool);
+	void (*dump_itrace_sample)(struct perf_session *session,
+				   struct perf_sample *sample);
 	int (*flush_events)(struct perf_session *session,
 			    struct perf_tool *tool);
 	void (*free_events)(struct perf_session *session);
@@ -224,6 +229,9 @@ struct itrace_mmap_params {
 };
 
 struct itrace_record {
+	int (*parse_sample_options)(struct itrace_record *itr,
+				    struct perf_record_opts *opts,
+				    const char *str);
 	int (*recording_options)(struct itrace_record *itr,
 				 struct perf_evlist *evlist,
 				 struct perf_record_opts *opts);
@@ -291,6 +299,13 @@ int itrace_queues__add_event(struct itrace_queues *queues,
 			     struct perf_session *session,
 			     union perf_event *event, off_t data_offset,
 			     struct itrace_buffer **buffer_ptr);
+struct itrace_queue *itrace_queues__sample_queue(struct itrace_queues *queues,
+						 struct perf_sample *sample,
+						 struct perf_session *session);
+int itrace_queues__add_sample(struct itrace_queues *queues,
+			      struct perf_sample *sample,
+			      struct perf_session *session,
+			      unsigned int *queue_nr, u64 ref);
 void itrace_queues__free(struct itrace_queues *queues);
 struct itrace_buffer *itrace_buffer__next(struct itrace_queue *queue,
 					  struct itrace_buffer *buffer);
@@ -304,6 +319,8 @@ void itrace_heap__free(struct itrace_heap *heap);
 
 struct itrace_record *itrace_record__init(int *err);
 
+int itrace_parse_sample_options(const struct option *opt, const char *str,
+				int unset);
 int itrace_record__options(struct itrace_record *itr,
 			     struct perf_evlist *evlist,
 			     struct perf_record_opts *opts);
@@ -356,6 +373,25 @@ static inline int itrace__process_event(struct perf_session *session,
 	return session->itrace->process_event(session, event, sample, tool);
 }
 
+static inline int itrace__queue_event(struct perf_session *session,
+				      union perf_event *event,
+				      struct perf_sample *sample)
+{
+	if (!session->itrace)
+		return 0;
+
+	return session->itrace->queue_event(session, event, sample);
+}
+
+static inline void itrace__dump_itrace_sample(struct perf_session *session,
+					      struct perf_sample *sample)
+{
+	if (!session->itrace)
+		return;
+
+	session->itrace->dump_itrace_sample(session, sample);
+}
+
 static inline int itrace__flush_events(struct perf_session *session,
 				       struct perf_tool *tool)
 {
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index 86f980e..52d5bca 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -93,7 +93,7 @@ void perf_evlist__config(struct perf_evlist *evlist,
 	list_for_each_entry(evsel, &evlist->entries, node)
 		perf_evsel__config(evsel, opts);
 
-	if (opts->full_itrace) {
+	if (perf_record_opts_itracing(opts)) {
 		use_sample_identifier = true;
 		list_for_each_entry(evsel, &evlist->entries, node)
 			perf_evsel__set_sample_id(evsel, use_sample_identifier);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 49c89e7..c60238a 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -771,7 +771,7 @@ int perf_session_queue_event(struct perf_session *s, union perf_event *event,
 
 	__queue_event(new, s);
 
-	return 0;
+	return itrace__queue_event(s, event, sample);
 }
 
 static void callchain__printf(struct perf_sample *sample)
@@ -885,6 +885,10 @@ static void dump_event(struct perf_session *session, union perf_event *event,
 
 	trace_event(event);
 
+	/* Instruction trace sample is so big it is better printed here */
+	if (sample && sample->itrace_sample.size)
+		itrace__dump_itrace_sample(session, sample);
+
 	if (sample)
 		perf_session__print_tstamp(session, event, sample);
 
-- 
1.8.5.1

