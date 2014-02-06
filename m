Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494AbaBFKvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 05:51:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:47371 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932299AbaBFKve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 05:51:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,793,1384329600"; 
   d="scan'208";a="470754085"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v1 08/11] x86: perf: intel_pt: Add sampling functionality
Date: Thu,  6 Feb 2014 12:50:31 +0200
Message-Id: <1391683834-29868-9-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel Processor Trace (PT) data can be used in perf event samples to annotate
other perf events. This patch implements itrace sampling related hooks that
configure and output sampling data to perf stream. Users will need to include
PERF_SAMPLE_ITRACE flag in the attr.sample_type mask and specify PT's PMU type
in attr.itrace_sample_type field.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_pt.c | 115 ++++++++++++++++++++++++++++++
 1 file changed, 115 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_pt.c b/arch/x86/kernel/cpu/perf_event_intel_pt.c
index b6b1a84..af1482d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_pt.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_pt.c
@@ -946,17 +946,130 @@ static void pt_event_read(struct perf_event *event)
 {
 }
 
+typedef unsigned int (*pt_copyfn)(void *data, const void *src,
+				  unsigned int len);
+
+/**
+ * pt_buffer_output - copy part of pt buffer to perf stream
+ * @buf: buffer to copy from
+ * @from: initial offset
+ * @to: final offset
+ * @copyfn: function that copies data out (like perf_output_copy())
+ * @data: data to be passed on to the copy function (like perf_output_handle)
+ */
+static int pt_buffer_output(struct pt_buffer *buf, unsigned long from,
+			    unsigned long to, pt_copyfn copyfn, void *data)
+{
+	unsigned long tocopy;
+	unsigned int len = 0, remainder;
+	void *page;
+
+	do {
+		tocopy = PAGE_SIZE - offset_in_page(from);
+		if (to > from)
+			tocopy = min(tocopy, to - from);
+		if (!tocopy)
+			break;
+
+		page = pt_buffer_get_page(buf, from >> PAGE_SHIFT);
+		if (WARN_ONCE(!page, "no data page for %lx offset\n", from))
+			break;
+
+		page += offset_in_page(from);
+
+		remainder = copyfn(data, page, tocopy);
+		if (remainder)
+			return -EFAULT;
+
+		len += tocopy;
+		from += tocopy;
+		if (from == buf->size)
+			from = 0;
+	} while (to != from);
+	return len;
+}
+
 static int pt_event_init(struct perf_event *event)
 {
 	if (event->attr.type != pt_pmu.itrace.pmu.type)
 		return -ENOENT;
 
+	/* can't be both */
+	if (event->attr.sample_type & PERF_SAMPLE_ITRACE)
+		return -ENOENT;
+
 	if (!pt_event_valid(event))
 		return -EINVAL;
 
 	return 0;
 }
 
+static unsigned long pt_trace_sampler_trace(struct perf_event *event,
+					    struct perf_sample_data *data)
+{
+	struct pt_buffer *buf;
+
+	pt_event_stop(event, 0);
+
+	buf = itrace_event_get_priv(event);
+	if (!buf) {
+		data->trace.size = 0;
+		goto out;
+	}
+
+	pt_read_offset(buf);
+	pt_update_head(buf);
+
+	data->trace.to = local64_read(&buf->head);
+
+	if (data->trace.to < event->attr.itrace_sample_size)
+		data->trace.from = buf->size + data->trace.to -
+			event->attr.itrace_sample_size;
+	else
+		data->trace.from = data->trace.to -
+			event->attr.itrace_sample_size;
+	data->trace.size = ALIGN(event->attr.itrace_sample_size, sizeof(u64));
+
+	itrace_event_put(event);
+
+out:
+	if (!data->trace.size)
+		pt_event_start(event, 0);
+
+	return data->trace.size;
+}
+
+static void pt_trace_sampler_output(struct perf_event *event,
+				    struct perf_output_handle *handle,
+				    struct perf_sample_data *data)
+{
+	unsigned long padding;
+	struct pt_buffer *buf;
+	int ret;
+
+	buf = itrace_event_get_priv(event);
+	if (!buf)
+		return;
+
+	ret = pt_buffer_output(buf, data->trace.from, data->trace.to,
+			       (pt_copyfn)perf_output_copy, handle);
+	itrace_event_put(event);
+	if (ret < 0) {
+		pr_warn("%s: failed to copy trace data\n", __func__);
+		goto out;
+	}
+
+	padding = data->trace.size - ret;
+	if (padding) {
+		u64 u = 0;
+
+		perf_output_copy(handle, &u, padding);
+	}
+
+out:
+	pt_event_start(event, 0);
+}
+
 static __init int pt_init(void)
 {
 	int ret, cpu;
@@ -982,6 +1095,8 @@ static __init int pt_init(void)
 	pt_pmu.itrace.pmu.read		= pt_event_read;
 	pt_pmu.itrace.alloc_buffer	= pt_buffer_itrace_alloc;
 	pt_pmu.itrace.free_buffer	= pt_buffer_itrace_free;
+	pt_pmu.itrace.sample_trace	= pt_trace_sampler_trace;
+	pt_pmu.itrace.sample_output	= pt_trace_sampler_output;
 	pt_pmu.itrace.name		= "intel_pt";
 	ret = itrace_pmu_register(&pt_pmu.itrace);
 
-- 
1.8.5.2

