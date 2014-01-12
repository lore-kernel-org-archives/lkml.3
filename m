Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaALScZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:32:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45327 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaALSb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:31:57 -0500
Date: Sun, 12 Jan 2014 10:31:27 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-bf19b82e7cf033319525a9eab12216b59c41c519@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1386833777-3790-15-git-send-email-namhyung@kernel.org>
References: <1386833777-3790-15-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Introduce pevent_filter_strerror()
Git-Commit-ID: bf19b82e7cf033319525a9eab12216b59c41c519
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:31:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf19b82e7cf033319525a9eab12216b59c41c519
Gitweb:     http://git.kernel.org/tip/bf19b82e7cf033319525a9eab12216b59c41c519
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 12 Dec 2013 16:36:17 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 18 Dec 2013 14:47:58 -0300

tools lib traceevent: Introduce pevent_filter_strerror()

The pevent_filter_strerror() function is for receiving actual error
message from pevent_errno value.  To do that, add a static buffer to
event_filter for saving internal error message

If a failed function saved other information in the static buffer
returns the information, otherwise returns generic error message.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386833777-3790-15-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c  | 17 +------
 tools/lib/traceevent/event-parse.h  |  7 ++-
 tools/lib/traceevent/parse-filter.c | 98 ++++++++++++++++++++-----------------
 3 files changed, 61 insertions(+), 61 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 22566c2..2ce565a 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5230,22 +5230,7 @@ int pevent_strerror(struct pevent *pevent __maybe_unused,
 
 	idx = errnum - __PEVENT_ERRNO__START - 1;
 	msg = pevent_error_str[idx];
-
-	switch (errnum) {
-	case PEVENT_ERRNO__MEM_ALLOC_FAILED:
-	case PEVENT_ERRNO__PARSE_EVENT_FAILED:
-	case PEVENT_ERRNO__READ_ID_FAILED:
-	case PEVENT_ERRNO__READ_FORMAT_FAILED:
-	case PEVENT_ERRNO__READ_PRINT_FAILED:
-	case PEVENT_ERRNO__OLD_FTRACE_ARG_FAILED:
-	case PEVENT_ERRNO__INVALID_ARG_TYPE:
-		snprintf(buf, buflen, "%s", msg);
-		break;
-
-	default:
-		/* cannot reach here */
-		break;
-	}
+	snprintf(buf, buflen, "%s", msg);
 
 	return 0;
 }
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 3ad784f..cf5db90 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -851,10 +851,13 @@ struct filter_type {
 	struct filter_arg	*filter;
 };
 
+#define PEVENT_FILTER_ERROR_BUFSZ  1024
+
 struct event_filter {
 	struct pevent		*pevent;
 	int			filters;
 	struct filter_type	*event_filters;
+	char			error_buffer[PEVENT_FILTER_ERROR_BUFSZ];
 };
 
 struct event_filter *pevent_filter_alloc(struct pevent *pevent);
@@ -874,10 +877,12 @@ enum filter_trivial_type {
 enum pevent_errno pevent_filter_add_filter_str(struct event_filter *filter,
 					       const char *filter_str);
 
-
 enum pevent_errno pevent_filter_match(struct event_filter *filter,
 				      struct pevent_record *record);
 
+int pevent_filter_strerror(struct event_filter *filter, enum pevent_errno err,
+			   char *buf, size_t buflen);
+
 int pevent_event_filtered(struct event_filter *filter,
 			  int event_id);
 
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index e2842b9..b502344 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -38,55 +38,31 @@ struct event_list {
 	struct event_format	*event;
 };
 
-#define MAX_ERR_STR_SIZE 256
-
-static void show_error(char **error_str, const char *fmt, ...)
+static void show_error(char *error_buf, const char *fmt, ...)
 {
 	unsigned long long index;
 	const char *input;
-	char *error;
 	va_list ap;
 	int len;
 	int i;
 
-	if (!error_str)
-		return;
-
 	input = pevent_get_input_buf();
 	index = pevent_get_input_buf_ptr();
 	len = input ? strlen(input) : 0;
 
-	error = malloc(MAX_ERR_STR_SIZE + (len*2) + 3);
-	if (error == NULL) {
-		/*
-		 * Maybe it's due to len is too long.
-		 * Retry without the input buffer part.
-		 */
-		len = 0;
-
-		error = malloc(MAX_ERR_STR_SIZE);
-		if (error == NULL) {
-			/* no memory */
-			*error_str = NULL;
-			return;
-		}
-	}
-
 	if (len) {
-		strcpy(error, input);
-		error[len] = '\n';
+		strcpy(error_buf, input);
+		error_buf[len] = '\n';
 		for (i = 1; i < len && i < index; i++)
-			error[len+i] = ' ';
-		error[len + i] = '^';
-		error[len + i + 1] = '\n';
+			error_buf[len+i] = ' ';
+		error_buf[len + i] = '^';
+		error_buf[len + i + 1] = '\n';
 		len += i+2;
 	}
 
 	va_start(ap, fmt);
-	vsnprintf(error + len, MAX_ERR_STR_SIZE, fmt, ap);
+	vsnprintf(error_buf + len, PEVENT_FILTER_ERROR_BUFSZ - len, fmt, ap);
 	va_end(ap);
-
-	*error_str = error;
 }
 
 static void free_token(char *token)
@@ -370,7 +346,7 @@ static void free_events(struct event_list *events)
 
 static enum pevent_errno
 create_arg_item(struct event_format *event, const char *token,
-		enum event_type type, struct filter_arg **parg, char **error_str)
+		enum event_type type, struct filter_arg **parg, char *error_str)
 {
 	struct format_field *field;
 	struct filter_arg *arg;
@@ -474,7 +450,7 @@ create_arg_cmp(enum filter_exp_type etype)
 }
 
 static enum pevent_errno
