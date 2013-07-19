Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965558Ab3GSHuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:50:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35610 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759664Ab3GSHuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:50:04 -0400
Date: Fri, 19 Jul 2013 00:49:24 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-47c3d1091cb68e727b840efd6fa3709d5b1ddfc2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1372944040-32690-3-git-send-email-adrian.hunter@intel.com>
References: <1372944040-32690-3-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix missing tool parameter
Git-Commit-ID: 47c3d1091cb68e727b840efd6fa3709d5b1ddfc2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:49:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47c3d1091cb68e727b840efd6fa3709d5b1ddfc2
Gitweb:     http://git.kernel.org/tip/47c3d1091cb68e727b840efd6fa3709d5b1ddfc2
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 4 Jul 2013 16:20:21 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:52:49 -0300

perf tools: Fix missing tool parameter

The 'inject' command expects to get a reference to 'struct perf_inject'
from its 'tool' member.  For that to work, 'tool' needs to be a
parameter of all tool callbacks.  Make it so.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1372944040-32690-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-inject.c | 26 +++++++++++---------------
 tools/perf/util/header.c    |  6 ++++--
 tools/perf/util/header.h    |  6 ++++--
 tools/perf/util/session.c   | 11 +++++++----
 tools/perf/util/tool.h      |  9 ++++-----
 5 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index f299ddf..c943513 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -73,22 +73,17 @@ static int perf_event__repipe_event_type_synth(struct perf_tool *tool,
 	return perf_event__repipe_synth(tool, event);
 }
 
