Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab3LMPOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:14:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45277 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab3LMPMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:12:21 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/20] tools lib traceevent: Refactor create_arg_item()
Date: Fri, 13 Dec 2013 12:12:03 -0300
Message-Id: <1386947526-7118-18-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386947526-7118-1-git-send-email-acme@infradead.org>
References: <1386947526-7118-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

So that it can return a proper pevent_errno value.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386833777-3790-10-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.h  |  3 ++-
 tools/lib/traceevent/parse-filter.c | 20 ++++++++++----------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 5e4392d8e2d4..57b66aed8122 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -367,7 +367,8 @@ enum pevent_flag {
 	_PE(ILLEGAL_INTEGER_CMP,"illegal comparison for integer"), 	      \
 	_PE(REPARENT_NOT_OP,	"cannot reparent other than OP"),	      \
 	_PE(REPARENT_FAILED,	"failed to reparent filter OP"),	      \
-	_PE(BAD_FILTER_ARG,	"bad arg in filter tree")
+	_PE(BAD_FILTER_ARG,	"bad arg in filter tree"),		      \
+	_PE(UNEXPECTED_TYPE,	"unexpected type (not a value)")
 
 #undef _PE
 #define _PE(__code, __str) PEVENT_ERRNO__ ## __code
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 9b05892566e0..8d71208f0131 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -368,9 +368,9 @@ static void free_events(struct event_list *events)
 	}
 }
 
-static struct filter_arg *
+static enum pevent_errno
 create_arg_item(struct event_format *event, const char *token,
-		enum event_type type, char **error_str)
+		enum event_type type, struct filter_arg **parg, char **error_str)
 {
 	struct format_field *field;
 	struct filter_arg *arg;
@@ -378,7 +378,7 @@ create_arg_item(struct event_format *event, const char *token,
 	arg = allocate_arg();
 	if (arg == NULL) {
 		show_error(error_str, "failed to allocate filter arg");
-		return NULL;
+		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
 	}
 
 	switch (type) {
@@ -392,7 +392,7 @@ create_arg_item(struct event_format *event, const char *token,
 		if (!arg->value.str) {
 			free_arg(arg);
 			show_error(error_str, "failed to allocate string filter arg");
-			return NULL;
+			return PEVENT_ERRNO__MEM_ALLOC_FAILED;
 		}
 		break;
 	case EVENT_ITEM:
@@ -420,11 +420,11 @@ create_arg_item(struct event_format *event, const char *token,
 		break;
 	default:
 		free_arg(arg);
-		show_error(error_str, "expected a value but found %s",
-			   token);
-		return NULL;
+		show_error(error_str, "expected a value but found %s", token);
+		return PEVENT_ERRNO__UNEXPECTED_TYPE;
 	}
-	return arg;
+	*parg = arg;
+	return 0;
 }
 
 static struct filter_arg *
@@ -993,8 +993,8 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 		case EVENT_SQUOTE:
 		case EVENT_DQUOTE:
 		case EVENT_ITEM:
-			arg = create_arg_item(event, token, type, error_str);
-			if (!arg)
+			ret = create_arg_item(event, token, type, &arg, error_str);
+			if (ret < 0)
 				goto fail;
 			if (!left_item)
 				left_item = arg;
-- 
1.8.1.4

