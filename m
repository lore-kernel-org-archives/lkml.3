Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab3KSCiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 21:38:23 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:58033 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751467Ab3KSCiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 21:38:22 -0500
Date: Mon, 18 Nov 2013 21:38:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH v2] tools lib traceevent: Report better error message on bad
 function args
Message-ID: <20131118213820.22173142@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---

V2:
   Added '[PATCH.*]' in subject. Don't know how I missed that the first time.

   Free token and farg. Thanks to Namhyung Kim for pointing that out.


diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 0362d57..87dda60 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2691,7 +2691,6 @@ process_func_handler(struct event_format *event, struct pevent_function_handler
 	struct print_arg *farg;
 	enum event_type type;
 	char *token;
-	const char *test;
 	int i;
 
 	arg->type = PRINT_FUNC;
@@ -2708,15 +2707,19 @@ process_func_handler(struct event_format *event, struct pevent_function_handler
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
@@ -2728,6 +2731,11 @@ process_func_handler(struct event_format *event, struct pevent_function_handler
 	*tok = token;
 
 	return type;
+
+err:
+	free_arg(farg);
+	free_token(token);
+	return EVENT_ERROR;
 }
 
 static enum event_type
