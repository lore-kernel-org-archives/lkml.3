Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab3C0Jt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:49:58 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:45755 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab3C0Jt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:49:56 -0400
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
CC: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH 11/14] tracing: use per trace_array clock_id instead of global trace_clock_id
Date: Wed, 27 Mar 2013 17:48:53 +0800
Message-ID: <1364377737-10540-13-git-send-email-jovi.zhangwei@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
References: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

tracing clock id already changed into per trace_array variable,
but there still use global trace_clock_id, which value always is 0 now.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/trace/trace.c |    8 +++-----
 kernel/trace/trace.h |    2 --
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index dd0c122..ee4e110 100644
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
@@ -2806,7 +2804,7 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 		iter->iter_flags |= TRACE_FILE_ANNOTATE;
 
 	/* Output in nanoseconds only if we are using a clock in nanoseconds. */
-	if (trace_clocks[trace_clock_id].in_ns)
+	if (trace_clocks[tr->clock_id].in_ns)
 		iter->iter_flags |= TRACE_FILE_TIME_IN_NS;
 
 	/* stop the trace while dumping if we are not opening "snapshot" */
@@ -3805,7 +3803,7 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 		iter->iter_flags |= TRACE_FILE_LAT_FMT;
 
 	/* Output in nanoseconds only if we are using a clock in nanoseconds. */
-	if (trace_clocks[trace_clock_id].in_ns)
+	if (trace_clocks[tr->clock_id].in_ns)
 		iter->iter_flags |= TRACE_FILE_TIME_IN_NS;
 
 	iter->cpu_file = tc->cpu;
@@ -5075,7 +5073,7 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 	cnt = ring_buffer_bytes_cpu(trace_buf->buffer, cpu);
 	trace_seq_printf(s, "bytes: %ld\n", cnt);
 
-	if (trace_clocks[trace_clock_id].in_ns) {
+	if (trace_clocks[tr->clock_id].in_ns) {
 		/* local or global for trace_clock */
 		t = ns2usecs(ring_buffer_oldest_event_ts(trace_buf->buffer, cpu));
 		usec_rem = do_div(t, USEC_PER_SEC);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index a244fbc..19e3da2 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -588,8 +588,6 @@ enum print_line_t print_trace_line(struct trace_iterator *iter);
 
 extern unsigned long trace_flags;
 
-extern int trace_clock_id;
-
 /* Standard output formatting function used for function return traces */
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
-- 
1.7.9.7


