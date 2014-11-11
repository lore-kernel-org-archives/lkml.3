Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaKKOWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:22:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:38869 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbaKKOUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:20:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="630152298"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 22/25] perf inject: Re-pipe Instruction Tracing events
Date: Tue, 11 Nov 2014 16:17:00 +0200
Message-Id: <1415715423-15563-23-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
References: <1415715423-15563-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New Instruction Tracing events must be re-piped by default.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-inject.c | 63 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 58 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 84df2de..29e0840 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -38,14 +38,11 @@ struct event_entry {
 	union perf_event event[0];
 };
 
-static int perf_event__repipe_synth(struct perf_tool *tool,
-				    union perf_event *event)
+static int output_bytes(struct perf_inject *inject, void *buf, size_t sz)
 {
-	struct perf_inject *inject = container_of(tool, struct perf_inject, tool);
 	ssize_t size;
 
-	size = perf_data_file__write(&inject->output, event,
-				     event->header.size);
+	size = perf_data_file__write(&inject->output, buf, sz);
 	if (size < 0)
 		return -errno;
 
@@ -53,6 +50,34 @@ static int perf_event__repipe_synth(struct perf_tool *tool,
 	return 0;
 }
 
+static int copy_bytes(struct perf_inject *inject, int fd, off_t size)
+{
+	char buf[4096];
+	ssize_t ssz;
+	int ret;
+
+	while (size > 0) {
+		ssz = read(fd, buf, MIN(size, sizeof(buf)));
+		if (ssz < 0)
+			return -errno;
+		ret = output_bytes(inject, buf, ssz);
+		if (ret)
+			return ret;
+		size -= ssz;
+	}
+
+	return 0;
+}
+
+static int perf_event__repipe_synth(struct perf_tool *tool,
+				    union perf_event *event)
+{
+	struct perf_inject *inject = container_of(tool, struct perf_inject,
+						  tool);
+
+	return output_bytes(inject, event, event->header.size);
+}
+
 static int perf_event__repipe_op2_synth(struct perf_tool *tool,
 					union perf_event *event,
 					struct perf_session *session
@@ -79,6 +104,31 @@ static int perf_event__repipe_attr(struct perf_tool *tool,
 	return perf_event__repipe_synth(tool, event);
 }
 
+static s64 perf_event__repipe_itrace(struct perf_tool *tool,
+				     union perf_event *event,
+				     struct perf_session *session
+				     __maybe_unused)
+{
+	struct perf_inject *inject = container_of(tool, struct perf_inject,
+						  tool);
+	int ret;
+
+	if (perf_data_file__is_pipe(session->file) || !session->one_mmap) {
+		ret = output_bytes(inject, event, event->header.size);
+		if (ret < 0)
+			return ret;
+		ret = copy_bytes(inject, perf_data_file__fd(session->file),
+				 event->itrace.size);
+	} else {
+		ret = output_bytes(inject, event,
+				   event->header.size + event->itrace.size);
+	}
+	if (ret < 0)
+		return ret;
+
+	return event->itrace.size;
+}
+
 static int perf_event__repipe(struct perf_tool *tool,
 			      union perf_event *event,
 			      struct perf_sample *sample __maybe_unused,
@@ -407,6 +457,9 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 			.unthrottle	= perf_event__repipe,
 			.attr		= perf_event__repipe_attr,
 			.tracing_data	= perf_event__repipe_op2_synth,
+			.itrace_info	= perf_event__repipe_op2_synth,
+			.itrace		= perf_event__repipe_itrace,
+			.itrace_error	= perf_event__repipe_op2_synth,
 			.finished_round	= perf_event__repipe_op2_synth,
 			.build_id	= perf_event__repipe_op2_synth,
 			.id_index	= perf_event__repipe_op2_synth,
-- 
1.9.1

