Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab3LKMnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:43:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:13714 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851Ab3LKMm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:42:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="448281441"
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
Subject: [PATCH v0 60/71] perf inject: Re-pipe Instruction Tracing events
Date: Wed, 11 Dec 2013 14:37:12 +0200
Message-Id: <1386765443-26966-61-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

New Instruction Tracing events must be re-piped by default.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-inject.c | 68 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 59 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 78911a3..8c47982 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -38,20 +38,14 @@ struct event_entry {
 	union perf_event event[0];
 };
 
-static int perf_event__repipe_synth(struct perf_tool *tool,
-				    union perf_event *event)
+static int output_bytes(struct perf_inject *inject, void *buf, size_t size)
 {
-	struct perf_inject *inject = container_of(tool, struct perf_inject, tool);
-	uint32_t size;
-	void *buf = event;
-
-	size = event->header.size;
+	ssize_t ret;
 
 	while (size) {
-		int ret = write(inject->output, buf, size);
+		ret = write(inject->output, buf, size);
 		if (ret < 0)
 			return -errno;
-
 		size -= ret;
 		buf += ret;
 		inject->bytes_written += ret;
@@ -60,6 +54,34 @@ static int perf_event__repipe_synth(struct perf_tool *tool,
 	return 0;
 }
 
+static int copy_bytes(struct perf_inject *inject, int fd, size_t size)
+{
+	char buf[4096];
+	ssize_t ssz;
+	int ret;
+
+	while (size) {
+		ssz = read(fd, buf, min(size, sizeof(buf)));
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
@@ -86,6 +108,31 @@ static int perf_event__repipe_attr(struct perf_tool *tool,
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
@@ -423,6 +470,9 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
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
1.8.5.1

