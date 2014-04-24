Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393AbaDXQNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:13:08 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:34376 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758165AbaDXQDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:03:24 -0400
Message-Id: <20140424160320.134145635@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 24 Apr 2014 12:02:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 3/8] tracing: Move ftrace_max_lock into trace_array
References: <20140424160232.271454710@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-tracing-Move-ftrace_max_lock-into-trace_array.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

In preparation for having tracers enabled in instances, the max_lock
should be unique as updating the max for one tracer is a separate
operation than updating it for another tracer using a different max.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c          | 40 ++++++++++++++--------------------------
 kernel/trace/trace.h          | 14 ++++++++++++++
 kernel/trace/trace_selftest.c |  4 ++--
 3 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f5fc56b..bb5147a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -963,22 +963,6 @@ static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 	return cnt;
 }
 
-/*
- * ftrace_max_lock is used to protect the swapping of buffers
- * when taking a max snapshot. The buffers themselves are
- * protected by per_cpu spinlocks. But the action of the swap
- * needs its own lock.
- *
- * This is defined as a arch_spinlock_t in order to help
- * with performance when lockdep debugging is enabled.
- *
- * It is also used in other places outside the update_max_tr
- * so it needs to be defined outside of the
- * CONFIG_TRACER_MAX_TRACE.
- */
-static arch_spinlock_t ftrace_max_lock =
-	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
-
 unsigned long __read_mostly	tracing_thresh;
 
 #ifdef CONFIG_TRACER_MAX_TRACE
@@ -1046,14 +1030,14 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 		return;
 	}
 
-	arch_spin_lock(&ftrace_max_lock);
+	arch_spin_lock(&tr->max_lock);
 
 	buf = tr->trace_buffer.buffer;
 	tr->trace_buffer.buffer = tr->max_buffer.buffer;
 	tr->max_buffer.buffer = buf;
 
 	__update_max_tr(tr, tsk, cpu);
-	arch_spin_unlock(&ftrace_max_lock);
+	arch_spin_unlock(&tr->max_lock);
 }
 
 /**
@@ -1079,7 +1063,7 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 		return;
 	}
 
-	arch_spin_lock(&ftrace_max_lock);
+	arch_spin_lock(&tr->max_lock);
 
 	ret = ring_buffer_swap_cpu(tr->max_buffer.buffer, tr->trace_buffer.buffer, cpu);
 
@@ -1097,7 +1081,7 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	WARN_ON_ONCE(ret && ret != -EAGAIN && ret != -EBUSY);
 
 	__update_max_tr(tr, tsk, cpu);
-	arch_spin_unlock(&ftrace_max_lock);
+	arch_spin_unlock(&tr->max_lock);
 }
 #endif /* CONFIG_TRACER_MAX_TRACE */
 
@@ -1351,7 +1335,7 @@ void tracing_start(void)
 	}
 
 	/* Prevent the buffers from switching */
-	arch_spin_lock(&ftrace_max_lock);
+	arch_spin_lock(&global_trace.max_lock);
 
 	buffer = global_trace.trace_buffer.buffer;
 	if (buffer)
@@ -1363,7 +1347,7 @@ void tracing_start(void)
 		ring_buffer_record_enable(buffer);
 #endif
 
-	arch_spin_unlock(&ftrace_max_lock);
+	arch_spin_unlock(&global_trace.max_lock);
 
 	ftrace_start();
  out:
@@ -1418,7 +1402,7 @@ void tracing_stop(void)
 		goto out;
 
 	/* Prevent the buffers from switching */
-	arch_spin_lock(&ftrace_max_lock);
+	arch_spin_lock(&global_trace.max_lock);
 
 	buffer = global_trace.trace_buffer.buffer;
 	if (buffer)
@@ -1430,7 +1414,7 @@ void tracing_stop(void)
 		ring_buffer_record_disable(buffer);
 #endif
 
-	arch_spin_unlock(&ftrace_max_lock);
+	arch_spin_unlock(&global_trace.max_lock);
 
  out:
 	raw_spin_unlock_irqrestore(&global_trace.start_lock, flags);
@@ -3331,7 +3315,7 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 	mutex_lock(&tracing_cpumask_update_lock);
 
 	local_irq_disable();
-	arch_spin_lock(&ftrace_max_lock);
+	arch_spin_lock(&tr->max_lock);
 	for_each_tracing_cpu(cpu) {
 		/*
 		 * Increase/decrease the disabled counter if we are
@@ -3348,7 +3332,7 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 			ring_buffer_record_enable_cpu(tr->trace_buffer.buffer, cpu);
 		}
 	}
-	arch_spin_unlock(&ftrace_max_lock);
+	arch_spin_unlock(&tr->max_lock);
 	local_irq_enable();
 
 	cpumask_copy(tr->tracing_cpumask, tracing_cpumask_new);
@@ -6129,6 +6113,8 @@ static int new_instance_create(const char *name)
 
 	raw_spin_lock_init(&tr->start_lock);
 
+	tr->max_lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
+
 	tr->current_trace = &nop_trace;
 
 	INIT_LIST_HEAD(&tr->systems);
@@ -6627,6 +6613,8 @@ __init static int tracer_alloc_buffers(void)
 	 */
 	global_trace.current_trace = &nop_trace;
 
+	global_trace.max_lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
+
 	ftrace_init_global_array_ops(&global_trace);
 
 	register_tracer(&nop_trace);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 644a8b5..5d2f07d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -192,6 +192,20 @@ struct trace_array {
 	bool			allocated_snapshot;
 	unsigned long		max_latency;
 #endif
+	/*
+	 * max_lock is used to protect the swapping of buffers
+	 * when taking a max snapshot. The buffers themselves are
+	 * protected by per_cpu spinlocks. But the action of the swap
+	 * needs its own lock.
+	 *
+	 * This is defined as a arch_spinlock_t in order to help
+	 * with performance when lockdep debugging is enabled.
+	 *
+	 * It is also used in other places outside the update_max_tr
+	 * so it needs to be defined outside of the
+	 * CONFIG_TRACER_MAX_TRACE.
+	 */
+	arch_spinlock_t		max_lock;
 	int			buffer_disabled;
 #ifdef CONFIG_FTRACE_SYSCALLS
 	int			sys_refcount_enter;
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index ac31858..1c95cd7 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -65,7 +65,7 @@ static int trace_test_buffer(struct trace_buffer *buf, unsigned long *count)
 
 	/* Don't allow flipping of max traces now */
 	local_irq_save(flags);
-	arch_spin_lock(&ftrace_max_lock);
+	arch_spin_lock(&buf->tr->max_lock);
 
 	cnt = ring_buffer_entries(buf->buffer);
 
@@ -83,7 +83,7 @@ static int trace_test_buffer(struct trace_buffer *buf, unsigned long *count)
 			break;
 	}
 	tracing_on();
-	arch_spin_unlock(&ftrace_max_lock);
+	arch_spin_unlock(&buf->tr->max_lock);
 	local_irq_restore(flags);
 
 	if (count)
-- 
1.8.5.3


