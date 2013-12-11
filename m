Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab3LKMsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:48:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:62878 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab3LKMl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:41:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="448281178"
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
Subject: [PATCH v0 50/71] perf itrace: Add helpers for queuing Instruction Tracing data
Date: Wed, 11 Dec 2013 14:37:02 +0200
Message-Id: <1386765443-26966-51-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Provide functions to queue Instruction
Tracing data buffers for processing.
There is one queue for each of the
mmap buffers used for recording.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/itrace.c | 278 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/itrace.h |  77 +++++++++++++
 2 files changed, 355 insertions(+)

diff --git a/tools/perf/util/itrace.c b/tools/perf/util/itrace.c
index 865b584..f26d6cd 100644
--- a/tools/perf/util/itrace.c
+++ b/tools/perf/util/itrace.c
@@ -23,11 +23,15 @@
 
 #include <linux/kernel.h>
 #include <linux/perf_event.h>
+#include <linux/string.h>
 
+#include <sys/param.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
+#include <limits.h>
 #include <errno.h>
+#include <linux/list.h>
 
 #include "../perf.h"
 #include "types.h"
@@ -113,6 +117,233 @@ void itrace_mmap_params__set_idx(struct itrace_mmap_params *mp,
 	}
 }
 
+#define ITRACE_INIT_NR_QUEUES	32
+
+static struct itrace_queue *itrace_alloc_queue_array(unsigned int nr_queues)
+{
+	struct itrace_queue *queue_array;
+	unsigned int max_nr_queues, i;
+
+	max_nr_queues = MIN(UINT_MAX, SIZE_MAX) / sizeof(struct itrace_queue);
+	if (nr_queues > max_nr_queues)
+		return NULL;
+
+	queue_array = calloc(nr_queues, sizeof(struct itrace_queue));
+	if (!queue_array)
+		return NULL;
+
+	for (i = 0; i < nr_queues; i++) {
+		INIT_LIST_HEAD(&queue_array[i].head);
+		queue_array[i].priv = NULL;
+	}
+
+	return queue_array;
+}
+
+int itrace_queues__init(struct itrace_queues *queues)
+{
+	queues->nr_queues = ITRACE_INIT_NR_QUEUES;
+	queues->queue_array = itrace_alloc_queue_array(queues->nr_queues);
+	if (!queues->queue_array)
+		return -ENOMEM;
+	return 0;
+}
+
+static int itrace_queues__grow(struct itrace_queues *queues,
+			       unsigned int new_nr_queues)
+{
+	unsigned int nr_queues = queues->nr_queues;
+	struct itrace_queue *queue_array;
+	unsigned int i;
+
+	if (!nr_queues)
+		nr_queues = ITRACE_INIT_NR_QUEUES;
+
+	while (nr_queues && nr_queues < new_nr_queues)
+		nr_queues <<= 1;
+
+	if (nr_queues < queues->nr_queues || nr_queues < new_nr_queues)
+		return -EINVAL;
+
+	queue_array = itrace_alloc_queue_array(nr_queues);
+	if (!queue_array)
+		return -ENOMEM;
+
+	for (i = 0; i < queues->nr_queues; i++) {
+		list_splice_tail(&queues->queue_array[i].head,
+				 &queue_array[i].head);
+		queue_array[i].priv = queues->queue_array[i].priv;
+	}
+
+	queues->nr_queues = nr_queues;
+	queues->queue_array = queue_array;
+
+	return 0;
+}
+
+static void *itrace_event__copy_data(union perf_event *event,
+				     struct perf_session *session)
+{
+	int fd = perf_data_file__fd(session->file);
+	void *p;
+	ssize_t ret;
+
+	if (event->itrace.size > SSIZE_MAX)
+		return NULL;
+
+	p = malloc(event->itrace.size);
+	if (!p)
+		return NULL;
+
+	ret = readn(fd, p, event->itrace.size);
+	if (ret != (ssize_t)event->itrace.size) {
+		free(p);
+		return NULL;
+	}
+
+	return p;
+}
+
+static int itrace_queues__add_buffer(struct itrace_queues *queues,
+				     unsigned int idx,
+				     struct itrace_buffer *buffer)
+{
+	struct itrace_queue *queue;
+	int err;
+
+	if (idx >= queues->nr_queues) {
+		err = itrace_queues__grow(queues, idx + 1);
+		if (err)
+			goto out_err;
+	}
+
+	queue = &queues->queue_array[idx];
+
+	if (!queue->set) {
+		queue->set = true;
+		queue->tid = buffer->tid;
+		queue->cpu = buffer->cpu;
+	} else if (buffer->cpu != queue->cpu || buffer->tid != queue->tid) {
+		pr_err("itrace queue conflict: cpu %d, tid %d vs cpu %d, tid %d\n",
+		       queue->cpu, queue->tid, buffer->cpu, buffer->tid);
+		err = -EINVAL;
+		goto out_err;
+	}
+
+	list_add_tail(&buffer->list, &queue->head);
+
+	queues->new_data = true;
+
+	return 0;
+
+out_err:
+	if (buffer->data_needs_freeing)
+		free(buffer->data);
+	free(buffer);
+	return err;
+}
+
+/* Limit buffers to 32MiB on 32-bit */
+#define BUFFER_LIMIT_FOR_32_BIT (32 * 1024 * 1024)
+
+static int itrace_queues__split_buffer(struct itrace_queues *queues,
+				       union perf_event *event,
+				       struct itrace_buffer *buffer)
+{
+	u64 sz = event->itrace.size;
+	bool consecutive = false;
+	struct itrace_buffer *b;
+	int err;
+
+	while (sz > BUFFER_LIMIT_FOR_32_BIT) {
+		b = memdup(buffer, sizeof(struct itrace_buffer));
+		if (!b)
+			return -ENOMEM;
+		b->size = BUFFER_LIMIT_FOR_32_BIT;
+		b->consecutive = consecutive;
+		err = itrace_queues__add_buffer(queues, event->itrace.idx, b);
+		if (err)
+			return err;
+		buffer->data_offset += BUFFER_LIMIT_FOR_32_BIT;
+		sz -= BUFFER_LIMIT_FOR_32_BIT;
+		consecutive = true;
+	}
+
+	buffer->size = sz;
+	buffer->consecutive = consecutive;
+
+	return 0;
+}
+
+int itrace_queues__add_event(struct itrace_queues *queues,
+			     struct perf_session *session,
+			     union perf_event *event, off_t data_offset,
+			     struct itrace_buffer **buffer_ptr)
+{
+	struct itrace_buffer *buffer;
+	int err;
+
+	queues->populated = true;
+
+	buffer = zalloc(sizeof(struct itrace_buffer));
+	if (!buffer)
+		return -ENOMEM;
+
+	if (buffer_ptr)
+		*buffer_ptr = buffer;
+
+	buffer->tid = event->itrace.tid;
+	buffer->cpu = event->itrace.cpu;
+
+	buffer->offset = event->itrace.offset;
+	buffer->reference = event->itrace.reference;
+
+	buffer->size = event->itrace.size;
+
+	if (session->one_mmap) {
+		buffer->data = data_offset - session->one_mmap_offset +
+			       session->one_mmap_addr;
+	} else if (perf_data_file__is_pipe(session->file)) {
+		buffer->data = itrace_event__copy_data(event, session);
+		if (!buffer->data)
+			return -ENOMEM;
+		buffer->data_needs_freeing = true;
+	} else if (BITS_PER_LONG == 64 ||
+		   event->itrace.size <= BUFFER_LIMIT_FOR_32_BIT) {
+		buffer->data_offset = data_offset;
+	} else {
+		buffer->data_offset = data_offset;
+		err = itrace_queues__split_buffer(queues, event, buffer);
+		if (err)
+			return err;
+	}
+
+	return itrace_queues__add_buffer(queues, event->itrace.idx, buffer);
+}
+
+void itrace_queues__free(struct itrace_queues *queues)
+{
+	unsigned int i;
+
+	for (i = 0; i < queues->nr_queues; i++) {
+		while (!list_empty(&queues->queue_array[i].head)) {
+			struct itrace_buffer *buffer;
+
+			buffer = list_entry(queues->queue_array[i].head.next,
+					     struct itrace_buffer, list);
+			itrace_buffer__put_data(buffer);
+			if (buffer->data_needs_freeing)
+				free(buffer->data);
+			list_del(&buffer->list);
+			free(buffer);
+		}
+	}
+
+	free(queues->queue_array);
+	queues->queue_array = NULL;
+	queues->nr_queues = 0;
+}
+
 size_t itrace_record__info_priv_size(struct itrace_record *itr)
 {
 	if (itr)
@@ -164,6 +395,53 @@ struct itrace_record *__attribute__ ((weak)) itrace_record__init(int *err)
 	return NULL;
 }
 
