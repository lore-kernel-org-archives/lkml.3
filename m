Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbaKEDKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 22:10:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:23438 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436AbaKEDKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 22:10:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,317,1413270000"; 
   d="scan'208";a="617287024"
From: Kan Liang <kan.liang@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V7 16/17] perf tools: handle LBR call stack data
Date: Tue,  4 Nov 2014 21:56:12 -0500
Message-Id: <1415156173-10035-17-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
References: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

The LBR call stack data will be output as PERF_SAMPLE_BRANCH_STACK data
format. ip_callchain is changed to show available callchain source.
LBR call stack also need to be shown in user space.
Perf test also changes accordingly.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 tools/perf/tests/hists_cumulate.c | 20 ++++++++++----------
 tools/perf/tests/sample-parsing.c |  2 +-
 tools/perf/util/event.h           |  8 ++++++++
 tools/perf/util/evsel.c           | 21 +++++++++++++--------
 4 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/tools/perf/tests/hists_cumulate.c b/tools/perf/tests/hists_cumulate.c
index 614d5c4..8967ae6 100644
--- a/tools/perf/tests/hists_cumulate.c
+++ b/tools/perf/tests/hists_cumulate.c
@@ -48,29 +48,29 @@ static struct sample fake_samples[] = {
  */
 static u64 fake_callchains[][10] = {
 	/*   schedule => run_command => main */
-	{ 3, FAKE_IP_KERNEL_SCHEDULE, FAKE_IP_PERF_RUN_COMMAND, FAKE_IP_PERF_MAIN, },
+	{ 1, 3, FAKE_IP_KERNEL_SCHEDULE, FAKE_IP_PERF_RUN_COMMAND, FAKE_IP_PERF_MAIN, },
 	/*   main  */
-	{ 1, FAKE_IP_PERF_MAIN, },
+	{ 1, 1, FAKE_IP_PERF_MAIN, },
 	/*   cmd_record => run_command => main */
-	{ 3, FAKE_IP_PERF_CMD_RECORD, FAKE_IP_PERF_RUN_COMMAND, FAKE_IP_PERF_MAIN, },
+	{ 1, 3, FAKE_IP_PERF_CMD_RECORD, FAKE_IP_PERF_RUN_COMMAND, FAKE_IP_PERF_MAIN, },
 	/*   malloc => cmd_record => run_command => main */
-	{ 4, FAKE_IP_LIBC_MALLOC, FAKE_IP_PERF_CMD_RECORD, FAKE_IP_PERF_RUN_COMMAND,
+	{ 1, 4, FAKE_IP_LIBC_MALLOC, FAKE_IP_PERF_CMD_RECORD, FAKE_IP_PERF_RUN_COMMAND,
 	     FAKE_IP_PERF_MAIN, },
 	/*   free => cmd_record => run_command => main */
-	{ 4, FAKE_IP_LIBC_FREE, FAKE_IP_PERF_CMD_RECORD, FAKE_IP_PERF_RUN_COMMAND,
+	{ 1, 4, FAKE_IP_LIBC_FREE, FAKE_IP_PERF_CMD_RECORD, FAKE_IP_PERF_RUN_COMMAND,
 	     FAKE_IP_PERF_MAIN, },
 	/*   main */
-	{ 1, FAKE_IP_PERF_MAIN, },
+	{ 1, 1, FAKE_IP_PERF_MAIN, },
 	/*   page_fault => sys_perf_event_open => run_command => main */
-	{ 4, FAKE_IP_KERNEL_PAGE_FAULT, FAKE_IP_KERNEL_SYS_PERF_EVENT_OPEN,
+	{ 1, 4, FAKE_IP_KERNEL_PAGE_FAULT, FAKE_IP_KERNEL_SYS_PERF_EVENT_OPEN,
 	     FAKE_IP_PERF_RUN_COMMAND, FAKE_IP_PERF_MAIN, },
 	/*   main */
-	{ 1, FAKE_IP_BASH_MAIN, },
+	{ 1, 1, FAKE_IP_BASH_MAIN, },
 	/*   xmalloc => malloc => xmalloc => malloc => xmalloc => main */
-	{ 6, FAKE_IP_BASH_XMALLOC, FAKE_IP_LIBC_MALLOC, FAKE_IP_BASH_XMALLOC,
+	{ 1, 6, FAKE_IP_BASH_XMALLOC, FAKE_IP_LIBC_MALLOC, FAKE_IP_BASH_XMALLOC,
 	     FAKE_IP_LIBC_MALLOC, FAKE_IP_BASH_XMALLOC, FAKE_IP_BASH_MAIN, },
 	/*   page_fault => malloc => main */
-	{ 3, FAKE_IP_KERNEL_PAGE_FAULT, FAKE_IP_LIBC_MALLOC, FAKE_IP_BASH_MAIN, },
+	{ 1, 3, FAKE_IP_KERNEL_PAGE_FAULT, FAKE_IP_LIBC_MALLOC, FAKE_IP_BASH_MAIN, },
 };
 
 static int add_hist_entries(struct hists *hists, struct machine *machine)
diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index ca292f9..dfa9dfa 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -145,7 +145,7 @@ static int do_test(u64 sample_type, u64 sample_regs_user, u64 read_format)
 		u64 data[64];
 	} callchain = {
 		/* 3 ips */
-		.data = {3, 201, 202, 203},
+		.data = {1, 3, 201, 202, 203},
 	};
 	union {
 		struct branch_stack branch_stack;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 8c7fe9d..efeefe7 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -119,7 +119,15 @@ struct sample_read {
 	};
 };
 
+/*
+ * From Haswell, the existing Last Branch Record facility can
+ * also be used to record call chains.
+ * source: indicates the available call chains source.
+ */
+#define	PERF_FP_CALLCHAIN	0x01
+#define	PERF_LBR_CALLCHAIN	0x02
 struct ip_callchain {
+	u64 source;
 	u64 nr;
 	u64 ips[0];
 };
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 2f9e680..ff472d6 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1028,7 +1028,6 @@ static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
 	ret += PRINT_ATTR2(exclude_host, exclude_guest);
 	ret += PRINT_ATTR2N("excl.callchain_kern", exclude_callchain_kernel,
 			    "excl.callchain_user", exclude_callchain_user);
-
 	ret += PRINT_ATTR_U32(wakeup_events);
 	ret += PRINT_ATTR_U32(wakeup_watermark);
 	ret += PRINT_ATTR_X32(bp_type);
@@ -1440,10 +1439,10 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		const u64 max_callchain_nr = UINT64_MAX / sizeof(u64);
 
 		OVERFLOW_CHECK_u64(array);
-		data->callchain = (struct ip_callchain *)array++;
+		data->callchain = (struct ip_callchain *)array;
 		if (data->callchain->nr > max_callchain_nr)
 			return -EFAULT;
-		sz = data->callchain->nr * sizeof(u64);
+		sz = (data->callchain->nr + 2) * sizeof(u64);
 		OVERFLOW_CHECK(array, sz, max_size);
 		array = (void *)array + sz;
 	}
@@ -1466,7 +1465,9 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		array = (void *)array + data->raw_size;
 	}
 
-	if (type & PERF_SAMPLE_BRANCH_STACK) {
+	if ((type & PERF_SAMPLE_BRANCH_STACK) ||
+		(data->callchain &&
+		(data->callchain->source & PERF_LBR_CALLCHAIN))) {
 		const u64 max_branch_nr = UINT64_MAX /
 					  sizeof(struct branch_entry);
 
@@ -1590,7 +1591,7 @@ size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
 	}
 
 	if (type & PERF_SAMPLE_CALLCHAIN) {
-		sz = (sample->callchain->nr + 1) * sizeof(u64);
+		sz = (sample->callchain->nr + 2) * sizeof(u64);
 		result += sz;
 	}
 
@@ -1599,7 +1600,9 @@ size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
 		result += sample->raw_size;
 	}
 
-	if (type & PERF_SAMPLE_BRANCH_STACK) {
+	if ((type & PERF_SAMPLE_BRANCH_STACK) ||
+		(sample->callchain &&
+		(sample->callchain->source & PERF_LBR_CALLCHAIN))) {
 		sz = sample->branch_stack->nr * sizeof(struct branch_entry);
 		sz += sizeof(u64);
 		result += sz;
@@ -1745,7 +1748,7 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 	}
 
 	if (type & PERF_SAMPLE_CALLCHAIN) {
-		sz = (sample->callchain->nr + 1) * sizeof(u64);
+		sz = (sample->callchain->nr + 2) * sizeof(u64);
 		memcpy(array, sample->callchain, sz);
 		array = (void *)array + sz;
 	}
@@ -1768,7 +1771,9 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 		array = (void *)array + sample->raw_size;
 	}
 
-	if (type & PERF_SAMPLE_BRANCH_STACK) {
+	if ((type & PERF_SAMPLE_BRANCH_STACK) ||
+		(sample->callchain &&
+		(sample->callchain->source & PERF_LBR_CALLCHAIN))) {
 		sz = sample->branch_stack->nr * sizeof(struct branch_entry);
 		sz += sizeof(u64);
 		memcpy(array, sample->branch_stack, sz);
-- 
1.8.3.2

