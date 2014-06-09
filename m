Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbaFIUca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:32:30 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:16312 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751879AbaFIUc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:32:27 -0400
Date: Mon, 9 Jun 2014 16:32:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: tracing: NULL ptr deref in ring_buffer_wait
Message-ID: <20140609163225.333fabcd@gandalf.local.home>
In-Reply-To: <5393DB61.6060707@oracle.com>
References: <5366DFBF.6090204@oracle.com>
	<20140505104712.11c63a5d@gandalf.local.home>
	<5367B248.2010804@oracle.com>
	<536BA35D.50807@oracle.com>
	<20140508121624.4ca87b2c@gandalf.local.home>
	<5393DB61.6060707@oracle.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Jun 2014 23:41:21 -0400
Sasha Levin <sasha.levin@oracle.com> wrote:

> Hi Steven,
> 
> Yup, it took me *that* long to reproduce it again, but I can confirm that that
> BUG() gets hit (the printk shows cpu 30 like the BUG):
> 
> [ 2410.677199] kernel BUG at kernel/trace/ring_buffer.c:563!
> [ 2410.679445] can: request_module (can-proto-4) failed.
> [ 2410.680298] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [ 2410.680298] Dumping ftrace buffer:
> [ 2410.680298]    (ftrace buffer empty)
> [ 2410.680298] Modules linked in:
> [ 2410.680298] CPU: 30 PID: 34851 Comm: trinity-c88 Not tainted 3.15.0-rc8-next-20140606-sasha-00021-ga9d3a0b-dirty #596
> [ 2410.680298] task: ffff8802c866b000 ti: ffff8802c7724000 task.ti: ffff8802c7724000
> [ 2410.680298] RIP: ring_buffer_wait (kernel/trace/ring_buffer.c:563)
> [ 2410.680298] RSP: 0018:ffff8802c7727de8  EFLAGS: 00010296
> [ 2410.680298] RAX: 0000000000000013 RBX: 0000000000000024 RCX: 0000000000000006
> [ 2410.680298] RDX: 0000000000000001 RSI: ffffffffad5030db RDI: ffffffffaa1d8952
> [ 2410.711484] RBP: ffff8802c7727e38 R08: 0000000000000000 R09: 0000000000000000
> [ 2410.711484] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88003681e900
> [ 2410.711484] R13: ffff88006ce7d100 R14: 0000000000000000 R15: ffff8800530090fc
> [ 2410.721370] FS:  00007f8c14bad700(0000) GS:ffff8806cae00000(0000) knlGS:0000000000000000
> [ 2410.721370] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2410.721370] CR2: 00007f8c11440000 CR3: 000000029dd18000 CR4: 00000000000006a0
> [ 2410.721370] DR0: 00000000006d6000 DR1: 00000000006d6000 DR2: 0000000000000000
> [ 2410.721370] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> [ 2410.721370] Stack:
> [ 2410.721370]  ffff880053008028 0000000000000000 ffff8802c866b000 ffffffffaa1bb600
> [ 2410.721370]  ffff8802c7727e08 ffff8802c7727e08 ffff880053008000 ffff880053008028
> [ 2410.721370]  ffff88006ce7d100 ffff8802c866b000 ffff8802c7727e48 ffffffffaa24af8a
> [ 2410.721370] Call Trace:
> [ 2410.721370] ? bit_waitqueue (kernel/sched/wait.c:291)
> [ 2410.721370] wait_on_pipe (kernel/trace/trace.c:1095)
> [ 2410.721370] tracing_wait_pipe.isra.19 (kernel/trace/trace.c:4280)
> [ 2410.721370] tracing_read_pipe (kernel/trace/trace.c:4326)
> [ 2410.721370] vfs_read (fs/read_write.c:430)
> [ 2410.721370] SyS_read (fs/read_write.c:568 fs/read_write.c:560)
> [ 2410.721370] tracesys (arch/x86/kernel/entry_64.S:542)

Found it.

