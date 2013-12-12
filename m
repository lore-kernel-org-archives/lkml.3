Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab3LLHgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:36:53 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50936 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3LLHg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:36:27 -0500
X-AuditID: 9c93016f-b7c57ae0000070d3-0d-52a967776d1f
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 11/14] tools lib traceevent: Make pevent_filter_add_filter_str() return pevent_errno
Date: Thu, 12 Dec 2013 16:36:14 +0900
Message-Id: <1386833777-3790-12-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
References: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Refactor the pevent_filter_add_filter_str() to return a proper error
code and get rid of the third error_str argument.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.h  |  8 ++--
 tools/lib/traceevent/parse-filter.c | 78 +++++++++++--------------------------
 2 files changed, 27 insertions(+), 59 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index da942d59cc3a..089964e56ed4 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -372,7 +372,8 @@ enum pevent_flag {
 	_PE(ILLEGAL_TOKEN,	"illegal token"),			      \
 	_PE(INVALID_PAREN,	"open parenthesis cannot come here"), 	      \
 	_PE(UNBALANCED_PAREN,	"unbalanced number of parenthesis"),	      \
-	_PE(UNKNOWN_TOKEN,	"unknown token")
+	_PE(UNKNOWN_TOKEN,	"unknown token"),			      \
+	_PE(FILTER_NOT_FOUND,	"no filter found")
 
 #undef _PE
 #define _PE(__code, __str) PEVENT_ERRNO__ ## __code
@@ -863,9 +864,8 @@ enum filter_trivial_type {
 	FILTER_TRIVIAL_BOTH,
 };
 
-int pevent_filter_add_filter_str(struct event_filter *filter,
-				 const char *filter_str,
-				 char **error_str);
+enum pevent_errno pevent_filter_add_filter_str(struct event_filter *filter,
+					       const char *filter_str);
 
 
 int pevent_filter_match(struct event_filter *filter,
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 5aa5012a17ee..78440d73e0ad 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1209,7 +1209,7 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 	return ret;
 }
 
-static int
+static enum pevent_errno
 process_event(struct event_format *event, const char *filter_str,
 	      struct filter_arg **parg, char **error_str)
 {
@@ -1218,21 +1218,15 @@ process_event(struct event_format *event, const char *filter_str,
 	pevent_buffer_init(filter_str, strlen(filter_str));
 
 	ret = process_filter(event, parg, error_str, 0);
-	if (ret == 1) {
-		show_error(error_str,
-			   "Unbalanced number of ')'");
-		return -1;
-	}
 	if (ret < 0)
 		return ret;
 
 	/* If parg is NULL, then make it into FALSE */
 	if (!*parg) {
 		*parg = allocate_arg();
-		if (*parg == NULL) {
-			show_error(error_str, "failed to allocate filter arg");
-			return -1;
-		}
+		if (*parg == NULL)
+			return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+
 		(*parg)->type = FILTER_ARG_BOOLEAN;
 		(*parg)->boolean.value = FILTER_FALSE;
 	}
@@ -1240,13 +1234,13 @@ process_event(struct event_format *event, const char *filter_str,
 	return 0;
 }
 
-static int filter_event(struct event_filter *filter,
-			struct event_format *event,
-			const char *filter_str, char **error_str)
+static enum pevent_errno
+filter_event(struct event_filter *filter, struct event_format *event,
+	     const char *filter_str, char **error_str)
 {
 	struct filter_type *filter_type;
 	struct filter_arg *arg;
-	int ret;
+	enum pevent_errno ret;
 
 	if (filter_str) {
 		ret = process_event(event, filter_str, &arg, error_str);
@@ -1256,20 +1250,16 @@ static int filter_event(struct event_filter *filter,
 	} else {
 		/* just add a TRUE arg */
 		arg = allocate_arg();
-		if (arg == NULL) {
-			show_error(error_str, "failed to allocate filter arg");
-			return -1;
-		}
+		if (arg == NULL)
+			return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+
 		arg->type = FILTER_ARG_BOOLEAN;
 		arg->boolean.value = FILTER_TRUE;
 	}
 
 	filter_type = add_filter_type(filter, event->id);
-	if (filter_type == NULL) {
-		show_error(error_str, "failed to add a new filter: %s",
-			   filter_str ? filter_str : "true");
-		return -1;
-	}
+	if (filter_type == NULL)
+		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
 
 	if (filter_type->filter)
 		free_arg(filter_type->filter);
@@ -1282,18 +1272,12 @@ static int filter_event(struct event_filter *filter,
  * pevent_filter_add_filter_str - add a new filter
  * @filter: the event filter to add to
  * @filter_str: the filter string that contains the filter
- * @error_str: string containing reason for failed filter
- *
- * Returns 0 if the filter was successfully added
- *   -1 if there was an error.
  *
- * On error, if @error_str points to a string pointer,
- * it is set to the reason that the filter failed.
- * This string must be freed with "free".
+ * Returns 0 if the filter was successfully added or a
+ * negative error code.
  */
-int pevent_filter_add_filter_str(struct event_filter *filter,
-				 const char *filter_str,
-				 char **error_str)
+enum pevent_errno pevent_filter_add_filter_str(struct event_filter *filter,
+					       const char *filter_str)
 {
 	struct pevent *pevent = filter->pevent;
 	struct event_list *event;
@@ -1304,23 +1288,20 @@ int pevent_filter_add_filter_str(struct event_filter *filter,
 	char *event_name = NULL;
 	char *sys_name = NULL;
 	char *sp;
-	int rtn = 0;
+	enum pevent_errno rtn = 0; /* PEVENT_ERRNO__SUCCESS */
 	int len;
 	int ret;
+	char *error_str = NULL;
 
 	/* clear buffer to reset show error */
 	pevent_buffer_init("", 0);
 
-	if (error_str)
-		*error_str = NULL;
-
 	filter_start = strchr(filter_str, ':');
 	if (filter_start)
 		len = filter_start - filter_str;
 	else
 		len = strlen(filter_str);
 
-
 	do {
 		next_event = strchr(filter_str, ',');
 		if (next_event &&
@@ -1333,10 +1314,9 @@ int pevent_filter_add_filter_str(struct event_filter *filter,
 
 		this_event = malloc(len + 1);
 		if (this_event == NULL) {
-			show_error(error_str, "Memory allocation failure");
 			/* This can only happen when events is NULL, but still */
 			free_events(events);
-			return -1;
+			return PEVENT_ERRNO__MEM_ALLOC_FAILED;
 		}
 		memcpy(this_event, filter_str, len);
 		this_event[len] = 0;
@@ -1350,30 +1330,18 @@ int pevent_filter_add_filter_str(struct event_filter *filter,
 		event_name = strtok_r(NULL, "/", &sp);
 
 		if (!sys_name) {
-			show_error(error_str, "No filter found");
 			/* This can only happen when events is NULL, but still */
 			free_events(events);
 			free(this_event);
-			return -1;
+			return PEVENT_ERRNO__FILTER_NOT_FOUND;
 		}
 
 		/* Find this event */
 		ret = find_event(pevent, &events, strim(sys_name), strim(event_name));
 		if (ret < 0) {
-			if (ret == PEVENT_ERRNO__MEM_ALLOC_FAILED)
-				show_error(error_str,
-					   "Memory allocation failure");
-			else if (event_name)
-				show_error(error_str,
-					   "No event found under '%s.%s'",
-					   sys_name, event_name);
-			else
-				show_error(error_str,
-					   "No event found under '%s'",
-					   sys_name);
 			free_events(events);
 			free(this_event);
-			return -1;
+			return ret;
 		}
 		free(this_event);
 	} while (filter_str);
@@ -1385,7 +1353,7 @@ int pevent_filter_add_filter_str(struct event_filter *filter,
 	/* filter starts here */
 	for (event = events; event; event = event->next) {
 		ret = filter_event(filter, event->event, filter_start,
-				   error_str);
+				   &error_str);
 		/* Failures are returned if a parse error happened */
 		if (ret < 0)
 			rtn = ret;
-- 
1.7.11.7

