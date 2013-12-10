Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab3LJJSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:18:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44236 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab3LJJSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:18:40 -0500
Date: Tue, 10 Dec 2013 01:18:05 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-71ad9583ff15d2e95cb8c67a5c963321d9d1877b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1386076182-14484-6-git-send-email-jolsa@redhat.com>
References: <1386076182-14484-6-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Change pevent_parse_format to include pevent handle
Git-Commit-ID: 71ad9583ff15d2e95cb8c67a5c963321d9d1877b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:18:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  71ad9583ff15d2e95cb8c67a5c963321d9d1877b
Gitweb:     http://git.kernel.org/tip/71ad9583ff15d2e95cb8c67a5c963321d9d1877b
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 3 Dec 2013 14:09:19 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Dec 2013 15:18:42 -0300

tools lib traceevent: Change pevent_parse_format to include pevent handle

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
index 900fca0..9849873 100644
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
