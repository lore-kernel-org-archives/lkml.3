Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933668Ab3CHDH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:07:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24181 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760297Ab3CHDG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:06:56 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=j27YvO5bLeIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1iIIbkL7PD8A:10 a=20KFwNOVAAAA:8 a=ayC55rCoAAAA:8 a=xkQe97tiNWYVitsJ0R0A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=q9mC2fbAJx8A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130308030653.904468188@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Mar 2013 22:00:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [for-next][PATCH 13/17] tracing: Add per_cpu directory into tracing instances
References: <20130308025958.501479677@goodmis.org>
Content-Disposition: inline; filename=0013-tracing-Add-per_cpu-directory-into-tracing-instances.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <srostedt@redhat.com>

Add the per_cpu directory to the created tracing instances:

  cd /sys/kernel/debug/tracing/instances
  mkdir foo
  ls foo/per_cpu/cpu0
buffer_size_kb	snapshot_raw  trace	  trace_pipe_raw
snapshot	stats	      trace_pipe

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 163743a..e6547ea 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5470,6 +5470,7 @@ static __init void create_trace_instances(struct dentry *d_tracer)
 static void
 init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 {
+	int cpu;
 
 	trace_create_file("trace_options", 0644, d_tracer,
 			  tr, &tracing_iter_fops);
@@ -5502,12 +5503,15 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 	trace_create_file("snapshot", 0644, d_tracer,
 			  (void *)&tr->trace_cpu, &snapshot_fops);
 #endif
+
+	for_each_tracing_cpu(cpu)
+		tracing_init_debugfs_percpu(tr, cpu);
+
 }
 
 static __init int tracer_init_debugfs(void)
 {
 	struct dentry *d_tracer;
-	int cpu;
 
 	trace_access_lock_init();
 
@@ -5547,9 +5551,6 @@ static __init int tracer_init_debugfs(void)
 
 	create_trace_options_dir(&global_trace);
 
-	for_each_tracing_cpu(cpu)
-		tracing_init_debugfs_percpu(&global_trace, cpu);
-
 	return 0;
 }
 
-- 
1.7.10.4


