Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbaJMNsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:48:32 -0400
Received: from mga03.intel.com ([134.134.136.65]:53430 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439AbaJMNs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:48:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,710,1406617200"; 
   d="scan'208";a="588024449"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v5 15/20] perf: Add api to (de-)allocate AUX buffers for kernel counters
Date: Mon, 13 Oct 2014 16:45:43 +0300
Message-Id: <1413207948-28202-16-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several use cases for AUX data, namely event sampling (including a piece of
AUX data in some perf event sample, so that the user can get, for example,
instruction traces leading up to a certain event like a breakpoint or a
hardware event), process core dumps (providing user with a history of a
process' instruction flow leading up to a crash), system crash dumps and
storing AUX data in pstore across reboot (to facilitate post-mortem
investigation of a system crash) require different parts of the kernel code
to be able to configure hardware to produce AUX data and collect it when it
is needed.

Luckily, there is already an api for in-kernel perf events, which has several
users. This proposal is to extend that api to allow in-kernel users to
allocate AUX buffers for kernel counters. Such users will call
rb_alloc_kernel() to allocate what they want and later copy the data out to
other backends, e.g. a sample in another event's ring buffer or a core dump
file. These buffers are never mapped to userspace.

There are no additional constraints or requirements on the pmu drivers.

A typical user of this interface will first create a kernel counter with a
call to perf_event_create_kernel_counter() and then allocate a ring buffer
for it with rb_alloc_kernel(). Data can then be copied out from the AUX
buffer using rb_output_aux(), which is passed a callback that will write
chunks of AUX data into the desired destination, such as perf_output_copy()
or dump_emit(). Caller needs to use perf_event_disable to make sure that the
counter is not active while it copies data out.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 kernel/events/internal.h    |  8 ++++++
 kernel/events/ring_buffer.c | 64 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 4715aae48b..81cb7afec4 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -54,6 +54,9 @@ struct ring_buffer {
 	void				*data_pages[0];
 };
 
+typedef unsigned long (*aux_copyfn)(void *data, const void *src,
+				    unsigned long len);
+
 extern void rb_free(struct ring_buffer *rb);
 extern struct ring_buffer *
 rb_alloc(int nr_pages, long watermark, int cpu, int flags);
@@ -61,6 +64,11 @@ extern void perf_event_wakeup(struct perf_event *event);
 extern int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
 			pgoff_t pgoff, int nr_pages, long watermark, int flags);
 extern void rb_free_aux(struct ring_buffer *rb);
+extern long rb_output_aux(struct ring_buffer *rb, unsigned long from,
+			  unsigned long to, aux_copyfn copyfn, void *data);
+extern struct ring_buffer *
+rb_alloc_kernel(struct perf_event *event, int nr_pages, int aux_nr_pages);
+extern void rb_free_kernel(struct ring_buffer *rb, struct perf_event *event);
 extern struct ring_buffer *ring_buffer_get(struct perf_event *event);
 extern void ring_buffer_put(struct ring_buffer *rb);
 
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 96ec58fb46..c062378c37 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -409,6 +409,37 @@ void *perf_get_aux(struct perf_output_handle *handle)
 	return handle->rb->aux_priv;
 }
 
+long rb_output_aux(struct ring_buffer *rb, unsigned long from,
+		   unsigned long to, aux_copyfn copyfn, void *data)
+{
+	unsigned long tocopy, remainder, len = 0;
+	void *addr;
+
+	from &= (rb->aux_nr_pages << PAGE_SHIFT) - 1;
+	to &= (rb->aux_nr_pages << PAGE_SHIFT) - 1;
+
+	do {
+		tocopy = PAGE_SIZE - offset_in_page(from);
+		if (to > from)
+			tocopy = min(tocopy, to - from);
+		if (!tocopy)
+			break;
+
+		addr = rb->aux_pages[from >> PAGE_SHIFT];
+		addr += offset_in_page(from);
+
+		remainder = copyfn(data, addr, tocopy);
+		if (remainder)
+			return -EFAULT;
+
+		len += tocopy;
+		from += tocopy;
+		from &= (rb->aux_nr_pages << PAGE_SHIFT) - 1;
+	} while (to != from);
+
+	return len;
+}
+
 #define PERF_AUX_GFP	(GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN | __GFP_NORETRY)
 
 static struct page *rb_alloc_aux_page(int node, int order)
@@ -540,6 +571,39 @@ void rb_free_aux(struct ring_buffer *rb)
 	kref_put(&rb->aux_refcount, __rb_free_aux);
 }
 
+struct ring_buffer *
+rb_alloc_kernel(struct perf_event *event, int nr_pages, int aux_nr_pages)
+{
+	struct ring_buffer *rb;
+	int ret, pgoff = nr_pages + 1;
+
+	rb = rb_alloc(nr_pages, 0, event->cpu, 0);
+	if (!rb)
+		return NULL;
+
+	ret = rb_alloc_aux(rb, event, pgoff, aux_nr_pages, 0, 0);
+	if (ret) {
+		rb_free(rb);
+		return NULL;
+	}
+
+	/*
+	 * Kernel counters don't need ring buffer wakeups, therefore we don't
+	 * use ring_buffer_attach() here and event->rb_entry stays empty
+	 */
+	rcu_assign_pointer(event->rb, rb);
+
+	return rb;
+}
+
+void rb_free_kernel(struct ring_buffer *rb, struct perf_event *event)
+{
+	WARN_ON_ONCE(atomic_read(&rb->refcount) != 1);
+	rcu_assign_pointer(event->rb, NULL);
+	rb_free_aux(rb);
+	rb_free(rb);
+}
+
 #ifndef CONFIG_PERF_USE_VMALLOC
 
 /*
-- 
2.1.0

