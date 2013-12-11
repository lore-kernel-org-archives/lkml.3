Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3LKMta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:49:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:15885 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab3LKMl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:41:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="450498559"
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
Subject: [PATCH v0 45/71] perf tools: Add a user event for Instruction Tracing errors
Date: Wed, 11 Dec 2013 14:36:57 +0200
Message-Id: <1386765443-26966-46-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

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
index 990d10b..9ae8a26 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -29,6 +29,7 @@ static const char *perf_event__names[] = {
 	[PERF_RECORD_ID_INDEX]			= "ID_INDEX",
 	[PERF_RECORD_ITRACE_INFO]		= "ITRACE_INFO",
 	[PERF_RECORD_ITRACE]			= "ITRACE",
+	[PERF_RECORD_ITRACE_ERROR]		= "ITRACE_ERROR",
 };
 
 const char *perf_event__name(unsigned int id)
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index ad3625c..9d9b9d2 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -162,6 +162,7 @@ enum perf_user_event_type { /* above any possible kernel type */
 	PERF_RECORD_ID_INDEX			= 69,
 	PERF_RECORD_ITRACE_INFO			= 70,
 	PERF_RECORD_ITRACE			= 71,
+	PERF_RECORD_ITRACE_ERROR		= 72,
 	PERF_RECORD_HEADER_MAX
 };
 
@@ -224,6 +225,20 @@ struct itrace_lost_event {
 	u64 offset;
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
@@ -242,6 +257,7 @@ union perf_event {
 	struct itrace_lost_event	itrace_lost;
 	struct itrace_info_event	itrace_info;
 	struct itrace_event		itrace;
+	struct itrace_error_event	itrace_error;
 };
 
 void perf_event__print_totals(void);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ac71006..95067b6 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -254,6 +254,15 @@ static s64 process_event_itrace_stub(struct perf_tool *tool __maybe_unused,
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
@@ -296,6 +305,8 @@ void perf_tool__fill_defaults(struct perf_tool *tool)
 		tool->itrace_info = process_event_itrace_info_stub;
 	if (tool->itrace == NULL)
 		tool->itrace = process_event_itrace_stub;
+	if (tool->itrace_error == NULL)
+		tool->itrace_error = process_event_itrace_error_stub;
 }
  
 static void swap_sample_id_all(union perf_event *event, void *data)
@@ -503,6 +514,17 @@ static void perf_event__itrace_swap(union perf_event *event,
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
 
@@ -525,6 +547,7 @@ static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_ID_INDEX]		  = perf_event__all64_swap,
 	[PERF_RECORD_ITRACE_INFO]	  = perf_event__itrace_info_swap,
 	[PERF_RECORD_ITRACE]		  = perf_event__itrace_swap,
+	[PERF_RECORD_ITRACE_ERROR]	  = perf_event__itrace_error_swap,
 	[PERF_RECORD_HEADER_MAX]	  = NULL,
 };
 
@@ -1105,6 +1128,8 @@ static s64 perf_session__process_user_event(struct perf_session *session,
 		/* setup for reading amidst mmap */
 		lseek(fd, file_offset + event->header.size, SEEK_SET);
 		return tool->itrace(tool, event, session);
+	case PERF_RECORD_ITRACE_ERROR:
+		return tool->itrace_error(tool, event, session);
 	default:
 		return -EINVAL;
 	}
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index c1e8744..0700257 100644
--- a/tools/perf/util/tool.h
+++ b/tools/perf/util/tool.h
@@ -47,7 +47,8 @@ struct perf_tool {
 	event_op2	finished_round,
 			build_id,
 			id_index,
-			itrace_info;
+			itrace_info,
+			itrace_error;
 	event_op3	itrace;
 	bool		ordered_samples;
 	bool		ordering_requires_timestamps;
-- 
1.8.5.1

