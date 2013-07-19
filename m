Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760674Ab3GSOQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:16:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2490 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760597Ab3GSOOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:14:54 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=-BQq9KubrigA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=QQkIEQ5O4vwA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=dz8HkSdgSyqEpBUUyHgA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130719141450.077446074@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 19 Jul 2013 10:12:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next-3.11][PATCH 11/12] tracing: Simplify the iteration logic in f_start/f_next
References: <20130719141224.703522101@goodmis.org>
Content-Disposition: inline; filename=0011-tracing-Simplify-the-iteration-logic-in-f_start-f_ne.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

f_next() looks overcomplicated, and it is not strictly correct
even if this doesn't matter.

Say, FORMAT_FIELD_SEPERATOR should not return NULL (means EOF)
if trace_get_fields() returns an empty list, we should simply
advance to FORMAT_PRINTFMT as we do when we find the end of list.

1. Change f_next() to return "struct list_head *" rather than
   "ftrace_event_field *", and change f_show() to do list_entry().

   This simplifies the code a bit, only f_show() needs to know
   about ftrace_event_field, and f_next() can play with ->prev
   directly

2. Change f_next() to not play with ->prev / return inside the
   switch() statement. It can simply set node = head/common_head,
   the prev-or-advance-to-the-next-magic below does all work.

While at it. f_start() looks overcomplicated too. I don't think
*pos == 0 makes sense as a separate case, just change this code
to do "while" instead of "do/while".

The patch also moves f_start() down, close to f_stop(). This is
purely cosmetic, just to make the locking added by the next patch
more clear/visible.

Link: http://lkml.kernel.org/r/20130718184710.GA4783@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   60 ++++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 38 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 7a75cb2..76defd9 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -826,59 +826,33 @@ enum {
 static void *f_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct ftrace_event_call *call = m->private;
-	struct ftrace_event_field *field;
 	struct list_head *common_head = &ftrace_common_fields;
 	struct list_head *head = trace_get_fields(call);
+	struct list_head *node = v;
 
 	(*pos)++;
 
 	switch ((unsigned long)v) {
 	case FORMAT_HEADER:
-		if (unlikely(list_empty(common_head)))
-			return NULL;
-
-		field = list_entry(common_head->prev,
-				   struct ftrace_event_field, link);
-		return field;
+		node = common_head;
+		break;
 
 	case FORMAT_FIELD_SEPERATOR:
-		if (unlikely(list_empty(head)))
-			return NULL;
-
-		field = list_entry(head->prev, struct ftrace_event_field, link);
-		return field;
+		node = head;
+		break;
 
 	case FORMAT_PRINTFMT:
 		/* all done */
 		return NULL;
 	}
 
-	field = v;
-	if (field->link.prev == common_head)
+	node = node->prev;
+	if (node == common_head)
 		return (void *)FORMAT_FIELD_SEPERATOR;
-	else if (field->link.prev == head)
+	else if (node == head)
 		return (void *)FORMAT_PRINTFMT;
-
-	field = list_entry(field->link.prev, struct ftrace_event_field, link);
-
-	return field;
-}
-
-static void *f_start(struct seq_file *m, loff_t *pos)
-{
-	loff_t l = 0;
-	void *p;
-
-	/* Start by showing the header */
-	if (!*pos)
-		return (void *)FORMAT_HEADER;
-
-	p = (void *)FORMAT_HEADER;
-	do {
-		p = f_next(m, p, &l);
-	} while (p && l < *pos);
-
-	return p;
+	else
+		return node;
 }
 
 static int f_show(struct seq_file *m, void *v)
@@ -904,8 +878,7 @@ static int f_show(struct seq_file *m, void *v)
 		return 0;
 	}
 
-	field = v;
-
+	field = list_entry(v, struct ftrace_event_field, link);
 	/*
 	 * Smartly shows the array type(except dynamic array).
 	 * Normal:
@@ -932,6 +905,17 @@ static int f_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+static void *f_start(struct seq_file *m, loff_t *pos)
+{
+	void *p = (void *)FORMAT_HEADER;
+	loff_t l = 0;
+
+	while (l < *pos && p)
+		p = f_next(m, p, &l);
+
+	return p;
+}
+
 static void f_stop(struct seq_file *m, void *p)
 {
 }
-- 
1.7.10.4


