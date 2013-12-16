Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab3LPP36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:29:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47782 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab3LPP3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:29:55 -0500
Date: Mon, 16 Dec 2013 07:29:34 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-41e12e580a7b0c151199f927193548b84d3e874c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1386833777-3790-13-git-send-email-namhyung@kernel.org>
References: <1386833777-3790-13-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Refactor pevent_filter_match() to get rid of die()
Git-Commit-ID: 41e12e580a7b0c151199f927193548b84d3e874c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 07:29:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41e12e580a7b0c151199f927193548b84d3e874c
Gitweb:     http://git.kernel.org/tip/41e12e580a7b0c151199f927193548b84d3e874c
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 12 Dec 2013 16:36:15 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 13 Dec 2013 10:30:22 -0300

tools lib traceevent: Refactor pevent_filter_match() to get rid of die()

The test_filter() function is for testing given filter is matched to a
given record.  However it doesn't handle error cases properly so add a
new argument err to save error info during the test and also pass it to
internal test functions.

The return value of pevent_filter_match() also converted to pevent_errno
to indicate an exact error case.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386833777-3790-13-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.h  |  21 ++++--
 tools/lib/traceevent/parse-filter.c | 135 +++++++++++++++++++++++-------------
 2 files changed, 99 insertions(+), 57 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 089964e..3ad784f 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -357,6 +357,8 @@ enum pevent_flag {
 	_PE(READ_PRINT_FAILED,	"failed to read event print fmt"), 	      \
 	_PE(OLD_FTRACE_ARG_FAILED,"failed to allocate field name for ftrace"),\
 	_PE(INVALID_ARG_TYPE,	"invalid argument type"),		      \
+	_PE(INVALID_EXP_TYPE,	"invalid expression type"),		      \
+	_PE(INVALID_OP_TYPE,	"invalid operator type"),		      \
 	_PE(INVALID_EVENT_NAME,	"invalid event name"),			      \
 	_PE(EVENT_NOT_FOUND,	"no event found"),			      \
 	_PE(SYNTAX_ERROR,	"syntax error"),			      \
@@ -373,12 +375,16 @@ enum pevent_flag {
 	_PE(INVALID_PAREN,	"open parenthesis cannot come here"), 	      \
 	_PE(UNBALANCED_PAREN,	"unbalanced number of parenthesis"),	      \
 	_PE(UNKNOWN_TOKEN,	"unknown token"),			      \
-	_PE(FILTER_NOT_FOUND,	"no filter found")
+	_PE(FILTER_NOT_FOUND,	"no filter found"),			      \
+	_PE(NOT_A_NUMBER,	"must have number field"),		      \
+	_PE(NO_FILTER,		"no filters exists"),			      \
+	_PE(FILTER_MISS,	"record does not match to filter")
 
 #undef _PE
 #define _PE(__code, __str) PEVENT_ERRNO__ ## __code
 enum pevent_errno {
 	PEVENT_ERRNO__SUCCESS			= 0,
+	PEVENT_ERRNO__FILTER_MATCH		= PEVENT_ERRNO__SUCCESS,
 
 	/*
 	 * Choose an arbitrary negative big number not to clash with standard
@@ -853,10 +859,11 @@ struct event_filter {
 
 struct event_filter *pevent_filter_alloc(struct pevent *pevent);
 
-#define FILTER_NONE		-2
-#define FILTER_NOEXIST		-1
-#define FILTER_MISS		0
-#define FILTER_MATCH		1
+/* for backward compatibility */
+#define FILTER_NONE		PEVENT_ERRNO__FILTER_NOT_FOUND
+#define FILTER_NOEXIST		PEVENT_ERRNO__NO_FILTER
+#define FILTER_MISS		PEVENT_ERRNO__FILTER_MISS
+#define FILTER_MATCH		PEVENT_ERRNO__FILTER_MATCH
 
 enum filter_trivial_type {
 	FILTER_TRIVIAL_FALSE,
@@ -868,8 +875,8 @@ enum pevent_errno pevent_filter_add_filter_str(struct event_filter *filter,
 					       const char *filter_str);
 
 
-int pevent_filter_match(struct event_filter *filter,
-			struct pevent_record *record);
+enum pevent_errno pevent_filter_match(struct event_filter *filter,
+				      struct pevent_record *record);
 
 int pevent_event_filtered(struct event_filter *filter,
 			  int event_id);
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 78440d7..9303c55 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1678,8 +1678,8 @@ int pevent_filter_event_has_trivial(struct event_filter *filter,
 	}
 }
 
-static int test_filter(struct event_format *event,
-		       struct filter_arg *arg, struct pevent_record *record);
+static int test_filter(struct event_format *event, struct filter_arg *arg,
+		       struct pevent_record *record, enum pevent_errno *err);
 
 static const char *
 get_comm(struct event_format *event, struct pevent_record *record)
@@ -1725,15 +1725,24 @@ get_value(struct event_format *event,
 }
 
 static unsigned long long
-get_arg_value(struct event_format *event, struct filter_arg *arg, struct pevent_record *record);
+get_arg_value(struct event_format *event, struct filter_arg *arg,
+	      struct pevent_record *record, enum pevent_errno *err);
 
 static unsigned long long
-get_exp_value(struct event_format *event, struct filter_arg *arg, struct pevent_record *record)
+get_exp_value(struct event_format *event, struct filter_arg *arg,
+	      struct pevent_record *record, enum pevent_errno *err)
 {
 	unsigned long long lval, rval;
 
-	lval = get_arg_value(event, arg->exp.left, record);
-	rval = get_arg_value(event, arg->exp.right, record);
+	lval = get_arg_value(event, arg->exp.left, record, err);
+	rval = get_arg_value(event, arg->exp.right, record, err);
+
+	if (*err) {
+		/*
+		 * There was an error, no need to process anymore.
+		 */
+		return 0;
+	}
 
 	switch (arg->exp.type) {
 	case FILTER_EXP_ADD:
@@ -1768,39 +1777,51 @@ get_exp_value(struct event_format *event, struct filter_arg *arg, struct pevent_
 
 	case FILTER_EXP_NOT:
 	default:
-		die("error in exp");
+		if (!*err)
+			*err = PEVENT_ERRNO__INVALID_EXP_TYPE;
 	}
 	return 0;
 }
 
 static unsigned long long
-get_arg_value(struct event_format *event, struct filter_arg *arg, struct pevent_record *record)
+get_arg_value(struct event_format *event, struct filter_arg *arg,
+	      struct pevent_record *record, enum pevent_errno *err)
 {
 	switch (arg->type) {
 	case FILTER_ARG_FIELD:
 		return get_value(event, arg->field.field, record);
 
 	case FILTER_ARG_VALUE:
-		if (arg->value.type != FILTER_NUMBER)
-			die("must have number field!");
+		if (arg->value.type != FILTER_NUMBER) {
+			if (!*err)
+				*err = PEVENT_ERRNO__NOT_A_NUMBER;
+		}
 		return arg->value.val;
 
 	case FILTER_ARG_EXP:
-		return get_exp_value(event, arg, record);
+		return get_exp_value(event, arg, record, err);
 
 	default:
-		die("oops in filter");
+		if (!*err)
+			*err = PEVENT_ERRNO__INVALID_ARG_TYPE;
 	}
 	return 0;
 }
 
-static int test_num(struct event_format *event,
-		    struct filter_arg *arg, struct pevent_record *record)
+static int test_num(struct event_format *event, struct filter_arg *arg,
+		    struct pevent_record *record, enum pevent_errno *err)
 {
 	unsigned long long lval, rval;
 
-	lval = get_arg_value(event, arg->num.left, record);
-	rval = get_arg_value(event, arg->num.right, record);
+	lval = get_arg_value(event, arg->num.left, record, err);
+	rval = get_arg_value(event, arg->num.right, record, err);
+
+	if (*err) {
+		/*
+		 * There was an error, no need to process anymore.
+		 */
+		return 0;
+	}
 
 	switch (arg->num.type) {
 	case FILTER_CMP_EQ:
@@ -1822,7 +1843,8 @@ static int test_num(struct event_format *event,
 		return lval <= rval;
 
 	default:
-		/* ?? */
+		if (!*err)
+			*err = PEVENT_ERRNO__ILLEGAL_INTEGER_CMP;
 		return 0;
 	}
 }
@@ -1869,8 +1891,8 @@ static const char *get_field_str(struct filter_arg *arg, struct pevent_record *r
 	return val;
 }
 
-static int test_str(struct event_format *event,
-		    struct filter_arg *arg, struct pevent_record *record)
+static int test_str(struct event_format *event, struct filter_arg *arg,
+		    struct pevent_record *record, enum pevent_errno *err)
 {
 	const char *val;
 
@@ -1894,48 +1916,57 @@ static int test_str(struct event_format *event,
 		return regexec(&arg->str.reg, val, 0, NULL, 0);
 
 	default:
-		/* ?? */
+		if (!*err)
+			*err = PEVENT_ERRNO__ILLEGAL_STRING_CMP;
 		return 0;
 	}
 }
 
-static int test_op(struct event_format *event,
-		   struct filter_arg *arg, struct pevent_record *record)
+static int test_op(struct event_format *event, struct filter_arg *arg,
+		   struct pevent_record *record, enum pevent_errno *err)
 {
 	switch (arg->op.type) {
 	case FILTER_OP_AND:
-		return test_filter(event, arg->op.left, record) &&
-			test_filter(event, arg->op.right, record);
+		return test_filter(event, arg->op.left, record, err) &&
+			test_filter(event, arg->op.right, record, err);
 
 	case FILTER_OP_OR:
-		return test_filter(event, arg->op.left, record) ||
-			test_filter(event, arg->op.right, record);
+		return test_filter(event, arg->op.left, record, err) ||
+			test_filter(event, arg->op.right, record, err);
 
 	case FILTER_OP_NOT:
-		return !test_filter(event, arg->op.right, record);
+		return !test_filter(event, arg->op.right, record, err);
 
 	default:
-		/* ?? */
+		if (!*err)
+			*err = PEVENT_ERRNO__INVALID_OP_TYPE;
 		return 0;
 	}
 }
 
-static int test_filter(struct event_format *event,
-		       struct filter_arg *arg, struct pevent_record *record)
+static int test_filter(struct event_format *event, struct filter_arg *arg,
+		       struct pevent_record *record, enum pevent_errno *err)
 {
+	if (*err) {
+		/*
+		 * There was an error, no need to process anymore.
+		 */
+		return 0;
+	}
+
 	switch (arg->type) {
 	case FILTER_ARG_BOOLEAN:
 		/* easy case */
 		return arg->boolean.value;
 
 	case FILTER_ARG_OP:
-		return test_op(event, arg, record);
+		return test_op(event, arg, record, err);
 
 	case FILTER_ARG_NUM:
-		return test_num(event, arg, record);
+		return test_num(event, arg, record, err);
 
 	case FILTER_ARG_STR:
-		return test_str(event, arg, record);
+		return test_str(event, arg, record, err);
 
 	case FILTER_ARG_EXP:
 	case FILTER_ARG_VALUE:
@@ -1944,11 +1975,11 @@ static int test_filter(struct event_format *event,
 		 * Expressions, fields and values evaluate
 		 * to true if they return non zero
 		 */
-		return !!get_arg_value(event, arg, record);
+		return !!get_arg_value(event, arg, record, err);
 
 	default:
-		die("oops!");
-		/* ?? */
+		if (!*err)
+			*err = PEVENT_ERRNO__INVALID_ARG_TYPE;
 		return 0;
 	}
 }
@@ -1961,8 +1992,7 @@ static int test_filter(struct event_format *event,
  * Returns 1 if filter found for @event_id
  *   otherwise 0;
  */
-int pevent_event_filtered(struct event_filter *filter,
-			  int event_id)
+int pevent_event_filtered(struct event_filter *filter, int event_id)
 {
 	struct filter_type *filter_type;
 
@@ -1979,31 +2009,36 @@ int pevent_event_filtered(struct event_filter *filter,
  * @filter: filter struct with filter information
  * @record: the record to test against the filter
  *
- * Returns:
- *  1 - filter found for event and @record matches
- *  0 - filter found for event and @record does not match
- * -1 - no filter found for @record's event
- * -2 - if no filters exist
+ * Returns: match result or error code (prefixed with PEVENT_ERRNO__)
+ * FILTER_MATCH - filter found for event and @record matches
+ * FILTER_MISS  - filter found for event and @record does not match
+ * FILTER_NOT_FOUND - no filter found for @record's event
+ * NO_FILTER - if no filters exist
+ * otherwise - error occurred during test
  */
-int pevent_filter_match(struct event_filter *filter,
-			struct pevent_record *record)
+enum pevent_errno pevent_filter_match(struct event_filter *filter,
+				      struct pevent_record *record)
 {
 	struct pevent *pevent = filter->pevent;
 	struct filter_type *filter_type;
 	int event_id;
+	int ret;
+	enum pevent_errno err = 0;
 
 	if (!filter->filters)
-		return FILTER_NONE;
+		return PEVENT_ERRNO__NO_FILTER;
 
 	event_id = pevent_data_type(pevent, record);
 
 	filter_type = find_filter_type(filter, event_id);
-
 	if (!filter_type)
-		return FILTER_NOEXIST;
+		return PEVENT_ERRNO__FILTER_NOT_FOUND;
+
+	ret = test_filter(filter_type->event, filter_type->filter, record, &err);
+	if (err)
+		return err;
 
-	return test_filter(filter_type->event, filter_type->filter, record) ?
-		FILTER_MATCH : FILTER_MISS;
+	return ret ? PEVENT_ERRNO__FILTER_MATCH : PEVENT_ERRNO__FILTER_MISS;
 }
 
 static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
