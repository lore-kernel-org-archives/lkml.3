Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaG2McT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:32:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43808 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400AbaG2McR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:32:17 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v4 1/3] ring-buffer: Race when writing and swapping cpu buffer in parallel
Date: Tue, 29 Jul 2014 14:31:41 +0200
Message-Id: <1406637103-15435-2-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1406637103-15435-1-git-send-email-pmladek@suse.cz>
References: <1406637103-15435-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trace/ring_buffer allows to swap the entire ring buffer. Everything has to
be done lockless. I think that I have found a race when trying to understand
the code. The problematic situation is the following:

CPU 1 (write/reserve event)		CPU 2 (swap the cpu buffer)
-------------------------------------------------------------------------
ring_buffer_write()
  if (cpu_buffer->record_disabled)
  ^^^ test fails and write continues

					ring_buffer_swap_cpu()

					  inc(&cpu_buffer_a->record_disabled);
					  inc(&cpu_buffer_b->record_disabled);

					  if (cpu_buffer_a->committing)
					  ^^^ test fails and swap continues
					  if (cpu_buffer_b->committing)
					  ^^^ test fails and swap continues

  rb_reserve_next_event()
    rb_start_commit()
      local_inc(&cpu_buffer->committing);
      local_inc(&cpu_buffer->commits);

    if (unlikely(ACCESS_ONCE(cpu_buffer->buffer) != buffer)) {
    ^^^ test fails and reserve_next continues

					  buffer_a->buffers[cpu] = cpu_buffer_b;
					  buffer_b->buffers[cpu] = cpu_buffer_a;
					  cpu_buffer_b->buffer = buffer_a;
					  cpu_buffer_a->buffer = buffer_b;

  Pheeee, reservation continues in the removed buffer.

This patch solves the problem by swapping the CPU buffer on the same CPU. It
helps to avoid memory barriers and keep both writing and swapping fast.

The limitation is that it cannot longer be called from another CPU with
disabled IRQs. It affects check_critical_timing() and tracing_snapshot_write().
Both callers will get fixed by followup patches.

In addition, the patch removes the obsolete check in rb_reserve_next_event().
The swap operation is not allowed in NMI context, it is done on the same CPU,
and therefore it could newer interrupt any write.

Finally, it adds some comments about why the reserve and swap operations are
safe. I hope that I have got it right :-)

Changes:
  + v4: handle correctly call with disabled IRQs; add followup patches
	to update callers in the tracing framework; problem found and solution
	proposed by Steven Rostedt <rostedt@goodmis.org>

  + v3: removes the check in  rb_reserve_next_event(); idea by Steven Rostedt
	<rostedt@goodmis.org>

  + v2: does the swap on the same CPU instead of using memory barriers;
	idea by Steven Rostedt <rostedt@goodmis.org>

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/trace/ring_buffer.c | 115 +++++++++++++++++++++++++++++++--------------
 1 file changed, 81 insertions(+), 34 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7c56c3d06943..038b880347ba 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2527,21 +2527,6 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 
 	rb_start_commit(cpu_buffer);
 
-#ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
-	/*
-	 * Due to the ability to swap a cpu buffer from a buffer
-	 * it is possible it was swapped before we committed.
-	 * (committing stops a swap). We check for it here and
-	 * if it happened, we have to fail the write.
-	 */
-	barrier();
-	if (unlikely(ACCESS_ONCE(cpu_buffer->buffer) != buffer)) {
-		local_dec(&cpu_buffer->committing);
-		local_dec(&cpu_buffer->commits);
-		return NULL;
-	}
-#endif
-
 	length = rb_calculate_event_length(length);
  again:
 	add_timestamp = 0;
@@ -4280,23 +4265,42 @@ int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu)
 EXPORT_SYMBOL_GPL(ring_buffer_empty_cpu);
 
 #ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
+struct ring_buffer_swap_info {
+	struct ring_buffer *buffer_a;	/* One buffer to swap with */
+	struct ring_buffer *buffer_b;	/* The other buffer to swap with */
+	int ret;			/* Return value from the swap op. */
+};
+
 /**
- * ring_buffer_swap_cpu - swap a CPU buffer between two ring buffers
- * @buffer_a: One buffer to swap with
- * @buffer_b: The other buffer to swap with
+ * ring_buffer_swap_this_cpu - swap CPU buffer, related to this CPU,
+ *	between two ring buffers.
+ * @arg: arguments and return value is passed via struct ring_buffer_swap_info.
  *
- * This function is useful for tracers that want to take a "snapshot"
- * of a CPU buffer and has another back up buffer lying around.
- * it is expected that the tracer handles the cpu buffer not being
- * used at the moment.
+ * The swapping of a CPU buffer is done on the same CPU. It helps to avoid
+ * memory barriers and keep writing fast. We can't use synchronize_sched
+ * here because this function can be called in atomic context.
  */
