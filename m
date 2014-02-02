Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbaBBVpS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:45:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbaBBVkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:40:17 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 15/22] tools lib traceevent: Factor print_event_fields function
Date: Sun,  2 Feb 2014 22:39:03 +0100
Message-Id: <1391377150-23920-16-git-send-email-jolsa@redhat.com>
In-Reply-To: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factoring print_event_fields function and adding pevent_field_info
function that is used later in comming patches.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/lib/traceevent/event-parse.c | 126 ++++++++++++++++++++-----------------
 tools/lib/traceevent/event-parse.h |   4 ++
 2 files changed, 71 insertions(+), 59 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 1587ea39..a3370f2 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4026,73 +4026,81 @@ static int is_printable_array(char *p, unsigned int len)
 	return 1;
 }
 
-static void print_event_fields(struct trace_seq *s, void *data,
-			       int size __maybe_unused,
-			       struct event_format *event)
+void pevent_field_info(struct trace_seq *s,
+		       struct format_field *field,
+		       void *data, int size __maybe_unused)
 {
-	struct format_field *field;
-	unsigned long long val;
+	struct event_format *event = field->event;
 	unsigned int offset, len, i;
+	unsigned long long val;
 
-	field = event->format.fields;
-	while (field) {
-		trace_seq_printf(s, " %s=", field->name);
-		if (field->flags & FIELD_IS_ARRAY) {
-			offset = field->offset;
-			len = field->size;
-			if (field->flags & FIELD_IS_DYNAMIC) {
-				val = pevent_read_number(event->pevent, data + offset, len);
-				offset = val;
-				len = offset >> 16;
-				offset &= 0xffff;
-			}
-			if (field->flags & FIELD_IS_STRING &&
-			    is_printable_array(data + offset, len)) {
-				trace_seq_printf(s, "%s", (char *)data + offset);
-			} else {
-				trace_seq_puts(s, "ARRAY[");
-				for (i = 0; i < len; i++) {
-					if (i)
-						trace_seq_puts(s, ", ");
-					trace_seq_printf(s, "%02x",
-							 *((unsigned char *)data + offset + i));
-				}
-				trace_seq_putc(s, ']');
-				field->flags &= ~FIELD_IS_STRING;
-			}
+	trace_seq_printf(s, " %s=", field->name);
+	if (field->flags & FIELD_IS_ARRAY) {
+		offset = field->offset;
+		len = field->size;
+		if (field->flags & FIELD_IS_DYNAMIC) {
+			val = pevent_read_number(event->pevent, data + offset, len);
+			offset = val;
+			len = offset >> 16;
+			offset &= 0xffff;
+		}
+		if (field->flags & FIELD_IS_STRING &&
+		    is_printable_array(data + offset, len)) {
+			trace_seq_printf(s, "%s", (char *)data + offset);
 		} else {
-			val = pevent_read_number(event->pevent, data + field->offset,
-						 field->size);
-			if (field->flags & FIELD_IS_POINTER) {
-				trace_seq_printf(s, "0x%llx", val);
-			} else if (field->flags & FIELD_IS_SIGNED) {
-				switch (field->size) {
-				case 4:
-					/*
-					 * If field is long then print it in hex.
-					 * A long usually stores pointers.
-					 */
-					if (field->flags & FIELD_IS_LONG)
-						trace_seq_printf(s, "0x%x", (int)val);
-					else
-						trace_seq_printf(s, "%d", (int)val);
-					break;
-				case 2:
-					trace_seq_printf(s, "%2d", (short)val);
-					break;
-				case 1:
-					trace_seq_printf(s, "%1d", (char)val);
-					break;
-				default:
-					trace_seq_printf(s, "%lld", val);
-				}
-			} else {
+			trace_seq_puts(s, "ARRAY[");
+			for (i = 0; i < len; i++) {
+				if (i)
+					trace_seq_puts(s, ", ");
+				trace_seq_printf(s, "%02x",
+						 *((unsigned char *)data + offset + i));
+			}
+			trace_seq_putc(s, ']');
+			field->flags &= ~FIELD_IS_STRING;
+		}
+	} else {
+		val = pevent_read_number(event->pevent, data + field->offset,
+					 field->size);
+		if (field->flags & FIELD_IS_POINTER) {
+			trace_seq_printf(s, "0x%llx", val);
+		} else if (field->flags & FIELD_IS_SIGNED) {
+			switch (field->size) {
+			case 4:
+				/*
+				 * If field is long then print it in hex.
+				 * A long usually stores pointers.
+				 */
 				if (field->flags & FIELD_IS_LONG)
-					trace_seq_printf(s, "0x%llx", val);
+					trace_seq_printf(s, "0x%x", (int)val);
 				else
-					trace_seq_printf(s, "%llu", val);
+					trace_seq_printf(s, "%d", (int)val);
+				break;
+			case 2:
+				trace_seq_printf(s, "%2d", (short)val);
+				break;
+			case 1:
+				trace_seq_printf(s, "%1d", (char)val);
+				break;
+			default:
+				trace_seq_printf(s, "%lld", val);
 			}
+		} else {
+			if (field->flags & FIELD_IS_LONG)
+				trace_seq_printf(s, "0x%llx", val);
+			else
+				trace_seq_printf(s, "%llu", val);
 		}
+	}
+}
+
+static void print_event_fields(struct trace_seq *s, void *data, int size,
+			       struct event_format *event)
+{
+	struct format_field *field;
+
+	field = event->format.fields;
+	while (field) {
+		pevent_field_info(s, field, data, size);
 		field = field->next;
 	}
 }
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 791c539..73492a9 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -588,6 +588,10 @@ int pevent_pid_is_registered(struct pevent *pevent, int pid);
 void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
 			struct pevent_record *record, bool use_trace_clock);
 
+void pevent_field_info(struct trace_seq *s,
+		       struct format_field *field,
+		       void *data, int size);
+
 int pevent_parse_header_page(struct pevent *pevent, char *buf, unsigned long size,
 			     int long_size);
 
-- 
1.8.3.1