Let me guess, if you ls /sys/kernel/debug/tracing/per_cpu, you'll see
more CPUs than you have on the box. I have a box like this, and when I
cat the trace_pipe from one of the CPUs that don't exist, I trigger the
bug.

This patch should fix the bug.

-- Steve

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index d69cf63..49a4d6f 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -97,7 +97,7 @@ __ring_buffer_alloc(unsigned long size, unsigned flags, struct lock_class_key *k
 	__ring_buffer_alloc((size), (flags), &__key);	\
 })
 
-void ring_buffer_wait(struct ring_buffer *buffer, int cpu);
+int ring_buffer_wait(struct ring_buffer *buffer, int cpu);
 int ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
 			  struct file *filp, poll_table *poll_table);
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index c634868..7c56c3d 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -543,7 +543,7 @@ static void rb_wake_up_waiters(struct irq_work *work)
  * as data is added to any of the @buffer's cpu buffers. Otherwise
  * it will wait for data to be added to a specific cpu buffer.
  */
-void ring_buffer_wait(struct ring_buffer *buffer, int cpu)
+int ring_buffer_wait(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	DEFINE_WAIT(wait);
@@ -557,6 +557,8 @@ void ring_buffer_wait(struct ring_buffer *buffer, int cpu)
 	if (cpu == RING_BUFFER_ALL_CPUS)
 		work = &buffer->irq_work;
 	else {
+		if (!cpumask_test_cpu(cpu, buffer->cpumask))
+			return -ENODEV;
 		cpu_buffer = buffer->buffers[cpu];
 		work = &cpu_buffer->irq_work;
 	}
@@ -591,6 +593,7 @@ void ring_buffer_wait(struct ring_buffer *buffer, int cpu)
 		schedule();
 
 	finish_wait(&work->waiters, &wait);
+	return 0;
 }
 
 /**
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 16f7038..56422f1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1085,13 +1085,13 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 }
 #endif /* CONFIG_TRACER_MAX_TRACE */
 
-static void wait_on_pipe(struct trace_iterator *iter)
+static int wait_on_pipe(struct trace_iterator *iter)
 {
 	/* Iterators are static, they should be filled or empty */
 	if (trace_buffer_iter(iter, iter->cpu_file))
-		return;
+		return 0;
 
-	ring_buffer_wait(iter->trace_buffer->buffer, iter->cpu_file);
+	return ring_buffer_wait(iter->trace_buffer->buffer, iter->cpu_file);
 }
 
 #ifdef CONFIG_FTRACE_STARTUP_TEST
@@ -4378,6 +4378,7 @@ tracing_poll_pipe(struct file *filp, poll_table *poll_table)
 static int tracing_wait_pipe(struct file *filp)
 {
 	struct trace_iterator *iter = filp->private_data;
+	int ret;
 
 	while (trace_empty(iter)) {
 
@@ -4399,10 +4400,13 @@ static int tracing_wait_pipe(struct file *filp)
 
 		mutex_unlock(&iter->mutex);
 
-		wait_on_pipe(iter);
+		ret = wait_on_pipe(iter);
 
 		mutex_lock(&iter->mutex);
 
+		if (ret)
+			return ret;
+
 		if (signal_pending(current))
 			return -EINTR;
 	}
@@ -5327,8 +5331,12 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 				goto out_unlock;
 			}
 			mutex_unlock(&trace_types_lock);
-			wait_on_pipe(iter);
+			ret = wait_on_pipe(iter);
 			mutex_lock(&trace_types_lock);
+			if (ret) {
+				size = ret;
+				goto out_unlock;
+			}
 			if (signal_pending(current)) {
 				size = -EINTR;
 				goto out_unlock;
@@ -5538,8 +5546,10 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 			goto out;
 		}
 		mutex_unlock(&trace_types_lock);
-		wait_on_pipe(iter);
+		ret = wait_on_pipe(iter);
 		mutex_lock(&trace_types_lock);
+		if (ret)
+			goto out;
 		if (signal_pending(current)) {
 			ret = -EINTR;
 			goto out;
