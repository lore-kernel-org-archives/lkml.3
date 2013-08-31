Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab3HaISe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 04:18:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59644 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab3HaIOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 04:14:46 -0400
Date: Sat, 31 Aug 2013 01:13:20 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-03b6ea9b91e0914caa847a1ade759af549555298@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1377591794-30553-3-git-send-email-adrian.hunter@intel.com>
References: <1377591794-30553-3-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  Tidy up sample parsing overflow checking
Git-Commit-ID: 03b6ea9b91e0914caa847a1ade759af549555298
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 31 Aug 2013 01:13:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  03b6ea9b91e0914caa847a1ade759af549555298
Gitweb:     http://git.kernel.org/tip/03b6ea9b91e0914caa847a1ade759af549555298
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 27 Aug 2013 11:23:04 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 29 Aug 2013 15:10:02 -0300

perf evsel: Tidy up sample parsing overflow checking

The size of data retrieved from a sample event must be validated to
ensure it does not go past the end of the event.  That was being done
sporadically and without considering integer overflows.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1377591794-30553-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
