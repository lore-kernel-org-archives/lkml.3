Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab3KTN4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:56:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35910 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab3KTN4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:56:01 -0500
Date: Wed, 20 Nov 2013 05:55:43 -0800
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-eff2c92f86c2ac2a0eab3749d58be39592293c3a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20131118142314.27ca334b@gandalf.local.home>
References: <20131118142314.27ca334b@gandalf.local.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools lib traceevent:
  Fix use of multiple options in processing field
Git-Commit-ID: eff2c92f86c2ac2a0eab3749d58be39592293c3a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 20 Nov 2013 05:55:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eff2c92f86c2ac2a0eab3749d58be39592293c3a
Gitweb:     http://git.kernel.org/tip/eff2c92f86c2ac2a0eab3749d58be39592293c3a
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Mon, 18 Nov 2013 14:23:14 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Nov 2013 10:34:39 -0300

tools lib traceevent: Fix use of multiple options in processing field

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
index 0362d57..8a5b65d 100644
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
 
