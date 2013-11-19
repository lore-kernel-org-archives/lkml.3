Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab3KSUmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 15:42:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48618 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab3KSUmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:42:06 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/5] tools lib traceevent: Fix use of multiple options in processing field
Date: Tue, 19 Nov 2013 17:41:57 -0300
Message-Id: <1384893718-18762-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384893718-18762-1-git-send-email-acme@infradead.org>
References: <1384893718-18762-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Jiri Olsa reported that the scsi_dispatch_cmd_done event failed to parse
with:

  Error: expected type 5 but read 4
  Error: expected type 5 but read 4

The problem is with this part of the print_fmt:

  __print_symbolic(((REC->result) >> 24) & 0xff, ...

The __print_symbolic() helper function's first parameter is the field to
use to determine what symbol to print based on the value of the result.
The parser can handle one operation, but it can not handle multiple
operations ('>>' and '&').

Add code to process all operations for the field argument for
__print_symbolic() as well as __print_flags().

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20131118142314.27ca334b@gandalf.local.home
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 0362d575de7d..8a5b65df6efb 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1606,6 +1606,24 @@ process_arg(struct event_format *event, struct print_arg *arg, char **tok)
 static enum event_type
 process_op(struct event_format *event, struct print_arg *arg, char **tok);
 
+/*
+ * For __print_symbolic() and __print_flags, we need to completely
+ * evaluate the first argument, which defines what to print next.
+ */
+static enum event_type
+process_field_arg(struct event_format *event, struct print_arg *arg, char **tok)
+{
+	enum event_type type;
+
+	type = process_arg(event, arg, tok);
+
+	while (type == EVENT_OP) {
+		type = process_op(event, arg, tok);
+	}
+
+	return type;
+}
+
 static enum event_type
 process_cond(struct event_format *event, struct print_arg *top, char **tok)
 {
@@ -2371,7 +2389,7 @@ process_flags(struct event_format *event, struct print_arg *arg, char **tok)
 		goto out_free;
 	}
 
-	type = process_arg(event, field, &token);
+	type = process_field_arg(event, field, &token);
 
 	/* Handle operations in the first argument */
 	while (type == EVENT_OP)
@@ -2424,7 +2442,8 @@ process_symbols(struct event_format *event, struct print_arg *arg, char **tok)
 		goto out_free;
 	}
 
-	type = process_arg(event, field, &token);
+	type = process_field_arg(event, field, &token);
+
 	if (test_type_token(type, token, EVENT_DELIM, ","))
 		goto out_free_field;
 
-- 
1.8.1.4

