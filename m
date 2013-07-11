Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab3GKNIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:08:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:53095 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161Ab3GKNIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:08:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1043,1363158000"; 
   d="scan'208";a="368613102"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V5 11/12] perf tools: expand perf_event__synthesize_sample()
Date: Thu, 11 Jul 2013 16:12:20 +0300
Message-Id: <1373548341-24119-12-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1373548341-24119-1-git-send-email-adrian.hunter@intel.com>
References: <1373548341-24119-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expand perf_event__synthesize_sample() to handle all
sample format bits.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-inject.c |  3 +-
 tools/perf/util/event.h     |  1 +
 tools/perf/util/evsel.c     | 70 ++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index da0cc13..459bf20 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -307,7 +307,8 @@ found:
 	sample_sw.period = sample->period;
 	sample_sw.time	 = sample->time;
 	perf_event__synthesize_sample(event_sw, evsel->attr.sample_type,
-				      &sample_sw, false);
+				      evsel->attr.sample_regs_user, &sample_sw,
+				      false);
 	build_id__mark_dso_hit(tool, event_sw, &sample_sw, evsel, machine);
 	return perf_event__repipe(tool, event_sw, &sample_sw, machine);
 }
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index ce2a92c..e00f922 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -228,6 +228,7 @@ int perf_event__preprocess_sample(const union perf_event *self,
 const char *perf_event__name(unsigned int id);
 
 int perf_event__synthesize_sample(union perf_event *event, u64 type,
+				  u64 sample_regs_user,
 				  const struct perf_sample *sample,
 				  bool swapped);
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 4940f65..ed5d767 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1356,11 +1356,12 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 }
 
 int perf_event__synthesize_sample(union perf_event *event, u64 type,
+				  u64 sample_regs_user,
 				  const struct perf_sample *sample,
 				  bool swapped)
 {
 	u64 *array;
-
+	size_t sz;
 	/*
 	 * used for cross-endian analysis. See git commit 65014ab3
 	 * for why this goofiness is needed.
@@ -1433,6 +1434,73 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 		array++;
 	}
 
+	if (type & PERF_SAMPLE_READ) {
+		fprintf(stderr, "PERF_SAMPLE_READ is unsupported for now\n");
+		return -1;
+	}
+
+	if (type & PERF_SAMPLE_CALLCHAIN) {
+		sz = (sample->callchain->nr + 1) * sizeof(u64);
+		memcpy(array, sample->callchain, sz);
+		array = (void*)array + sz;
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
+		if (sample->user_regs.regs && sample_regs_user) {
+			*array++ = sample_regs_user;
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

