Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab3LKMl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:41:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:56257 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab3LKMlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:41:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="422886961"
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
Subject: [PATCH v0 49/71] perf itrace: Add helpers for Instruction Tracing errors
Date: Wed, 11 Dec 2013 14:37:01 +0200
Message-Id: <1386765443-26966-50-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add functions to synthesize, count and print
Instruction Tracing error events.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/itrace.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/itrace.h | 16 ++++++++++++++
 2 files changed, 71 insertions(+)

diff --git a/tools/perf/util/itrace.c b/tools/perf/util/itrace.c
index b80411d..865b584 100644
--- a/tools/perf/util/itrace.c
+++ b/tools/perf/util/itrace.c
@@ -25,6 +25,7 @@
 #include <linux/perf_event.h>
 
 #include <stdlib.h>
+#include <stdio.h>
 #include <string.h>
 #include <errno.h>
 
@@ -37,6 +38,7 @@
 #include "itrace.h"
 
 #include "event.h"
+#include "session.h"
 #include "debug.h"
 #include "parse-options.h"
 
@@ -162,6 +164,28 @@ struct itrace_record *__attribute__ ((weak)) itrace_record__init(int *err)
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
+	strncpy(itrace_error->msg, msg, MAX_ITRACE_ERROR_MSG - 1);
+
+	size = (void *)itrace_error->msg - (void *)itrace_error +
+	       strlen(itrace_error->msg);
+	itrace_error->header.size = PERF_ALIGN(size, sizeof(u64));
+}
+
 int perf_event__synthesize_itrace_info(struct itrace_record *itr,
 				       struct perf_tool *tool,
 				       struct perf_session *session,
@@ -310,6 +334,37 @@ out_err:
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
index 8453351..08877d2 100644
--- a/tools/perf/util/itrace.h
+++ b/tools/perf/util/itrace.h
@@ -37,6 +37,10 @@ struct option;
 struct perf_record_opts;
 struct itrace_info_event;
 
+enum itrace_error_type {
+	PERF_ITRACE_DECODER_ERROR = 1,
+};
+
 enum itrace_period_type {
 	PERF_ITRACE_PERIOD_INSTRUCTIONS,
 	PERF_ITRACE_PERIOD_TICKS,
@@ -198,6 +202,10 @@ int itrace_record__info_fill(struct itrace_record *itr,
 void itrace_record__free(struct itrace_record *itr);
 u64 itrace_record__reference(struct itrace_record *itr);
 
+void itrace_synth_error(struct itrace_error_event *itrace_error, int type,
+			int code, int cpu, pid_t pid, pid_t tid, u64 ip,
+			const char *msg);
+
 int perf_event__synthesize_itrace_info(struct itrace_record *itr,
 				       struct perf_tool *tool,
 				       struct perf_session *session,
@@ -206,10 +214,18 @@ int perf_event__synthesize_itrace(struct perf_tool *tool,
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
1.8.5.1

