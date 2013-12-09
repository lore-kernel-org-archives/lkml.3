Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053Ab3LIThj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:37:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54957 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760924Ab3LIThU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:37:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/21] tools lib traceevent: Report better error message on bad function args
Date: Mon,  9 Dec 2013 16:36:52 -0300
Message-Id: <1386617830-18926-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386617830-18926-1-git-send-email-acme@infradead.org>
References: <1386617830-18926-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

When Jiri Olsa was writing a function callback for
scsi_trace_parse_cdb(), he thought that the traceevent library had a
bug in it because he was getting this error:

  Error: expected ')' but read ','
  Error: expected ')' but read ','
  Error: expected ')' but read ','
  Error: expected ')' but read ','

But in truth, he didn't have the write number of arguments for the
function callback, and the error was the library detecting the
discrepancy. A better error message would have prevented the confusion:

  Error: function 'scsi_trace_parse_cdb()' only expects 2 arguments but event scsi_dispatch_cmd_timeout has more
  Error: function 'scsi_trace_parse_cdb()' only expects 2 arguments but event scsi_dispatch_cmd_start has more
  Error: function 'scsi_trace_parse_cdb()' only expects 2 arguments but event scsi_dispatch_cmd_error has more
  Error: function 'scsi_trace_parse_cdb()' only expects 2 arguments but event scsi_dispatch_cmd_done has more

Or

  Error: function 'scsi_trace_parse_cdb()' expects 4 arguments but event scsi_dispatch_cmd_timeout only uses 3
  Error: function 'scsi_trace_parse_cdb()' expects 4 arguments but event scsi_dispatch_cmd_start only uses 3
  Error: function 'scsi_trace_parse_cdb()' expects 4 arguments but event scsi_dispatch_cmd_error only uses 3
  Error: function 'scsi_trace_parse_cdb()' expects 4 arguments but event scsi_dispatch_cmd_done only uses 3

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-a4c34w62vl0diitvxb7bt3er@git.kernel.org
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 9849873265d4..22566c271275 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2710,7 +2710,6 @@ process_func_handler(struct event_format *event, struct pevent_function_handler
 	struct print_arg *farg;
 	enum event_type type;
 	char *token;
-	const char *test;
 	int i;
 
 	arg->type = PRINT_FUNC;
@@ -2727,15 +2726,19 @@ process_func_handler(struct event_format *event, struct pevent_function_handler
 		}
 
 		type = process_arg(event, farg, &token);
-		if (i < (func->nr_args - 1))
-			test = ",";
-		else
-			test = ")";
-
-		if (test_type_token(type, token, EVENT_DELIM, test)) {
-			free_arg(farg);
-			free_token(token);
-			return EVENT_ERROR;
+		if (i < (func->nr_args - 1)) {
+			if (type != EVENT_DELIM || strcmp(token, ",") != 0) {
+				warning("Error: function '%s()' expects %d arguments but event %s only uses %d",
+					func->name, func->nr_args,
+					event->name, i + 1);
+				goto err;
+			}
+		} else {
+			if (type != EVENT_DELIM || strcmp(token, ")") != 0) {
+				warning("Error: function '%s()' only expects %d arguments but event %s has more",
+					func->name, func->nr_args, event->name);
+				goto err;
+			}
 		}
 
 		*next_arg = farg;
@@ -2747,6 +2750,11 @@ process_func_handler(struct event_format *event, struct pevent_function_handler
 	*tok = token;
 
 	return type;
+
+err:
+	free_arg(farg);
+	free_token(token);
+	return EVENT_ERROR;
 }
 
 static enum event_type
-- 
1.8.1.4

