Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab3LKMk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:40:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:44423 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab3LKMkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:40:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="422886515"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 38/71] perf tools: Add itrace sample parsing
Date: Wed, 11 Dec 2013 14:36:50 +0200
Message-Id: <1386765443-26966-39-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add supoprt for parsing samples containing
Instruction Traces i.e. PERF_SAMPLE_ITRACE.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/tests/sample-parsing.c |  7 ++++++-
 tools/perf/util/event.h           |  6 ++++++
 tools/perf/util/evlist.c          | 12 ++++++++++++
 tools/perf/util/evlist.h          |  4 ++++
 tools/perf/util/evsel.c           | 33 +++++++++++++++++++++++++++++++--
 tools/perf/util/evsel.h           | 13 +++++++++++--
 tools/perf/util/session.c         |  3 ++-
 7 files changed, 72 insertions(+), 6 deletions(-)

diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index 1b67720..acc8132 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -155,6 +155,7 @@ static int do_test(u64 sample_type, u64 sample_regs_user, u64 read_format)
 	u64 user_regs[64];
 	const u64 raw_data[] = {0x123456780a0b0c0dULL, 0x1102030405060708ULL};
 	const u64 data[] = {0x2211443366558877ULL, 0, 0xaabbccddeeff4321ULL};
+	const u64 itrace_data[] = {0xa55a, 0, 0xeeddee, 0x0282028202820282};
 	struct perf_sample sample = {
 		.ip		= 101,
 		.pid		= 102,
@@ -184,6 +185,10 @@ static int do_test(u64 sample_type, u64 sample_regs_user, u64 read_format)
 			.time_enabled = 0x030a59d664fca7deULL,
 			.time_running = 0x011b6ae553eb98edULL,
 		},
+		.itrace_sample	= {
+			.size	= sizeof(itrace_data),
+			.data	= (void *)itrace_data,
+		},
 	};
 	struct sample_read_value values[] = {{1, 5}, {9, 3}, {2, 7}, {6, 4},};
 	struct perf_sample sample_out;
@@ -280,7 +285,7 @@ int test__sample_parsing(void)
 	 * were added.  Please actually update the test rather than just change
 	 * the condition below.
 	 */
-	if (PERF_SAMPLE_MAX > PERF_SAMPLE_TRANSACTION << 1) {
+	if (PERF_SAMPLE_MAX > PERF_SAMPLE_ITRACE << 1) {
 		pr_debug("sample format has changed, some new PERF_SAMPLE_ bit was introduced - test needs updating\n");
 		return -1;
 	}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index b684398..cc49148 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -111,6 +111,11 @@ struct sample_read {
 	};
 };
 
+struct itrace_sample {
+	u64 size;
+	void *data;
+};
+
 struct perf_sample {
 	u64 ip;
 	u32 pid, tid;
@@ -130,6 +135,7 @@ struct perf_sample {
 	struct regs_dump  user_regs;
 	struct stack_dump user_stack;
 	struct sample_read read;
+	struct itrace_sample itrace_sample;
 };
 
 #define PERF_MEM_DATA_SRC_NONE \
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index e750a21..490af37 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1238,6 +1238,18 @@ int perf_evlist__parse_sample(struct perf_evlist *evlist, union perf_event *even
 	return perf_evsel__parse_sample(evsel, event, sample);
 }
 
+int __perf_evlist__parse_sample(struct perf_evlist *evlist,
+				union perf_event *event,
+				struct perf_sample *sample,
+				bool fix_swap)
+{
+	struct perf_evsel *evsel = perf_evlist__event2evsel(evlist, event);
+
+	if (!evsel)
+		return -EFAULT;
+	return __perf_evsel__parse_sample(evsel, event, sample, fix_swap);
+}
+
 size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp)
 {
 	struct perf_evsel *evsel;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index f0ce3bf..6f3166e 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -151,6 +151,10 @@ u16 perf_evlist__id_hdr_size(struct perf_evlist *evlist);
 
 int perf_evlist__parse_sample(struct perf_evlist *evlist, union perf_event *event,
 			      struct perf_sample *sample);
+int __perf_evlist__parse_sample(struct perf_evlist *evlist,
+				union perf_event *event,
+				struct perf_sample *sample,
+				bool fix_swap);
 
 bool perf_evlist__valid_sample_type(struct perf_evlist *evlist);
 bool perf_evlist__valid_sample_id_all(struct perf_evlist *evlist);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index da2116c..88b7edd 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1233,8 +1233,10 @@ static inline bool overflow(const void *endp, u16 max_size, const void *offset,
 #define OVERFLOW_CHECK_u64(offset) \
 	OVERFLOW_CHECK(offset, sizeof(u64), sizeof(u64))
 
-int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
-			     struct perf_sample *data)
+int __perf_evsel__parse_sample(struct perf_evsel *evsel,
+			       union perf_event *event,
+			       struct perf_sample *data,
+			       bool fix_swap)
 {
 	u64 type = evsel->attr.sample_type;
 	bool swapped = evsel->needs_swap;
@@ -1479,6 +1481,19 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		array++;
 	}
 
+	if (type & PERF_SAMPLE_ITRACE) {
+		OVERFLOW_CHECK_u64(array);
+		sz = *array++;
+
+		OVERFLOW_CHECK(array, sz, max_size);
+		/* Undo swap of data */
+		if (fix_swap && swapped)
+			mem_bswap_64((char *)array, sz);
+		data->itrace_sample.size = sz;
+		data->itrace_sample.data = (char *)array;
+		array = (void *)array + sz;
+	}
+
 	return 0;
 }
 
@@ -1574,6 +1589,11 @@ size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
 	if (type & PERF_SAMPLE_TRANSACTION)
 		result += sizeof(u64);
 
+	if (type & PERF_SAMPLE_ITRACE) {
+		result += sizeof(u64);
+		result += sample->itrace_sample.size;
+	}
+
 	return result;
 }
 
@@ -1752,6 +1772,15 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 		array++;
 	}
 
+	if (type & PERF_SAMPLE_ITRACE) {
+		sz = sample->itrace_sample.size;
+		*array++ = sz;
+		memcpy(array, sample->itrace_sample.data, sz);
+		if (swapped)
+			mem_bswap_64((char *)array, sz);
+		array = (void *)array + sz;
+	}
+
 	return 0;
 }
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 3e25e23..b0433fd 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -280,8 +280,17 @@ static inline int perf_evsel__read_scaled(struct perf_evsel *evsel,
 
 void hists__init(struct hists *hists);
 
-int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
-			     struct perf_sample *sample);
+int __perf_evsel__parse_sample(struct perf_evsel *evsel,
+			       union perf_event *event,
+			       struct perf_sample *data,
+			       bool fix_swap);
+
+static inline int perf_evsel__parse_sample(struct perf_evsel *evsel,
+					   union perf_event *event,
+					   struct perf_sample *data)
+{
+	return __perf_evsel__parse_sample(evsel, event, data, false);
+}
 
 static inline struct perf_evsel *perf_evsel__next(struct perf_evsel *evsel)
 {
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index de09c2e..fbf9024 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1086,7 +1086,8 @@ static s64 perf_session__process_event(struct perf_session *session,
 	/*
 	 * For all kernel events we get the sample data
 	 */
-	ret = perf_evlist__parse_sample(session->evlist, event, &sample);
+	ret = __perf_evlist__parse_sample(session->evlist, event, &sample,
+					  true);
 	if (ret)
 		return ret;
 
-- 
1.8.5.1

