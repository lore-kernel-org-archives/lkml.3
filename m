Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaHKF35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:29:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:18760 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbaHKF3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:29:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,839,1400050800"; 
   d="scan'208";a="583017886"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v3 08/23] perf: Add AUX record
Date: Mon, 11 Aug 2014 08:19:37 +0300
Message-Id: <1407734392-31097-9-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When there's new data in the AUX space, output a record indicating its
offset and size and weather it was truncated to fix in the ring buffer.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/uapi/linux/perf_event.h | 16 ++++++++++++++++
 kernel/events/core.c            | 39 +++++++++++++++++++++++++++++++++++++++
 kernel/events/internal.h        |  3 +++
 kernel/events/ring_buffer.c     |  1 +
 4 files changed, 59 insertions(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 7e0967c0f5..c022c3d756 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -733,6 +733,22 @@ enum perf_event_type {
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
+	 *	u8				reserved[7];
+	 *	u64				id;
+	 *	u64				stream_id;
+	 * };
+	 */
+	PERF_RECORD_AUX				= 11,
+
 	PERF_RECORD_MAX,			/* non-ABI */
 };
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 848f2af576..25aad70812 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5443,6 +5443,45 @@ void perf_event_mmap(struct vm_area_struct *vma)
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
+		u8				reserved[7];
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
index b8f6c193ea..c6b2987afe 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -64,6 +64,9 @@ static inline bool rb_has_aux(struct ring_buffer *rb)
 	return !!rb->aux_nr_pages;
 }
 
+void perf_event_aux_event(struct perf_event *event, unsigned long head,
+			  unsigned long size, bool truncated);
+
 extern void
 perf_event_header__init_id(struct perf_event_header *header,
 			   struct perf_sample_data *data,
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index feee52077f..598c02a555 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -293,6 +293,7 @@ void perf_aux_output_end(struct perf_output_handle *handle, unsigned long size,
 	struct ring_buffer *rb = handle->rb;
 
 	local_add(size, &rb->aux_head);
+	perf_event_aux_event(handle->event, aux_head, size, truncated);
 
 	smp_wmb();
 	rb->user_page->aux_head = local_read(&rb->aux_head);
-- 
2.1.0.rc1

