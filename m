Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab3LKMli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:41:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:31118 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab3LKMld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:41:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="442369408"
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
Subject: [PATCH v0 46/71] perf session: Add Instruction Tracing hooks
Date: Wed, 11 Dec 2013 14:36:58 +0200
Message-Id: <1386765443-26966-47-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Hook into session processing so that
Instruction Trace decoding can
synthesize events transparently to
the tools.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/itrace.h  | 49 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/session.c | 45 +++++++++++++++++++++++++++++++++++++------
 tools/perf/util/session.h |  3 +++
 3 files changed, 91 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/itrace.h b/tools/perf/util/itrace.h
index da52a29..e6b0cc0 100644
--- a/tools/perf/util/itrace.h
+++ b/tools/perf/util/itrace.h
@@ -26,6 +26,7 @@
 #include <linux/perf_event.h>
 
 #include "../perf.h"
+#include "session.h"
 #include "types.h"
 
 union perf_event;
@@ -35,6 +36,18 @@ struct perf_tool;
 struct perf_record_opts;
 struct itrace_info_event;
 
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
 /**
  * struct itrace_mmap - records an mmap at PERF_EVENT_ITRACE_OFFSET.
  * @base: address of mapped area
@@ -164,4 +177,40 @@ int perf_event__synthesize_itrace(struct perf_tool *tool,
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
index 95067b6..55aead5 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -15,6 +15,7 @@
 #include "cpumap.h"
 #include "perf_regs.h"
 #include "vdso.h"
+#include "itrace.h"
 
 static int perf_session__open(struct perf_session *session)
 {
@@ -148,6 +149,7 @@ static void perf_session_env__delete(struct perf_session_env *env)
 
 void perf_session__delete(struct perf_session *session)
 {
+	itrace__free(session);
 	perf_session__destroy_kernel_maps(session);
 	perf_session__delete_dead_threads(session);
 	perf_session__delete_threads(session);
@@ -1022,11 +1024,11 @@ perf_session__deliver_sample(struct perf_session *session,
 					    &sample->read.one, machine);
 }
 
-static int perf_session_deliver_event(struct perf_session *session,
-				      union perf_event *event,
-				      struct perf_sample *sample,
-				      struct perf_tool *tool,
-				      u64 file_offset)
+static int __perf_session__deliver_event(struct perf_session *session,
+					 union perf_event *event,
+					 struct perf_sample *sample,
+					 struct perf_tool *tool,
+					 u64 file_offset)
 {
 	struct perf_evsel *evsel;
 	struct machine *machine;
@@ -1095,6 +1097,24 @@ static int perf_session_deliver_event(struct perf_session *session,
 	}
 }
 
+static int perf_session_deliver_event(struct perf_session *session,
+				      union perf_event *event,
+				      struct perf_sample *sample,
+				      struct perf_tool *tool,
+				      u64 file_offset)
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
@@ -1146,7 +1166,7 @@ int perf_session__deliver_synth_event(struct perf_session *session,
 		return perf_session__process_user_event(session, event, tool,
 							0);
 
-	return perf_session_deliver_event(session, event, sample, tool, 0);
+	return __perf_session__deliver_event(session, event, sample, tool, 0);
 }
 
 static void event_swap(union perf_event *event, bool sample_id_all)
@@ -1258,6 +1278,11 @@ static void perf_session__warn_about_errors(const struct perf_session *session,
 			    "Do you have a KVM guest running and not using 'perf kvm'?\n",
 			    session->stats.nr_unprocessable_samples);
 	}
+
+	if (session->itrace && session->itrace->error_count) {
+		ui__warning("%llu instruction trace errors\n",
+			    session->itrace->error_count);
+	}
 }
 
 volatile int session_done;
@@ -1346,10 +1371,14 @@ done:
 	/* do the final flush for ordered samples */
 	session->ordered_samples.next_flush = ULLONG_MAX;
 	err = flush_sample_queue(session, tool);
+	if (err)
+		goto out_err;
+	err = itrace__flush_events(session, tool);
 out_err:
 	free(buf);
 	perf_session__warn_about_errors(session, tool);
 	perf_session_free_sample_buffers(session);
+	itrace__free_events(session);
 	return err;
 }
 
@@ -1492,10 +1521,14 @@ out:
 	/* do the final flush for ordered samples */
 	session->ordered_samples.next_flush = ULLONG_MAX;
 	err = flush_sample_queue(session, tool);
+	if (err)
+		goto out_err;
+	err = itrace__flush_events(session, tool);
 out_err:
 	ui_progress__finish();
 	perf_session__warn_about_errors(session, tool);
 	perf_session_free_sample_buffers(session);
+	itrace__free_events(session);
 	session->one_mmap = false;
 	return err;
 }
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 64d8145..9000193 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -29,10 +29,13 @@ struct ordered_samples {
 	unsigned int		nr_samples;
 };
 
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
1.8.5.1

