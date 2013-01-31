Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab3AaKiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:38:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35946 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab3AaKiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:38:17 -0500
Date: Thu, 31 Jan 2013 02:36:05 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-e23c1a5578cf32ed3a7ac9dde59a2de0a52ff812@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <1359060403-32422-1-git-send-email-jolsa@redhat.com>
References: <1359060403-32422-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Handle dynamic array'
 s element size properly
Git-Commit-ID: e23c1a5578cf32ed3a7ac9dde59a2de0a52ff812
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 02:36:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e23c1a5578cf32ed3a7ac9dde59a2de0a52ff812
Gitweb:     http://git.kernel.org/tip/e23c1a5578cf32ed3a7ac9dde59a2de0a52ff812
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 24 Jan 2013 21:46:43 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 25 Jan 2013 12:49:28 -0300

tools lib traceevent: Handle dynamic array's element size properly

Fixing the dynamic array format field parsing.

Currently the event_read_fields function could segfault while parsing
dynamic array other than string type. The reason is the event->pevent
does not need to be set and gets dereferenced unconditionaly.

Also adding proper initialization of field->elementsize based on the
parsed dynamic type.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1359060403-32422-1-git-send-email-jolsa@redhat.com
[ committer note: Made a char pointer parameter const, as requested by Steven ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c | 39 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index bb8b3db..82b0606 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1223,6 +1223,34 @@ static int field_is_long(struct format_field *field)
 	return 0;
 }
 
+static unsigned int type_size(const char *name)
+{
+	/* This covers all FIELD_IS_STRING types. */
+	static struct {
+		const char *type;
+		unsigned int size;
+	} table[] = {
+		{ "u8",   1 },
+		{ "u16",  2 },
+		{ "u32",  4 },
+		{ "u64",  8 },
+		{ "s8",   1 },
+		{ "s16",  2 },
+		{ "s32",  4 },
+		{ "s64",  8 },
+		{ "char", 1 },
+		{ },
+	};
+	int i;
+
+	for (i = 0; table[i].type; i++) {
+		if (!strcmp(table[i].type, name))
+			return table[i].size;
+	}
+
+	return 0;
+}
+
 static int event_read_fields(struct event_format *event, struct format_field **fields)
 {
 	struct format_field *field = NULL;
@@ -1232,6 +1260,8 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 	int count = 0;
 
 	do {
+		unsigned int size_dynamic = 0;
+
 		type = read_token(&token);
 		if (type == EVENT_NEWLINE) {
 			free_token(token);
@@ -1390,6 +1420,7 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 				field->type = new_type;
 				strcat(field->type, " ");
 				strcat(field->type, field->name);
+				size_dynamic = type_size(field->name);
 				free_token(field->name);
 				strcat(field->type, brackets);
 				field->name = token;
@@ -1478,10 +1509,14 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 		if (field->flags & FIELD_IS_ARRAY) {
 			if (field->arraylen)
 				field->elementsize = field->size / field->arraylen;
+			else if (field->flags & FIELD_IS_DYNAMIC)
+				field->elementsize = size_dynamic;
 			else if (field->flags & FIELD_IS_STRING)
 				field->elementsize = 1;
-			else
-				field->elementsize = event->pevent->long_size;
+			else if (field->flags & FIELD_IS_LONG)
+				field->elementsize = event->pevent ?
+						     event->pevent->long_size :
+						     sizeof(long);
 		} else
 			field->elementsize = field->size;
 
