Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab3H0IXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:23:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:48898 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab3H0IRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:17:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,966,1367996400"; 
   d="scan'208";a="352104886"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V13 02/12] perf tools: tidy up sample parsing overflow checking
Date: Tue, 27 Aug 2013 11:23:04 +0300
Message-Id: <1377591794-30553-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377591794-30553-1-git-send-email-adrian.hunter@intel.com>
References: <1377591794-30553-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size of data retrieved from a sample event must be
validated to ensure it does not go past the end of the
event.  That was being done sporadically and without
considering integer overflows.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/evsel.c | 112 ++++++++++++++++++++++++++++++------------------
 1 file changed, 71 insertions(+), 41 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 47cbe1e..9a5fb23 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1131,24 +1131,30 @@ static int perf_evsel__parse_id_sample(const struct perf_evsel *evsel,
 	return 0;
 }
 
-static bool sample_overlap(const union perf_event *event,
-			   const void *offset, u64 size)
+static inline bool overflow(const void *endp, u16 max_size, const void *offset,
+			    u64 size)
 {
-	const void *base = event;
+	return size > max_size || offset + size > endp;
+}
 
-	if (offset + size > base + event->header.size)
-		return true;
+#define OVERFLOW_CHECK(offset, size, max_size)				\
+	do {								\
+		if (overflow(endp, (max_size), (offset), (size)))	\
+			return -EFAULT;					\
+	} while (0)
 
-	return false;
-}
+#define OVERFLOW_CHECK_u64(offset) \
+	OVERFLOW_CHECK(offset, sizeof(u64), sizeof(u64))
 
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
@@ -1170,6 +1176,11 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 
 	array = event->sample.array;
 
+	/*
+	 * The evsel's sample_size is based on PERF_SAMPLE_MASK which includes
+	 * up to PERF_SAMPLE_PERIOD.  After that overflow() must be used to
+	 * check the format does not go past the end of the event.
+	 */
 	if (evsel->sample_size + sizeof(event->header) > event->header.size)
 		return -EFAULT;
 
