Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933677Ab3GDNPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 09:15:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:65349 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932445Ab3GDNPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 09:15:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,995,1363158000"; 
   d="scan'208";a="264088118"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V4 16/21] perf tools: tidy up sample parsing overflow checking
Date: Thu,  4 Jul 2013 16:20:35 +0300
Message-Id: <1372944040-32690-17-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372944040-32690-1-git-send-email-adrian.hunter@intel.com>
References: <1372944040-32690-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size of data retrieved from a sample event must be
validated to ensure it does not go past the end of the
event.  That was being done sporadically and without
considering integer overflows.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evsel.c | 101 ++++++++++++++++++++++++++++++------------------
 1 file changed, 63 insertions(+), 38 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 10ccf38..16b5d5f 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1108,24 +1108,38 @@ static int perf_evsel__parse_id_sample(const struct perf_evsel *evsel,
 	return 0;
 }
 
-static bool sample_overlap(const union perf_event *event,
-			   const void *offset, u64 size)
+static inline bool overflow_one(const void *endp, const void *offset)
 {
-	const void *base = event;
-
-	if (offset + size > base + event->header.size)
-		return true;
+	return offset + sizeof(u64) > endp;
+}
 
-	return false;
+static inline bool overflow(const void *endp, u16 max_size, const void *offset,
+			    u64 size)
+{
+	return size > max_size || offset + size > endp;
 }
 
+#define OVERFLOW_CHECK_ONE(offset)				\
+	do {							\
+		if (overflow_one(endp, (offset)))		\
+			return -EFAULT;				\
+	} while (0)
+
+#define OVERFLOW_CHECK(offset, size)				\
+	do {							\
+		if (overflow(endp, max_size, (offset), (size)))	\
+			return -EFAULT;				\
+	} while (0)
+
 int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 			     struct perf_sample *data)
 {
 	u64 type = evsel->attr.sample_type;
-	u64 regs_user = evsel->attr.sample_regs_user;
 	bool swapped = evsel->needs_swap;
 	const u64 *array;
+	u16 max_size = event->header.size;
+	const void *endp = (void *)event + max_size;
+	u64 sz;
 
 	/*
 	 * used for cross-endian analysis. See git commit 65014ab3
@@ -1147,6 +1161,11 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 
 	array = event->sample.array;
 
+	/*
+	 * sample_size is based on PERF_SAMPLE_MASK which includes up to
+	 * PERF_SAMPLE_PERIOD.  After that overflow_one() or overflow() must be
+	 * used to check the format does not go past the end of the event.
+	 */
 	if (evsel->sample_size + sizeof(event->header) > event->header.size)
 		return -EFAULT;
 
@@ -1215,20 +1234,19 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 	}
 
 	if (type & PERF_SAMPLE_CALLCHAIN) {
-		if (sample_overlap(event, array, sizeof(data->callchain->nr)))
-			return -EFAULT;
-
-		data->callchain = (struct ip_callchain *)array;
+		const u64 max_callchain_nr = UINT64_MAX / sizeof(u64);
 
-		if (sample_overlap(event, array, data->callchain->nr))
+		OVERFLOW_CHECK_ONE(array);
+		data->callchain = (struct ip_callchain *)array++;
+		if (data->callchain->nr > max_callchain_nr)
 			return -EFAULT;
-
-		array += 1 + data->callchain->nr;
+		sz = data->callchain->nr * sizeof(u64);
+		OVERFLOW_CHECK(array, sz);
+		array = (void*)array + sz;
 	}
 
 	if (type & PERF_SAMPLE_RAW) {
-		const u64 *pdata;
-
+		OVERFLOW_CHECK_ONE(array);
 		u.val64 = *array;
 		if (WARN_ONCE(swapped,
 			      "Endianness of raw data not corrected!\n")) {
@@ -1237,65 +1255,72 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 			u.val32[0] = bswap_32(u.val32[0]);
 			u.val32[1] = bswap_32(u.val32[1]);
 		}
-
-		if (sample_overlap(event, array, sizeof(u32)))
-			return -EFAULT;
-
 		data->raw_size = u.val32[0];
-		pdata = (void *) array + sizeof(u32);
+		array = (void *)array + sizeof(u32);
 
-		if (sample_overlap(event, pdata, data->raw_size))
-			return -EFAULT;
-
-		data->raw_data = (void *) pdata;
-
-		array = (void *)array + data->raw_size + sizeof(u32);
+		OVERFLOW_CHECK(array, data->raw_size);
+		data->raw_data = (void *)array;
+		array = (void *)array + data->raw_size;
 	}
 
 	if (type & PERF_SAMPLE_BRANCH_STACK) {
-		u64 sz;
+		const u64 max_branch_nr = UINT64_MAX / sizeof(struct branch_entry);
 
-		data->branch_stack = (struct branch_stack *)array;
-		array++; /* nr */
+		OVERFLOW_CHECK_ONE(array);
+		data->branch_stack = (struct branch_stack *)array++;
 
+		if (data->branch_stack->nr > max_branch_nr)
+			return -EFAULT;
 		sz = data->branch_stack->nr * sizeof(struct branch_entry);
-		sz /= sizeof(u64);
-		array += sz;
+		OVERFLOW_CHECK(array, sz);
+		array = (void *)array + sz;
 	}
 
 	if (type & PERF_SAMPLE_REGS_USER) {
+		u64 avail;
+
 		/* First u64 tells us if we have any regs in sample. */
-		u64 avail = *array++;
+		OVERFLOW_CHECK_ONE(array);
+		avail = *array++;
 
 		if (avail) {
+			u64 regs_user = evsel->attr.sample_regs_user;
+
+			sz = hweight_long(regs_user) * sizeof(u64);
+			OVERFLOW_CHECK(array, sz);
 			data->user_regs.regs = (u64 *)array;
-			array += hweight_long(regs_user);
+			array = (void *)array + sz;
 		}
 	}
 
 	if (type & PERF_SAMPLE_STACK_USER) {
-		u64 size = *array++;
+		OVERFLOW_CHECK_ONE(array);
+		sz = *array++;
 
 		data->user_stack.offset = ((char *)(array - 1)
 					  - (char *) event);
 
-		if (!size) {
+		if (!sz) {
 			data->user_stack.size = 0;
 		} else {
+			OVERFLOW_CHECK(array, sz);
 			data->user_stack.data = (char *)array;
-			array += size / sizeof(*array);
+			array = (void *)array + sz;
+			OVERFLOW_CHECK_ONE(array);
 			data->user_stack.size = *array++;
 		}
 	}
 
 	data->weight = 0;
 	if (type & PERF_SAMPLE_WEIGHT) {
+		OVERFLOW_CHECK_ONE(array);
 		data->weight = *array;
 		array++;
 	}
 
 	data->data_src = PERF_MEM_DATA_SRC_NONE;
 	if (type & PERF_SAMPLE_DATA_SRC) {
+		OVERFLOW_CHECK_ONE(array);
 		data->data_src = *array;
 		array++;
 	}
-- 
1.7.11.7

