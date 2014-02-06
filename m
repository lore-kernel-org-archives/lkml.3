Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540AbaBFKvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 05:51:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:23837 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932497AbaBFKvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 05:51:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,793,1384329600"; 
   d="scan'208";a="450662770"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v1 11/11] x86: perf: intel_bts: Add core dump related functionality
Date: Thu,  6 Feb 2014 12:50:34 +0200
Message-Id: <1391683834-29868-12-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTS data can be used in process core dumps. This patch implements itrace
core dump related hooks that will configure and output BTS traces into
a core file.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_bts.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_bts.c b/arch/x86/kernel/cpu/perf_event_intel_bts.c
index 0a08969..20a19b2 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_bts.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_bts.c
@@ -436,6 +436,26 @@ static void bts_event_read(struct perf_event *event)
 {
 }
 
+static size_t bts_trace_core_size(struct perf_event *event)
+{
+	return 0;
+}
+
+static void bts_trace_core_output(struct coredump_params *cprm,
+				  struct perf_event *event,
+				  unsigned long len)
+{
+	struct bts_buffer *buf = itrace_event_get_priv(event);
+	u64 head = local64_read(&buf->head);
+
+	if (head < len) {
+		dump_emit(cprm, buf->buf + head, buf->real_size - head);
+		dump_emit(cprm, buf->buf, len - buf->real_size + head);
+	} else
+		dump_emit(cprm, buf->buf + head - len, len);
+	itrace_event_put(event);
+}
+
 static __init int bts_init(void)
 {
 	int ret, cpu;
@@ -459,6 +479,8 @@ static __init int bts_init(void)
 	bts_pmu.pmu.read		= bts_event_read;
 	bts_pmu.alloc_buffer		= bts_buffer_itrace_alloc;
 	bts_pmu.free_buffer		= bts_buffer_itrace_free;
+	bts_pmu.core_size		= bts_trace_core_size;
+	bts_pmu.core_output		= bts_trace_core_output;
 	bts_pmu.name			= "intel_bts";
 
 	ret = itrace_pmu_register(&bts_pmu);
-- 
1.8.5.2

