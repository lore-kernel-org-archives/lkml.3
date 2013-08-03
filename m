Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab3HCBmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 21:42:11 -0400
Received: from mail-qe0-f74.google.com ([209.85.128.74]:41628 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab3HCBmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 21:42:09 -0400
From: Alexander Z Lam <azl@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>
Subject: [PATCH 2/3] tracing: Fix reset of time stamps during trace_clock changes
Date: Fri,  2 Aug 2013 18:36:16 -0700
Message-Id: <1375493777-17261-2-git-send-email-azl@google.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1375493777-17261-1-git-send-email-azl@google.com>
References: <1375493777-17261-1-git-send-email-azl@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed two issues with changing the timestamp clock with trace_clock:

 - The global buffer was reset on instance clock changes. Change this to pass
   the correct per-instance buffer
 - ftrace_now() is used to set buf->time_start in tracing_reset_online_cpus().
   This was incorrect because ftrace_now() used the global buffer's clock to
   return the current time. Change this to use buffer_ftrace_now() which
   returns the current time for the correct per-instance buffer.

Also removed tracing_reset_current() because it is not used anywhere

Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: David Sharp <dhsharp@google.com>
Cc: Alexander Z Lam <lambchop468@gmail.com>
Signed-off-by: Alexander Z Lam <azl@google.com>
---
 kernel/trace/trace.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9bfb889..678a88b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -243,20 +243,25 @@ int filter_current_check_discard(struct ring_buffer *buffer,
 }
 EXPORT_SYMBOL_GPL(filter_current_check_discard);
 
-cycle_t ftrace_now(int cpu)
+cycle_t buffer_ftrace_now(struct trace_buffer *buf, int cpu)
 {
 	u64 ts;
 
 	/* Early boot up does not have a buffer yet */
-	if (!global_trace.trace_buffer.buffer)
+	if (!buf->buffer)
 		return trace_clock_local();
 
-	ts = ring_buffer_time_stamp(global_trace.trace_buffer.buffer, cpu);
-	ring_buffer_normalize_time_stamp(global_trace.trace_buffer.buffer, cpu, &ts);
+	ts = ring_buffer_time_stamp(buf->buffer, cpu);
+	ring_buffer_normalize_time_stamp(buf->buffer, cpu, &ts);
 
 	return ts;
 }
 
+cycle_t ftrace_now(int cpu)
+{
+	return buffer_ftrace_now(&global_trace.trace_buffer, cpu);
+}
+
 /**
  * tracing_is_enabled - Show if global_trace has been disabled
  *
@@ -1211,7 +1216,7 @@ void tracing_reset_online_cpus(struct trace_buffer *buf)
 	/* Make sure all commits have finished */
 	synchronize_sched();
 
-	buf->time_start = ftrace_now(buf->cpu);
+	buf->time_start = buffer_ftrace_now(buf, buf->cpu);
 
 	for_each_online_cpu(cpu)
 		ring_buffer_reset_cpu(buffer, cpu);
@@ -1219,11 +1224,6 @@ void tracing_reset_online_cpus(struct trace_buffer *buf)
 	ring_buffer_record_enable(buffer);
 }
 
-void tracing_reset_current(int cpu)
-{
-	tracing_reset(&global_trace.trace_buffer, cpu);
-}
-
 /* Must have trace_types_lock held */
 void tracing_reset_all_online_cpus(void)
 {
@@ -4633,12 +4633,12 @@ static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
 	 * New clock may not be consistent with the previous clock.
 	 * Reset the buffer so that it doesn't have incomparable timestamps.
 	 */
-	tracing_reset_online_cpus(&global_trace.trace_buffer);
+	tracing_reset_online_cpus(&tr->trace_buffer);
 
 #ifdef CONFIG_TRACER_MAX_TRACE
 	if (tr->flags & TRACE_ARRAY_FL_GLOBAL && tr->max_buffer.buffer)
 		ring_buffer_set_clock(tr->max_buffer.buffer, trace_clocks[i].func);
-	tracing_reset_online_cpus(&global_trace.max_buffer);
+	tracing_reset_online_cpus(&tr->max_buffer);
 #endif
 
 	mutex_unlock(&trace_types_lock);
-- 
1.8.3

