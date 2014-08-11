Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaHKFcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:32:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:19052 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbaHKFcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:32:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,839,1400050800"; 
   d="scan'208";a="583018701"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v3 17/23] perf: Add rb_{alloc,free}_kernel api
Date: Mon, 11 Aug 2014 08:19:46 +0300
Message-Id: <1407734392-31097-18-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Events that generate AUX data can also be created by the kernel. In this
case, some in-kernel infrastructure is needed to store and copy this data.

This patch adds api for ring buffer (de-)allocation that can be used by the
kernel code.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 kernel/events/internal.h    |  3 +++
 kernel/events/ring_buffer.c | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 4f99987bc3..f4cfa4cabb 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -59,6 +59,9 @@ extern void perf_event_wakeup(struct perf_event *event);
 extern int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
 			pgoff_t pgoff, int nr_pages, long watermark, int flags);
 extern void rb_free_aux(struct ring_buffer *rb, struct perf_event *event);
+extern struct ring_buffer *
+rb_alloc_kernel(struct perf_event *event, int nr_pages, int aux_nr_pages);
+extern void rb_free_kernel(struct ring_buffer *rb, struct perf_event *event);
 extern struct ring_buffer *ring_buffer_get(struct perf_event *event);
 extern void ring_buffer_put(struct ring_buffer *rb);
 
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 85858d201c..43c4cc1892 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -467,6 +467,39 @@ void rb_free_aux(struct ring_buffer *rb, struct perf_event *event)
 	rb->aux_nr_pages = 0;
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
+	BUG_ON(atomic_read(&rb->refcount) != 1);
+	rcu_assign_pointer(event->rb, NULL);
+	rb_free_aux(rb, event);
+	rb_free(rb);
+}
+
 #ifndef CONFIG_PERF_USE_VMALLOC
 
 /*
-- 
2.1.0.rc1

