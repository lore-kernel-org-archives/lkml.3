Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab3LKMmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:42:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:50059 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab3LKMmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:42:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="450498746"
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
Subject: [PATCH v0 51/71] perf itrace: Add a heap for sorting Instruction Tracing queues
Date: Wed, 11 Dec 2013 14:37:03 +0200
Message-Id: <1386765443-26966-52-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

In order to process Instruction Tracing
data in time order, the queue with data
with the lowest timestamp must be
processed first.  Provide a heap to
keep track of which queue that is.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/itrace.c | 86 ++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/itrace.h | 29 ++++++++++++++++
 2 files changed, 115 insertions(+)

diff --git a/tools/perf/util/itrace.c b/tools/perf/util/itrace.c
index f26d6cd..44214bc 100644
--- a/tools/perf/util/itrace.c
+++ b/tools/perf/util/itrace.c
@@ -344,6 +344,92 @@ void itrace_queues__free(struct itrace_queues *queues)
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
+	free(heap->heap_array);
+	heap->heap_array = NULL;
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
index b4aca53..304d377 100644
--- a/tools/perf/util/itrace.h
+++ b/tools/perf/util/itrace.h
@@ -150,6 +150,29 @@ struct itrace_queues {
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
  * struct itrace_mmap - records an mmap at PERF_EVENT_ITRACE_OFFSET.
  * @base: address of mapped area
  * @mask: %0 if @len is not a power of two, otherwise (@len - %1)
@@ -266,6 +289,12 @@ struct itrace_buffer *itrace_buffer__next(struct itrace_queue *queue,
 					  struct itrace_buffer *buffer);
 void *itrace_buffer__get_data(struct itrace_buffer *buffer, int fd);
 void itrace_buffer__put_data(struct itrace_buffer *buffer);
+
+int itrace_heap__add(struct itrace_heap *heap, unsigned int queue_nr,
+		     u64 ordinal);
+void itrace_heap__pop(struct itrace_heap *heap);
+void itrace_heap__free(struct itrace_heap *heap);
+
 struct itrace_record *itrace_record__init(int *err);
 
 int itrace_record__options(struct itrace_record *itr,
-- 
1.8.5.1

