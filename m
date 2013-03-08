Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933829Ab3CHDHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:07:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3964 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759999Ab3CHDGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:06:54 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=qfL2yWBuHN4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=NNw_V_daimkA:10 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=68l2MZAu6OqOvJS6VcsA:9 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=CT1-3ZQZSF5mfwKV:21 a=DSLUHRffn4ET0wL8:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130308030652.941443285@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Mar 2013 22:00:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [for-next][PATCH 07/17] tracing: Add snapshot in the per_cpu trace directories
References: <20130308025958.501479677@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-Add-snapshot-in-the-per_cpu-trace-directorie.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <srostedt@redhat.com>

Add the snapshot file into the per_cpu tracing directories to allow
them to be read for an individual cpu. This also allows to clear
an individual cpu from the snapshot buffer.

If the kernel allows it (CONFIG_RING_BUFFER_ALLOW_SWAP is set), then
echoing in '1' into one of the per_cpu snapshot files will do an
individual cpu buffer swap instead of the entire file.

Cc: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   66 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 56 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index cd15864..96cd165 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2435,6 +2435,31 @@ static void test_ftrace_alive(struct seq_file *m)
 }
 
 #ifdef CONFIG_TRACER_MAX_TRACE
+static void show_snapshot_main_help(struct seq_file *m)
+{
+	seq_printf(m, "# echo 0 > snapshot : Clears and frees snapshot buffer\n");
+	seq_printf(m, "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n");
+	seq_printf(m, "#                      Takes a snapshot of the main buffer.\n");
+	seq_printf(m, "# echo 2 > snapshot : Clears snapshot buffer (but does not allocate)\n");
+	seq_printf(m, "#                      (Doesn't have to be '2' works with any number that\n");
+	seq_printf(m, "#                       is not a '0' or '1')\n");
+}
+
+static void show_snapshot_percpu_help(struct seq_file *m)
+{
+	seq_printf(m, "# echo 0 > snapshot : Invalid for per_cpu snapshot file.\n");
+#ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
+	seq_printf(m, "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n");
+	seq_printf(m, "#                      Takes a snapshot of the main buffer for this cpu.\n");
+#else
+	seq_printf(m, "# echo 1 > snapshot : Not supported with this kernel.\n");
+	seq_printf(m, "#                     Must use main snapshot file to allocate.\n");
+#endif
+	seq_printf(m, "# echo 2 > snapshot : Clears this cpu's snapshot buffer (but does not allocate)\n");
+	seq_printf(m, "#                      (Doesn't have to be '2' works with any number that\n");
+	seq_printf(m, "#                       is not a '0' or '1')\n");
+}
+
 static void print_snapshot_help(struct seq_file *m, struct trace_iterator *iter)
 {
 	if (iter->trace->allocated_snapshot)
@@ -2443,12 +2468,10 @@ static void print_snapshot_help(struct seq_file *m, struct trace_iterator *iter)
 		seq_printf(m, "#\n# * Snapshot is freed *\n#\n");
 
 	seq_printf(m, "# Snapshot commands:\n");
-	seq_printf(m, "# echo 0 > snapshot : Clears and frees snapshot buffer\n");
-	seq_printf(m, "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n");
-	seq_printf(m, "#                      Takes a snapshot of the main buffer.\n");
-	seq_printf(m, "# echo 2 > snapshot : Clears snapshot buffer (but does not allocate)\n");
-	seq_printf(m, "#                      (Doesn't have to be '2' works with any number that\n");
-	seq_printf(m, "#                       is not a '0' or '1')\n");
+	if (iter->cpu_file == RING_BUFFER_ALL_CPUS)
+		show_snapshot_main_help(m);
+	else
+		show_snapshot_percpu_help(m);
 }
 #else
 /* Should never be called */
@@ -4178,6 +4201,7 @@ static int tracing_snapshot_open(struct inode *inode, struct file *file)
 		}
 		iter->tr = tc->tr;
 		iter->trace_buffer = &tc->tr->max_buffer;
+		iter->cpu_file = tc->cpu;
 		m->private = iter;
 		file->private_data = m;
 	}
@@ -4212,6 +4236,10 @@ tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	switch (val) {
 	case 0:
+		if (iter->cpu_file != RING_BUFFER_ALL_CPUS) {
+			ret = -EINVAL;
+			break;
+		}
 		if (tr->current_trace->allocated_snapshot) {
 			/* free spare buffer */
 			ring_buffer_resize(tr->max_buffer.buffer, 1,
@@ -4222,6 +4250,13 @@ tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		}
 		break;
 	case 1:
+/* Only allow per-cpu swap if the ring buffer supports it */
+#ifndef CONFIG_RING_BUFFER_ALLOW_SWAP
+		if (iter->cpu_file != RING_BUFFER_ALL_CPUS) {
+			ret = -EINVAL;
+			break;
+		}
+#endif
 		if (!tr->current_trace->allocated_snapshot) {
 			/* allocate spare buffer */
 			ret = resize_buffer_duplicate_size(&tr->max_buffer,
@@ -4230,15 +4265,21 @@ tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
 				break;
 			tr->current_trace->allocated_snapshot = true;
 		}
-
 		local_irq_disable();
 		/* Now, we're going to swap */
-		update_max_tr(&global_trace, current, smp_processor_id());
+		if (iter->cpu_file == RING_BUFFER_ALL_CPUS)
+			update_max_tr(&global_trace, current, smp_processor_id());
+		else
+			update_max_tr_single(&global_trace, current, iter->cpu_file);
 		local_irq_enable();
 		break;
 	default:
-		if (tr->current_trace->allocated_snapshot)
-			tracing_reset_online_cpus(&tr->max_buffer);
+		if (tr->current_trace->allocated_snapshot) {
+			if (iter->cpu_file == RING_BUFFER_ALL_CPUS)
+				tracing_reset_online_cpus(&tr->max_buffer);
+			else
+				tracing_reset(&tr->max_buffer, iter->cpu_file);
+		}
 		break;
 	}
 
@@ -4806,6 +4847,11 @@ tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 
 	trace_create_file("buffer_size_kb", 0444, d_cpu,
 			(void *)&data->trace_cpu, &tracing_entries_fops);
+
+#ifdef CONFIG_TRACER_SNAPSHOT
+	trace_create_file("snapshot", 0644, d_cpu,
+			  (void *)&data->trace_cpu, &snapshot_fops);
+#endif
 }
 
 #ifdef CONFIG_FTRACE_SELFTEST
-- 
1.7.10.4


