Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab3H0BVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:21:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab3H0BHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [ 32/74] tracing: trace_remove_event_call() should fail if call/file is in use
Date: Mon, 26 Aug 2013 18:08:30 -0700
Message-Id: <20130827010431.264813035@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 2816c551c796ec14620325b2c9ed75b9979d3125 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/ftrace_event.h |    2 +-
 kernel/trace/trace_events.c  |   35 +++++++++++++++++++++++++++++++++--
 2 files changed, 34 insertions(+), 3 deletions(-)

--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -334,7 +334,7 @@ extern int trace_define_field(struct ftr
 			      const char *name, int offset, int size,
 			      int is_signed, int filter_type);
 extern int trace_add_event_call(struct ftrace_event_call *call);
-extern void trace_remove_event_call(struct ftrace_event_call *call);
+extern int trace_remove_event_call(struct ftrace_event_call *call);
 
 #define is_signed_type(type)	(((type)(-1)) < (type)1)
 
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1735,16 +1735,47 @@ static void __trace_remove_event_call(st
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


