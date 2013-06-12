Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670Ab3FLBGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 21:06:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab3FLBGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 21:06:09 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=YFVuyZFqpzEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=J0NPbRLP794A:10 a=VwQbUJbxAAAA:8 a=3nbZYyFuAAAA:8 a=3S4UGLa6ViCKBmvxCUYA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370999166.9844.235.camel@gandalf.local.home>
Subject: [PATCH][GIT PULL] tracing: Fix outputting formats of x86-tsc and
 counter when use trace_clock
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Date: Tue, 11 Jun 2013 21:06:06 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Yoshihiro Yunomae fixed a regression in the output format when using
one of the counter clocks. The new multibuffer code changed the trace_clock
file to update the trace instances tr->clock_id but the actual traces still
used the value from the obsolete global variable trace_clock_id.

Please pull the latest trace-fixes-v3.10-rc5 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.10-rc5

Tag SHA1: b8e6ba8d6e642b2c0a9515de7d0d6f7034f46f68
Head SHA1: 58e8eedf18577c7eac722d5d1f190507ea263d1b


Yoshihiro YUNOMAE (1):
      tracing: Fix outputting formats of x86-tsc and counter when use trace_clock

----
 kernel/trace/trace.c |    8 +++-----
 kernel/trace/trace.h |    2 --
 2 files changed, 3 insertions(+), 7 deletions(-)
---------------------------
commit 58e8eedf18577c7eac722d5d1f190507ea263d1b
Author: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Date:   Tue Apr 23 10:32:39 2013 +0900

    tracing: Fix outputting formats of x86-tsc and counter when use trace_clock
    
    Outputting formats of x86-tsc and counter should be a raw format, but after
    applying the patch(2b6080f28c7cc3efc8625ab71495aae89aeb63a0), the format was
    changed to nanosec. This is because the global variable trace_clock_id was used.
    When we use multiple buffers, clock_id of each sub-buffer should be used. Then,
    this patch uses tr->clock_id instead of the global variable trace_clock_id.
    
    [ Basically, this fixes a regression where the multibuffer code changed the
      trace_clock file to update tr->clock_id but the traces still use the old
      global trace_clock_id variable, negating the file's effect. The global
      trace_clock_id variable is obsolete and removed. - SR ]
    
    Link: http://lkml.kernel.org/r/20130423013239.22334.7394.stgit@yunodevel
    
    Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 1a41023..e71a8be 100644
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
@@ -2826,7 +2824,7 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 		iter->iter_flags |= TRACE_FILE_ANNOTATE;
 
 	/* Output in nanoseconds only if we are using a clock in nanoseconds. */
-	if (trace_clocks[trace_clock_id].in_ns)
+	if (trace_clocks[tr->clock_id].in_ns)
 		iter->iter_flags |= TRACE_FILE_TIME_IN_NS;
 
 	/* stop the trace while dumping if we are not opening "snapshot" */
@@ -3825,7 +3823,7 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 		iter->iter_flags |= TRACE_FILE_LAT_FMT;
 
 	/* Output in nanoseconds only if we are using a clock in nanoseconds. */
-	if (trace_clocks[trace_clock_id].in_ns)
+	if (trace_clocks[tr->clock_id].in_ns)
 		iter->iter_flags |= TRACE_FILE_TIME_IN_NS;
 
 	iter->cpu_file = tc->cpu;
@@ -5095,7 +5093,7 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 	cnt = ring_buffer_bytes_cpu(trace_buf->buffer, cpu);
 	trace_seq_printf(s, "bytes: %ld\n", cnt);
 
-	if (trace_clocks[trace_clock_id].in_ns) {
+	if (trace_clocks[tr->clock_id].in_ns) {
 		/* local or global for trace_clock */
 		t = ns2usecs(ring_buffer_oldest_event_ts(trace_buf->buffer, cpu));
 		usec_rem = do_div(t, USEC_PER_SEC);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 711ca7d..20572ed 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -700,8 +700,6 @@ enum print_line_t print_trace_line(struct trace_iterator *iter);
 
 extern unsigned long trace_flags;
 
-extern int trace_clock_id;
-
 /* Standard output formatting function used for function return traces */
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 


