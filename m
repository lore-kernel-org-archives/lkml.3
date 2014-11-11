Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbaKKOUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:20:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:16753 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbaKKOT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:19:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="630152171"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 15/25] perf itrace: Add a heap for sorting Instruction Tracing queues
Date: Tue, 11 Nov 2014 16:16:53 +0200
Message-Id: <1415715423-15563-16-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
References: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to process Instruction Tracing
data in time order, the queue with data
with the lowest timestamp must be
processed first.  Provide a heap to
keep track of which queue that is.

As with the queues, a decoder does not have
to use the heap, but Intel BTS and Intel PT
will use it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/itrace.c | 85 ++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/itrace.h | 29 +++++++++++++++++
 2 files changed, 114 insertions(+)

diff --git a/tools/perf/util/itrace.c b/tools/perf/util/itrace.c
index c67bf10..b50d959 100644
--- a/tools/perf/util/itrace.c
+++ b/tools/perf/util/itrace.c
@@ -347,6 +347,91 @@ void itrace_queues__free(struct itrace_queues *queues)
 	queues->nr_queues = 0;
 }
 
+static void itrace_heapify(struct itrace_heap_item *heap_array,
+			   unsigned int pos, unsigned int queue_nr,
+			   u64 ordinal)
+{
+	unsigned int parent;
+
+	while (pos) {
+		parent = (pos - 1) >> 1;
+		if (heap_array[parent].ordinal <= ordinal)
+			break;
+		heap_array[pos] = heap_array[parent];
+		pos = parent;
+	}
+	heap_array[pos].queue_nr = queue_nr;
+	heap_array[pos].ordinal = ordinal;
+}
+
+int itrace_heap__add(struct itrace_heap *heap, unsigned int queue_nr,
+		     u64 ordinal)
+{
+	struct itrace_heap_item *heap_array;
+
+	if (queue_nr >= heap->heap_sz) {
+		unsigned int heap_sz = ITRACE_INIT_NR_QUEUES;
+
+		while (heap_sz <= queue_nr)
+			heap_sz <<= 1;
+		heap_array = realloc(heap->heap_array,
+				     heap_sz * sizeof(struct itrace_heap_item));
+		if (!heap_array)
+			return -ENOMEM;
+		heap->heap_array = heap_array;
+		heap->heap_sz = heap_sz;
+	}
+
+	itrace_heapify(heap->heap_array, heap->heap_cnt++, queue_nr, ordinal);
+
+	return 0;
+}
+
+void itrace_heap__free(struct itrace_heap *heap)
+{
+	zfree(&heap->heap_array);
+	heap->heap_cnt = 0;
+	heap->heap_sz = 0;
+}
+
+void itrace_heap__pop(struct itrace_heap *heap)
+{
+	unsigned int pos, last, heap_cnt = heap->heap_cnt;
+	struct itrace_heap_item *heap_array;
+
+	if (!heap_cnt)
+		return;
+
+	heap->heap_cnt -= 1;
+
+	heap_array = heap->heap_array;
+
+	pos = 0;
+	while (1) {
+		unsigned int left, right;
+
+		left = (pos << 1) + 1;
+		if (left >= heap_cnt)
+			break;
+		right = left + 1;
+		if (right >= heap_cnt) {
+			heap_array[pos] = heap_array[left];
+			return;
+		}
+		if (heap_array[left].ordinal < heap_array[right].ordinal) {
+			heap_array[pos] = heap_array[left];
+			pos = left;
+		} else {
+			heap_array[pos] = heap_array[right];
+			pos = right;
+		}
+	}
+
+	last = heap_cnt - 1;
+	itrace_heapify(heap_array, pos, heap_array[last].queue_nr,
+		       heap_array[last].ordinal);
+}
+
 size_t itrace_record__info_priv_size(struct itrace_record *itr)
 {
 	if (itr)
diff --git a/tools/perf/util/itrace.h b/tools/perf/util/itrace.h
index c357893..a7d4ad2 100644
--- a/tools/perf/util/itrace.h
+++ b/tools/perf/util/itrace.h
@@ -172,6 +172,29 @@ struct itrace_queues {
 };
 
 /**
+ * struct itrace_heap_item - element of struct itrace_heap.
+ * @queue_nr: queue number
+ * @ordinal: value used for sorting (lowest ordinal is top of the heap) expected
+ *           to be a timestamp
+ */
+struct itrace_heap_item {
+	unsigned int		queue_nr;
+	u64			ordinal;
+};
+
+/**
+ * struct itrace_heap - a heap suitable for sorting Instruction Tracing queues.
+ * @heap_array: the heap
+ * @heap_cnt: the number of elements in the heap
+ * @heap_sz: maximum number of elements (grows as needed)
+ */
+struct itrace_heap {
+	struct itrace_heap_item	*heap_array;
+	unsigned int		heap_cnt;
+	unsigned int		heap_sz;
+};
+
+/**
  * struct itrace_mmap - records an mmap of the itrace buffer.
  * @base: address of mapped area
  * @userpg: pointer to buffer's perf_event_mmap_page
@@ -280,6 +303,12 @@ void *itrace_buffer__get_data(struct itrace_buffer *buffer, int fd);
 void itrace_buffer__put_data(struct itrace_buffer *buffer);
 void itrace_buffer__drop_data(struct itrace_buffer *buffer);
 void itrace_buffer__free(struct itrace_buffer *buffer);
+
+int itrace_heap__add(struct itrace_heap *heap, unsigned int queue_nr,
+		     u64 ordinal);
+void itrace_heap__pop(struct itrace_heap *heap);
+void itrace_heap__free(struct itrace_heap *heap);
+
 struct itrace_record *itrace_record__init(int *err);
 
 int itrace_record__options(struct itrace_record *itr,
-- 
1.9.1

