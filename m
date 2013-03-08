Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801Ab3CHDHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:07:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24181 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760206Ab3CHDGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:06:54 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=u6RBS0WTdTsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=YKD1qu1yjHgA:10 a=20KFwNOVAAAA:8 a=w8R6YF8i7uNADn0HRG0A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130308030652.459447844@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Mar 2013 22:00:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [for-next][PATCH 04/17] tracing: Clear all trace buffers when unloaded module event was used
References: <20130308025958.501479677@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Clear-all-trace-buffers-when-unloaded-module.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <srostedt@redhat.com>

Currently we do not know what buffer a module event was enabled in.
On unload, it is safest to clear all buffer instances, not just the
top level buffer.

Todo: Clear only the buffer that the event was used in. The
infrastructure is there to do this, but it makes the code a bit
more complex. Lets get the current code vetted before we add that.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c        |   10 ++++++++--
 kernel/trace/trace.h        |    2 +-
 kernel/trace/trace_events.c |   10 +++++++---
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f743121..d852165 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -911,9 +911,15 @@ void tracing_reset_current(int cpu)
 	tracing_reset(&global_trace, cpu);
 }
 
-void tracing_reset_current_online_cpus(void)
+void tracing_reset_all_online_cpus(void)
 {
-	tracing_reset_online_cpus(&global_trace);
+	struct trace_array *tr;
+
+	mutex_lock(&trace_types_lock);
+	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
+		tracing_reset_online_cpus(tr);
+	}
+	mutex_unlock(&trace_types_lock);
 }
 
 #define SAVED_CMDLINES 128
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 50a9c81..e9486c74d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -492,7 +492,7 @@ int tracing_is_enabled(void);
 void tracing_reset(struct trace_array *tr, int cpu);
 void tracing_reset_online_cpus(struct trace_array *tr);
 void tracing_reset_current(int cpu);
-void tracing_reset_current_online_cpus(void);
+void tracing_reset_all_online_cpus(void);
 int tracing_open_generic(struct inode *inode, struct file *filp);
 struct dentry *trace_create_file(const char *name,
 				 umode_t mode,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 9a7dc4b..a376ab5 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1649,14 +1649,18 @@ static void trace_module_remove_events(struct module *mod)
 		list_del(&file_ops->list);
 		kfree(file_ops);
 	}
+	up_write(&trace_event_mutex);
 
 	/*
 	 * It is safest to reset the ring buffer if the module being unloaded
-	 * registered any events that were used.
+	 * registered any events that were used. The only worry is if
+	 * a new module gets loaded, and takes on the same id as the events
+	 * of this module. When printing out the buffer, traced events left
+	 * over from this module may be passed to the new module events and
+	 * unexpected results may occur.
 	 */
 	if (clear_trace)
-		tracing_reset_current_online_cpus();
-	up_write(&trace_event_mutex);
+		tracing_reset_all_online_cpus();
 }
 
 static int trace_module_notify(struct notifier_block *self,
-- 
1.7.10.4


