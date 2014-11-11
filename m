Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbaKKOTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:19:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:55261 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbaKKOTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:19:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="630151894"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 13/25] perf itrace: Add helpers for Instruction Tracing errors
Date: Tue, 11 Nov 2014 16:16:51 +0200
Message-Id: <1415715423-15563-14-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
References: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add functions to synthesize, count and print
Instruction Tracing error events.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/itrace.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/itrace.h | 16 ++++++++++++++
 2 files changed, 71 insertions(+)

diff --git a/tools/perf/util/itrace.c b/tools/perf/util/itrace.c
index 2a3a7ce..b063c26 100644
--- a/tools/perf/util/itrace.c
+++ b/tools/perf/util/itrace.c
@@ -22,6 +22,7 @@
 #include <linux/types.h>
 
 #include <stdlib.h>
+#include <stdio.h>
 #include <string.h>
 #include <errno.h>
 
@@ -33,6 +34,7 @@
 #include "itrace.h"
 
 #include "event.h"
+#include "session.h"
 #include "debug.h"
 #include "parse-options.h"
 
@@ -157,6 +159,28 @@ struct itrace_record * __weak itrace_record__init(int *err)
 	return NULL;
 }
 
+void itrace_synth_error(struct itrace_error_event *itrace_error, int type,
+			int code, int cpu, pid_t pid, pid_t tid, u64 ip,
+			const char *msg)
+{
+	size_t size;
+
+	memset(itrace_error, 0, sizeof(struct itrace_error_event));
+
+	itrace_error->header.type = PERF_RECORD_ITRACE_ERROR;
+	itrace_error->type = type;
+	itrace_error->code = code;
+	itrace_error->cpu = cpu;
+	itrace_error->pid = pid;
+	itrace_error->tid = tid;
+	itrace_error->ip = ip;
+	strlcpy(itrace_error->msg, msg, MAX_ITRACE_ERROR_MSG);
+
+	size = (void *)itrace_error->msg - (void *)itrace_error +
+	       strlen(itrace_error->msg) + 1;
+	itrace_error->header.size = PERF_ALIGN(size, sizeof(u64));
+}
+
 int perf_event__synthesize_itrace_info(struct itrace_record *itr,
 				       struct perf_tool *tool,
 				       struct perf_session *session,
@@ -336,6 +360,37 @@ out_err:
 	return -EINVAL;
 }
 
+size_t perf_event__fprintf_itrace_error(union perf_event *event, FILE *fp)
+{
+	struct itrace_error_event *e = &event->itrace_error;
+	int ret;
+
+	ret = fprintf(fp, " Instruction trace error type %u", e->type);
+	ret += fprintf(fp, " cpu %d pid %d tid %d ip %#"PRIx64" code %u: %s\n",
+		       e->cpu, e->pid, e->tid, e->ip, e->code, e->msg);
+	return ret;
+}
+
+int perf_event__process_itrace_error(struct perf_tool *tool __maybe_unused,
+				     union perf_event *event,
+				     struct perf_session *session)
+{
+	if (session->itrace)
+		session->itrace->error_count += 1;
+
+	perf_event__fprintf_itrace_error(event, stdout);
+	return 0;
+}
+
+int perf_event__count_itrace_error(struct perf_tool *tool __maybe_unused,
+				   union perf_event *event __maybe_unused,
+				   struct perf_session *session)
+{
+	if (session->itrace)
+		session->itrace->error_count += 1;
+	return 0;
+}
+
 int itrace_mmap__read(struct itrace_mmap *mm, struct itrace_record *itr,
 		      struct perf_tool *tool, process_itrace_t fn)
 {
diff --git a/tools/perf/util/itrace.h b/tools/perf/util/itrace.h
index 76e70ea..8275afd 100644
--- a/tools/perf/util/itrace.h
+++ b/tools/perf/util/itrace.h
@@ -33,6 +33,10 @@ struct option;
 struct record_opts;
 struct itrace_info_event;
 
+enum itrace_error_type {
+	PERF_ITRACE_DECODER_ERROR = 1,
+};
+
 enum itrace_period_type {
 	PERF_ITRACE_PERIOD_INSTRUCTIONS,
 	PERF_ITRACE_PERIOD_TICKS,
@@ -202,6 +206,10 @@ int itrace_record__info_fill(struct itrace_record *itr,
 void itrace_record__free(struct itrace_record *itr);
 u64 itrace_record__reference(struct itrace_record *itr);
 
+void itrace_synth_error(struct itrace_error_event *itrace_error, int type,
+			int code, int cpu, pid_t pid, pid_t tid, u64 ip,
+			const char *msg);
+
 int perf_event__synthesize_itrace_info(struct itrace_record *itr,
 				       struct perf_tool *tool,
 				       struct perf_session *session,
@@ -210,10 +218,18 @@ int perf_event__synthesize_itrace(struct perf_tool *tool,
 				  perf_event__handler_t process,
 				  size_t size, u64 offset, u64 ref, int idx,
 				  u32 tid, u32 cpu);
+int perf_event__process_itrace_error(struct perf_tool *tool,
+				     union perf_event *event,
+				     struct perf_session *session);
+int perf_event__count_itrace_error(struct perf_tool *tool __maybe_unused,
+				   union perf_event *event __maybe_unused,
+				   struct perf_session *session);
 int itrace_parse_synth_opts(const struct option *opt, const char *str,
 			    int unset);
 void itrace_synth_opts__set_default(struct itrace_synth_opts *synth_opts);
 
+size_t perf_event__fprintf_itrace_error(union perf_event *event, FILE *fp);
+
 static inline int itrace__process_event(struct perf_session *session,
 					union perf_event *event,
 					struct perf_sample *sample,
-- 
1.9.1

