Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab3KRTXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 14:23:21 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:51008 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752354Ab3KRTXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 14:23:18 -0500
Date: Mon, 18 Nov 2013 14:23:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH] tools lib traceevent: Fix use of multiple options in
 processing field
Message-ID: <20131118142314.27ca334b@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa reported that the scsi_dispatch_cmd_done event failed to
parse with:

  Error: expected type 5 but read 4
  Error: expected type 5 but read 4

The problem is with this part of the print_fmt:

  __print_symbolic(((REC->result) >> 24) & 0xff, ...

The __print_symbolic() helper function's first parameter is the field
to use to determine what symbol to print based on the value of the
result. The parser can handle one operation, but it can not handle
multiple operations ('>>' and '&').

Add code to process all operations for the field argument for
__print_symbolic() as well as __print_flags().

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 57fe3ba..dcd0e21 100644
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
 
