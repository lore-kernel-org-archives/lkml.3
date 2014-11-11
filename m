Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaKKOTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:19:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:55261 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbaKKOTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:19:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="630151706"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 07/25] perf tools: Add support for Instruction Trace recording
Date: Tue, 11 Nov 2014 16:16:45 +0200
Message-Id: <1415715423-15563-8-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
References: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for reading from the Instruction
Tracing mmap and synthesizing Instruction
Tracing events.

This patch introduces an abstraction for recording
Instruction Trace data.  Recording is initialized
by itrace_record__init() which is a weak function
to be implemented by the architecture to provide
recording callbacks.  Recording is mainly handled
by itrace_mmap__read() and
perf_event__synthesize_itrace() but there are
callbacks for miscellaneous needs including
validating and processing user options, populating
private data in itrace_info_event, and freeing
the structure when finished.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/perf.h        |   2 +
 tools/perf/util/itrace.c | 195 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/itrace.h |  59 +++++++++++++-
 tools/perf/util/record.c |  11 ++-
 4 files changed, 265 insertions(+), 2 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 511c2831..24c97bc 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -52,8 +52,10 @@ struct record_opts {
 	bool	     sample_weight;
 	bool	     sample_time;
 	bool	     period;
+	bool	     full_itrace;
 	unsigned int freq;
 	unsigned int mmap_pages;
+	unsigned int itrace_mmap_pages;
 	unsigned int user_freq;
 	u64          branch_stack;
 	u64	     default_interval;
diff --git a/tools/perf/util/itrace.c b/tools/perf/util/itrace.c
index c950b4f..08372a9 100644
--- a/tools/perf/util/itrace.c
+++ b/tools/perf/util/itrace.c
@@ -21,6 +21,10 @@
 #include <linux/perf_event.h>
 #include <linux/types.h>
 
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+
 #include "../perf.h"
 #include "util.h"
 #include "evlist.h"
@@ -28,6 +32,9 @@
 #include "thread_map.h"
 #include "itrace.h"
 
+#include "event.h"
+#include "debug.h"
+
 int itrace_mmap__mmap(struct itrace_mmap *mm, struct itrace_mmap_params *mp,
 		      void *userpg, int fd)
 {
@@ -97,3 +104,191 @@ void itrace_mmap_params__set_idx(struct itrace_mmap_params *mp,
 		mp->tid = evlist->threads->map[idx];
 	}
 }
+
+size_t itrace_record__info_priv_size(struct itrace_record *itr)
+{
+	if (itr)
+		return itr->info_priv_size(itr);
+	return 0;
+}
+
+static int itrace_not_supported(void)
+{
+	pr_err("Instruction tracing is not supported on this architecture\n");
+	return -EINVAL;
+}
+
+int itrace_record__info_fill(struct itrace_record *itr,
+			     struct perf_session *session,
+			     struct itrace_info_event *itrace_info,
+			     size_t priv_size)
+{
+	if (itr)
+		return itr->info_fill(itr, session, itrace_info, priv_size);
+	return itrace_not_supported();
+}
+
+void itrace_record__free(struct itrace_record *itr)
+{
+	if (itr)
+		itr->free(itr);
+}
+
+int itrace_record__options(struct itrace_record *itr,
+			   struct perf_evlist *evlist,
+			   struct record_opts *opts)
+{
+	if (itr)
+		return itr->recording_options(itr, evlist, opts);
+	return 0;
+}
+
+u64 itrace_record__reference(struct itrace_record *itr)
+{
+	if (itr)
+		return itr->reference(itr);
+	return 0;
+}
+
+struct itrace_record * __weak itrace_record__init(int *err)
+{
+	*err = 0;
+	return NULL;
+}
+
+int perf_event__synthesize_itrace_info(struct itrace_record *itr,
+				       struct perf_tool *tool,
+				       struct perf_session *session,
+				       perf_event__handler_t process)
+{
+	union perf_event *ev;
+	size_t priv_size;
+	int err;
+
+	pr_debug2("Synthesizing itrace information\n");
+	priv_size = itrace_record__info_priv_size(itr);
+	ev = zalloc(sizeof(struct itrace_info_event) + priv_size);
+	if (!ev)
+		return -ENOMEM;
+
+	ev->itrace_info.header.type = PERF_RECORD_ITRACE_INFO;
+	ev->itrace_info.header.size = sizeof(struct itrace_info_event) +
+				      priv_size;
+	err = itrace_record__info_fill(itr, session, &ev->itrace_info,
+				       priv_size);
+	if (err)
+		goto out_free;
+
+	err = process(tool, ev, NULL, NULL);
+out_free:
+	free(ev);
+	return err;
+}
+
+int perf_event__synthesize_itrace(struct perf_tool *tool,
+				  perf_event__handler_t process,
+				  size_t size, u64 offset, u64 ref, int idx,
+				  u32 tid, u32 cpu)
+{
+	union perf_event ev;
+
+	memset(&ev, 0, sizeof(ev));
+	ev.itrace.header.type = PERF_RECORD_ITRACE;
+	ev.itrace.header.size = sizeof(ev.itrace);
+	ev.itrace.size = size;
+	ev.itrace.offset = offset;
+	ev.itrace.reference = ref;
+	ev.itrace.idx = idx;
+	ev.itrace.tid = tid;
+	ev.itrace.cpu = cpu;
+
+	return process(tool, &ev, NULL, NULL);
+}
+
+int itrace_mmap__read(struct itrace_mmap *mm, struct itrace_record *itr,
+		      struct perf_tool *tool, process_itrace_t fn)
+{
+	u64 head = itrace_mmap__read_head(mm);
+	u64 old = mm->prev, offset, ref;
+	unsigned char *data = mm->base;
+	size_t size, head_off, old_off, len1, len2, padding;
+	union perf_event ev;
+	void *data1, *data2;
+
+	if (old == head)
+		return 0;
+
+	pr_debug3("itrace idx %d old %#"PRIx64" head %#"PRIx64" diff %#"PRIx64"\n",
+		  mm->idx, old, head, head - old);
+
+	if (mm->mask) {
+		head_off = head & mm->mask;
+		old_off = old & mm->mask;
+	} else {
+		head_off = head % mm->len;
+		old_off = old % mm->len;
+	}
+
+	if (head_off > old_off)
+		size = head_off - old_off;
+	else
+		size = mm->len - (old_off - head_off);
+
+	ref = itrace_record__reference(itr);
+
+	if (head > old || size <= head || mm->mask) {
+		offset = head - size;
+	} else {
+		/*
+		 * When the buffer size is not a power of 2, 'head' wraps at the
+		 * highest multiple of the buffer size, so we have to subtract
+		 * the remainder here.
+		 */
+		u64 rem = (0ULL - mm->len) % mm->len;
+
+		offset = head - size - rem;
+	}
+
+	if (size > head_off) {
+		len1 = size - head_off;
+		data1 = &data[mm->len - len1];
+		len2 = head_off;
+		data2 = &data[0];
+	} else {
+		len1 = size;
+		data1 = &data[head_off - len1];
+		len2 = 0;
+		data2 = NULL;
+	}
+
+	/* padding must be written by fn() e.g. record__process_itrace() */
+	padding = size & 7;
+	if (padding)
+		padding = 8 - padding;
+
+	memset(&ev, 0, sizeof(ev));
+	ev.itrace.header.type = PERF_RECORD_ITRACE;
+	ev.itrace.header.size = sizeof(ev.itrace);
+	ev.itrace.size = size + padding;
+	ev.itrace.offset = offset;
+	ev.itrace.reference = ref;
+	ev.itrace.idx = mm->idx;
+	ev.itrace.tid = mm->tid;
+	ev.itrace.cpu = mm->cpu;
+
+	if (fn(tool, &ev, data1, len1, data2, len2))
+		return -1;
+
+	mm->prev = head;
+
+	itrace_mmap__write_tail(mm, head);
+	if (itr->read_finish) {
+		int err;
+
+		err = itr->read_finish(itr, mm->idx);
+		if (err < 0)
+			return err;
+	}
+
+	return 1;
+}
diff --git a/tools/perf/util/itrace.h b/tools/perf/util/itrace.h
index 00ba409..44b6a01 100644
--- a/tools/perf/util/itrace.h
+++ b/tools/perf/util/itrace.h
@@ -18,13 +18,18 @@
 
 #include <sys/types.h>
 #include <stdbool.h>
-
+#include <stddef.h>
 #include <linux/perf_event.h>
 #include <linux/types.h>
 
 #include "../perf.h"
 
+union perf_event;
+struct perf_session;
 struct perf_evlist;
+struct perf_tool;
+struct record_opts;
+struct itrace_info_event;
 
 /**
  * struct itrace_mmap - records an mmap of the itrace buffer.
@@ -70,6 +75,29 @@ struct itrace_mmap_params {
 	int		cpu;
 };
 
+/**
+ * struct itrace_record - callbacks for recording Instruction Trace data.
+ * @recording_options: validate and process recording options
+ * @info_priv_size: return the size of the private data in itrace_info_event
+ * @info_fill: fill-in the private data in itrace_info_event
+ * @free: free this itrace record structure
+ * @reference: provide a 64-bit reference number for itrace_event
+ * @read_finish: called after reading from an itrace mmap
+ */
+struct itrace_record {
+	int (*recording_options)(struct itrace_record *itr,
+				 struct perf_evlist *evlist,
+				 struct record_opts *opts);
+	size_t (*info_priv_size)(struct itrace_record *itr);
+	int (*info_fill)(struct itrace_record *itr,
+			 struct perf_session *session,
+			 struct itrace_info_event *itrace_info,
+			 size_t priv_size);
+	void (*free)(struct itrace_record *itr);
+	u64 (*reference)(struct itrace_record *itr);
+	int (*read_finish)(struct itrace_record *itr, int idx);
+};
+
 static inline u64 itrace_mmap__read_head(struct itrace_mmap *mm __maybe_unused)
 {
 	/* Not yet implemented */
@@ -93,4 +121,33 @@ void itrace_mmap_params__set_idx(struct itrace_mmap_params *mp,
 				 struct perf_evlist *evlist, int idx,
 				 bool per_cpu);
 
+typedef int (*process_itrace_t)(struct perf_tool *tool, union perf_event *event,
+				void *data1, size_t len1, void *data2,
+				size_t len2);
+
+int itrace_mmap__read(struct itrace_mmap *mm, struct itrace_record *itr,
+		      struct perf_tool *tool, process_itrace_t fn);
+
+struct itrace_record *itrace_record__init(int *err);
+
+int itrace_record__options(struct itrace_record *itr,
+			   struct perf_evlist *evlist,
+			   struct record_opts *opts);
+size_t itrace_record__info_priv_size(struct itrace_record *itr);
+int itrace_record__info_fill(struct itrace_record *itr,
+			     struct perf_session *session,
+			     struct itrace_info_event *itrace_info,
+			     size_t priv_size);
+void itrace_record__free(struct itrace_record *itr);
+u64 itrace_record__reference(struct itrace_record *itr);
+
+int perf_event__synthesize_itrace_info(struct itrace_record *itr,
+				       struct perf_tool *tool,
+				       struct perf_session *session,
+				       perf_event__handler_t process);
+int perf_event__synthesize_itrace(struct perf_tool *tool,
+				  perf_event__handler_t process,
+				  size_t size, u64 offset, u64 ref, int idx,
+				  u32 tid, u32 cpu);
+
 #endif
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index cf69325..656eaa3 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -119,7 +119,16 @@ void perf_evlist__config(struct perf_evlist *evlist, struct record_opts *opts)
 			evsel->attr.comm_exec = 1;
 	}
 
-	if (evlist->nr_entries > 1) {
+	if (opts->full_itrace) {
+		/*
+		 * Need to be able to synthesize and parse selected events with
+		 * arbitrary sample types, which requires always being able to
+		 * match the id.
+		 */
+		use_sample_identifier = true;
+		evlist__for_each(evlist, evsel)
+			perf_evsel__set_sample_id(evsel, use_sample_identifier);
+	} else if (evlist->nr_entries > 1) {
 		struct perf_evsel *first = perf_evlist__first(evlist);
 
 		evlist__for_each(evlist, evsel) {
-- 
1.9.1

