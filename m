Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaBBVor (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:44:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806AbaBBVkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:40:25 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 17/22] tools lib traceevent: Add pevent_field_cmp function
Date: Sun,  2 Feb 2014 22:39:05 +0100
Message-Id: <1391377150-23920-18-git-send-email-jolsa@redhat.com>
In-Reply-To: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding pevent_field_cmp function to compare 2 fields data,
the interface is:

int pevent_field_cmp(struct format_field *a_field,
		     struct format_field *b_field,
		     void *a_data, int a_size,
		     void *b_data, int b_size);

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
 tools/lib/traceevent/event-parse.c | 54 ++++++++++++++++++++++++++++++++++++++
 tools/lib/traceevent/event-parse.h |  5 ++++
 2 files changed, 59 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 7b5b2dc..aa58c26 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4026,6 +4026,60 @@ static int is_printable_array(char *p, unsigned int len)
 	return 1;
 }
 
+int pevent_field_cmp(struct format_field *a_field,
+		     struct format_field *b_field,
+		     void *a_data, int a_size,
+		     void *b_data, int b_size)
+{
+	struct event_format *a_event = a_field->event;
+	struct event_format *b_event = a_field->event;
+	unsigned int a_offset, b_offset, a_len, b_len, i;
+	unsigned long long a_val = 0, b_val = 0;
+
+	if (a_size != b_size)
+		return a_size - b_size;
+
+	if (a_field->flags & FIELD_IS_ARRAY) {
+		a_offset = a_field->offset;
+		b_offset = b_field->offset;
+		a_len = a_field->size;
+		b_len = b_field->size;
+
+		if (a_field->flags & FIELD_IS_DYNAMIC) {
+			a_offset = pevent_read_number(a_event->pevent,
+						      a_data + a_offset,
+						      a_len);
+			a_len = a_offset >> 16;
+			a_offset &= 0xffff;
+		}
+
+		if (b_field->flags & FIELD_IS_DYNAMIC) {
+			b_offset = pevent_read_number(b_event->pevent,
+						      b_data + b_offset,
+						      b_len);
+			b_len = b_offset >> 16;
+			b_offset &= 0xffff;
+		}
+
+		if (a_len != b_len)
+			return a_len - b_len;
+
+		for (i = 0; (i < a_len) && (a_val == b_val); i++) {
+			a_val = *((unsigned char *)a_data + a_offset + i);
+			b_val = *((unsigned char *)b_data + b_offset + i);
+		}
+	} else {
+		a_val = pevent_read_number(a_event->pevent,
+					   a_data + a_field->offset,
+					   a_field->size);
+		b_val = pevent_read_number(b_event->pevent,
+					   b_data + b_field->offset,
+					   b_field->size);
+	}
+
+	return a_val - b_val;
+}
+
 void pevent_field_info(struct trace_seq *s,
 		       struct format_field *field,
 		       void *data, int size __maybe_unused,
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index b49fad1..7158b55 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -588,6 +588,11 @@ int pevent_pid_is_registered(struct pevent *pevent, int pid);
 void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
 			struct pevent_record *record, bool use_trace_clock);
 
+int pevent_field_cmp(struct format_field *a_field,
+		     struct format_field *b_field,
+		     void *a_data, int a_size,
+		     void *b_data, int b_size);
+
 void pevent_field_info(struct trace_seq *s,
 		       struct format_field *field,
 		       void *data, int size __maybe_unused,
-- 
1.8.3.1

