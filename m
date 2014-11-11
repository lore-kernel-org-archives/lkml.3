Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaKKOS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:18:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:55261 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbaKKOS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:18:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="630151655"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 06/25] perf tools: Add user events for Instruction Tracing
Date: Tue, 11 Nov 2014 16:16:44 +0200
Message-Id: <1415715423-15563-7-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
References: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two user events for Instruction Tracing.

PERF_RECORD_ITRACE_INFO contains metadata,
consisting primarily the type of the
Instruction Tracing data plus some amount
of architecture-specific information.
There should be only one
PERF_RECORD_ITRACE_INFO event.

PERF_RECORD_ITRACE identifies Instruction
Tracing data copied from the mmapped
Instruction Tracing region.  The actual
data is not part of the event but
immediately follows it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/event.c   |  2 ++
 tools/perf/util/event.h   | 22 +++++++++++++++
 tools/perf/util/session.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/tool.h    |  9 ++++++-
 4 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 6c6d044..efe6475 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -29,6 +29,8 @@ static const char *perf_event__names[] = {
 	[PERF_RECORD_HEADER_BUILD_ID]		= "BUILD_ID",
 	[PERF_RECORD_FINISHED_ROUND]		= "FINISHED_ROUND",
 	[PERF_RECORD_ID_INDEX]			= "ID_INDEX",
+	[PERF_RECORD_ITRACE_INFO]		= "ITRACE_INFO",
+	[PERF_RECORD_ITRACE]			= "ITRACE",
 };
 
 const char *perf_event__name(unsigned int id)
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 7be3897..21d341e 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -214,6 +214,8 @@ enum perf_user_event_type { /* above any possible kernel type */
 	PERF_RECORD_HEADER_BUILD_ID		= 67,
 	PERF_RECORD_FINISHED_ROUND		= 68,
 	PERF_RECORD_ID_INDEX			= 69,
+	PERF_RECORD_ITRACE_INFO			= 70,
+	PERF_RECORD_ITRACE			= 71,
 	PERF_RECORD_HEADER_MAX
 };
 
@@ -279,6 +281,24 @@ struct id_index_event {
 	struct id_index_entry entries[0];
 };
 
+struct itrace_info_event {
+	struct perf_event_header header;
+	u32 type;
+	u32 reserved__; /* For alignment */
+	u64 priv[];
+};
+
+struct itrace_event {
+	struct perf_event_header header;
+	u64 size;
+	u64 offset;
+	u64 reference;
+	u32 idx;
+	u32 tid;
+	u32 cpu;
+	u32 reserved__; /* For alignment */
+};
+
 union perf_event {
 	struct perf_event_header	header;
 	struct mmap_event		mmap;
@@ -294,6 +314,8 @@ union perf_event {
 	struct tracing_data_event	tracing_data;
 	struct build_id_event		build_id;
 	struct id_index_event		id_index;
+	struct itrace_info_event	itrace_info;
+	struct itrace_event		itrace;
 };
 
 void perf_event__print_totals(void);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index f4478ce..c1639c7 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -237,6 +237,40 @@ static int process_id_index_stub(struct perf_tool *tool __maybe_unused,
 	return 0;
 }
 
+static int process_event_itrace_info_stub(struct perf_tool *tool __maybe_unused,
+				  union perf_event *event __maybe_unused,
+				  struct perf_session *session __maybe_unused)
+{
+	dump_printf(": unhandled!\n");
+	return 0;
+}
+
+static int skipn(int fd, off_t n)
+{
+	char buf[4096];
+	ssize_t ret;
+
+	while (n > 0) {
+		ret = read(fd, buf, MIN(n, sizeof(buf)));
+		if (ret <= 0)
+			return ret;
+		n -= ret;
+	}
+
+	return 0;
+}
+
+static s64 process_event_itrace_stub(struct perf_tool *tool __maybe_unused,
+				     union perf_event *event,
+				     struct perf_session *session
+				     __maybe_unused)
+{
+	dump_printf(": unhandled!\n");
+	if (perf_data_file__is_pipe(session->file))
+		skipn(perf_data_file__fd(session->file), event->itrace.size);
+	return event->itrace.size;
+}
+
 void perf_tool__fill_defaults(struct perf_tool *tool)
 {
 	if (tool->sample == NULL)
@@ -273,6 +307,10 @@ void perf_tool__fill_defaults(struct perf_tool *tool)
 	}
 	if (tool->id_index == NULL)
 		tool->id_index = process_id_index_stub;
+	if (tool->itrace_info == NULL)
+		tool->itrace_info = process_event_itrace_info_stub;
+	if (tool->itrace == NULL)
+		tool->itrace = process_event_itrace_stub;
 }
  
 static void swap_sample_id_all(union perf_event *event, void *data)
