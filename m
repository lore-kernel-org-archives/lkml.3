Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab3LDUIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:08:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59445 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933333Ab3LDUHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:07:24 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/38] tools lib traceevent: Change pevent_parse_format to include pevent handle
Date: Wed,  4 Dec 2013 17:06:40 -0300
Message-Id: <1386187622-2928-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386187622-2928-1-git-send-email-acme@infradead.org>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Changing the pevent_parse_format interface to include the pevent handle.

The goal is to always use pevent object when dealing with traceevent
library. The reason is that we might need additional processing (like
plugins), which is not possible otherwise.

Patches follow to make this happen completely.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386076182-14484-6-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 56 ++++++++++++++++++++++++--------------
 tools/lib/traceevent/event-parse.h |  4 ++-
 tools/perf/util/evsel.c            |  2 +-
 3 files changed, 39 insertions(+), 23 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 900fca01bdd3..9849873265d4 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5121,8 +5121,38 @@ enum pevent_errno __pevent_parse_format(struct event_format **eventp,
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
@@ -5134,10 +5164,12 @@ enum pevent_errno __pevent_parse_format(struct event_format **eventp,
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
@@ -5158,25 +5190,7 @@ enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
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
index 54273c0ec544..620c27a72960 100644
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
index b5fe7f9b2e15..6a046ed73f98 100644
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
1.8.1.4

