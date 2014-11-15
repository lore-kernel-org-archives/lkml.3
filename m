Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbaKOFHj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 00:07:39 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:28219 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752259AbaKOFGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 00:06:08 -0500
Message-Id: <20141115050603.904875201@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 14 Nov 2014 23:59:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 19/26 v5] tracing: Use trace_seq_used() and seq_buf_used() instead of len
References: <20141115045847.712848224@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0019-tracing-Use-trace_seq_used-and-seq_buf_used-instead-.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

As the seq_buf->len will soon be +1 size when there's an overflow, we
must use trace_seq_used() or seq_buf_used() methods to get the real
length. This will prevent buffer overflow issues if just the len
of the seq_buf descriptor is used to copy memory.

Link: http://lkml.kernel.org/r/20141114121911.09ba3d38@gandalf.local.home

Reported-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/trace_seq.h            | 20 +++++++++++++++-
 kernel/trace/seq_buf.c               |  2 +-
 kernel/trace/trace.c                 | 44 ++++++++++++++++++++++++------------
 kernel/trace/trace_events.c          |  9 +++++---
 kernel/trace/trace_functions_graph.c |  5 +++-
 kernel/trace/trace_seq.c             |  2 +-
 6 files changed, 60 insertions(+), 22 deletions(-)

diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index 85d37106be3d..cfaf5a1d4bad 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -24,6 +24,24 @@ trace_seq_init(struct trace_seq *s)
 }
 
 /**
+ * trace_seq_used - amount of actual data written to buffer
+ * @s: trace sequence descriptor
+ *
+ * Returns the amount of data written to the buffer.
+ *
+ * IMPORTANT!
+ *
+ * Use this instead of @s->seq.len if you need to pass the amount
+ * of data from the buffer to another buffer (userspace, or what not).
+ * The @s->seq.len on overflow is bigger than the buffer size and
+ * using it can cause access to undefined memory.
+ */
+static inline int trace_seq_used(struct trace_seq *s)
+{
+	return seq_buf_used(&s->seq);
+}
+
+/**
  * trace_seq_buffer_ptr - return pointer to next location in buffer
  * @s: trace sequence descriptor
  *
@@ -35,7 +53,7 @@ trace_seq_init(struct trace_seq *s)
 static inline unsigned char *
 trace_seq_buffer_ptr(struct trace_seq *s)
 {
-	return s->buffer + s->seq.len;
+	return s->buffer + seq_buf_used(&s->seq);
 }
 
 /**
diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
index 9ec5305d9da7..ce17f65268ed 100644
--- a/kernel/trace/seq_buf.c
+++ b/kernel/trace/seq_buf.c
@@ -328,7 +328,7 @@ int seq_buf_to_user(struct seq_buf *s, char __user *ubuf, int cnt)
 	if (s->len <= s->readpos)
 		return -EBUSY;
 
-	len = s->len - s->readpos;
+	len = seq_buf_used(s) - s->readpos;
 	if (cnt > len)
 		cnt = len;
 	ret = copy_to_user(ubuf, s->buffer + s->readpos, cnt);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7d7a07e9b9e9..9f1ffc707f3b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -944,10 +944,10 @@ static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 {
 	int len;
 
-	if (s->seq.len <= s->seq.readpos)
+	if (trace_seq_used(s) <= s->seq.readpos)
 		return -EBUSY;
 
-	len = s->seq.len - s->seq.readpos;
+	len = trace_seq_used(s) - s->seq.readpos;
 	if (cnt > len)
 		cnt = len;
 	memcpy(buf, s->buffer + s->seq.readpos, cnt);
@@ -4514,18 +4514,18 @@ waitagain:
 	trace_access_lock(iter->cpu_file);
 	while (trace_find_next_entry_inc(iter) != NULL) {
 		enum print_line_t ret;
-		int len = iter->seq.seq.len;
+		int save_len = iter->seq.seq.len;
 
 		ret = print_trace_line(iter);
 		if (ret == TRACE_TYPE_PARTIAL_LINE) {
 			/* don't print partial lines */
-			iter->seq.seq.len = len;
+			iter->seq.seq.len = save_len;
 			break;
 		}
 		if (ret != TRACE_TYPE_NO_CONSUME)
 			trace_consume(iter);
 
-		if (iter->seq.seq.len >= cnt)
+		if (trace_seq_used(&iter->seq) >= cnt)
 			break;
 
 		/*
@@ -4541,7 +4541,7 @@ waitagain:
 
 	/* Now copy what we have to the user */
 	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