-add_right(struct filter_arg *op, struct filter_arg *arg, char **error_str)
+add_right(struct filter_arg *op, struct filter_arg *arg, char *error_str)
 {
 	struct filter_arg *left;
 	char *str;
@@ -786,7 +762,7 @@ enum filter_vals {
 
 static enum pevent_errno
 reparent_op_arg(struct filter_arg *parent, struct filter_arg *old_child,
-		struct filter_arg *arg, char **error_str)
+		struct filter_arg *arg, char *error_str)
 {
 	struct filter_arg *other_child;
 	struct filter_arg **ptr;
@@ -838,7 +814,7 @@ reparent_op_arg(struct filter_arg *parent, struct filter_arg *old_child,
 
 /* Returns either filter_vals (success) or pevent_errno (failfure) */
 static int test_arg(struct filter_arg *parent, struct filter_arg *arg,
-		    char **error_str)
+		    char *error_str)
 {
 	int lval, rval;
 
@@ -938,7 +914,7 @@ static int test_arg(struct filter_arg *parent, struct filter_arg *arg,
 
 /* Remove any unknown event fields */
 static int collapse_tree(struct filter_arg *arg,
-			 struct filter_arg **arg_collapsed, char **error_str)
+			 struct filter_arg **arg_collapsed, char *error_str)
 {
 	int ret;
 
@@ -973,7 +949,7 @@ static int collapse_tree(struct filter_arg *arg,
 
 static enum pevent_errno
 process_filter(struct event_format *event, struct filter_arg **parg,
-	       char **error_str, int not)
+	       char *error_str, int not)
 {
 	enum event_type type;
 	char *token = NULL;
@@ -1211,7 +1187,7 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 
 static enum pevent_errno
 process_event(struct event_format *event, const char *filter_str,
-	      struct filter_arg **parg, char **error_str)
+	      struct filter_arg **parg, char *error_str)
 {
 	int ret;
 
@@ -1236,7 +1212,7 @@ process_event(struct event_format *event, const char *filter_str,
 
 static enum pevent_errno
 filter_event(struct event_filter *filter, struct event_format *event,
-	     const char *filter_str, char **error_str)
+	     const char *filter_str, char *error_str)
 {
 	struct filter_type *filter_type;
 	struct filter_arg *arg;
@@ -1268,13 +1244,21 @@ filter_event(struct event_filter *filter, struct event_format *event,
 	return 0;
 }
 
+static void filter_init_error_buf(struct event_filter *filter)
+{
+	/* clear buffer to reset show error */
+	pevent_buffer_init("", 0);
+	filter->error_buffer[0] = '\0';
+}
+
 /**
  * pevent_filter_add_filter_str - add a new filter
  * @filter: the event filter to add to
  * @filter_str: the filter string that contains the filter
  *
  * Returns 0 if the filter was successfully added or a
- * negative error code.
+ * negative error code.  Use pevent_filter_strerror() to see
+ * actual error message in case of error.
  */
 enum pevent_errno pevent_filter_add_filter_str(struct event_filter *filter,
 					       const char *filter_str)
@@ -1291,10 +1275,8 @@ enum pevent_errno pevent_filter_add_filter_str(struct event_filter *filter,
 	enum pevent_errno rtn = 0; /* PEVENT_ERRNO__SUCCESS */
 	int len;
 	int ret;
-	char *error_str = NULL;
 
-	/* clear buffer to reset show error */
-	pevent_buffer_init("", 0);
+	filter_init_error_buf(filter);
 
 	filter_start = strchr(filter_str, ':');
 	if (filter_start)
@@ -1353,7 +1335,7 @@ enum pevent_errno pevent_filter_add_filter_str(struct event_filter *filter,
 	/* filter starts here */
 	for (event = events; event; event = event->next) {
 		ret = filter_event(filter, event->event, filter_start,
-				   &error_str);
+				   filter->error_buffer);
 		/* Failures are returned if a parse error happened */
 		if (ret < 0)
 			rtn = ret;
@@ -1382,6 +1364,32 @@ static void free_filter_type(struct filter_type *filter_type)
 }
 
 /**
+ * pevent_filter_strerror - fill error message in a buffer
+ * @filter: the event filter contains error
+ * @err: the error code
+ * @buf: the buffer to be filled in
+ * @buflen: the size of the buffer
+ *
+ * Returns 0 if message was filled successfully, -1 if error
+ */
+int pevent_filter_strerror(struct event_filter *filter, enum pevent_errno err,
+			   char *buf, size_t buflen)
+{
+	if (err <= __PEVENT_ERRNO__START || err >= __PEVENT_ERRNO__END)
+		return -1;
+
+	if (strlen(filter->error_buffer) > 0) {
+		size_t len = snprintf(buf, buflen, "%s", filter->error_buffer);
+
+		if (len > buflen)
+			return -1;
+		return 0;
+	}
+
+	return pevent_strerror(filter->pevent, err, buf, buflen);
+}
+
+/**
  * pevent_filter_remove_event - remove a filter for an event
  * @filter: the event filter to remove from
  * @event_id: the event to remove a filter for
@@ -2027,6 +2035,8 @@ enum pevent_errno pevent_filter_match(struct event_filter *filter,
 	int ret;
 	enum pevent_errno err = 0;
 
+	filter_init_error_buf(filter);
+
 	if (!filter->filters)
 		return PEVENT_ERRNO__NO_FILTER;
 