-static int perf_event__repipe_tracing_data_synth(union perf_event *event,
-						 struct perf_session *session
-						 __maybe_unused)
-{
-	return perf_event__repipe_synth(NULL, event);
-}
-
-static int perf_event__repipe_attr(union perf_event *event,
-				   struct perf_evlist **pevlist __maybe_unused)
+static int perf_event__repipe_attr(struct perf_tool *tool,
+				   union perf_event *event,
+				   struct perf_evlist **pevlist)
 {
 	int ret;
-	ret = perf_event__process_attr(event, pevlist);
+
+	ret = perf_event__process_attr(tool, event, pevlist);
 	if (ret)
 		return ret;
 
-	return perf_event__repipe_synth(NULL, event);
+	return perf_event__repipe_synth(tool, event);
 }
 
 static int perf_event__repipe(struct perf_tool *tool,
@@ -147,13 +142,14 @@ static int perf_event__repipe_fork(struct perf_tool *tool,
 	return err;
 }
 
-static int perf_event__repipe_tracing_data(union perf_event *event,
+static int perf_event__repipe_tracing_data(struct perf_tool *tool,
+					   union perf_event *event,
 					   struct perf_session *session)
 {
 	int err;
 
-	perf_event__repipe_synth(NULL, event);
-	err = perf_event__process_tracing_data(event, session);
+	perf_event__repipe_synth(tool, event);
+	err = perf_event__process_tracing_data(tool, event, session);
 
 	return err;
 }
@@ -407,7 +403,7 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 			.unthrottle	= perf_event__repipe,
 			.attr		= perf_event__repipe_attr,
 			.event_type	= perf_event__repipe_event_type_synth,
-			.tracing_data	= perf_event__repipe_tracing_data_synth,
+			.tracing_data	= perf_event__repipe_op2_synth,
 			.build_id	= perf_event__repipe_op2_synth,
 		},
 		.input_name  = "-",
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index a4dafbe..d12d79c 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2922,7 +2922,8 @@ int perf_event__synthesize_attrs(struct perf_tool *tool,
 	return err;
 }
 
-int perf_event__process_attr(union perf_event *event,
+int perf_event__process_attr(struct perf_tool *tool __maybe_unused,
+			     union perf_event *event,
 			     struct perf_evlist **pevlist)
 {
 	u32 i, ids, n_ids;
@@ -3065,7 +3066,8 @@ int perf_event__synthesize_tracing_data(struct perf_tool *tool, int fd,
 	return aligned_size;
 }
 
-int perf_event__process_tracing_data(union perf_event *event,
+int perf_event__process_tracing_data(struct perf_tool *tool __maybe_unused,
+				     union perf_event *event,
 				     struct perf_session *session)
 {
 	ssize_t size_read, padding, size = event->tracing_data.size;
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 16a3e83..2d1ca7d 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -130,7 +130,8 @@ int perf_event__synthesize_attr(struct perf_tool *tool,
 int perf_event__synthesize_attrs(struct perf_tool *tool,
 				 struct perf_session *session,
 				 perf_event__handler_t process);
-int perf_event__process_attr(union perf_event *event, struct perf_evlist **pevlist);
+int perf_event__process_attr(struct perf_tool *tool, union perf_event *event,
+			     struct perf_evlist **pevlist);
 
 int perf_event__synthesize_event_type(struct perf_tool *tool,
 				      u64 event_id, char *name,
@@ -145,7 +146,8 @@ int perf_event__process_event_type(struct perf_tool *tool,
 int perf_event__synthesize_tracing_data(struct perf_tool *tool,
 					int fd, struct perf_evlist *evlist,
 					perf_event__handler_t process);
-int perf_event__process_tracing_data(union perf_event *event,
+int perf_event__process_tracing_data(struct perf_tool *tool,
+				     union perf_event *event,
 				     struct perf_session *session);
 
 int perf_event__synthesize_build_id(struct perf_tool *tool,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ad47fb9..6b71b88 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -193,7 +193,9 @@ void perf_session__delete(struct perf_session *self)
 	vdso__exit();
 }
 
-static int process_event_synth_tracing_data_stub(union perf_event *event
+static int process_event_synth_tracing_data_stub(struct perf_tool *tool
+						 __maybe_unused,
+						 union perf_event *event
 						 __maybe_unused,
 						 struct perf_session *session
 						__maybe_unused)
@@ -202,7 +204,8 @@ static int process_event_synth_tracing_data_stub(union perf_event *event
 	return 0;
 }
 
-static int process_event_synth_attr_stub(union perf_event *event __maybe_unused,
+static int process_event_synth_attr_stub(struct perf_tool *tool __maybe_unused,
+					 union perf_event *event __maybe_unused,
 					 struct perf_evlist **pevlist
 					 __maybe_unused)
 {
@@ -921,7 +924,7 @@ static int perf_session__process_user_event(struct perf_session *session, union
 	/* These events are processed right away */
 	switch (event->header.type) {
 	case PERF_RECORD_HEADER_ATTR:
-		err = tool->attr(event, &session->evlist);
+		err = tool->attr(tool, event, &session->evlist);
 		if (err == 0)
 			perf_session__set_id_hdr_size(session);
 		return err;
@@ -930,7 +933,7 @@ static int perf_session__process_user_event(struct perf_session *session, union
 	case PERF_RECORD_HEADER_TRACING_DATA:
 		/* setup for reading amidst mmap */
 		lseek(session->fd, file_offset, SEEK_SET);
-		return tool->tracing_data(event, session);
+		return tool->tracing_data(tool, event, session);
 	case PERF_RECORD_HEADER_BUILD_ID:
 		return tool->build_id(tool, event, session);
 	case PERF_RECORD_FINISHED_ROUND:
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index b0e1aad..88f8cbd 100644
--- a/tools/perf/util/tool.h
+++ b/tools/perf/util/tool.h
@@ -18,12 +18,11 @@ typedef int (*event_sample)(struct perf_tool *tool, union perf_event *event,
 typedef int (*event_op)(struct perf_tool *tool, union perf_event *event,
 			struct perf_sample *sample, struct machine *machine);
 
-typedef int (*event_attr_op)(union perf_event *event,
+typedef int (*event_attr_op)(struct perf_tool *tool,
+			     union perf_event *event,
 			     struct perf_evlist **pevlist);
-typedef int (*event_simple_op)(struct perf_tool *tool, union perf_event *event);
 
-typedef int (*event_synth_op)(union perf_event *event,
-			      struct perf_session *session);
+typedef int (*event_simple_op)(struct perf_tool *tool, union perf_event *event);
 
 typedef int (*event_op2)(struct perf_tool *tool, union perf_event *event,
 			 struct perf_session *session);
@@ -39,7 +38,7 @@ struct perf_tool {
 			throttle,
 			unthrottle;
 	event_attr_op	attr;
-	event_synth_op	tracing_data;
+	event_op2	tracing_data;
 	event_simple_op	event_type;
 	event_op2	finished_round,
 			build_id;
