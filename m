Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030396AbaLLNx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 08:53:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:50123 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030261AbaLLNui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 08:50:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,563,1413270000"; 
   d="scan'208";a="636669055"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V3 13/22] perf itrace: Add processing for Instruction Tracing events
Date: Fri, 12 Dec 2014 15:48:00 +0200
Message-Id: <1418392089-5568-14-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418392089-5568-1-git-send-email-adrian.hunter@intel.com>
References: <1418392089-5568-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide hooks so that an Instruction Trace
decoder can process Instruction Tracing
events.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/itrace.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/itrace.h | 13 +++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/tools/perf/util/itrace.c b/tools/perf/util/itrace.c
index ee05677..feb9159 100644
--- a/tools/perf/util/itrace.c
+++ b/tools/perf/util/itrace.c
@@ -600,6 +600,28 @@ out_free:
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
@@ -620,6 +642,30 @@ int perf_event__synthesize_itrace(struct perf_tool *tool,
 	return process(tool, &ev, NULL, NULL);
 }
 
+s64 perf_event__process_itrace(struct perf_tool *tool, union perf_event *event,
+			       struct perf_session *session)
+{
+	s64 err;
+
+	if (dump_trace)
+		fprintf(stdout, " size: %#"PRIx64"  offset: %#"PRIx64"  ref: %#"PRIx64"  idx: %u  tid: %d  cpu: %d\n",
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
 #define PERF_ITRACE_DEFAULT_PERIOD_TYPE		PERF_ITRACE_PERIOD_NANOSECS
 #define PERF_ITRACE_DEFAULT_PERIOD		100000
 #define PERF_ITRACE_DEFAULT_CALLCHAIN_SZ	16
@@ -765,6 +811,9 @@ int perf_event__process_itrace_error(struct perf_tool *tool __maybe_unused,
 				     union perf_event *event,
 				     struct perf_session *session)
 {
+	if (itrace__dont_decode(session))
+		return 0;
+
 	if (session->itrace)
 		session->itrace->error_count += 1;
 
diff --git a/tools/perf/util/itrace.h b/tools/perf/util/itrace.h
index 0b00d50..08247d5 100644
--- a/tools/perf/util/itrace.h
+++ b/tools/perf/util/itrace.h
@@ -34,6 +34,10 @@ struct option;
 struct record_opts;
 struct itrace_info_event;
 
+enum itrace_type {
+	PERF_ITRACE_UNKNOWN,
+};
+
 enum itrace_error_type {
 	PERF_ITRACE_DECODER_ERROR = 1,
 };
@@ -90,6 +94,9 @@ struct itrace {
 			     union perf_event *event,
 			     struct perf_sample *sample,
 			     struct perf_tool *tool);
+	int (*process_itrace_event)(struct perf_session *session,
+				    union perf_event *event,
+				    struct perf_tool *tool);
 	int (*flush_events)(struct perf_session *session,
 			    struct perf_tool *tool);
 	void (*free_events)(struct perf_session *session);
@@ -330,10 +337,16 @@ int perf_event__synthesize_itrace_info(struct itrace_record *itr,
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
1.9.1

