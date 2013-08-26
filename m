Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab3HZMzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:55:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:52649 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756789Ab3HZMy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:54:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,958,1367996400"; 
   d="scan'208";a="392111875"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V12 11/13] perf tools: expand perf_event__synthesize_sample()
Date: Mon, 26 Aug 2013 16:00:28 +0300
Message-Id: <1377522030-27870-12-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377522030-27870-1-git-send-email-adrian.hunter@intel.com>
References: <1377522030-27870-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expand perf_event__synthesize_sample() to handle all
sample format bits.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-inject.c |  4 +-
 tools/perf/util/event.h     |  1 +
 tools/perf/util/evsel.c     | 95 ++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 97 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index ffacd46..9b336fd 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -301,7 +301,9 @@ found:
 	sample_sw.period = sample->period;
 	sample_sw.time	 = sample->time;
 	perf_event__synthesize_sample(event_sw, evsel->attr.sample_type,
-				      &sample_sw, false);
+				      evsel->attr.sample_regs_user,
+				      evsel->attr.read_format, &sample_sw,
+				      false);
 	build_id__mark_dso_hit(tool, event_sw, &sample_sw, evsel, machine);
 	return perf_event__repipe(tool, event_sw, &sample_sw, machine);
 }
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 6bb5d7c..84f704f 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -246,6 +246,7 @@ int perf_event__preprocess_sample(const union perf_event *self,
 const char *perf_event__name(unsigned int id);
 
 int perf_event__synthesize_sample(union perf_event *event, u64 type,
+				  u64 sample_regs_user, u64 read_format,
 				  const struct perf_sample *sample,
 				  bool swapped);
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 1184188..7d62373 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1416,7 +1416,6 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 	}
 
 	if (type & PERF_SAMPLE_REGS_USER) {
-		/* First u64 tells us if we have any regs in sample. */
 		OVERFLOW_CHECK_u64(array);
 		data->user_regs.abi = *array;
 		array++;
@@ -1467,11 +1466,12 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 }
 
 int perf_event__synthesize_sample(union perf_event *event, u64 type,
+				  u64 sample_regs_user, u64 read_format,
 				  const struct perf_sample *sample,
 				  bool swapped)
 {
 	u64 *array;
-
+	size_t sz;
 	/*
 	 * used for cross-endian analysis. See git commit 65014ab3
 	 * for why this goofiness is needed.
@@ -1544,6 +1544,97 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 		array++;
 	}
 
+	if (type & PERF_SAMPLE_READ) {
+		if (read_format & PERF_FORMAT_GROUP)
+			*array = sample->read.group.nr;
+		else
+			*array = sample->read.one.value;
+		array++;
+
+		if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED) {
+			*array = sample->read.time_enabled;
+			array++;
+		}
+
+		if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING) {
+			*array = sample->read.time_running;
+			array++;
+		}
+
+		/* PERF_FORMAT_ID is forced for PERF_SAMPLE_READ */
+		if (read_format & PERF_FORMAT_GROUP) {
+			sz = sample->read.group.nr *
+			     sizeof(struct sample_read_value);
+			memcpy(array, sample->read.group.values, sz);
+			array = (void *)array + sz;
+		} else {
+			*array = sample->read.one.id;
+			array++;
+		}
+	}
+
+	if (type & PERF_SAMPLE_CALLCHAIN) {
+		sz = (sample->callchain->nr + 1) * sizeof(u64);
+		memcpy(array, sample->callchain, sz);
+		array = (void *)array + sz;
+	}
+
+	if (type & PERF_SAMPLE_RAW) {
+		u.val32[0] = sample->raw_size;
+		if (WARN_ONCE(swapped,
+			      "Endianness of raw data not corrected!\n")) {
+			/*
+			 * Inverse of what is done in perf_evsel__parse_sample
+			 */
+			u.val32[0] = bswap_32(u.val32[0]);
+			u.val32[1] = bswap_32(u.val32[1]);
+			u.val64 = bswap_64(u.val64);
+		}
+		*array = u.val64;
+		array = (void *)array + sizeof(u32);
+
+		memcpy(array, sample->raw_data, sample->raw_size);
+		array = (void *)array + sample->raw_size;
+	}
+
+	if (type & PERF_SAMPLE_BRANCH_STACK) {
+		sz = sample->branch_stack->nr * sizeof(struct branch_entry);
+		sz += sizeof(u64);
+		memcpy(array, sample->branch_stack, sz);
+		array = (void *)array + sz;
+	}
+
+	if (type & PERF_SAMPLE_REGS_USER) {
+		if (sample->user_regs.abi) {
+			*array++ = sample->user_regs.abi;
+			sz = hweight_long(sample_regs_user) * sizeof(u64);
+			memcpy(array, sample->user_regs.regs, sz);
+			array = (void *)array + sz;
+		} else {
+			*array++ = 0;
+		}
+	}
+
+	if (type & PERF_SAMPLE_STACK_USER) {
+		sz = sample->user_stack.size;
+		*array++ = sz;
+		if (sz) {
+			memcpy(array, sample->user_stack.data, sz);
+			array = (void *)array + sz;
+			*array++ = sz;
+		}
+	}
+
+	if (type & PERF_SAMPLE_WEIGHT) {
+		*array = sample->weight;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_DATA_SRC) {
+		*array = sample->data_src;
+		array++;
+	}
+
 	return 0;
 }
 
-- 
1.7.11.7

