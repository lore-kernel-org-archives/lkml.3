Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab3ISSlC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 14:41:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43983 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab3ISSkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:40:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 6/9] perf session: Check for SIGINT in more loops
Date: Thu, 19 Sep 2013 15:40:29 -0300
Message-Id: <1379616032-13061-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1379616032-13061-1-git-send-email-acme@infradead.org>
References: <1379616032-13061-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

When processing big files we were not checking if session_done was set
by the SIGINT signal handler, for instance in 'perf report'. Fix it.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-pyad42lgrtq7xhg2dpsoauq7@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-inject.c | 2 --
 tools/perf/builtin-report.c | 5 +++--
 tools/perf/builtin-script.c | 2 --
 tools/perf/util/hist.c      | 2 ++
 tools/perf/util/session.c   | 9 +++++++--
 tools/perf/util/session.h   | 4 ++++
 6 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 423875c..afe377b 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -321,8 +321,6 @@ found:
 	return perf_event__repipe(tool, event_sw, &sample_sw, machine);
 }
 
-extern volatile int session_done;
-
 static void sig_handler(int sig __maybe_unused)
 {
 	session_done = 1;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8e50d8d..72eae74 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -401,8 +401,6 @@ static int perf_report__setup_sample_type(struct perf_report *rep)
 	return 0;
 }
 
-extern volatile int session_done;
-
 static void sig_handler(int sig __maybe_unused)
 {
 	session_done = 1;
@@ -568,6 +566,9 @@ static int __cmd_report(struct perf_report *rep)
 		}
 	}
 
+	if (session_done())
+		return 0;
+
 	if (nr_samples == 0) {
 		ui__error("The %s file has no samples!\n", session->filename);
 		return 0;
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 7f31a3d..9c333ff 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -553,8 +553,6 @@ static struct perf_tool perf_script = {
 	.ordering_requires_timestamps = true,
 };
 
-extern volatile int session_done;
-
 static void sig_handler(int sig __maybe_unused)
 {
 	session_done = 1;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 46a0d35..9ff6cf3 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -611,6 +611,8 @@ void hists__collapse_resort(struct hists *hists)
 	next = rb_first(root);
 
 	while (next) {
+		if (session_done())
+			break;
 		n = rb_entry(next, struct hist_entry, rb_node_in);
 		next = rb_next(&n->rb_node_in);
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 51f5edf..70ffa41 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -531,6 +531,9 @@ static int flush_sample_queue(struct perf_session *s,
 		return 0;
 
 	list_for_each_entry_safe(iter, tmp, head, list) {
+		if (session_done())
+			return 0;
+
 		if (iter->timestamp > limit)
 			break;
 
@@ -1160,7 +1163,6 @@ static void perf_session__warn_about_errors(const struct perf_session *session,
 	}
 }
 
-#define session_done()	(*(volatile int *)(&session_done))
 volatile int session_done;
 
 static int __perf_session__process_pipe_events(struct perf_session *self,
@@ -1372,10 +1374,13 @@ more:
 				    "Processing events...");
 	}
 
+	err = 0;
+	if (session_done())
+		goto out_err;
+
 	if (file_pos < file_size)
 		goto more;
 
-	err = 0;
 	/* do the final flush for ordered samples */
 	session->ordered_samples.next_flush = ULLONG_MAX;
 	err = flush_sample_queue(session, tool);
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 3aa75fb..04bf737 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -124,4 +124,8 @@ int __perf_session__set_tracepoints_handlers(struct perf_session *session,
 
 #define perf_session__set_tracepoints_handlers(session, array) \
 	__perf_session__set_tracepoints_handlers(session, array, ARRAY_SIZE(array))
+
+extern volatile int session_done;
+
+#define session_done()	(*(volatile int *)(&session_done))
 #endif /* __PERF_SESSION_H */
-- 
1.8.1.4

