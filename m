Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab3A3Ot1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 09:49:27 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57851 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab3A3OrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 09:47:19 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/21] tools lib traceevent: Handle dynamic array's element size properly
Date: Wed, 30 Jan 2013 11:46:42 -0300
Message-Id: <1359557222-17547-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359557222-17547-1-git-send-email-acme@infradead.org>
References: <1359557222-17547-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

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
 
-- 
1.8.1.1.361.gec3ae6e

