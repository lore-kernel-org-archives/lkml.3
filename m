Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab3DWB3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 21:29:17 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:44724 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab3DWB3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 21:29:16 -0400
X-AuditID: 85900ec0-d4ccab900000151e-32-5175e3e8b71c
Subject: [PATCH -tip] ftrace: Fix outputting formats of x86-tsc and counter
 when use trace_clock
To: linux-kernel@vger.kernel.org
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Tue, 23 Apr 2013 10:32:39 +0900
Message-ID: <20130423013239.22334.7394.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Outputting formats of x86-tsc and counter should be a raw format, but after
applying the patch(2b6080f28c7cc3efc8625ab71495aae89aeb63a0), the format was
changed to nanosec. This is because the global variable trace_clock_id was used.
When we use multiple buffers, clock_id of each sub-buffer should be used. Then,
this patch uses tr->clock_id instead of the global variable trace_clock_id.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/trace.c |    8 +++-----
 kernel/trace/trace.h |    2 --
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7297079..2ab9ccb 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -652,8 +652,6 @@ static struct {
 	ARCH_TRACE_CLOCKS
 };
 
-int trace_clock_id;
-
 /*
  * trace_parser_get_init - gets the buffer for trace parser
  */
@@ -2815,7 +2813,7 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 		iter->iter_flags |= TRACE_FILE_ANNOTATE;
 
 	/* Output in nanoseconds only if we are using a clock in nanoseconds. */
-	if (trace_clocks[trace_clock_id].in_ns)
+	if (trace_clocks[tr->clock_id].in_ns)
 		iter->iter_flags |= TRACE_FILE_TIME_IN_NS;
 
 	/* stop the trace while dumping if we are not opening "snapshot" */
@@ -3814,7 +3812,7 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 		iter->iter_flags |= TRACE_FILE_LAT_FMT;
 
 	/* Output in nanoseconds only if we are using a clock in nanoseconds. */
-	if (trace_clocks[trace_clock_id].in_ns)
+	if (trace_clocks[tr->clock_id].in_ns)
 		iter->iter_flags |= TRACE_FILE_TIME_IN_NS;
 
 	iter->cpu_file = tc->cpu;
@@ -5084,7 +5082,7 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 	cnt = ring_buffer_bytes_cpu(trace_buf->buffer, cpu);
 	trace_seq_printf(s, "bytes: %ld\n", cnt);
 
-	if (trace_clocks[trace_clock_id].in_ns) {
+	if (trace_clocks[tr->clock_id].in_ns) {
 		/* local or global for trace_clock */
 		t = ns2usecs(ring_buffer_oldest_event_ts(trace_buf->buffer, cpu));
 		usec_rem = do_div(t, USEC_PER_SEC);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9e01458..0ae9e8a 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -705,8 +705,6 @@ enum print_line_t print_trace_line(struct trace_iterator *iter);
 
 extern unsigned long trace_flags;
 
-extern int trace_clock_id;
-
 /* Standard output formatting function used for function return traces */
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 

