Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbbAHMyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 07:54:55 -0500
Received: from mga14.intel.com ([192.55.52.115]:35459 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756773AbbAHMyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:54:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="437999758"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V4 08/23] perf session: Add hooks to allow transparent decoding of Instruction Tracing data
Date: Thu,  8 Jan 2015 14:52:12 +0200
Message-Id: <1420721547-26470-9-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420721547-26470-1-git-send-email-adrian.hunter@intel.com>
References: <1420721547-26470-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hook into session processing so that Instruction Trace decoding can
synthesize events transparently to the tools.

The advantages of transparent decoding are that tools can be used
directly with perf.data files containing Instruction Tracing data,
which is easier for the user and more efficient than having a
separate decoding tool.

This will work as follows:
1. Tools will feed itrace events to the decoder using
perf_tool->itrace() (support for that still to come).
2. The decoder can process side-band events as needed due
to the itrace->process_event() hook.
3. The decoder can deliver synthesized events into the
event stream using perf_session__deliver_synth_event().

Note the expectation is that decoding will work on data that is
time-ordered with respect to the per-cpu or per-thread contexts
that were recorded.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/itrace.h  | 57 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/session.c | 52 +++++++++++++++++++++++++++++++++++++-----
 tools/perf/util/session.h |  3 +++
 3 files changed, 106 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/itrace.h b/tools/perf/util/itrace.h
index 6eef25c..beea1d7 100644
--- a/tools/perf/util/itrace.h
+++ b/tools/perf/util/itrace.h
@@ -23,6 +23,7 @@
 #include <linux/types.h>
 
 #include "../perf.h"
+#include "session.h"
 
 union perf_event;
 struct perf_session;
@@ -32,6 +33,26 @@ struct record_opts;
 struct itrace_info_event;
 
 /**
+ * struct itrace - session callbacks to allow Instruction Trace data decoding.
+ * @process_event: lets the decoder see all session events
+ * @flush_events: process any remaining data
+ * @free_events: free resources associated with event processing
+ * @free: free resources associated with the session
+ * @error_count: number of errors
+ */
+struct itrace {
+	int (*process_event)(struct perf_session *session,
+			     union perf_event *event,
+			     struct perf_sample *sample,
+			     struct perf_tool *tool);
+	int (*flush_events)(struct perf_session *session,
+			    struct perf_tool *tool);
+	void (*free_events)(struct perf_session *session);
+	void (*free)(struct perf_session *session);
+	unsigned long long error_count;
+};
+
+/**
  * struct itrace_mmap - records an mmap of the itrace buffer.
  * @base: address of mapped area
  * @userpg: pointer to buffer's perf_event_mmap_page
@@ -150,4 +171,40 @@ int perf_event__synthesize_itrace(struct perf_tool *tool,
 				  size_t size, u64 offset, u64 ref, int idx,
 				  u32 tid, u32 cpu);
 
+static inline int itrace__process_event(struct perf_session *session,
+					union perf_event *event,
+					struct perf_sample *sample,
+					struct perf_tool *tool)
+{
+	if (!session->itrace)
+		return 0;
+
+	return session->itrace->process_event(session, event, sample, tool);
+}
+
+static inline int itrace__flush_events(struct perf_session *session,
+				       struct perf_tool *tool)
+{
+	if (!session->itrace)
+		return 0;
+
+	return session->itrace->flush_events(session, tool);
+}
+
+static inline void itrace__free_events(struct perf_session *session)
+{
+	if (!session->itrace)
+		return;
+
+	return session->itrace->free_events(session);
+}
+
+static inline void itrace__free(struct perf_session *session)
+{
+	if (!session->itrace)
+		return;
+
+	return session->itrace->free(session);
+}
+
 #endif
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ea5d4ae..bb653ef 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -15,6 +15,7 @@
 #include "cpumap.h"
 #include "perf_regs.h"
 #include "asm/bug.h"
+#include "itrace.h"
 
 static int perf_session__open(struct perf_session *session)
 {
@@ -166,6 +167,7 @@ static void perf_session_env__delete(struct perf_session_env *env)
 
 void perf_session__delete(struct perf_session *session)
 {
+	itrace__free(session);
 	perf_session__destroy_kernel_maps(session);
 	perf_session__delete_dead_threads(session);
 	perf_session__delete_threads(session);
@@ -929,10 +931,11 @@ perf_session__deliver_sample(struct perf_session *session,
 					    &sample->read.one, machine);
 }
 
-int perf_session__deliver_event(struct perf_session *session,
-				union perf_event *event,
-				struct perf_sample *sample,
-				struct perf_tool *tool, u64 file_offset)
+static int __perf_session__deliver_event(struct perf_session *session,
+					 union perf_event *event,
+					 struct perf_sample *sample,
+					 struct perf_tool *tool,
+					 u64 file_offset)
 {
 	struct perf_evsel *evsel;
 	struct machine *machine;
@@ -983,6 +986,24 @@ int perf_session__deliver_event(struct perf_session *session,
 	}
 }
 
+int perf_session__deliver_event(struct perf_session *session,
+				union perf_event *event,
+				struct perf_sample *sample,
+				struct perf_tool *tool,
+				u64 file_offset)
+{
+	int ret;
+
+	ret = itrace__process_event(session, event, sample, tool);
+	if (ret < 0)
+		return ret;
+	if (ret > 0)
+		return 0;
+
+	return __perf_session__deliver_event(session, event, sample, tool,
+					     file_offset);
+}
+
 static s64 perf_session__process_user_event(struct perf_session *session,
 					    union perf_event *event,
 					    struct perf_tool *tool,
@@ -1041,7 +1062,7 @@ int perf_session__deliver_synth_event(struct perf_session *session,
 	if (event->header.type >= PERF_RECORD_USER_TYPE_START)
 		return perf_session__process_user_event(session, event, tool, 0);
 
-	return perf_session__deliver_event(session, event, sample, tool, 0);
+	return __perf_session__deliver_event(session, event, sample, tool, 0);
 }
 
 static void event_swap(union perf_event *event, bool sample_id_all)
@@ -1211,6 +1232,11 @@ static void perf_session__warn_about_errors(const struct perf_session *session,
 
 	if (session->stats.nr_unordered_events != 0)
 		ui__warning("%u out of order events recorded.\n", session->stats.nr_unordered_events);
+
+	if (session->itrace && session->itrace->error_count) {
+		ui__warning("%llu instruction trace errors\n",
+			    session->itrace->error_count);
+	}
 }
 
 volatile int session_done;
@@ -1298,10 +1324,14 @@ more:
 done:
 	/* do the final flush for ordered samples */
 	err = ordered_events__flush(session, tool, OE_FLUSH__FINAL);
