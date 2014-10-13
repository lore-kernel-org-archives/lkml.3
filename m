Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbaJMNsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:48:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:63833 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433AbaJMNsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:48:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,710,1406617200"; 
   d="scan'208";a="604522086"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v5 06/20] perf: Add AUX record
Date: Mon, 13 Oct 2014 16:45:34 +0300
Message-Id: <1413207948-28202-7-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When there's new data in the AUX space, output a record indicating its
offset and size and a set of flags, such as PERF_AUX_FLAG_TRUNCATED, to
mean the described data was truncated to fit in the ring buffer.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
---
 include/uapi/linux/perf_event.h | 19 +++++++++++++++++++
 kernel/events/core.c            | 34 ++++++++++++++++++++++++++++++++++
 kernel/events/internal.h        |  3 +++
 3 files changed, 56 insertions(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 7e0967c0f5..1a46627699 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -733,6 +733,20 @@ enum perf_event_type {
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
+	 *	u64				flags;
+	 * 	struct sample_id		sample_id;
+	 * };
+	 */
+	PERF_RECORD_AUX				= 11,
+
 	PERF_RECORD_MAX,			/* non-ABI */
 };
 
@@ -750,6 +764,11 @@ enum perf_callchain_context {
 	PERF_CONTEXT_MAX		= (__u64)-4095,
 };
 
+/**
+ * PERF_RECORD_AUX::flags bits
+ */
+#define PERF_AUX_FLAG_TRUNCATED		0x01	/* record was truncated to fit */
+
 #define PERF_FLAG_FD_NO_GROUP		(1UL << 0)
 #define PERF_FLAG_FD_OUTPUT		(1UL << 1)
 #define PERF_FLAG_PID_CGROUP		(1UL << 2) /* pid=cgroup id, per-cpu mode only */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index ced9b0819f..46a6217bbe 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5581,6 +5581,40 @@ void perf_event_mmap(struct vm_area_struct *vma)
 	perf_event_mmap_event(&mmap_event);
 }
 
+void perf_event_aux_event(struct perf_event *event, unsigned long head,
+			  unsigned long size, u64 flags)
+{
+	struct perf_output_handle handle;
+	struct perf_sample_data sample;
+	struct perf_aux_event {
+		struct perf_event_header	header;
+		u64				offset;
+		u64				size;
+		u64				flags;
+	} rec = {
+		.header = {
+			.type = PERF_RECORD_AUX,
+			.misc = 0,
+			.size = sizeof(rec),
+		},
+		.offset		= head,
+		.size		= size,
+		.flags		= flags,
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
index 1e476d2f29..e0013084c5 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -62,6 +62,9 @@ static inline bool rb_has_aux(struct ring_buffer *rb)
 	return !!rb->aux_nr_pages;
 }
 
+void perf_event_aux_event(struct perf_event *event, unsigned long head,
+			  unsigned long size, u64 flags);
+
 extern void
 perf_event_header__init_id(struct perf_event_header *header,
 			   struct perf_sample_data *data,
-- 
2.1.0