@@ -1235,6 +1246,7 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 	if (type & PERF_SAMPLE_READ) {
 		u64 read_format = evsel->attr.read_format;
 
+		OVERFLOW_CHECK_u64(array);
 		if (read_format & PERF_FORMAT_GROUP)
 			data->read.group.nr = *array;
 		else
@@ -1243,41 +1255,51 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		array++;
 
 		if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED) {
+			OVERFLOW_CHECK_u64(array);
 			data->read.time_enabled = *array;
 			array++;
 		}
 
 		if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING) {
+			OVERFLOW_CHECK_u64(array);
 			data->read.time_running = *array;
 			array++;
 		}
 
 		/* PERF_FORMAT_ID is forced for PERF_SAMPLE_READ */
 		if (read_format & PERF_FORMAT_GROUP) {
-			data->read.group.values = (struct sample_read_value *) array;
-			array = (void *) array + data->read.group.nr *
-				sizeof(struct sample_read_value);
+			const u64 max_group_nr = UINT64_MAX /
+					sizeof(struct sample_read_value);
+
+			if (data->read.group.nr > max_group_nr)
+				return -EFAULT;
+			sz = data->read.group.nr *
+			     sizeof(struct sample_read_value);
+			OVERFLOW_CHECK(array, sz, max_size);
+			data->read.group.values =
+					(struct sample_read_value *)array;
+			array = (void *)array + sz;
 		} else {
+			OVERFLOW_CHECK_u64(array);
 			data->read.one.id = *array;
 			array++;
 		}
 	}
 
 	if (type & PERF_SAMPLE_CALLCHAIN) {
-		if (sample_overlap(event, array, sizeof(data->callchain->nr)))
-			return -EFAULT;
-
-		data->callchain = (struct ip_callchain *)array;
+		const u64 max_callchain_nr = UINT64_MAX / sizeof(u64);
 
-		if (sample_overlap(event, array, data->callchain->nr))
+		OVERFLOW_CHECK_u64(array);
+		data->callchain = (struct ip_callchain *)array++;
+		if (data->callchain->nr > max_callchain_nr)
 			return -EFAULT;
-
-		array += 1 + data->callchain->nr;
+		sz = data->callchain->nr * sizeof(u64);
+		OVERFLOW_CHECK(array, sz, max_size);
+		array = (void *)array + sz;
 	}
 
 	if (type & PERF_SAMPLE_RAW) {
-		const u64 *pdata;
-
+		OVERFLOW_CHECK_u64(array);
 		u.val64 = *array;
 		if (WARN_ONCE(swapped,
 			      "Endianness of raw data not corrected!\n")) {
@@ -1286,65 +1308,73 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 			u.val32[0] = bswap_32(u.val32[0]);
 			u.val32[1] = bswap_32(u.val32[1]);
 		}
-
-		if (sample_overlap(event, array, sizeof(u32)))
-			return -EFAULT;
-
 		data->raw_size = u.val32[0];
-		pdata = (void *) array + sizeof(u32);
-
-		if (sample_overlap(event, pdata, data->raw_size))
-			return -EFAULT;
+		array = (void *)array + sizeof(u32);
 
-		data->raw_data = (void *) pdata;
-
-		array = (void *)array + data->raw_size + sizeof(u32);
+		OVERFLOW_CHECK(array, data->raw_size, max_size);
+		data->raw_data = (void *)array;
+		array = (void *)array + data->raw_size;
 	}
 
 	if (type & PERF_SAMPLE_BRANCH_STACK) {
-		u64 sz;
+		const u64 max_branch_nr = UINT64_MAX /
+					  sizeof(struct branch_entry);
 
-		data->branch_stack = (struct branch_stack *)array;
-		array++; /* nr */
+		OVERFLOW_CHECK_u64(array);
+		data->branch_stack = (struct branch_stack *)array++;
 
+		if (data->branch_stack->nr > max_branch_nr)
+			return -EFAULT;
 		sz = data->branch_stack->nr * sizeof(struct branch_entry);
-		sz /= sizeof(u64);
-		array += sz;
+		OVERFLOW_CHECK(array, sz, max_size);
+		array = (void *)array + sz;
 	}
 
 	if (type & PERF_SAMPLE_REGS_USER) {
+		u64 avail;
+
 		/* First u64 tells us if we have any regs in sample. */
-		u64 avail = *array++;
+		OVERFLOW_CHECK_u64(array);
+		avail = *array++;
 
 		if (avail) {
+			u64 regs_user = evsel->attr.sample_regs_user;
+
+			sz = hweight_long(regs_user) * sizeof(u64);
+			OVERFLOW_CHECK(array, sz, max_size);
 			data->user_regs.regs = (u64 *)array;
-			array += hweight_long(regs_user);
+			array = (void *)array + sz;
 		}
 	}
 
 	if (type & PERF_SAMPLE_STACK_USER) {
-		u64 size = *array++;
+		OVERFLOW_CHECK_u64(array);
+		sz = *array++;
 
 		data->user_stack.offset = ((char *)(array - 1)
 					  - (char *) event);
 
-		if (!size) {
+		if (!sz) {
 			data->user_stack.size = 0;
 		} else {
+			OVERFLOW_CHECK(array, sz, max_size);
 			data->user_stack.data = (char *)array;
-			array += size / sizeof(*array);
+			array = (void *)array + sz;
+			OVERFLOW_CHECK_u64(array);
 			data->user_stack.size = *array++;
 		}
 	}
 
 	data->weight = 0;
 	if (type & PERF_SAMPLE_WEIGHT) {
+		OVERFLOW_CHECK_u64(array);
 		data->weight = *array;
 		array++;
 	}
 
 	data->data_src = PERF_MEM_DATA_SRC_NONE;
 	if (type & PERF_SAMPLE_DATA_SRC) {
+		OVERFLOW_CHECK_u64(array);
 		data->data_src = *array;
 		array++;
 	}
-- 
1.7.11.7

