Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab3LKLEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:04:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60090 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab3LKLEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:04:09 -0500
Date: Wed, 11 Dec 2013 03:03:50 -0800
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-a4c34w62vl0diitvxb7bt3er@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
        jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, rostedt@goodmis.org, tglx@linutronix.de,
        jolsa@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Report better error message on bad function args
Git-Commit-ID: 3a3ffa2e82205921d1189f1055c22dae4c72819a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:03:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a3ffa2e82205921d1189f1055c22dae4c72819a
Gitweb:     http://git.kernel.org/tip/3a3ffa2e82205921d1189f1055c22dae4c72819a
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Mon, 18 Nov 2013 21:38:20 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 6 Dec 2013 10:39:54 -0300

tools lib traceevent: Report better error message on bad function args

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
index 9849873..22566c2 100644
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
