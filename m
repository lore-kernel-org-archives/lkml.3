Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab3LLHgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:36:47 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50936 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab3LLHgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:36:25 -0500
X-AuditID: 9c93016f-b7c57ae0000070d3-04-52a967768566
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 09/14] tools lib traceevent: Refactor create_arg_item()
Date: Thu, 12 Dec 2013 16:36:12 +0900
Message-Id: <1386833777-3790-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
References: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

So that it can return a proper pevent_errno value.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
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
1.7.11.7

