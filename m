Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700Ab3CHDHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:07:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8123 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760287Ab3CHDG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:06:56 -0500
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=0PbznsJNoqIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=smO_UAbdURIA:10 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=JfrnYn6hAAAA:8 a=INGKewmq4RbIql4W7r0A:9 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=Zh68SRI7RUMA:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130308030654.221050352@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Mar 2013 22:00:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [for-next][PATCH 15/17] tracing: Add internal tracing_snapshot() functions
References: <20130308025958.501479677@goodmis.org>
Content-Disposition: inline; filename=0015-tracing-Add-internal-tracing_snapshot-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <srostedt@redhat.com>

The new snapshot feature is quite handy. It's a way for the user
to take advantage of the spare buffer that, until then, only
the latency tracers used to "snapshot" the buffer when it hit
a max latency. Now users can trigger a "snapshot" manually when
some condition is hit in a program. But a snapshot currently can
not be triggered by a condition inside the kernel.

With the addition of tracing_snapshot() and tracing_snapshot_alloc(),
snapshots can now be taking when a condition is hit, and the
developer wants to snapshot the case without stopping the trace.

Note, any snapshot will overwrite the old one, so take care
in how this is done.

These new functions are to be used like tracing_on(), tracing_off()
and trace_printk() are. That is, they should never be called
in the mainline Linux kernel. They are solely for the purpose
of debugging.

The tracing_snapshot() will not allocate a buffer, but it is
safe to be called from any context (except NMIs). But if a
snapshot buffer isn't allocated when it is called, it will write
to the live buffer, complaining about the lack of a snapshot
buffer, and then stop tracing (giving you the "permanent snapshot").

tracing_snapshot_alloc() will allocate the snapshot buffer if
it was not already allocated and then take the snapshot. This routine
*may sleep*, and must be called from context that can sleep.
The allocation is done with GFP_KERNEL and not atomic.

If you need a snapshot in an atomic context, say in early boot,
then it is best to call the tracing_snapshot_alloc() before then,
where it will allocate the buffer, and then you can use the
tracing_snapshot() anywhere you want and still get snapshots.

Cc: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/kernel.h |    4 +++
 kernel/trace/trace.c   |   84 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index c566927..bc5392a 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -483,6 +483,8 @@ enum ftrace_dump_mode {
 void tracing_on(void);
 void tracing_off(void);
 int tracing_is_on(void);
+void tracing_snapshot(void);
+void tracing_snapshot_alloc(void);
 
 extern void tracing_start(void);
 extern void tracing_stop(void);
@@ -570,6 +572,8 @@ static inline void trace_dump_stack(void) { }
 static inline void tracing_on(void) { }
 static inline void tracing_off(void) { }
 static inline int tracing_is_on(void) { return 0; }
+static inline void tracing_snapshot(void) { }
+static inline void tracing_snapshot_alloc(void) { }
 
 static inline __printf(1, 2)
 int trace_printk(const char *fmt, ...)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8ede7d1..c15ba8b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -339,6 +339,90 @@ void tracing_on(void)
 }
 EXPORT_SYMBOL_GPL(tracing_on);
 
+#ifdef CONFIG_TRACER_SNAPSHOT
+/**
+ * trace_snapshot - take a snapshot of the current buffer.
+ *
+ * This causes a swap between the snapshot buffer and the current live
+ * tracing buffer. You can use this to take snapshots of the live
+ * trace when some condition is triggered, but continue to trace.
+ *
+ * Note, make sure to allocate the snapshot with either
+ * a tracing_snapshot_alloc(), or by doing it manually
+ * with: echo 1 > /sys/kernel/debug/tracing/snapshot
+ *
+ * If the snapshot buffer is not allocated, it will stop tracing.
+ * Basically making a permanent snapshot.
+ */
+void tracing_snapshot(void)
+{
+	struct trace_array *tr = &global_trace;
+	struct tracer *tracer = tr->current_trace;
+	unsigned long flags;
+
+	if (!tr->allocated_snapshot) {
+		trace_printk("*** SNAPSHOT NOT ALLOCATED ***\n");
+		trace_printk("*** stopping trace here!   ***\n");
+		tracing_off();
+		return;
+	}
+
+	/* Note, snapshot can not be used when the tracer uses it */
+	if (tracer->use_max_tr) {
+		trace_printk("*** LATENCY TRACER ACTIVE ***\n");
+		trace_printk("*** Can not use snapshot (sorry) ***\n");
+		return;
+	}
+
+	local_irq_save(flags);
+	update_max_tr(tr, current, smp_processor_id());
+	local_irq_restore(flags);
+}
+
+static int resize_buffer_duplicate_size(struct trace_buffer *trace_buf,
+					struct trace_buffer *size_buf, int cpu_id);
+
+/**
+ * trace_snapshot_alloc - allocate and take a snapshot of the current buffer.
+ *
+ * This is similar to trace_snapshot(), but it will allocate the
+ * snapshot buffer if it isn't already allocated. Use this only
+ * where it is safe to sleep, as the allocation may sleep.
+ *
+ * This causes a swap between the snapshot buffer and the current live
+ * tracing buffer. You can use this to take snapshots of the live
+ * trace when some condition is triggered, but continue to trace.
+ */
+void tracing_snapshot_alloc(void)
+{
+	struct trace_array *tr = &global_trace;
+	int ret;
+
+	if (!tr->allocated_snapshot) {
+
+		/* allocate spare buffer */
+		ret = resize_buffer_duplicate_size(&tr->max_buffer,
+				   &tr->trace_buffer, RING_BUFFER_ALL_CPUS);
+		if (WARN_ON(ret < 0))
+			return;
+
+		tr->allocated_snapshot = true;
+	}
+
+	tracing_snapshot();
+}
+#else
+void tracing_snapshot(void)
+{
+	WARN_ONCE(1, "Snapshot feature not enabled, but internal snapshot used");
+}
+void tracing_snapshot_alloc(void)
+{
+	/* Give warning */
+	tracing_snapshot();
+}
+#endif /* CONFIG_TRACER_SNAPSHOT */
+
 /**
  * tracing_off - turn off tracing buffers
  *
-- 
1.7.10.4


