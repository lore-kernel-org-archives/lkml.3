Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab3LLHgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:36:40 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50936 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab3LLHgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:36:24 -0500
X-AuditID: 9c93016f-b7c57ae0000070d3-ed-52a967740a87
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 05/14] tools lib traceevent: Get rid of malloc_or_die() in find_event()
Date: Thu, 12 Dec 2013 16:36:08 +0900
Message-Id: <1386833777-3790-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
References: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it return pevent_errno to distinguish malloc allocation failure.
Since it'll be returned to user later, add more error code.

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
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
1.7.11.7