-	if (iter->seq.seq.readpos >= iter->seq.seq.len)
+	if (iter->seq.seq.readpos >= trace_seq_used(&iter->seq))
 		trace_seq_init(&iter->seq);
 
 	/*
@@ -4575,20 +4575,33 @@ static size_t
 tracing_fill_pipe_page(size_t rem, struct trace_iterator *iter)
 {
 	size_t count;
+	int save_len;
 	int ret;
 
 	/* Seq buffer is page-sized, exactly what we need. */
 	for (;;) {
-		count = iter->seq.seq.len;
+		save_len = iter->seq.seq.len;
 		ret = print_trace_line(iter);
-		count = iter->seq.seq.len - count;
-		if (rem < count) {
-			rem = 0;
-			iter->seq.seq.len -= count;
+
+		if (trace_seq_has_overflowed(&iter->seq)) {
+			iter->seq.seq.len = save_len;
 			break;
 		}
+
+		/*
+		 * This should not be hit, because it should only
+		 * be set if the iter->seq overflowed. But check it
+		 * anyway to be safe.
+		 */
 		if (ret == TRACE_TYPE_PARTIAL_LINE) {
-			iter->seq.seq.len -= count;
+			iter->seq.seq.len = save_len;
+			break;
+		}
+
+		count = trace_seq_used(&iter->seq) - save_len;
+		if (rem < count) {
+			rem = 0;
+			iter->seq.seq.len = save_len;;
 			break;
 		}
 
@@ -4669,13 +4682,13 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		/* Copy the data into the page, so we can start over. */
 		ret = trace_seq_to_buffer(&iter->seq,
 					  page_address(spd.pages[i]),
-					  iter->seq.seq.len);
+					  trace_seq_used(&iter->seq));
 		if (ret < 0) {
 			__free_page(spd.pages[i]);
 			break;
 		}
 		spd.partial[i].offset = 0;
-		spd.partial[i].len = iter->seq.seq.len;
+		spd.partial[i].len = trace_seq_used(&iter->seq);
 
 		trace_seq_init(&iter->seq);
 	}
@@ -5676,7 +5689,8 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 	cnt = ring_buffer_read_events_cpu(trace_buf->buffer, cpu);
 	trace_seq_printf(s, "read events: %ld\n", cnt);
 
-	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->seq.len);
+	count = simple_read_from_buffer(ubuf, count, ppos,
+					s->buffer, trace_seq_used(s));
 
 	kfree(s);
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 4d0067dd7f88..935cbea78532 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1044,7 +1044,8 @@ event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 	mutex_unlock(&event_mutex);
 
 	if (file)
-		r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->seq.len);
+		r = simple_read_from_buffer(ubuf, cnt, ppos,
+					    s->buffer, trace_seq_used(s));
 
 	kfree(s);
 
@@ -1210,7 +1211,8 @@ subsystem_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 	trace_seq_init(s);
 
 	print_subsystem_event_filter(system, s);
-	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->seq.len);
+	r = simple_read_from_buffer(ubuf, cnt, ppos,
+				    s->buffer, trace_seq_used(s));
 
 	kfree(s);
 
@@ -1265,7 +1267,8 @@ show_header(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 	trace_seq_init(s);
 
 	func(s);
-	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->seq.len);
+	r = simple_read_from_buffer(ubuf, cnt, ppos,
+				    s->buffer, trace_seq_used(s));
 
 	kfree(s);
 
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 6d1342ae7a44..ec35468349a7 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1153,6 +1153,9 @@ print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
 			return ret;
 	}
 
+	if (trace_seq_has_overflowed(s))
+		goto out;
+
 	/* Strip ending newline */
 	if (s->buffer[s->seq.len - 1] == '\n') {
 		s->buffer[s->seq.len - 1] = '\0';
@@ -1160,7 +1163,7 @@ print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
 	}
 
 	trace_seq_puts(s, " */\n");
-
+ out:
 	return trace_handle_return(s);
 }
 
diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
index 087fa514069d..0c7aab4dd94f 100644
--- a/kernel/trace/trace_seq.c
+++ b/kernel/trace/trace_seq.c
@@ -30,7 +30,7 @@
 #define TRACE_SEQ_BUF_LEFT(s) seq_buf_buffer_left(&(s)->seq)
 
 /* How much buffer is written? */
-#define TRACE_SEQ_BUF_USED(s) min((s)->seq.len, (unsigned int)(PAGE_SIZE - 1))
+#define TRACE_SEQ_BUF_USED(s) seq_buf_used(&(s)->seq)
 
 /*
  * trace_seq should work with being initialized with 0s.
-- 
2.1.1


