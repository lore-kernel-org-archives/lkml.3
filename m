Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab3LMPMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:12:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45247 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab3LMPMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:12:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/20] tools lib traceevent: Get rid of malloc_or_die() in find_event()
Date: Fri, 13 Dec 2013 12:11:59 -0300
Message-Id: <1386947526-7118-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386947526-7118-1-git-send-email-acme@infradead.org>
References: <1386947526-7118-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Make it return pevent_errno to distinguish malloc allocation failure.
Since it'll be returned to user later, add more error code.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386833777-3790-6-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.h  |  4 +++-
 tools/lib/traceevent/parse-filter.c | 27 +++++++++++++++++++--------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 6e23f197175f..abdfd3c606ed 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -356,7 +356,9 @@ enum pevent_flag {
 	_PE(READ_FORMAT_FAILED,	"failed to read event format"),		      \
 	_PE(READ_PRINT_FAILED,	"failed to read event print fmt"), 	      \
 	_PE(OLD_FTRACE_ARG_FAILED,"failed to allocate field name for ftrace"),\
-	_PE(INVALID_ARG_TYPE,	"invalid argument type")
+	_PE(INVALID_ARG_TYPE,	"invalid argument type"),		      \
+	_PE(INVALID_EVENT_NAME,	"invalid event name"),			      \
+	_PE(EVENT_NOT_FOUND,	"No event found")
 
 #undef _PE
 #define _PE(__code, __str) PEVENT_ERRNO__ ## __code
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 246ee81e1f93..a0ab040e8f71 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -287,7 +287,7 @@ static int event_match(struct event_format *event,
 		!regexec(ereg, event->name, 0, NULL, 0);
 }
 
-static int
+static enum pevent_errno
 find_event(struct pevent *pevent, struct event_list **events,
 	   char *sys_name, char *event_name)
 {
@@ -306,23 +306,31 @@ find_event(struct pevent *pevent, struct event_list **events,
 		sys_name = NULL;
 	}
 
-	reg = malloc_or_die(strlen(event_name) + 3);
+	reg = malloc(strlen(event_name) + 3);
+	if (reg == NULL)
+		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+
 	sprintf(reg, "^%s$", event_name);
 
 	ret = regcomp(&ereg, reg, REG_ICASE|REG_NOSUB);
 	free(reg);
 
 	if (ret)
-		return -1;
+		return PEVENT_ERRNO__INVALID_EVENT_NAME;
 
 	if (sys_name) {
-		reg = malloc_or_die(strlen(sys_name) + 3);
+		reg = malloc(strlen(sys_name) + 3);
+		if (reg == NULL) {
+			regfree(&ereg);
+			return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+		}
+
 		sprintf(reg, "^%s$", sys_name);
 		ret = regcomp(&sreg, reg, REG_ICASE|REG_NOSUB);
 		free(reg);
 		if (ret) {
 			regfree(&ereg);
-			return -1;
+			return PEVENT_ERRNO__INVALID_EVENT_NAME;
 		}
 	}
 
@@ -342,9 +350,9 @@ find_event(struct pevent *pevent, struct event_list **events,
 		regfree(&sreg);
 
 	if (!match)
-		return -1;
+		return PEVENT_ERRNO__EVENT_NOT_FOUND;
 	if (fail)
-		return -2;
+		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
 
 	return 0;
 }
@@ -1312,7 +1320,10 @@ int pevent_filter_add_filter_str(struct event_filter *filter,
 		/* Find this event */
 		ret = find_event(pevent, &events, strim(sys_name), strim(event_name));
 		if (ret < 0) {
-			if (event_name)
+			if (ret == PEVENT_ERRNO__MEM_ALLOC_FAILED)
+				show_error(error_str,
+					   "Memory allocation failure");
+			else if (event_name)
 				show_error(error_str,
 					   "No event found under '%s.%s'",
 					   sys_name, event_name);
-- 
1.8.1.4

