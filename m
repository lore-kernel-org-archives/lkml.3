Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbbAZMND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:13:03 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:43065 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbbAZMM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:12:59 -0500
From: Javi Merino <javi.merino@arm.com>
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Cc: Javi Merino <javi.merino@arm.com>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH v4 2/3] tools lib traceevent: factor out allocating and processing args
Date: Mon, 26 Jan 2015 12:11:50 +0000
Message-Id: <1422274311-19738-3-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422274311-19738-1-git-send-email-javi.merino@arm.com>
References: <1422274311-19738-1-git-send-email-javi.merino@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sequence of allocating the print_arg field, calling process_arg()
and verifying that the next event delimiter is repeated twice in
process_hex() and will also be used for process_int_array().  Factor it
out to a function to avoid writing the same code again and again.

Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Javi Merino <javi.merino@arm.com>
---
 tools/lib/traceevent/event-parse.c | 77 ++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 37 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index cf3a44bf1ec3..dabd8f5c6398 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2013,6 +2013,38 @@ process_entry(struct event_format *event __maybe_unused, struct print_arg *arg,
 	return EVENT_ERROR;
 }
 
+static int alloc_and_process_arg(struct event_format *event, char *next_token,
+				 struct print_arg **print_arg)
+{
+	struct print_arg *field;
+	enum event_type type;
+	char *token;
+	int ret = 0;
+
+	field = alloc_arg();
+	if (!field) {
+		do_warning_event(event, "%s: not enough memory!", __func__);
+		errno = ENOMEM;
+		return -1;
+	}
+
+	type = process_arg(event, field, &token);
+
+	if (test_type_token(type, token, EVENT_DELIM, next_token)) {
+		errno = EINVAL;
+		ret = -1;
+		free_arg(field);
+		goto out_free_token;
+	}
+
+	*print_arg = field;
+
+out_free_token:
+	free_token(token);
+
+	return ret;
+}
+
 static char *arg_eval (struct print_arg *arg);
 
 static unsigned long long
@@ -2485,49 +2517,20 @@ out_free:
 static enum event_type
 process_hex(struct event_format *event, struct print_arg *arg, char **tok)
 {
-	struct print_arg *field;
-	enum event_type type;
-	char *token = NULL;
-
 	memset(arg, 0, sizeof(*arg));
 	arg->type = PRINT_HEX;
 
-	field = alloc_arg();
-	if (!field) {
-		do_warning_event(event, "%s: not enough memory!", __func__);
-		goto out_free;
-	}
-
-	type = process_arg(event, field, &token);
-
-	if (test_type_token(type, token, EVENT_DELIM, ","))
-		goto out_free;
-
-	arg->hex.field = field;
-
-	free_token(token);
-
-	field = alloc_arg();
-	if (!field) {
-		do_warning_event(event, "%s: not enough memory!", __func__);
-		*tok = NULL;
-		return EVENT_ERROR;
-	}
-
-	type = process_arg(event, field, &token);
-
-	if (test_type_token(type, token, EVENT_DELIM, ")"))
-		goto out_free;
+	if (alloc_and_process_arg(event, ",", &arg->hex.field))
+		goto out;
 
-	arg->hex.size = field;
+	if (alloc_and_process_arg(event, ")", &arg->hex.size))
+		goto free_field;
 
-	free_token(token);
-	type = read_token_item(tok);
-	return type;
+	return read_token_item(tok);
 
- out_free:
-	free_arg(field);
-	free_token(token);
+free_field:
+	free_arg(arg->hex.field);
+out:
 	*tok = NULL;
 	return EVENT_ERROR;
 }
-- 
1.9.1

