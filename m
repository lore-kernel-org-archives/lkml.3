Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaKRDVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 22:21:50 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:10359 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751547AbaKRDVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 22:21:49 -0500
Date: Mon, 17 Nov 2014 22:21:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 00/26 v5] trace-seq/seq-buf/x86/printk: Print all stacks
 from NMI safely
Message-ID: <20141117222145.5c55a0f3@gandalf.local.home>
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

So far the only difference between v5 I have is that I split the update
of tracing_fill_pipe_page() out of "tracing: Use trace_seq_used() and
seq_buf_used() instead of len", and this:

-- Steve

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9f1ffc707f3b..9023446b2c2b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4601,7 +4601,7 @@ tracing_fill_pipe_page(size_t rem, struct trace_iterator *iter)
 		count = trace_seq_used(&iter->seq) - save_len;
 		if (rem < count) {
 			rem = 0;
-			iter->seq.seq.len = save_len;;
+			iter->seq.seq.len = save_len;
 			break;
 		}
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 2193e8038681..a72f3d8d813e 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -131,6 +131,10 @@ print_syscall_enter(struct trace_iterator *iter, int flags,
 	trace_seq_printf(s, "%s(", entry->name);
 
 	for (i = 0; i < entry->nb_args; i++) {
+
+		if (trace_seq_has_overflowed(s))
+			goto end;
+
 		/* parameter types */
 		if (trace_flags & TRACE_ITER_VERBOSE)
 			trace_seq_printf(s, "%s ", entry->types[i]);
diff --git a/lib/seq_buf.c b/lib/seq_buf.c
index a2288ca567a3..4eedfedb9e31 100644
--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -16,6 +16,14 @@
 #include <linux/seq_file.h>
 #include <linux/seq_buf.h>
 
+/**
+ * seq_buf_can_fit - can the new data fit in the current buffer?
+ * @s: the seq_buf descriptor
+ * @len: The length to see if it can fit in the current buffer
+ *
+ * Returns true if there's enough unused space in the seq_buf buffer
+ * to fit the amount of new data according to @len.
+ */
 static bool seq_buf_can_fit(struct seq_buf *s, size_t len)
 {
 	return s->len + len <= s->size;
