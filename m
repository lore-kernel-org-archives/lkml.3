Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab3LKMln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:41:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:6442 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab3LKMlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:41:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="450498600"
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
Subject: [PATCH v0 47/71] perf session: Add Instruction Tracing options
Date: Wed, 11 Dec 2013 14:36:59 +0200
Message-Id: <1386765443-26966-48-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Instruction Trace decoding synthesizes
"instructions" and "branches" events.
Add options for that.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/itrace.c  | 100 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/itrace.h  |  33 +++++++++++++++
 tools/perf/util/session.h |   2 +
 3 files changed, 135 insertions(+)

diff --git a/tools/perf/util/itrace.c b/tools/perf/util/itrace.c
index 9596cc2..b80411d 100644
--- a/tools/perf/util/itrace.c
+++ b/tools/perf/util/itrace.c
@@ -38,6 +38,7 @@
 
 #include "event.h"
 #include "debug.h"
+#include "parse-options.h"
 
 int itrace_mmap__mmap(struct itrace_mmap *mm, struct itrace_mmap_params *mp,
 		      int fd)
@@ -210,6 +211,105 @@ int perf_event__synthesize_itrace(struct perf_tool *tool,
 	return process(tool, &ev, NULL, NULL);
 }
 
+#define PERF_ITRACE_DEFAULT_PERIOD_TYPE	PERF_ITRACE_PERIOD_INSTRUCTIONS
+#define PERF_ITRACE_DEFAULT_PERIOD	1000
+
+void itrace_synth_opts__set_default(struct itrace_synth_opts *synth_opts)
+{
+	synth_opts->instructions = true;
+	synth_opts->branches = true;
+	synth_opts->errors = true;
+	synth_opts->period_type = PERF_ITRACE_DEFAULT_PERIOD_TYPE;
+	synth_opts->period = PERF_ITRACE_DEFAULT_PERIOD;
+}
+
+int itrace_parse_synth_opts(const struct option *opt, const char *str,
+			    int unset)
+{
+	struct itrace_synth_opts *synth_opts = opt->value;
+	const char *p;
+	char *endptr;
+
+	synth_opts->set = true;
+
+	if (unset) {
+		synth_opts->dont_decode = true;
+		return 0;
+	}
+
+	if (!str) {
+		itrace_synth_opts__set_default(synth_opts);
+		return 0;
+	}
+
+	for (p = str; *p;) {
+		switch (*p++) {
+		case 'i':
+			synth_opts->instructions = true;
+			while (*p == ' ' || *p == ',')
+				p += 1;
+			if (isdigit(*p)) {
+				synth_opts->period = strtoull(p, &endptr, 10);
+				p = endptr;
+				while (*p == ' ' || *p == ',')
+					p += 1;
+				switch (*p++) {
+				case 'i':
+					synth_opts->period_type =
+						PERF_ITRACE_PERIOD_INSTRUCTIONS;
+					break;
+				case 't':
+					synth_opts->period_type =
+						PERF_ITRACE_PERIOD_TICKS;
+					break;
+				case 'm':
+					synth_opts->period *= 1000;
+					/* Fall through */
+				case 'u':
+					synth_opts->period *= 1000;
+					/* Fall through */
+				case 'n':
+					if (*p++ != 's')
+						goto out_err;
+					synth_opts->period_type =
+						PERF_ITRACE_PERIOD_NANOSECS;
+					break;
+				case '\0':
+					goto out;
+				default:
+					goto out_err;
+				}
+			}
+			break;
+		case 'b':
+			synth_opts->branches = true;
+			break;
+		case 'e':
+			synth_opts->errors = true;
+			break;
+		case ' ':
+		case ',':
+			break;
+		default:
+			goto out_err;
+		}
+	}
+out:
+	if (synth_opts->instructions) {
+		if (!synth_opts->period_type)
+			synth_opts->period_type =
+					PERF_ITRACE_DEFAULT_PERIOD_TYPE;
+		if (!synth_opts->period)
+			synth_opts->period = PERF_ITRACE_DEFAULT_PERIOD;
+	}
+
+	return 0;
+
+out_err:
+	pr_err("Bad instruction trace options '%s'\n", str);
+	return -EINVAL;
+}
+
 int itrace_mmap__read(struct itrace_mmap *mm, struct itrace_record *itr,
 		      struct perf_tool *tool, process_itrace_t fn)
 {
diff --git a/tools/perf/util/itrace.h b/tools/perf/util/itrace.h
index e6b0cc0..8453351 100644
--- a/tools/perf/util/itrace.h
+++ b/tools/perf/util/itrace.h
@@ -33,9 +33,39 @@ union perf_event;
 struct perf_session;
 struct perf_evlist;
 struct perf_tool;
+struct option;
 struct perf_record_opts;
 struct itrace_info_event;
 
+enum itrace_period_type {
+	PERF_ITRACE_PERIOD_INSTRUCTIONS,
+	PERF_ITRACE_PERIOD_TICKS,
+	PERF_ITRACE_PERIOD_NANOSECS,
+};
+
+/**
+ * struct itrace_synth_opts - Instruction Tracing synthesis options.
+ * @set: indicates whether or not options have been set
+ * @inject: indicates the event (not just the sample) must be fully synthesized
+ *          because 'perf inject' will write it out
+ * @instructions: whether to synthesize 'instructions' events
+ * @branches: whether to synthesize 'branches' events
+ * @errors: whether to synthesize decoder error events
+ * @dont_decode: whether to skip decoding entirely
+ * @period: 'instructions' events period
+ * @period_type: 'instructions' events period type
+ */
+struct itrace_synth_opts {
+	bool			set;
+	bool			inject;
+	bool			instructions;
+	bool			branches;
+	bool			errors;
+	bool			dont_decode;
+	unsigned long long	period;
+	enum itrace_period_type	period_type;
+};
+
 struct itrace {
 	int (*process_event)(struct perf_session *session,
 			     union perf_event *event,
@@ -176,6 +206,9 @@ int perf_event__synthesize_itrace(struct perf_tool *tool,
 				  perf_event__handler_t process,
 				  size_t size, u64 offset, u64 ref, int idx,
 				  u32 tid, u32 cpu);
+int itrace_parse_synth_opts(const struct option *opt, const char *str,
+			    int unset);
+void itrace_synth_opts__set_default(struct itrace_synth_opts *synth_opts);
 
 static inline int itrace__process_event(struct perf_session *session,
 					union perf_event *event,
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 9000193..a7873c0 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -30,12 +30,14 @@ struct ordered_samples {
 };
 
 struct itrace;
+struct itrace_synth_opts;
 
 struct perf_session {
 	struct perf_header	header;
 	struct machines		machines;
 	struct perf_evlist	*evlist;
 	struct itrace		*itrace;
+	struct itrace_synth_opts *itrace_synth_opts;
 	struct trace_event	tevent;
 	struct events_stats	stats;
 	bool			repipe;
-- 
1.8.5.1

