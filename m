Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab3K1KbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 05:31:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757724Ab3K1KbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 05:31:10 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 7/7] perf inject: Handle output file via perf_data_file object
Date: Thu, 28 Nov 2013 11:30:19 +0100
Message-Id: <1385634619-8129-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385634619-8129-1-git-send-email-jolsa@redhat.com>
References: <1385634619-8129-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the perf_data_file object to handle output
file processing.

No functional change intended.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-inject.c | 65 +++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 38 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 6a25085..939999c 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -22,14 +22,13 @@
 #include <linux/list.h>
 
 struct perf_inject {
-	struct perf_tool tool;
-	bool		 build_ids;
-	bool		 sched_stat;
-	const char	 *input_name;
-	int		 pipe_output,
-			 output;
-	u64		 bytes_written;
-	struct list_head samples;
+	struct perf_tool	 tool;
+	bool			 build_ids;
+	bool			 sched_stat;
+	const char		*input_name;
+	struct perf_data_file	 output;
+	u64			 bytes_written;
+	struct list_head	 samples;
 };
 
 struct event_entry {
@@ -42,21 +41,14 @@ static int perf_event__repipe_synth(struct perf_tool *tool,
 				    union perf_event *event)
 {
 	struct perf_inject *inject = container_of(tool, struct perf_inject, tool);
-	uint32_t size;
-	void *buf = event;
+	ssize_t size;
 
-	size = event->header.size;
-
-	while (size) {
-		int ret = write(inject->output, buf, size);
-		if (ret < 0)
-			return -errno;
-
-		size -= ret;
-		buf += ret;
-		inject->bytes_written += ret;
-	}
+	size = perf_data_file__write(&inject->output, event,
+				     event->header.size);
+	if (size < 0)
+		return -errno;
 
+	inject->bytes_written += size;
 	return 0;
 }
 
@@ -80,7 +72,7 @@ static int perf_event__repipe_attr(struct perf_tool *tool,
 	if (ret)
 		return ret;
 
-	if (!inject->pipe_output)
+	if (&inject->output.is_pipe)
 		return 0;
 
 	return perf_event__repipe_synth(tool, event);
@@ -355,6 +347,7 @@ static int __cmd_inject(struct perf_inject *inject)
 		.path = inject->input_name,
 		.mode = PERF_DATA_MODE_READ,
 	};
+	struct perf_data_file *file_out = &inject->output;
 
 	signal(SIGINT, sig_handler);
 
@@ -391,14 +384,14 @@ static int __cmd_inject(struct perf_inject *inject)
 		}
 	}
 
-	if (!inject->pipe_output)
-		lseek(inject->output, session->header.data_offset, SEEK_SET);
+	if (!file_out->is_pipe)
+		lseek(file_out->fd, session->header.data_offset, SEEK_SET);
 
 	ret = perf_session__process_events(session, &inject->tool);
 
-	if (!inject->pipe_output) {
+	if (!file_out->is_pipe) {
 		session->header.data_size = inject->bytes_written;
-		perf_session__write_header(session, session->evlist, inject->output, true);
+		perf_session__write_header(session, session->evlist, file_out->fd, true);
 	}
 
 	perf_session__delete(session);
@@ -427,14 +420,17 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 		},
 		.input_name  = "-",
 		.samples = LIST_HEAD_INIT(inject.samples),
+		.output = {
+			.path = "-",
+			.mode = PERF_DATA_MODE_WRITE,
+		},
 	};
-	const char *output_name = "-";
 	const struct option options[] = {
 		OPT_BOOLEAN('b', "build-ids", &inject.build_ids,
 			    "Inject build-ids into the output stream"),
 		OPT_STRING('i', "input", &inject.input_name, "file",
 			   "input file name"),
-		OPT_STRING('o', "output", &output_name, "file",
+		OPT_STRING('o', "output", &inject.output.path, "file",
 			   "output file name"),
 		OPT_BOOLEAN('s', "sched-stat", &inject.sched_stat,
 			    "Merge sched-stat and sched-switch for getting events "
@@ -456,16 +452,9 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (argc)
 		usage_with_options(inject_usage, options);
 
-	if (!strcmp(output_name, "-")) {
-		inject.pipe_output = 1;
-		inject.output = STDOUT_FILENO;
-	} else {
-		inject.output = open(output_name, O_CREAT | O_WRONLY | O_TRUNC,
-						  S_IRUSR | S_IWUSR);
-		if (inject.output < 0) {
-			perror("failed to create output file");
-			return -1;
-		}
+	if (perf_data_file__open(&inject.output)) {
+		perror("failed to create output file");
+		return -1;
 	}
 
 	if (symbol__init() < 0)
-- 
1.8.3.1

