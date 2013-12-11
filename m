Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab3LKMmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:42:18 -0500
Received: from mga14.intel.com ([143.182.124.37]:18915 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab3LKMmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:42:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="442369647"
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
Subject: [PATCH v0 52/71] perf itrace: Add processing for Instruction Tracing events
Date: Wed, 11 Dec 2013 14:37:04 +0200
Message-Id: <1386765443-26966-53-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Provide hooks so that an Instruction Trace
decoder can process Instruction Tracing
events.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/itrace.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/itrace.h | 13 ++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/tools/perf/util/itrace.c b/tools/perf/util/itrace.c
index 44214bc..91f1fb5 100644
--- a/tools/perf/util/itrace.c
+++ b/tools/perf/util/itrace.c
@@ -579,6 +579,31 @@ out_free:
 	return err;
 }
 
+static bool itrace__dont_decode(struct perf_session *session)
+{
+	return !session->itrace_synth_opts ||
+	       session->itrace_synth_opts->dont_decode;
+}
+
+int perf_event__process_itrace_info(struct perf_tool *tool __maybe_unused,
+				    union perf_event *event,
+				    struct perf_session *session __maybe_unused)
+{
+	enum itrace_type type = event->itrace_info.type;
+
+	if (dump_trace)
+		fprintf(stdout, " type: %u\n", type);
+
+	if (itrace__dont_decode(session))
+		return 0;
+
+	switch (type) {
+	case PERF_ITRACE_UNKNOWN:
+	default:
+		return -EINVAL;
+	}
+}
+
 int perf_event__synthesize_itrace(struct perf_tool *tool,
 				  perf_event__handler_t process,
 				  size_t size, u64 offset, u64 ref, int idx,
@@ -599,6 +624,30 @@ int perf_event__synthesize_itrace(struct perf_tool *tool,
 	return process(tool, &ev, NULL, NULL);
 }
 
+s64 perf_event__process_itrace(struct perf_tool *tool, union perf_event *event,
+			       struct perf_session *session)
+{
+	s64 err;
+
+	if (dump_trace)
+		fprintf(stdout, " size: %"PRIu64"  offset: %"PRIx64"  ref: %"PRIx64"  idx: %u  tid: %d  cpu: %d\n",
+			event->itrace.size, event->itrace.offset,
+			event->itrace.reference, event->itrace.idx,
+			event->itrace.tid, event->itrace.cpu);
+
+	if (itrace__dont_decode(session))
+		return event->itrace.size;
+
+	if (!session->itrace || event->header.type != PERF_RECORD_ITRACE)
+		return -EINVAL;
+
+	err = session->itrace->process_itrace_event(session, event, tool);
+	if (err < 0)
+		return err;
+
+	return event->itrace.size;
+}
+
 #define PERF_ITRACE_DEFAULT_PERIOD_TYPE	PERF_ITRACE_PERIOD_INSTRUCTIONS
 #define PERF_ITRACE_DEFAULT_PERIOD	1000
 
@@ -713,6 +762,9 @@ int perf_event__process_itrace_error(struct perf_tool *tool __maybe_unused,
 				     union perf_event *event,
 				     struct perf_session *session)
 {
+	if (itrace__dont_decode(session))
+		return 0;
+
 	if (session->itrace)
 		session->itrace->error_count += 1;
 
diff --git a/tools/perf/util/itrace.h b/tools/perf/util/itrace.h
index 304d377..ec3b78a 100644
--- a/tools/perf/util/itrace.h
+++ b/tools/perf/util/itrace.h
@@ -38,6 +38,10 @@ struct option;
 struct perf_record_opts;
 struct itrace_info_event;
 
+enum itrace_type {
+	PERF_ITRACE_UNKNOWN,
+};
+
 enum itrace_error_type {
 	PERF_ITRACE_DECODER_ERROR = 1,
 };
@@ -76,6 +80,9 @@ struct itrace {
 			     union perf_event *event,
 			     struct perf_sample *sample,
 			     struct perf_tool *tool);
+	int (*process_itrace_event)(struct perf_session *session,
+				    union perf_event *event,
+				    struct perf_tool *tool);
 	int (*flush_events)(struct perf_session *session,
 			    struct perf_tool *tool);
 	void (*free_events)(struct perf_session *session);
@@ -316,10 +323,16 @@ int perf_event__synthesize_itrace_info(struct itrace_record *itr,
 				       struct perf_tool *tool,
 				       struct perf_session *session,
 				       perf_event__handler_t process);
+int perf_event__process_itrace_info(struct perf_tool *tool,
+				    union perf_event *event,
+				    struct perf_session *session);
 int perf_event__synthesize_itrace(struct perf_tool *tool,
 				  perf_event__handler_t process,
 				  size_t size, u64 offset, u64 ref, int idx,
 				  u32 tid, u32 cpu);
+s64 perf_event__process_itrace(struct perf_tool *tool,
+			       union perf_event *event,
+			       struct perf_session *session);
 int perf_event__process_itrace_error(struct perf_tool *tool,
 				     union perf_event *event,
 				     struct perf_session *session);
-- 
1.8.5.1

