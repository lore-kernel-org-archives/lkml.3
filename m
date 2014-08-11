Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaHKFgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:36:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:33381 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbaHKFgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:36:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,839,1400050800"; 
   d="scan'208";a="574813333"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v3 21/23] perf: Allocate ring buffers for inherited per-task kernel events
Date: Mon, 11 Aug 2014 08:19:50 +0300
Message-Id: <1407734392-31097-22-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a new event is inherited from a per-task kernel event that has a
ring buffer, allocate a new buffer for this event so that data from the
child task is collected and can later be retrieved for sample annotation
or whatnot.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 kernel/events/core.c     |  9 +++++++++
 kernel/events/internal.h | 11 +++++++++++
 2 files changed, 20 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7a3ffda1c0..c2f02ea6d7 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7993,6 +7993,15 @@ inherit_event(struct perf_event *parent_event,
 		(void)perf_event_set_output(child_event, parent_event);
 
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
index bb035dd645..b306bc9307 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -120,6 +120,17 @@ static inline unsigned long perf_aux_size(struct ring_buffer *rb)
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
2.1.0.rc1