+struct itrace_buffer *itrace_buffer__next(struct itrace_queue *queue,
+					  struct itrace_buffer *buffer)
+{
+	if (buffer) {
+		if (list_is_last(&buffer->list, &queue->head))
+			return NULL;
+		return list_entry(buffer->list.next, struct itrace_buffer,
+				  list);
+	} else {
+		if (list_empty(&queue->head))
+			return NULL;
+		return list_entry(queue->head.next, struct itrace_buffer, list);
+	}
+}
+
+void *itrace_buffer__get_data(struct itrace_buffer *buffer, int fd)
+{
+	size_t adj = buffer->data_offset & (page_size - 1);
+	size_t size = buffer->size + adj;
+	off_t file_offset = buffer->data_offset - adj;
+	void *addr;
+
+	if (buffer->data)
+		return buffer->data;
+
+	addr = mmap(NULL, size, PROT_READ, MAP_SHARED, fd, file_offset);
+	if (addr == MAP_FAILED)
+		return NULL;
+
+	buffer->mmap_addr = addr;
+	buffer->mmap_size = size;
+
+	buffer->data = addr + adj;
+
+	return buffer->data;
+}
+
+void itrace_buffer__put_data(struct itrace_buffer *buffer)
+{
+	if (!buffer->data || !buffer->mmap_addr)
+		return;
+	munmap(buffer->mmap_addr, buffer->mmap_size);
+	buffer->mmap_addr = NULL;
+	buffer->mmap_size = 0;
+	buffer->data = NULL;
+}
+
 void itrace_synth_error(struct itrace_error_event *itrace_error, int type,
 			int code, int cpu, pid_t pid, pid_t tid, u64 ip,
 			const char *msg)
