Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607AbaFKPvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:51:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:12535 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbaFKPvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:51:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,458,1400050800"; 
   d="scan'208";a="444333871"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [RFC v2 7/7] perf: add AUX record
Date: Wed, 11 Jun 2014 18:41:50 +0300
Message-Id: <1402501310-31940-8-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1402501310-31940-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1402501310-31940-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When there's new data in the AUX space, output a record indicating its
offset and size and weather it was truncated to fix in the ring buffer.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/uapi/linux/perf_event.h | 15 +++++++++++++++
 kernel/events/core.c            | 38 ++++++++++++++++++++++++++++++++++++++
 kernel/events/internal.h        |  3 +++
 kernel/events/ring_buffer.c     |  1 +
 4 files changed, 57 insertions(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index dd10f16..7f8621f 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -726,6 +726,21 @@ enum perf_event_type {
 	 */
 	PERF_RECORD_MMAP2			= 10,
 
+	/*
+	 * Records that new data landed in the AUX buffer part.
+	 *
+	 * struct {
+	 * 	struct perf_event_header	header;
+	 *
+	 * 	u64				aux_offset;
+	 * 	u64				aux_size;
+	 *	u8				truncated;
+	 *	u64				id;
+	 *	u64				stream_id;
+	 * };
+	 */
+	PERF_RECORD_AUX				= 11,
+
 	PERF_RECORD_MAX,			/* non-ABI */
 };
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 44d6d01..cd64b75 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5394,6 +5394,44 @@ void perf_event_mmap(struct vm_area_struct *vma)
 	perf_event_mmap_event(&mmap_event);
 }
 
+void perf_event_aux_event(struct perf_event *event, unsigned long head,
+			  unsigned long size, bool truncated)
+{
+	struct perf_output_handle handle;
+	struct perf_sample_data sample;
+	struct perf_aux_event {
+		struct perf_event_header	header;
+		u64				offset;
+		u64				size;
+		u8				truncated;
+		u64				id;
+		u64				stream_id;
+	} rec = {
+		.header = {
+			.type = PERF_RECORD_AUX,
+			.misc = 0,
+			.size = sizeof(rec),
+		},
+		.offset		= head,
+		.size		= size,
+		.truncated	= truncated,
+		.id		= primary_event_id(event),
+		.stream_id	= event->id,
+	};
+	int ret;
+
+	perf_event_header__init_id(&rec.header, &sample, event);
+	ret = perf_output_begin(&handle, event, rec.header.size);
+
+	if (ret)
+		return;
+
+	perf_output_put(&handle, rec);
+	perf_event__output_id_sample(event, &handle, &sample);
+
+	perf_output_end(&handle);
+}
+
 /*
  * IRQ throttle logging
  */
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index e20d073..8bc4547 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -63,6 +63,9 @@ static inline bool rb_has_aux(struct ring_buffer *rb)
 	return !!rb->aux_nr_pages;
 }
 
+void perf_event_aux_event(struct perf_event *event, unsigned long head,
+			  unsigned long size, bool truncated);
+
 extern void
 perf_event_header__init_id(struct perf_event_header *header,
 			   struct perf_sample_data *data,
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 8f76e5c..4e6f815 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -280,6 +280,7 @@ void perf_aux_output_end(struct perf_output_handle *handle, unsigned long size,
 
 	aux_head = local_read(&rb->aux_head);
 	local_add(size, &rb->aux_head);
+	perf_event_aux_event(handle->event, aux_head, size, truncated);
 
 	rb->user_page->aux_head = local_read(&rb->aux_head);
 	smp_wmb();
-- 
2.0.0

