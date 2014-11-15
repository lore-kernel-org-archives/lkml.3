Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbaKOFI7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 00:08:59 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:3893 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751903AbaKOFIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 00:08:55 -0500
Date: Sat, 15 Nov 2014 00:08:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [PATCH 00/26 v5] trace-seq/seq-buf/x86/printk: Print all stacks
 from NMI safely
Message-ID: <20141115000854.3bcf0801@gandalf.local.home>
In-Reply-To: <20141115045847.712848224@goodmis.org>
References: <20141115045847.712848224@goodmis.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 23:58:47 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Version 5!
> 
> Full diff between v4 and v5 will be replied to this email.
> 

Here it is:

-- Steve

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index da211dfbcebe..9aafe0e24c68 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -67,7 +67,7 @@ seq_buf_buffer_left(struct seq_buf *s)
 /* How much buffer was written? */
 static inline unsigned int seq_buf_used(struct seq_buf *s)
 {
-	return min((s)->len, (s)->size);
+	return min(s->len, s->size);
 }
 
 /**
@@ -105,7 +105,8 @@ static inline void seq_buf_commit(struct seq_buf *s, int num)
 	if (num < 0) {
 		seq_buf_set_overflow(s);
 	} else {
-		BUG_ON(s->len + num > s->size + 1);
+		/* num must be negative on overflow */
+		BUG_ON(s->len + num > s->size);
 		s->len += num;
 	}
 }
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
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index f13471b5d27a..139b5067345b 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -277,7 +277,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
 	field = (typeof(field))iter->ent;				\
 									\
 	ret = ftrace_raw_output_prep(iter, trace_event);		\
-	if (ret)							\
+	if (ret != TRACE_TYPE_HANDLED)					\
 		return ret;						\
 									\
 	trace_seq_printf(s, print);					\
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
index ac2300ca0b70..ec35468349a7 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -677,12 +677,8 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 		}
 
 		/* Latency format */
-		if (trace_flags & TRACE_ITER_LATENCY_FMT) {
-			ret = print_graph_lat_fmt(s, ent);
-			if (ret == TRACE_TYPE_PARTIAL_LINE)
-				return TRACE_TYPE_PARTIAL_LINE;
-		}
-
+		if (trace_flags & TRACE_ITER_LATENCY_FMT)
+			print_graph_lat_fmt(s, ent);
 	}
 
 	/* No overhead */
@@ -1157,6 +1153,9 @@ print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
 			return ret;
 	}
 
+	if (trace_seq_has_overflowed(s))
+		goto out;
+
 	/* Strip ending newline */
 	if (s->buffer[s->seq.len - 1] == '\n') {
 		s->buffer[s->seq.len - 1] = '\0';
@@ -1164,7 +1163,7 @@ print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
 	}
 
 	trace_seq_puts(s, " */\n");
-
+ out:
 	return trace_handle_return(s);
 }
 
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 163c11b6b8ff..723818bc83b4 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -196,10 +196,7 @@ int ftrace_raw_output_prep(struct trace_iterator *iter,
 	trace_seq_init(p);
 	trace_seq_printf(s, "%s: ", ftrace_event_name(event));
 
-	if (trace_seq_has_overflowed(s))
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	return 0;
+	return trace_handle_return(s);
 }
 EXPORT_SYMBOL(ftrace_raw_output_prep);
 
diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
index 475412e31de5..0c7aab4dd94f 100644
--- a/kernel/trace/trace_seq.c
+++ b/kernel/trace/trace_seq.c
@@ -30,7 +30,7 @@
 #define TRACE_SEQ_BUF_LEFT(s) seq_buf_buffer_left(&(s)->seq)
 
 /* How much buffer is written? */
