Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933650Ab3GDDll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 23:41:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6793 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933508Ab3GDDkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 23:40:41 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=k7IgWVHcToQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=z-IdPYz_cLQA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=UpiCnllv92cimEvuNrgA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130704034038.665930010@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 23:33:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH 2/4] tracing: trace_remove_event_call() should fail if call/file is in
 use
References: <20130704033347.807661713@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-trace_remove_event_call-should-fail-if-call-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

Change trace_remove_event_call(call) to return the error if this
call is active. This is what the callers assume but can't verify
outside of the tracing locks. Both trace_kprobe.c/trace_uprobe.c
need the additional changes, unregister_trace_probe() should abort
if trace_remove_event_call() fails.

We also check TRACE_EVENT_FL_REF_MASK to ensure that nobody opened
the files we are going to remove, these means that nobody can access
the soon-to-be-freed ftrace_event_file/call via filp->private_data.

Link: http://lkml.kernel.org/r/20130702222359.GA27629@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    2 +-
 kernel/trace/trace_events.c  |   33 +++++++++++++++++++++++++++++++--
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 72ff2c6..bdf6bdd 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -338,7 +338,7 @@ extern int trace_define_field(struct ftrace_event_call *call, const char *type,
 			      const char *name, int offset, int size,
 			      int is_signed, int filter_type);
 extern int trace_add_event_call(struct ftrace_event_call *call);
-extern void trace_remove_event_call(struct ftrace_event_call *call);
+extern int trace_remove_event_call(struct ftrace_event_call *call);
 
 #define is_signed_type(type)	(((type)(-1)) < (type)1)
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 90cf243..1a5547e 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1766,16 +1766,45 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
 	destroy_preds(call);
 }
 
+static int probe_remove_event_call(struct ftrace_event_call *call)
+{
+	struct trace_array *tr;
+	struct ftrace_event_file *file;
+
+	if (call->flags & TRACE_EVENT_FL_REF_MASK)
+		return -EBUSY;
+
+#ifdef CONFIG_PERF_EVENTS
+	if (call->perf_refcount)
+		return -EBUSY;
+#endif
+	do_for_each_event_file(tr, file) {
+		if (file->event_call != call)
+			continue;
+		if (file->flags & FTRACE_EVENT_FL_ENABLED)
+			return -EBUSY;
+		break;
+	} while_for_each_event_file();
+
+	__trace_remove_event_call(call);
+
+	return 0;
+}
+
 /* Remove an event_call */
-void trace_remove_event_call(struct ftrace_event_call *call)
+int trace_remove_event_call(struct ftrace_event_call *call)
 {
+	int ret;
+
 	mutex_lock(&trace_types_lock);
 	mutex_lock(&event_mutex);
 	down_write(&trace_event_sem);
-	__trace_remove_event_call(call);
+	ret = probe_remove_event_call(call);
 	up_write(&trace_event_sem);
 	mutex_unlock(&event_mutex);
 	mutex_unlock(&trace_types_lock);
+
+	return ret;
 }
 
 #define for_each_event(event, start, end)			\
-- 
1.7.10.4


