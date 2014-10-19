Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaJSWGq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 18:06:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:34011 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbaJSWFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 18:05:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="402644515"
From: Kan Liang <kan.liang@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V6 16/17] perf tools: handle LBR call stack data
Date: Sun, 19 Oct 2014 17:55:11 -0400
Message-Id: <1413755712-8259-17-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
References: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LBR call stack data will be output as PERF_SAMPLE_BRANCH_STACK data
format. ip_callchain is changed to show available callchain source.
LBR call stack also need to be shown in user space.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 tools/perf/util/event.h |  8 ++++++++
 tools/perf/util/evsel.c | 21 +++++++++++++--------
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 5699e7e..3e291c5 100644
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
index d1ecde0..431f0eb 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1027,7 +1027,6 @@ static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
 	ret += PRINT_ATTR2(exclude_host, exclude_guest);
 	ret += PRINT_ATTR2N("excl.callchain_kern", exclude_callchain_kernel,
 			    "excl.callchain_user", exclude_callchain_user);
-
 	ret += PRINT_ATTR_U32(wakeup_events);
 	ret += PRINT_ATTR_U32(wakeup_watermark);
 	ret += PRINT_ATTR_X32(bp_type);
@@ -1439,10 +1438,10 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
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
@@ -1465,7 +1464,9 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		array = (void *)array + data->raw_size;
 	}
 
-	if (type & PERF_SAMPLE_BRANCH_STACK) {
+	if ((type & PERF_SAMPLE_BRANCH_STACK) ||
+		(data->callchain &&
+		(data->callchain->source & PERF_LBR_CALLCHAIN))) {
 		const u64 max_branch_nr = UINT64_MAX /
 					  sizeof(struct branch_entry);
 
@@ -1589,7 +1590,7 @@ size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
 	}
 
 	if (type & PERF_SAMPLE_CALLCHAIN) {
-		sz = (sample->callchain->nr + 1) * sizeof(u64);
+		sz = (sample->callchain->nr + 2) * sizeof(u64);
 		result += sz;
 	}
 
@@ -1598,7 +1599,9 @@ size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
 		result += sample->raw_size;
 	}
 
-	if (type & PERF_SAMPLE_BRANCH_STACK) {
+	if ((type & PERF_SAMPLE_BRANCH_STACK) ||
+		(sample->callchain &&
+		(sample->callchain->source & PERF_LBR_CALLCHAIN))) {
 		sz = sample->branch_stack->nr * sizeof(struct branch_entry);
 		sz += sizeof(u64);
 		result += sz;
@@ -1744,7 +1747,7 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 	}
 
 	if (type & PERF_SAMPLE_CALLCHAIN) {
-		sz = (sample->callchain->nr + 1) * sizeof(u64);
+		sz = (sample->callchain->nr + 2) * sizeof(u64);
 		memcpy(array, sample->callchain, sz);
 		array = (void *)array + sz;
 	}
@@ -1767,7 +1770,9 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
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

