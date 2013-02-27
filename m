Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab3B0RuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:50:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22754 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760226Ab3B0RuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:50:00 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=hycxAtJf6wwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=cQTstR13JksA:10 a=20KFwNOVAAAA:8 a=VINYbWRauGbIm7Qh0NoA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=FQIcuXSJGNzFiMYb:21 a=hWAslysqxj4jKj9a:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130227174958.033093275@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 27 Feb 2013 12:22:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com
Subject: [for-next][PATCH 2/8] tracing: Use RING_BUFFER_ALL_CPUS for TRACE_PIPE_ALL_CPU
References: <20130227172232.707306533@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Use-RING_BUFFER_ALL_CPUS-for-TRACE_PIPE_ALL_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Both RING_BUFFER_ALL_CPUS and TRACE_PIPE_ALL_CPU are defined as
-1 and used to say that all the ring buffers are to be modified
or read (instead of just a single cpu, which would be >= 0).

There's no reason to keep TRACE_PIPE_ALL_CPU as it is also started
to be used for more than what it was created for, and now that
the ring buffer code added a generic RING_BUFFER_ALL_CPUS define,
we can clean up the trace code to use that instead and remove
the TRACE_PIPE_ALL_CPU macro.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c     |   26 +++++++++++++-------------
 kernel/trace/trace.h     |    2 --
 kernel/trace/trace_kdb.c |    4 ++--
 3 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a2756a0..e06f1aa 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -287,13 +287,13 @@ static DEFINE_PER_CPU(struct mutex, cpu_access_lock);
 
 static inline void trace_access_lock(int cpu)
 {
-	if (cpu == TRACE_PIPE_ALL_CPU) {
+	if (cpu == RING_BUFFER_ALL_CPUS) {
 		/* gain it for accessing the whole ring buffer. */
 		down_write(&all_cpu_access_lock);
 	} else {
 		/* gain it for accessing a cpu ring buffer. */
 
-		/* Firstly block other trace_access_lock(TRACE_PIPE_ALL_CPU). */
+		/* Firstly block other trace_access_lock(RING_BUFFER_ALL_CPUS). */
 		down_read(&all_cpu_access_lock);
 
 		/* Secondly block other access to this @cpu ring buffer. */
@@ -303,7 +303,7 @@ static inline void trace_access_lock(int cpu)
 
 static inline void trace_access_unlock(int cpu)
 {
-	if (cpu == TRACE_PIPE_ALL_CPU) {
+	if (cpu == RING_BUFFER_ALL_CPUS) {
 		up_write(&all_cpu_access_lock);
 	} else {
 		mutex_unlock(&per_cpu(cpu_access_lock, cpu));
@@ -1822,7 +1822,7 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu,
 	 * If we are in a per_cpu trace file, don't bother by iterating over
 	 * all cpu and peek directly.
 	 */
-	if (cpu_file > TRACE_PIPE_ALL_CPU) {
+	if (cpu_file > RING_BUFFER_ALL_CPUS) {
 		if (ring_buffer_empty_cpu(buffer, cpu_file))
 			return NULL;
 		ent = peek_next_entry(iter, cpu_file, ent_ts, missing_events);
@@ -1982,7 +1982,7 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 		iter->cpu = 0;
 		iter->idx = -1;
 
-		if (cpu_file == TRACE_PIPE_ALL_CPU) {
+		if (cpu_file == RING_BUFFER_ALL_CPUS) {
 			for_each_tracing_cpu(cpu)
 				tracing_iter_reset(iter, cpu);
 		} else
@@ -2290,7 +2290,7 @@ int trace_empty(struct trace_iterator *iter)
 	int cpu;
 
 	/* If we are looking at one CPU buffer, only check that one */
-	if (iter->cpu_file != TRACE_PIPE_ALL_CPU) {
+	if (iter->cpu_file != RING_BUFFER_ALL_CPUS) {
 		cpu = iter->cpu_file;
 		buf_iter = trace_buffer_iter(iter, cpu);
 		if (buf_iter) {
@@ -2509,7 +2509,7 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 	if (!iter->snapshot)
 		tracing_stop();
 
-	if (iter->cpu_file == TRACE_PIPE_ALL_CPU) {
+	if (iter->cpu_file == RING_BUFFER_ALL_CPUS) {
 		for_each_tracing_cpu(cpu) {
 			iter->buffer_iter[cpu] =
 				ring_buffer_read_prepare(iter->tr->buffer, cpu);
@@ -2593,7 +2593,7 @@ static int tracing_open(struct inode *inode, struct file *file)
 	    (file->f_flags & O_TRUNC)) {
 		long cpu = (long) inode->i_private;
 
-		if (cpu == TRACE_PIPE_ALL_CPU)
+		if (cpu == RING_BUFFER_ALL_CPUS)
 			tracing_reset_online_cpus(&global_trace);
 		else
 			tracing_reset(&global_trace, cpu);
@@ -4979,7 +4979,7 @@ static __init int tracer_init_debugfs(void)
 			NULL, &tracing_cpumask_fops);
 
 	trace_create_file("trace", 0644, d_tracer,
-			(void *) TRACE_PIPE_ALL_CPU, &tracing_fops);
+			(void *) RING_BUFFER_ALL_CPUS, &tracing_fops);
 
 	trace_create_file("available_tracers", 0444, d_tracer,
 			&global_trace, &show_traces_fops);
@@ -4999,7 +4999,7 @@ static __init int tracer_init_debugfs(void)
 			NULL, &tracing_readme_fops);
 
 	trace_create_file("trace_pipe", 0444, d_tracer,
-			(void *) TRACE_PIPE_ALL_CPU, &tracing_pipe_fops);
+			(void *) RING_BUFFER_ALL_CPUS, &tracing_pipe_fops);
 
 	trace_create_file("buffer_size_kb", 0644, d_tracer,
 			(void *) RING_BUFFER_ALL_CPUS, &tracing_entries_fops);
@@ -5106,7 +5106,7 @@ void trace_init_global_iter(struct trace_iterator *iter)
 {
 	iter->tr = &global_trace;
 	iter->trace = current_trace;
-	iter->cpu_file = TRACE_PIPE_ALL_CPU;
+	iter->cpu_file = RING_BUFFER_ALL_CPUS;
 }
 
 static void
@@ -5154,7 +5154,7 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 
 	switch (oops_dump_mode) {
 	case DUMP_ALL:
-		iter.cpu_file = TRACE_PIPE_ALL_CPU;
+		iter.cpu_file = RING_BUFFER_ALL_CPUS;
 		break;
 	case DUMP_ORIG:
 		iter.cpu_file = raw_smp_processor_id();
@@ -5163,7 +5163,7 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 		goto out_enable;
 	default:
 		printk(KERN_TRACE "Bad dumping mode, switching to all CPUs dump\n");
-		iter.cpu_file = TRACE_PIPE_ALL_CPU;
+		iter.cpu_file = RING_BUFFER_ALL_CPUS;
 	}
 
 	printk(KERN_TRACE "Dumping ftrace buffer:\n");
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index ef11984..0698e49 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -449,8 +449,6 @@ static __always_inline void trace_clear_recursion(int bit)
 	current->trace_recursion = val;
 }
 
-#define TRACE_PIPE_ALL_CPU	-1
-
 static inline struct ring_buffer_iter *
 trace_buffer_iter(struct trace_iterator *iter, int cpu)
 {
diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
index 3c5c5df..cc1dbdc 100644
--- a/kernel/trace/trace_kdb.c
+++ b/kernel/trace/trace_kdb.c
@@ -43,7 +43,7 @@ static void ftrace_dump_buf(int skip_lines, long cpu_file)
 	iter.iter_flags |= TRACE_FILE_LAT_FMT;
 	iter.pos = -1;
 
-	if (cpu_file == TRACE_PIPE_ALL_CPU) {
+	if (cpu_file == RING_BUFFER_ALL_CPUS) {
 		for_each_tracing_cpu(cpu) {
 			iter.buffer_iter[cpu] =
 			ring_buffer_read_prepare(iter.tr->buffer, cpu);
@@ -115,7 +115,7 @@ static int kdb_ftdump(int argc, const char **argv)
 		    !cpu_online(cpu_file))
 			return KDB_BADINT;
 	} else {
-		cpu_file = TRACE_PIPE_ALL_CPU;
+		cpu_file = RING_BUFFER_ALL_CPUS;
 	}
 
 	kdb_trap_printk++;
-- 
1.7.10.4