-int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
-			 struct ring_buffer *buffer_b, int cpu)
+static void ring_buffer_swap_this_cpu(void *arg)
 {
+	struct ring_buffer_swap_info *rb_swap_info = arg;
+	struct ring_buffer *buffer_a;
+	struct ring_buffer *buffer_b;
 	struct ring_buffer_per_cpu *cpu_buffer_a;
 	struct ring_buffer_per_cpu *cpu_buffer_b;
-	int ret = -EINVAL;
+	int cpu = smp_processor_id();
 
+	/*
+	 * The buffer for this CPU is swapped. It does not make sense
+	 * to call this function with IRQs enabled.
+	 */
+	rb_swap_info->ret = -EPERM;
+	if (WARN_ON_ONCE(!irqs_disabled()))
+		return;
+
+	buffer_a = rb_swap_info->buffer_a;
+	buffer_b = rb_swap_info->buffer_b;
+
+	rb_swap_info->ret = -EINVAL;
 	if (!cpumask_test_cpu(cpu, buffer_a->cpumask) ||
 	    !cpumask_test_cpu(cpu, buffer_b->cpumask))
 		goto out;
@@ -4308,7 +4312,8 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 	if (cpu_buffer_a->nr_pages != cpu_buffer_b->nr_pages)
 		goto out;
 
-	ret = -EAGAIN;
+	/* Also check if the buffers can be manipulated */
+	rb_swap_info->ret = -EAGAIN;
 
 	if (ring_buffer_flags != RB_BUFFERS_ON)
 		goto out;
@@ -4326,15 +4331,19 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 		goto out;
 
 	/*
-	 * We can't do a synchronize_sched here because this
-	 * function can be called in atomic context.
-	 * Normally this will be called from the same CPU as cpu.
-	 * If not it's up to the caller to protect this.
+	 * Recording has to be disabled. Otherwise, ring_buffer_lock_reserve()
+	 * and ring_buffer_unlock_commit() might operate with different
+	 * cpu buffers.
+	 *
+	 * All other operations are safe. Read gets the CPU buffer only once
+	 * and then works with it. Resize does the critical operation on the
+	 * same CPU with disabled interrupts.
 	 */
 	atomic_inc(&cpu_buffer_a->record_disabled);
 	atomic_inc(&cpu_buffer_b->record_disabled);
 
-	ret = -EBUSY;
+	/* Bail out if we interrupted some recording */
+	rb_swap_info->ret = -EBUSY;
 	if (local_read(&cpu_buffer_a->committing))
 		goto out_dec;
 	if (local_read(&cpu_buffer_b->committing))
@@ -4346,13 +4355,51 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 	cpu_buffer_b->buffer = buffer_a;
 	cpu_buffer_a->buffer = buffer_b;
 
-	ret = 0;
-
+	rb_swap_info->ret = 0;
 out_dec:
 	atomic_dec(&cpu_buffer_a->record_disabled);
 	atomic_dec(&cpu_buffer_b->record_disabled);
 out:
-	return ret;
+	return;
+}
+
+/**
+ * ring_buffer_swap_cpu - swap a CPU buffer between two ring buffers
+ * @buffer_a: One buffer to swap with
+ * @buffer_b: The other buffer to swap with
+ *
+ * This function is useful for tracers that want to take a "snapshot"
+ * of a CPU buffer and has another back up buffer lying around.
+ * It is expected that the tracer handles the cpu buffer not being
+ * used at the moment.
+ */
+int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
+			 struct ring_buffer *buffer_b, int cpu)
+{
+	struct ring_buffer_swap_info rb_swap_info = {
+		.buffer_a = buffer_a,
+		.buffer_b = buffer_b,
+	};
+	int ret = 0;
+
+	/*
+	 * Swap the CPU buffer on the same CPU. Recording has to be fast
+	 * and and this helps to avoid memory barriers.
+	 */
+	if (irqs_disabled()) {
+		/* Only allowed to swap current CPU if irqs are disabled */
+		if (WARN_ON_ONCE(cpu != smp_processor_id()))
+			return -EPERM;
+		ring_buffer_swap_this_cpu(&rb_swap_info);
+	} else {
+		ret = smp_call_function_single(cpu, ring_buffer_swap_this_cpu,
+					       (void *)&rb_swap_info, 1);
+	}
+
+	if (ret)
+		return ret;
+
+	return rb_swap_info.ret;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_swap_cpu);
 #endif /* CONFIG_RING_BUFFER_ALLOW_SWAP */
-- 
1.8.4