diff --git a/tools/perf/util/itrace.h b/tools/perf/util/itrace.h
index 08877d2..b4aca53 100644
--- a/tools/perf/util/itrace.h
+++ b/tools/perf/util/itrace.h
@@ -23,6 +23,7 @@
 #include <sys/types.h>
 #include <stdbool.h>
 #include <stddef.h>
+#include <linux/list.h>
 #include <linux/perf_event.h>
 
 #include "../perf.h"
@@ -83,6 +84,72 @@ struct itrace {
 };
 
 /**
+ * struct itrace_buffer - a buffer containing Instruction Tracing data.
+ * @list: buffers are queued in a list held by struct itrace_queue
+ * @size: size of the buffer in bytes
+ * @pid: in per-thread mode, the pid this buffer is associated with
+ * @tid: in per-thread mode, the tid this buffer is associated with
+ * @cpu: in per-cpu mode, the cpu this buffer is associated with
+ * @data: actual buffer data (can be null if the data has not been loaded)
+ * @data_offset: file offset at which the buffer can be read
+ * @mmap_addr: mmap address at which the buffer can be read
+ * @mmap_size: size of the mmap at @mmap_addr
+ * @data_needs_freeing: @data was malloc'd so free it when it is no longer
+ *                      needed
+ * @consecutive: the original data was split up and this buffer is consecutive
+ *               to the previous buffer
+ * @offset: offset as determined by data_head / data_tail members of struct
+ *          perf_event_mmap_page
+ * @reference: an implementation-specific reference determined when the data is
+ *             recorded
+ */
+struct itrace_buffer {
+	struct list_head	list;
+	size_t			size;
+	pid_t			pid;
+	pid_t			tid;
+	int			cpu;
+	void			*data;
+	off_t			data_offset;
+	void			*mmap_addr;
+	size_t			mmap_size;
+	bool			data_needs_freeing;
+	bool			consecutive;
+	u64			offset;
+	u64			reference;
+};
+
+/**
+ * struct itrace_queue - a queue of Instruction Tracing data buffers.
+ * @head: head of buffer list
+ * @tid: in per-thread mode, the tid this queue is associated with
+ * @cpu: in per-cpu mode, the cpu this queue is associated with
+ * @set: %true once this queue has been dedicated to a specific thread or cpu
+ * @priv: implementation-specific data
+ */
+struct itrace_queue {
+	struct list_head	head;
+	pid_t			tid;
+	int			cpu;
+	bool			set;
+	void			*priv;
+};
+
+/**
+ * struct itrace_queues - an array of Instruction Tracing queues.
+ * @queue_array: array of queues
+ * @nr_queues: number of queues
+ * @new_data: set whenever new data is queued
+ * @populated: queues have been fully populated using the itrace_index
+ */
+struct itrace_queues {
+	struct itrace_queue	*queue_array;
+	unsigned int		nr_queues;
+	bool			new_data;
+	bool			populated;
+};
+
+/**
  * struct itrace_mmap - records an mmap at PERF_EVENT_ITRACE_OFFSET.
  * @base: address of mapped area
  * @mask: %0 if @len is not a power of two, otherwise (@len - %1)
@@ -189,6 +256,16 @@ int itrace_mmap__read(struct itrace_mmap *mm,
 			    struct itrace_record *itr, struct perf_tool *tool,
 			    process_itrace_t fn);
 
+int itrace_queues__init(struct itrace_queues *queues);
+int itrace_queues__add_event(struct itrace_queues *queues,
+			     struct perf_session *session,
+			     union perf_event *event, off_t data_offset,
+			     struct itrace_buffer **buffer_ptr);
+void itrace_queues__free(struct itrace_queues *queues);
+struct itrace_buffer *itrace_buffer__next(struct itrace_queue *queue,
+					  struct itrace_buffer *buffer);
+void *itrace_buffer__get_data(struct itrace_buffer *buffer, int fd);
+void itrace_buffer__put_data(struct itrace_buffer *buffer);
 struct itrace_record *itrace_record__init(int *err);
 
 int itrace_record__options(struct itrace_record *itr,
-- 
1.8.5.1

