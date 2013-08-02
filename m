Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab3HBC4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:56:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11299 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab3HBCzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:55:55 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=lRKr_0V5QH8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=O0z0J5NHkMsA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=3nbZYyFuAAAA:8 a=pAzJERHJ3ZG-qIp2IKcA:9 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130802025553.332084027@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 01 Aug 2013 22:49:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next-3.11][PATCH 2/5] tracing: trace_remove_event_call() should fail if call/file is in
 use
References: <20130802024924.999067099@goodmis.org>
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

The caller is going to free this call/file so we must ensure that
nobody can use them after trace_remove_event_call() succeeds.
debugfs should be fine after the previous changes and event_remove()
does TRACE_REG_UNREGISTER, but still there are 2 reasons why we need
the additional checks:

- There could be a perf_event(s) attached to this tp_event, so the
  patch checks ->perf_refcount.

- TRACE_REG_UNREGISTER can be suppressed by FTRACE_EVENT_FL_SOFT_MODE,
  so we simply check FTRACE_EVENT_FL_ENABLED protected by event_mutex.

Link: http://lkml.kernel.org/r/20130729175033.GB26284@redhat.com

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    2 +-
 kernel/trace/trace_events.c  |   35 +++++++++++++++++++++++++++++++++--
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 4372658..f98ab06 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -332,7 +332,7 @@ extern int trace_define_field(struct ftrace_event_call *call, const char *type,
 			      const char *name, int offset, int size,
 			      int is_signed, int filter_type);
 extern int trace_add_event_call(struct ftrace_event_call *call);
-extern void trace_remove_event_call(struct ftrace_event_call *call);
+extern int trace_remove_event_call(struct ftrace_event_call *call);
 
 #define is_signed_type(type)	(((type)(-1)) < (type)1)
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index a67c913..ec04836 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1713,16 +1713,47 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
 	destroy_preds(call);
 }
 
+static int probe_remove_event_call(struct ftrace_event_call *call)
+{
+	struct trace_array *tr;
+	struct ftrace_event_file *file;
+
+#ifdef CONFIG_PERF_EVENTS
+	if (call->perf_refcount)
+		return -EBUSY;
+#endif
+	do_for_each_event_file(tr, file) {
+		if (file->event_call != call)
+			continue;
+		/*
+		 * We can't rely on ftrace_event_enable_disable(enable => 0)
+		 * we are going to do, FTRACE_EVENT_FL_SOFT_MODE can suppress
+		 * TRACE_REG_UNREGISTER.
+		 */
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


