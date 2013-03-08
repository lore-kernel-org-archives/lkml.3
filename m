Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933752Ab3CHDHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:07:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24181 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760282Ab3CHDGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:06:55 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Rp8EDAU41BcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=X5W5GLXA_zwA:10 a=20KFwNOVAAAA:8 a=tJ_0iVES2a_3Akxd73UA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130308030653.738901962@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Mar 2013 22:00:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [for-next][PATCH 12/17] tracing: Add snapshot feature to instances
References: <20130308025958.501479677@goodmis.org>
Content-Disposition: inline; filename=0012-tracing-Add-snapshot-feature-to-instances.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <srostedt@redhat.com>

Add the "snapshot" file to the the multi-buffer instances.

  cd /sys/kernel/debug/tracing/instances
  mkdir foo
  ls foo
buffer_size_kb  buffer_total_size_kb  events  free_buffer  set_event
snapshot  trace  trace_clock  trace_marker  trace_options  trace_pipe
tracing_on
  cat foo/snapshot
 # tracer: nop
 #
 #
 # * Snapshot is freed *
 #
 # Snapshot commands:
 # echo 0 > snapshot : Clears and frees snapshot buffer
 # echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.
 #                      Takes a snapshot of the main buffer.
 # echo 2 > snapshot : Clears snapshot buffer (but does not allocate)
 #                      (Doesn't have to be '2' works with any number that
 #                       is not a '0' or '1')

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 1dec636..163743a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4273,9 +4273,9 @@ tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		local_irq_disable();
 		/* Now, we're going to swap */
 		if (iter->cpu_file == RING_BUFFER_ALL_CPUS)
-			update_max_tr(&global_trace, current, smp_processor_id());
+			update_max_tr(tr, current, smp_processor_id());
 		else
-			update_max_tr_single(&global_trace, current, iter->cpu_file);
+			update_max_tr_single(tr, current, iter->cpu_file);
 		local_irq_enable();
 		break;
 	default:
@@ -5497,6 +5497,11 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 
 	trace_create_file("tracing_on", 0644, d_tracer,
 			    tr, &rb_simple_fops);
+
+#ifdef CONFIG_TRACER_SNAPSHOT
+	trace_create_file("snapshot", 0644, d_tracer,
+			  (void *)&tr->trace_cpu, &snapshot_fops);
+#endif
 }
 
 static __init int tracer_init_debugfs(void)
@@ -5538,11 +5543,6 @@ static __init int tracer_init_debugfs(void)
 			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
 #endif
 
-#ifdef CONFIG_TRACER_SNAPSHOT
-	trace_create_file("snapshot", 0644, d_tracer,
-			  (void *)&global_trace.trace_cpu, &snapshot_fops);
-#endif
-
 	create_trace_instances(d_tracer);
 
 	create_trace_options_dir(&global_trace);
-- 
1.7.10.4


