Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab3AWUgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 15:36:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16406 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab3AWUeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 15:34:36 -0500
X-Authority-Analysis: v=2.0 cv=QcjkT7nv c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=nH_ZYoD11S8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=HrQT0s1en64A:10 a=20KFwNOVAAAA:8 a=zRbQ-iiXTHIWYcTDm-0A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130123203434.909357811@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 23 Jan 2013 15:30:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 11/12 -next] ring-buffer: User context bit recursion checking
References: <20130123203002.957226869@goodmis.org>
Content-Disposition: inline; filename=0011-ring-buffer-User-context-bit-recursion-checking.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Using context bit recursion checking, we can help increase the
performance of the ring buffer.

Before this patch:

 # echo function > /debug/tracing/current_tracer
 # for i in `seq 10`; do ./hackbench 50; done
Time: 10.285
Time: 10.407
Time: 10.243
Time: 10.372
Time: 10.380
Time: 10.198
Time: 10.272
Time: 10.354
Time: 10.248
Time: 10.253

(average: 10.3012)

Now we have:

 # echo function > /debug/tracing/current_tracer
 # for i in `seq 10`; do ./hackbench 50; done
Time: 9.712
Time: 9.824
Time: 9.861
Time: 9.827
Time: 9.962
Time: 9.905
Time: 9.886
Time: 10.088
Time: 9.861
Time: 9.834

(average: 9.876)

 a 4% savings!

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   85 +++++++++++++++++++++++++++++++-------------
 kernel/trace/trace.h       |   13 +++----
 2 files changed, 67 insertions(+), 31 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 6ff9cc4..481e262 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2432,41 +2432,76 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 
 #ifdef CONFIG_TRACING
 
-#define TRACE_RECURSIVE_DEPTH 16
+/*
+ * The lock and unlock are done within a preempt disable section.
+ * The current_context per_cpu variable can only be modified
+ * by the current task between lock and unlock. But it can
+ * be modified more than once via an interrupt. To pass this
+ * information from the lock to the unlock without having to
+ * access the 'in_interrupt()' functions again (which do show
+ * a bit of overhead in something as critical as function tracing,
+ * we use a bitmask trick.
+ *
+ *  bit 0 =  NMI context
+ *  bit 1 =  IRQ context
+ *  bit 2 =  SoftIRQ context
+ *  bit 3 =  normal context.
+ *
+ * This works because this is the order of contexts that can
+ * preempt other contexts. A SoftIRQ never preempts an IRQ
+ * context.
+ *
+ * When the context is determined, the corresponding bit is
+ * checked and set (if it was set, then a recursion of that context
+ * happened).
+ *
+ * On unlock, we need to clear this bit. To do so, just subtract
+ * 1 from the current_context and AND it to itself.
+ *
+ * (binary)
+ *  101 - 1 = 100
+ *  101 & 100 = 100 (clearing bit zero)
+ *
+ *  1010 - 1 = 1001
+ *  1010 & 1001 = 1000 (clearing bit 1)
+ *
+ * The least significant bit can be cleared this way, and it
+ * just so happens that it is the same bit corresponding to
+ * the current context.
+ */
+static DEFINE_PER_CPU(unsigned int, current_context);
 
-/* Keep this code out of the fast path cache */
-static noinline void trace_recursive_fail(void)
+static __always_inline int trace_recursive_lock(void)
 {
-	/* Disable all tracing before we do anything else */
-	tracing_off_permanent();
-
-	printk_once(KERN_WARNING "Tracing recursion: depth[%ld]:"
-		    "HC[%lu]:SC[%lu]:NMI[%lu]\n",
-		    trace_recursion_buffer(),
-		    hardirq_count() >> HARDIRQ_SHIFT,
-		    softirq_count() >> SOFTIRQ_SHIFT,
-		    in_nmi());
+	unsigned int val = this_cpu_read(current_context);
+	int bit;
 
-	WARN_ON_ONCE(1);
-}
-
-static inline int trace_recursive_lock(void)
-{
-	trace_recursion_inc();
+	if (in_interrupt()) {
+		if (in_nmi())
+			bit = 0;
+		else if (in_irq())
+			bit = 1;
+		else
+			bit = 2;
+	} else
+		bit = 3;
 
-	if (likely(trace_recursion_buffer() < TRACE_RECURSIVE_DEPTH))
-		return 0;
+	if (unlikely(val & (1 << bit)))
+		return 1;
 
-	trace_recursive_fail();
+	val |= (1 << bit);
+	this_cpu_write(current_context, val);
 
-	return -1;
+	return 0;
 }
 
-static inline void trace_recursive_unlock(void)
+static __always_inline void trace_recursive_unlock(void)
 {
-	WARN_ON_ONCE(!trace_recursion_buffer());
+	unsigned int val = this_cpu_read(current_context);
 
-	trace_recursion_dec();
+	val--;
+	val &= this_cpu_read(current_context);
+	this_cpu_write(current_context, val);
 }
 
 #else
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index c203a51..04a2c7a 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -291,11 +291,6 @@ struct tracer {
 
 
 /* Only current can touch trace_recursion */
-#define trace_recursion_inc() do { (current)->trace_recursion++; } while (0)
-#define trace_recursion_dec() do { (current)->trace_recursion--; } while (0)
-
-/* Ring buffer has the 10 LSB bits to count */
-#define trace_recursion_buffer() ((current)->trace_recursion & 0x3ff)
 
 /*
  * For function tracing recursion:
@@ -323,7 +318,13 @@ struct tracer {
  * caller, and we can skip the current check.
  */
 enum {
-	TRACE_FTRACE_BIT = 11,
+	TRACE_BUFFER_BIT,
+	TRACE_BUFFER_NMI_BIT,
+	TRACE_BUFFER_IRQ_BIT,
+	TRACE_BUFFER_SIRQ_BIT,
+
+	/* Start of function recursion bits */
+	TRACE_FTRACE_BIT,
 	TRACE_FTRACE_NMI_BIT,
 	TRACE_FTRACE_IRQ_BIT,
 	TRACE_FTRACE_SIRQ_BIT,
-- 
1.7.10.4