@@ -453,6 +491,29 @@ static void perf_event__tracing_data_swap(union perf_event *event,
 	event->tracing_data.size = bswap_32(event->tracing_data.size);
 }
 
+static void perf_event__itrace_info_swap(union perf_event *event,
+					 bool sample_id_all __maybe_unused)
+{
+	size_t size;
+
+	event->itrace_info.type = bswap_32(event->itrace_info.type);
+
+	size = event->header.size;
+	size -= (void *)&event->itrace_info.priv - (void *)event;
+	mem_bswap_64(event->itrace_info.priv, size);
+}
+
+static void perf_event__itrace_swap(union perf_event *event,
+				    bool sample_id_all __maybe_unused)
+{
+	event->itrace.size      = bswap_64(event->itrace.size);
+	event->itrace.offset    = bswap_64(event->itrace.offset);
+	event->itrace.reference = bswap_64(event->itrace.reference);
+	event->itrace.idx       = bswap_32(event->itrace.idx);
+	event->itrace.tid       = bswap_32(event->itrace.tid);
+	event->itrace.cpu       = bswap_32(event->itrace.cpu);
+}
+
 typedef void (*perf_event__swap_op)(union perf_event *event,
 				    bool sample_id_all);
 
@@ -472,6 +533,8 @@ static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_HEADER_TRACING_DATA] = perf_event__tracing_data_swap,
 	[PERF_RECORD_HEADER_BUILD_ID]	  = NULL,
 	[PERF_RECORD_ID_INDEX]		  = perf_event__all64_swap,
+	[PERF_RECORD_ITRACE_INFO]	  = perf_event__itrace_info_swap,
+	[PERF_RECORD_ITRACE]		  = perf_event__itrace_swap,
 	[PERF_RECORD_HEADER_MAX]	  = NULL,
 };
 
@@ -902,6 +965,12 @@ static s64 perf_session__process_user_event(struct perf_session *session,
 		return tool->finished_round(tool, event, session);
 	case PERF_RECORD_ID_INDEX:
 		return tool->id_index(tool, event, session);
+	case PERF_RECORD_ITRACE_INFO:
+		return tool->itrace_info(tool, event, session);
+	case PERF_RECORD_ITRACE:
+		/* setup for reading amidst mmap */
+		lseek(fd, file_offset + event->header.size, SEEK_SET);
+		return tool->itrace(tool, event, session);
 	default:
 		return -EINVAL;
 	}
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index bb2708b..b734c1a 100644
--- a/tools/perf/util/tool.h
+++ b/tools/perf/util/tool.h
@@ -3,6 +3,8 @@
 
 #include <stdbool.h>
 
+#include <linux/types.h>
+
 struct perf_session;
 union perf_event;
 struct perf_evlist;
@@ -25,6 +27,9 @@ typedef int (*event_attr_op)(struct perf_tool *tool,
 typedef int (*event_op2)(struct perf_tool *tool, union perf_event *event,
 			 struct perf_session *session);
 
+typedef s64 (*event_op3)(struct perf_tool *tool, union perf_event *event,
+			 struct perf_session *session);
+
 struct perf_tool {
 	event_sample	sample,
 			read;
@@ -40,7 +45,9 @@ struct perf_tool {
 	event_op2	tracing_data;
 	event_op2	finished_round,
 			build_id,
-			id_index;
+			id_index,
+			itrace_info;
+	event_op3	itrace;
 	bool		ordered_events;
 	bool		ordering_requires_timestamps;
 };
-- 
1.9.1

