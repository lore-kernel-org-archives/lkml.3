Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306Ab3K1Lhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:37:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759041Ab3K1Lep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:34:45 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 22/29] tools lib traceevent: Change pevent_parse_format to include pevent handle
Date: Thu, 28 Nov 2013 12:33:21 +0100
Message-Id: <1385638408-23519-23-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385638408-23519-1-git-send-email-jolsa@redhat.com>
References: <1385638408-23519-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the pevent_parse_format interface to include the
pevent handle.

The goal is to always use pevent object when dealing with
traceevent library. The reason is that we might need additional
processing (like plugins), which is not possible otherwise.

Patches follow to make this happen completely.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/lib/traceevent/event-parse.c | 56 ++++++++++++++++++++++++--------------
 tools/lib/traceevent/event-parse.h |  4 ++-
 tools/perf/util/evsel.c            |  2 +-
 3 files changed, 39 insertions(+), 23 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 74007ab..22566c2 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5129,8 +5129,38 @@ enum pevent_errno __pevent_parse_format(struct event_format **eventp,
 	return ret;
 }
 
+static enum pevent_errno
+__pevent_parse_event(struct pevent *pevent,
+		     struct event_format **eventp,
+		     const char *buf, unsigned long size,
+		     const char *sys)
+{
+	int ret = __pevent_parse_format(eventp, pevent, buf, size, sys);
+	struct event_format *event = *eventp;
+
+	if (event == NULL)
+		return ret;
+
+	if (pevent && add_event(pevent, event)) {
+		ret = PEVENT_ERRNO__MEM_ALLOC_FAILED;
+		goto event_add_failed;
+	}
+
+#define PRINT_ARGS 0
+	if (PRINT_ARGS && event->print_fmt.args)
+		print_args(event->print_fmt.args);
+
+	return 0;
+
+event_add_failed:
+	pevent_free_format(event);
+	return ret;
+}
+
 /**
  * pevent_parse_format - parse the event format
+ * @pevent: the handle to the pevent
+ * @eventp: returned format
  * @buf: the buffer storing the event format string
  * @size: the size of @buf
  * @sys: the system the event belongs to
@@ -5142,10 +5172,12 @@ enum pevent_errno __pevent_parse_format(struct event_format **eventp,
  *
  * /sys/kernel/debug/tracing/events/.../.../format
  */
-enum pevent_errno pevent_parse_format(struct event_format **eventp, const char *buf,
+enum pevent_errno pevent_parse_format(struct pevent *pevent,
+				      struct event_format **eventp,
+				      const char *buf,
 				      unsigned long size, const char *sys)
 {
-	return __pevent_parse_format(eventp, NULL, buf, size, sys);
+	return __pevent_parse_event(pevent, eventp, buf, size, sys);
 }
 
 /**
@@ -5166,25 +5198,7 @@ enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
 				     unsigned long size, const char *sys)
 {
 	struct event_format *event = NULL;
-	int ret = __pevent_parse_format(&event, pevent, buf, size, sys);
-
-	if (event == NULL)
-		return ret;
-
-	if (add_event(pevent, event)) {
-		ret = PEVENT_ERRNO__MEM_ALLOC_FAILED;
-		goto event_add_failed;
-	}
-
-#define PRINT_ARGS 0
-	if (PRINT_ARGS && event->print_fmt.args)
-		print_args(event->print_fmt.args);
-
-	return 0;
-
-event_add_failed:
-	pevent_free_format(event);
-	return ret;
+	return __pevent_parse_event(pevent, &event, buf, size, sys);
 }
 
 #undef _PE
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 54273c0..620c27a 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -562,7 +562,9 @@ int pevent_parse_header_page(struct pevent *pevent, char *buf, unsigned long siz
 
 enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
 				     unsigned long size, const char *sys);
-enum pevent_errno pevent_parse_format(struct event_format **eventp, const char *buf,
+enum pevent_errno pevent_parse_format(struct pevent *pevent,
+				      struct event_format **eventp,
+				      const char *buf,
 				      unsigned long size, const char *sys);
 void pevent_free_format(struct event_format *event);
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index b5fe7f9..6a046ed 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -210,7 +210,7 @@ struct event_format *event_format__new(const char *sys, const char *name)
 		size += n;
 	} while (n > 0);
 
-	pevent_parse_format(&format, bf, size, sys);
+	pevent_parse_format(NULL, &format, bf, size, sys);
 
 out_free_bf:
 	free(bf);
-- 
1.8.3.1

