Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab3LKMlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:41:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:58062 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab3LKMlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:41:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="450498479"
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
Subject: [PATCH v0 42/71] perf tools: Add support for Instruction Trace recording
Date: Wed, 11 Dec 2013 14:36:54 +0200
Message-Id: <1386765443-26966-43-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add support for reading from the Instruction
Tracing mmap and synthesizing Instruction
Tracing events.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/perf.h        |   2 +
 tools/perf/util/itrace.c | 190 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/itrace.h |  51 ++++++++++++-
 tools/perf/util/record.c |   6 +-
 4 files changed, 247 insertions(+), 2 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index b23fed5..b68b469 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -261,8 +261,10 @@ struct perf_record_opts {
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
index a889e63..9596cc2 100644
--- a/tools/perf/util/itrace.c
+++ b/tools/perf/util/itrace.c
@@ -24,6 +24,10 @@
 #include <linux/kernel.h>
 #include <linux/perf_event.h>
 
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+
 #include "../perf.h"
 #include "types.h"
 #include "util.h"
@@ -32,6 +36,9 @@
 #include "thread_map.h"
 #include "itrace.h"
 
+#include "event.h"
+#include "debug.h"
+
 int itrace_mmap__mmap(struct itrace_mmap *mm, struct itrace_mmap_params *mp,
 		      int fd)
 {
@@ -102,3 +109,186 @@ void itrace_mmap_params__set_idx(struct itrace_mmap_params *mp,
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
+			   struct perf_record_opts *opts)
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
+struct itrace_record *__attribute__ ((weak)) itrace_record__init(int *err)
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
+	unsigned char *data = mm->base + page_size;
+	size_t size, head_off, old_off, len1, len2;
+	union perf_event ev;
+	void *data1, *data2;
+
+	if (old == head)
+		return 0;
+
+	pr_debug3("itrace idx %d old %"PRIu64" head %"PRIu64" diff %"PRIu64"\n",
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
+	memset(&ev, 0, sizeof(ev));
+	ev.itrace.header.type = PERF_RECORD_ITRACE;
+	ev.itrace.header.size = sizeof(ev.itrace);
+	ev.itrace.size = size;
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
index 4b17aca..da52a29 100644
--- a/tools/perf/util/itrace.h
+++ b/tools/perf/util/itrace.h
@@ -22,13 +22,18 @@
 
 #include <sys/types.h>
 #include <stdbool.h>
-
+#include <stddef.h>
 #include <linux/perf_event.h>
 
 #include "../perf.h"
 #include "types.h"
 
+union perf_event;
+struct perf_session;
 struct perf_evlist;
+struct perf_tool;
+struct perf_record_opts;
+struct itrace_info_event;
 
 /**
  * struct itrace_mmap - records an mmap at PERF_EVENT_ITRACE_OFFSET.
@@ -74,6 +79,20 @@ struct itrace_mmap_params {
 	int		cpu;
 };
 
+struct itrace_record {
+	int (*recording_options)(struct itrace_record *itr,
+				 struct perf_evlist *evlist,
+				 struct perf_record_opts *opts);
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
 static inline u64 itrace_mmap__read_head(struct itrace_mmap *mm)
 {
 	struct perf_event_mmap_page *pc = mm->base;
@@ -115,4 +134,34 @@ void itrace_mmap_params__set_idx(struct itrace_mmap_params *mp,
 				 struct perf_evlist *evlist, int idx,
 				 bool per_cpu);
 
+typedef int (*process_itrace_t)(struct perf_tool *tool, union perf_event *event,
+				void *data1, size_t len1, void *data2,
+				size_t len2);
+
+int itrace_mmap__read(struct itrace_mmap *mm,
+			    struct itrace_record *itr, struct perf_tool *tool,
+			    process_itrace_t fn);
+
+struct itrace_record *itrace_record__init(int *err);
+
+int itrace_record__options(struct itrace_record *itr,
+			     struct perf_evlist *evlist,
+			     struct perf_record_opts *opts);
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
index e510453..86f980e 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -93,7 +93,11 @@ void perf_evlist__config(struct perf_evlist *evlist,
 	list_for_each_entry(evsel, &evlist->entries, node)
 		perf_evsel__config(evsel, opts);
 
-	if (evlist->nr_entries > 1) {
+	if (opts->full_itrace) {
+		use_sample_identifier = true;
+		list_for_each_entry(evsel, &evlist->entries, node)
+			perf_evsel__set_sample_id(evsel, use_sample_identifier);
+	} else if (evlist->nr_entries > 1) {
 		struct perf_evsel *first = perf_evlist__first(evlist);
 
 		list_for_each_entry(evsel, &evlist->entries, node) {
-- 
1.8.5.1

