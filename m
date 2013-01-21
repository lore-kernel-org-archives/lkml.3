Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab3AUMoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:44:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab3AUMog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:44:36 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] tools lib traceevent: Handle dynamic array's element size properly
Date: Mon, 21 Jan 2013 13:44:11 +0100
Message-Id: <1358772251-4411-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing the dynamic array format field parsing.

Currently the event_read_fields function could segfault while parsing
dynamic array other than string type. The reason is the event->pevent
does not need to be set and gets dereferenced unconditionaly.

Also adding proper initialization of field->elementsize based on the
parsed dynamic type.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/lib/traceevent/event-parse.c | 40 +++++++++++++++++++++++++++++++++++---
 tools/lib/traceevent/event-parse.h |  1 +
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index f504619..d682df2 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1223,6 +1223,34 @@ static int field_is_long(struct format_field *field)
 	return 0;
 }
 
+static unsigned int field_dynamic_elem_size(struct format_field *field)
+{
+	/* This covers all FIELD_IS_STRING types. */
+	static struct {
+		char *type;
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
+		if (!strcmp(table[i].type, field->type_dyn))
+			return table[i].size;
+	}
+
+	return 0;
+}
+
 static int event_read_fields(struct event_format *event, struct format_field **fields)
 {
 	struct format_field *field = NULL;
@@ -1390,7 +1418,7 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 				field->type = new_type;
 				strcat(field->type, " ");
 				strcat(field->type, field->name);
-				free_token(field->name);
+				field->type_dyn = field->name;
 				strcat(field->type, brackets);
 				field->name = token;
 				type = read_token(&token);
@@ -1477,10 +1505,14 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 		if (field->flags & FIELD_IS_ARRAY) {
 			if (field->arraylen)
 				field->elementsize = field->size / field->arraylen;
+			else if (field->flags & FIELD_IS_DYNAMIC)
+				field->elementsize = field_dynamic_elem_size(field);
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
 
@@ -1496,6 +1528,7 @@ fail:
 fail_expect:
 	if (field) {
 		free(field->type);
+		free(field->type_dyn);
 		free(field->name);
 		free(field);
 	}
@@ -5500,6 +5533,7 @@ static void free_format_fields(struct format_field *field)
 	while (field) {
 		next = field->next;
 		free(field->type);
+		free(field->type_dyn);
 		free(field->name);
 		free(field);
 		field = next;
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 7be7e89..4d54af2 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -174,6 +174,7 @@ struct format_field {
 	struct format_field	*next;
 	struct event_format	*event;
 	char			*type;
+	char			*type_dyn;
 	char			*name;
 	int			offset;
 	int			size;
-- 
1.7.11.7

