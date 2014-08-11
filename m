Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaHKFcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:32:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:60033 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbaHKFcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:32:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,839,1400050800"; 
   d="scan'208";a="586295764"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v3 18/23] perf: Add a helper to copy AUX data in the kernel
Date: Mon, 11 Aug 2014 08:19:47 +0300
Message-Id: <1407734392-31097-19-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a helper for the kernel counters that generate AUX data to
copy this data around, for example, to output it to the perf ring buffer
as a sample record or write it to a core dump file.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 kernel/events/internal.h    |  5 +++++
 kernel/events/ring_buffer.c | 31 +++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index f4cfa4cabb..bb035dd645 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -52,6 +52,9 @@ struct ring_buffer {
 	void				*data_pages[0];
 };
 
+typedef unsigned long (*aux_copyfn)(void *data, const void *src,
+				    unsigned long len);
+
 extern void rb_free(struct ring_buffer *rb);
 extern struct ring_buffer *
 rb_alloc(int nr_pages, long watermark, int cpu, int flags);
@@ -59,6 +62,8 @@ extern void perf_event_wakeup(struct perf_event *event);
 extern int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
 			pgoff_t pgoff, int nr_pages, long watermark, int flags);
 extern void rb_free_aux(struct ring_buffer *rb, struct perf_event *event);
+extern long rb_output_aux(struct ring_buffer *rb, unsigned long from,
+			  unsigned long to, aux_copyfn copyfn, void *data);
 extern struct ring_buffer *
 rb_alloc_kernel(struct perf_event *event, int nr_pages, int aux_nr_pages);
 extern void rb_free_kernel(struct ring_buffer *rb, struct perf_event *event);
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 43c4cc1892..3434bd145c 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -348,6 +348,37 @@ void *perf_get_aux(struct perf_output_handle *handle)
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
-- 
2.1.0.rc1