-#define TRACE_SEQ_BUF_USED(s) min((s)->seq.len, (unsigned int)(PAGE_SIZE - 1))
+#define TRACE_SEQ_BUF_USED(s) seq_buf_used(&(s)->seq)
 
 /*
  * trace_seq should work with being initialized with 0s.
@@ -98,7 +98,6 @@ void trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
 		s->seq.len = save_len;
 		s->full = 1;
-		return;
 	}
 }
 EXPORT_SYMBOL_GPL(trace_seq_printf);
@@ -144,20 +143,18 @@ EXPORT_SYMBOL_GPL(trace_seq_bitmask);
 void trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
 {
 	unsigned int save_len = s->seq.len;
-	int ret;
 
 	if (s->full)
 		return;
 
 	__trace_seq_init(s);
 
-	ret = seq_buf_vprintf(&s->seq, fmt, args);
+	seq_buf_vprintf(&s->seq, fmt, args);
 
 	/* If we can't write it all, don't bother writing anything */
 	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
 		s->seq.len = save_len;
 		s->full = 1;
-		return;
 	}
 }
 EXPORT_SYMBOL_GPL(trace_seq_vprintf);
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index fcc2b5ebcc5a..fd76f8e108ef 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -866,11 +866,13 @@ print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *e
 	for (i = 0; i < tu->tp.nr_args; i++) {
 		struct probe_arg *parg = &tu->tp.args[i];
 
-		parg->type->print(s, parg->name, data + parg->offset, entry);
+		if (!parg->type->print(s, parg->name, data + parg->offset, entry))
+			goto out;
 	}
 
 	trace_seq_putc(s, '\n');
 
+ out:
 	return trace_handle_return(s);
 }
 
diff --git a/lib/seq_buf.c b/lib/seq_buf.c
index 84b6377df827..a2288ca567a3 100644
--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -16,6 +16,11 @@
 #include <linux/seq_file.h>
 #include <linux/seq_buf.h>
 
+static bool seq_buf_can_fit(struct seq_buf *s, size_t len)
+{
+	return s->len + len <= s->size;
+}
+
 /**
  * seq_buf_print_seq - move the contents of seq_buf into a seq_file
  * @m: the seq_file descriptor that is the destination
@@ -48,7 +53,7 @@ int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args)
 
 	if (s->len < s->size) {
 		len = vsnprintf(s->buffer + s->len, s->size - s->len, fmt, args);
-		if (s->len + len <= s->size) {
+		if (seq_buf_can_fit(s, len)) {
 			s->len += len;
 			return 0;
 		}
@@ -141,7 +146,7 @@ int seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary)
 
 	if (s->len < s->size) {
 		ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
-		if (s->len + ret <= s->size) {
+		if (seq_buf_can_fit(s, ret)) {
 			s->len += ret;
 			return 0;
 		}
@@ -166,7 +171,7 @@ int seq_buf_puts(struct seq_buf *s, const char *str)
 
 	WARN_ON(s->size == 0);
 
-	if (s->len + len <= s->size) {
+	if (seq_buf_can_fit(s, len)) {
 		memcpy(s->buffer + s->len, str, len);
 		s->len += len;
 		return 0;
@@ -188,7 +193,7 @@ int seq_buf_putc(struct seq_buf *s, unsigned char c)
 {
 	WARN_ON(s->size == 0);
 
-	if (s->len + 1 <= s->size) {
+	if (seq_buf_can_fit(s, 1)) {
 		s->buffer[s->len++] = c;
 		return 0;
 	}
@@ -212,7 +217,7 @@ int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len)
 {
 	WARN_ON(s->size == 0);
 
-	if (s->len + len <= s->size) {
+	if (seq_buf_can_fit(s, len)) {
 		memcpy(s->buffer + s->len, mem, len);
 		s->len += len;
 		return 0;
@@ -332,7 +337,7 @@ int seq_buf_to_user(struct seq_buf *s, char __user *ubuf, int cnt)
 	if (s->len <= s->readpos)
 		return -EBUSY;
 
-	len = s->len - s->readpos;
+	len = seq_buf_used(s) - s->readpos;
 	if (cnt > len)
 		cnt = len;
 	ret = copy_to_user(ubuf, s->buffer + s->readpos, cnt);
