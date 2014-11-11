Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbaKKOYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:24:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:55261 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbaKKOTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:19:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="630151808"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 10/25] perf tools: Add a user event for Instruction Tracing errors
Date: Tue, 11 Nov 2014 16:16:48 +0200
Message-Id: <1415715423-15563-11-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
References: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Errors encountered when decoding an Instruction
Trace need to be reported to the user. However
the "user" might be a script or another tool,
so provide a new user event to capture those
errors.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/event.c   |  1 +
 tools/perf/util/event.h   | 16 ++++++++++++++++
 tools/perf/util/session.c | 25 +++++++++++++++++++++++++
 tools/perf/util/tool.h    |  3 ++-
 4 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index efe6475..573fed2 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -31,6 +31,7 @@ static const char *perf_event__names[] = {
 	[PERF_RECORD_ID_INDEX]			= "ID_INDEX",
 	[PERF_RECORD_ITRACE_INFO]		= "ITRACE_INFO",
 	[PERF_RECORD_ITRACE]			= "ITRACE",
+	[PERF_RECORD_ITRACE_ERROR]		= "ITRACE_ERROR",
 };
 
 const char *perf_event__name(unsigned int id)
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 21d341e..2a9b99f 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -216,6 +216,7 @@ enum perf_user_event_type { /* above any possible kernel type */
 	PERF_RECORD_ID_INDEX			= 69,
 	PERF_RECORD_ITRACE_INFO			= 70,
 	PERF_RECORD_ITRACE			= 71,
+	PERF_RECORD_ITRACE_ERROR		= 72,
 	PERF_RECORD_HEADER_MAX
 };
 
@@ -299,6 +300,20 @@ struct itrace_event {
 	u32 reserved__; /* For alignment */
 };
 
+#define MAX_ITRACE_ERROR_MSG 64
+
+struct itrace_error_event {
+	struct perf_event_header header;
+	u32 type;
+	u32 code;
+	u32 cpu;
+	u32 pid;
+	u32 tid;
+	u32 reserved__; /* For alignment */
+	u64 ip;
+	char msg[MAX_ITRACE_ERROR_MSG];
+};
+
 union perf_event {
 	struct perf_event_header	header;
 	struct mmap_event		mmap;
@@ -316,6 +331,7 @@ union perf_event {
 	struct id_index_event		id_index;
 	struct itrace_info_event	itrace_info;
 	struct itrace_event		itrace;
+	struct itrace_error_event	itrace_error;
 };
 
 void perf_event__print_totals(void);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index c1639c7..89ca176 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -271,6 +271,15 @@ static s64 process_event_itrace_stub(struct perf_tool *tool __maybe_unused,
 	return event->itrace.size;
 }
 
+static
+int process_event_itrace_error_stub(struct perf_tool *tool __maybe_unused,
+				    union perf_event *event __maybe_unused,
+				    struct perf_session *session __maybe_unused)
+{
+	dump_printf(": unhandled!\n");
+	return 0;
+}
+
 void perf_tool__fill_defaults(struct perf_tool *tool)
 {
 	if (tool->sample == NULL)
@@ -311,6 +320,8 @@ void perf_tool__fill_defaults(struct perf_tool *tool)
 		tool->itrace_info = process_event_itrace_info_stub;
 	if (tool->itrace == NULL)
 		tool->itrace = process_event_itrace_stub;
+	if (tool->itrace_error == NULL)
+		tool->itrace_error = process_event_itrace_error_stub;
 }
  
 static void swap_sample_id_all(union perf_event *event, void *data)
@@ -514,6 +525,17 @@ static void perf_event__itrace_swap(union perf_event *event,
 	event->itrace.cpu       = bswap_32(event->itrace.cpu);
 }
 
+static void perf_event__itrace_error_swap(union perf_event *event,
+					  bool sample_id_all __maybe_unused)
+{
+	event->itrace_error.type = bswap_32(event->itrace_error.type);
+	event->itrace_error.code = bswap_32(event->itrace_error.code);
+	event->itrace_error.cpu  = bswap_32(event->itrace_error.cpu);
+	event->itrace_error.pid  = bswap_32(event->itrace_error.pid);
+	event->itrace_error.tid  = bswap_32(event->itrace_error.tid);
+	event->itrace_error.ip   = bswap_64(event->itrace_error.ip);
+}
+
 typedef void (*perf_event__swap_op)(union perf_event *event,
 				    bool sample_id_all);
 
@@ -535,6 +557,7 @@ static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_ID_INDEX]		  = perf_event__all64_swap,
 	[PERF_RECORD_ITRACE_INFO]	  = perf_event__itrace_info_swap,
 	[PERF_RECORD_ITRACE]		  = perf_event__itrace_swap,
+	[PERF_RECORD_ITRACE_ERROR]	  = perf_event__itrace_error_swap,
 	[PERF_RECORD_HEADER_MAX]	  = NULL,
 };
 
@@ -971,6 +994,8 @@ static s64 perf_session__process_user_event(struct perf_session *session,
 		/* setup for reading amidst mmap */
 		lseek(fd, file_offset + event->header.size, SEEK_SET);
 		return tool->itrace(tool, event, session);
+	case PERF_RECORD_ITRACE_ERROR:
+		return tool->itrace_error(tool, event, session);
 	default:
 		return -EINVAL;
 	}
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index b734c1a..b5c55de 100644
--- a/tools/perf/util/tool.h
+++ b/tools/perf/util/tool.h
@@ -46,7 +46,8 @@ struct perf_tool {
 	event_op2	finished_round,
 			build_id,
 			id_index,
-			itrace_info;
+			itrace_info,
+			itrace_error;
 	event_op3	itrace;
 	bool		ordered_events;
 	bool		ordering_requires_timestamps;
-- 
1.9.1

