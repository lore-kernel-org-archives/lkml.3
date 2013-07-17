Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab3GQTfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:35:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455Ab3GQTfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:35:38 -0400
Date: Wed, 17 Jul 2013 21:30:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 5/4] tracing: Simplify the ftrace_event_field iteration
	in f_next/f_show
Message-ID: <20130717193017.GA15312@redhat.com>
References: <20130716185658.GA21167@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716185658.GA21167@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_events.c |   60 +++++++++++++++---------------------------
 1 files changed, 22 insertions(+), 38 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f4a86f9..6c3e4e6 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -806,59 +806,33 @@ enum {
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
@@ -884,8 +858,7 @@ static int f_show(struct seq_file *m, void *v)
 		return 0;
 	}
 
-	field = v;
-
+	field = list_entry(v, struct ftrace_event_field, link);
 	/*
 	 * Smartly shows the array type(except dynamic array).
 	 * Normal:
@@ -912,6 +885,17 @@ static int f_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+static void *f_start(struct seq_file *m, loff_t *pos)
+{
+	void *p = (void *)FORMAT_HEADER;
+	loff_t l = 0;
+
+	while (p && l < *pos)
+		p = f_next(m, p, &l);
+
+	return p;
+}
+
 static void f_stop(struct seq_file *m, void *p)
 {
 }
-- 
1.5.5.1


