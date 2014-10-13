Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbaJMNsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:48:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:63957 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439AbaJMNsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:48:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,710,1406617200"; 
   d="scan'208";a="604522471"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v5 18/20] perf: Allocate ring buffers for inherited per-task kernel events
Date: Mon, 13 Oct 2014 16:45:46 +0300
Message-Id: <1413207948-28202-19-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally, per-task events can't be inherited parents' ring buffers to
avoid multiple events contending for the same buffer. And since buffer
allocation is typically done by the userspace consumer, there is no
practical interface to allocate new buffers for inherited counters.

However, for kernel users we can allocate new buffers for inherited
events as soon as they are created (and also reap them on event
destruction). This pattern has a number of use cases, such as event
sample annotation and process core dump annotation.

When a new event is inherited from a per-task kernel event that has a
ring buffer, allocate a new buffer for this event so that data from the
child task is collected and can later be retrieved for sample annotation
or core dump inclusion. This ring buffer is released when the event is
freed, for example, when the child task exits.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 kernel/events/core.c     |  9 +++++++++
 kernel/events/internal.h | 11 +++++++++++
 2 files changed, 20 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5da1bc403f..60e354d668 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8267,6 +8267,15 @@ inherit_event(struct perf_event *parent_event,
 		= parent_event->overflow_handler_context;
 
 	/*
+	 * For per-task kernel events with ring buffers, set_output doesn't
+	 * make sense, but we can allocate a new buffer here.
+	 */
+	if (parent_event->cpu == -1 && kernel_rb_event(parent_event)) {
+		(void)rb_alloc_kernel(child_event, parent_event->rb->nr_pages,
+				      parent_event->rb->aux_nr_pages);
+	}
+
+	/*
 	 * Precalculate sample_data sizes
 	 */
 	perf_event__header_size(child_event);
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 81cb7afec4..373ac012f5 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -122,6 +122,17 @@ static inline unsigned long perf_aux_size(struct ring_buffer *rb)
 	return rb->aux_nr_pages << PAGE_SHIFT;
 }
 
+static inline bool kernel_rb_event(struct perf_event *event)
+{
+	/*
+	 * Having a ring buffer and not being on any ring buffers' wakeup
+	 * list means it was attached by rb_alloc_kernel() and not
+	 * ring_buffer_attach(). It's the only case when these two
+	 * conditions take place at the same time.
+	 */
+	return event->rb && list_empty(&event->rb_entry);
+}
+
 #define DEFINE_OUTPUT_COPY(func_name, memcpy_func)			\
 static inline unsigned long						\
 func_name(struct perf_output_handle *handle,				\
-- 
2.1.0