+	if (err)
+		goto out_err;
+	err = itrace__flush_events(session, tool);
 out_err:
 	free(buf);
 	perf_session__warn_about_errors(session, tool);
 	ordered_events__free(&session->ordered_events);
+	itrace__free_events(session);
 	return err;
 }
 
@@ -1443,10 +1473,14 @@ more:
 out:
 	/* do the final flush for ordered samples */
 	err = ordered_events__flush(session, tool, OE_FLUSH__FINAL);
+	if (err)
+		goto out_err;
+	err = itrace__flush_events(session, tool);
 out_err:
 	ui_progress__finish();
 	perf_session__warn_about_errors(session, tool);
 	ordered_events__free(&session->ordered_events);
+	itrace__free_events(session);
 	session->one_mmap = false;
 	return err;
 }
@@ -1528,7 +1562,13 @@ size_t perf_session__fprintf_dsos_buildid(struct perf_session *session, FILE *fp
 
 size_t perf_session__fprintf_nr_events(struct perf_session *session, FILE *fp)
 {
-	size_t ret = fprintf(fp, "Aggregated stats:\n");
+	size_t ret;
+	const char *msg = "";
+
+	if (perf_header__has_feat(&session->header, HEADER_ITRACE))
+		msg = " (excludes Instruction Trace decoded/synthesized events)";
+
+	ret = fprintf(fp, "Aggregated stats:%s\n", msg);
 
 	ret += events_stats__fprintf(&session->stats, fp);
 	return ret;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index dc26ebf..6f8ac2f 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -15,10 +15,13 @@
 struct ip_callchain;
 struct thread;
 
+struct itrace;
+
 struct perf_session {
 	struct perf_header	header;
 	struct machines		machines;
 	struct perf_evlist	*evlist;
+	struct itrace		*itrace;
 	struct trace_event	tevent;
 	struct events_stats	stats;
 	bool			repipe;
-- 
1.9.1

