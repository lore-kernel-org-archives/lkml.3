Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab3GDNOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 09:14:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:61212 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756710Ab3GDNOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 09:14:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,995,1363158000"; 
   d="scan'208";a="264087787"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V4 02/21] perf tools: fix missing tool parameter
Date: Thu,  4 Jul 2013 16:20:21 +0300
Message-Id: <1372944040-32690-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372944040-32690-1-git-send-email-adrian.hunter@intel.com>
References: <1372944040-32690-1-git-send-email-adrian.hunter@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf inject expects to get a reference to 'struct perf_inject'
from its 'tool' member.  For that to work, 'tool' needs to be
a parameter of all tool callbacks.  Make it so.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
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
index 93dd315..855f056 100644
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
@@ -3063,7 +3064,8 @@ int perf_event__synthesize_tracing_data(struct perf_tool *tool, int fd,
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
-- 
1.7.11.7

