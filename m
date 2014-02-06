Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbaBFKwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 05:52:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:35768 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318AbaBFKv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 05:51:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,793,1384329600"; 
   d="scan'208";a="450662697"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v1 09/11] x86: perf: intel_pt: Add core dump functionality
Date: Thu,  6 Feb 2014 12:50:32 +0200
Message-Id: <1391683834-29868-10-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel Processor Trace (PT) data can be used in process core dumps. This
is done by implementing itrace code dump related hooks that configure and
output trace data to a core file. The driver will also include the list
of PT capabilities in itrace core dump notes so that the decoder can make
assumptions about the binary stream.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 arch/x86/kernel/cpu/intel_pt.h            |  2 +
 arch/x86/kernel/cpu/perf_event_intel_pt.c | 74 +++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/arch/x86/kernel/cpu/intel_pt.h b/arch/x86/kernel/cpu/intel_pt.h
index dd69092..befde1f 100644
--- a/arch/x86/kernel/cpu/intel_pt.h
+++ b/arch/x86/kernel/cpu/intel_pt.h
@@ -84,6 +84,8 @@ enum pt_capabilities {
 struct pt_pmu {
 	struct itrace_pmu	itrace;
 	u32			caps[4 * PT_CPUID_LEAVES];
+	char			*capstr;
+	unsigned int		caplen;
 };
 
 /**
diff --git a/arch/x86/kernel/cpu/perf_event_intel_pt.c b/arch/x86/kernel/cpu/perf_event_intel_pt.c
index af1482d..cb03594 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_pt.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_pt.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/debugfs.h>
 #include <linux/device.h>
+#include <linux/coredump.h>
 
 #include <asm-generic/sizes.h>
 #include <asm/perf_event.h>
@@ -88,6 +89,34 @@ static void pt_cap_set(enum pt_capabilities cap, u32 val)
 	pt_pmu.caps[idx] = (val << shift) & cd->mask;
 }
 
+/**
+ * pt_cap_string - format PT capabilities into an ascii string
+ *
+ * We need to include PT capabilities in the core dump note so that the
+ * decoder knows what to expect in the binary stream.
+ */
+static void pt_cap_string(void)
+{
+	char *capstr;
+	int pos, i;
+
+	capstr = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!capstr)
+		return;
+
+	for (i = 0, pos = 0; i < ARRAY_SIZE(pt_caps) && pos < PAGE_SIZE; i++) {
+		pos += snprintf(&capstr[pos], PAGE_SIZE - pos, "%s:%x%c",
+				pt_caps[i].name, pt_cap_get(i),
+				i == ARRAY_SIZE(pt_caps) - 1 ? 0 : ',');
+	}
+
+	if (pt_pmu.capstr)
+		kfree(pt_pmu.capstr);
+
+	pt_pmu.capstr = capstr;
+	pt_pmu.caplen = pos;
+}
+
 static ssize_t pt_cap_show(struct device *cdev,
 			   struct device_attribute *attr,
 			   char *buf)
@@ -114,6 +143,7 @@ static ssize_t pt_cap_store(struct device *cdev,
 		return -EINVAL;
 
 	pt_cap_set(cap, new);
+	pt_cap_string();
 	return size;
 }
 
@@ -179,6 +209,7 @@ static int __init pt_pmu_hw_init(void)
 		attrs[i] = &de_attrs[i].attr.attr;
 	}
 
+	pt_cap_string();
 	pt_cap_group.attrs = attrs;
 	return 0;
 
@@ -1070,6 +1101,46 @@ out:
 	pt_event_start(event, 0);
 }
 
+static size_t pt_trace_core_size(struct perf_event *event)
+{
+	return pt_pmu.caplen;
+}
+
+static unsigned int pt_core_copy(void *data, const void *src,
+				 unsigned int len)
+{
+	struct coredump_params *cprm = data;
+
+	if (dump_emit(cprm, src, len))
+		return 0;
+
+	return len;
+}
+
+static void pt_trace_core_output(struct coredump_params *cprm,
+				 struct perf_event *event,
+				 unsigned long len)
+{
+	struct pt_buffer *buf;
+	u64 from, to;
+	int ret;
+
+	buf = itrace_priv(event);
+
+	if (!dump_emit(cprm, pt_pmu.capstr, pt_pmu.caplen))
+		return;
+
+	to = local64_read(&buf->head);
+	if (to < len)
+		from = buf->size + to - len;
+	else
+		from = to - len;
+
+	ret = pt_buffer_output(buf, from, to, pt_core_copy, cprm);
+	if (ret < 0)
+		pr_warn("%s: failed to copy trace data\n", __func__);
+}
+
 static __init int pt_init(void)
 {
 	int ret, cpu;
@@ -1097,6 +1168,9 @@ static __init int pt_init(void)
 	pt_pmu.itrace.free_buffer	= pt_buffer_itrace_free;
 	pt_pmu.itrace.sample_trace	= pt_trace_sampler_trace;
 	pt_pmu.itrace.sample_output	= pt_trace_sampler_output;
+	pt_pmu.itrace.core_size		= pt_trace_core_size;
+	pt_pmu.itrace.core_output	= pt_trace_core_output;
+	pt_pmu.itrace.coredump_config	= RTIT_CTL_TSC_EN | RTIT_CTL_DISRETC;
 	pt_pmu.itrace.name		= "intel_pt";
 	ret = itrace_pmu_register(&pt_pmu.itrace);
 
-- 
1.8.5.2

