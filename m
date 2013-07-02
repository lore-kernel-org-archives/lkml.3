Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab3GBTj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 15:39:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932938Ab3GBTjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 15:39:14 -0400
Date: Tue, 2 Jul 2013 21:34:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: PATCH? trace_remove_event_call() should fail if call is active
Message-ID: <20130702193425.GA8813@redhat.com>
References: <51C951CD.50701@huawei.com> <20130625172359.GA8523@redhat.com> <20130626185205.GA27894@redhat.com> <51CBEE3E.70103@hitachi.com> <20130627161716.GA17889@redhat.com> <51CCF8BA.4030601@hitachi.com> <20130628180946.GA30838@redhat.com> <51D16E1D.5040904@hitachi.com> <20130702190037.GA6289@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130702190037.GA6289@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To remind/summarise, the usage of unregister_trace_probe() in
trace_kprobe.c and trace_uprobe.c is racy.

unregister_trace_probe() checks trace_probe_is_enabled() but
we can't trust the result, we can race with kprobe_register()
which is going to set TP_FLAG_TRACE/PROFILE.

And we can't add the new lock (or reuse probe_lock) to avoid
the race. kprobe_register() is called under event_mutex, so
unregister_trace_probe() can't hold this new lock around
unregister_probe_event() which takes event_mutex.

And we shouldn't shift event_mutex from trace_remove_event_call()
to its callers, this lock should be private to the core tracing
code.


Masami, Steven. What do you think about the patch below?

To simplify, lets ignore trace_module_remove_events() which calls
__trace_remove_event_call() too, although at first glance this
case should be fine too.

It really seems to me that trace_remove_event_call() should not
succeed if this ftrace_event_call is "active". Even if we forget
about perf, ftrace_event_enable_disable(file, 0) doesn't guarantee
reg(call, TRACE_REG_UNREGISTER) if SOFT_MODE is set.



If something like this patch can work then we can fix trace_kprobe.
unregister_trace_probe() can do unregister_probe_event() first and
abort if trace_remove_event_call() fails.

As for release_all_trace_probes(), we lose the all-or-nothing
semantics, but probably this is fine.

Or I misunderstood this logic completely?

Oleg.
-------------------------------------------------------------------------------

In essence this change is one-liner, it does

	-	ftrace_event_enable_disable(file);
	+	if (file->flags & FTRACE_EVENT_FL_ENABLED)
	+		return -EBUSY;

and propagates the error.

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
index 27963e2..876957c 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1473,15 +1473,20 @@ static void remove_event_from_tracers(struct ftrace_event_call *call)
 	} while_for_each_event_file();
 }
 
-static void event_remove(struct ftrace_event_call *call)
+static int event_remove(struct ftrace_event_call *call)
 {
 	struct trace_array *tr;
 	struct ftrace_event_file *file;
 
+#ifdef CONFIG_PERF_EVENTS
+	if (call->perf_refcount)
+		return -EBUSY;
+#endif
 	do_for_each_event_file(tr, file) {
 		if (file->event_call != call)
 			continue;
-		ftrace_event_enable_disable(file, 0);
+		if (file->flags & FTRACE_EVENT_FL_ENABLED)
+			return -EBUSY;
 		/*
 		 * The do_for_each_event_file() is
 		 * a double loop. After finding the call for this
@@ -1495,6 +1500,7 @@ static void event_remove(struct ftrace_event_call *call)
 		__unregister_ftrace_event(&call->event);
 	remove_event_from_tracers(call);
 	list_del(&call->list);
+	return 0;
 }
 
 static int event_init(struct ftrace_event_call *call)
@@ -1604,21 +1610,30 @@ int trace_add_event_call(struct ftrace_event_call *call)
 /*
  * Must be called under locking both of event_mutex and trace_event_sem.
  */
-static void __trace_remove_event_call(struct ftrace_event_call *call)
+static int __trace_remove_event_call(struct ftrace_event_call *call)
 {
-	event_remove(call);
-	trace_destroy_fields(call);
-	destroy_preds(call);
+	int err = event_remove(call);
+
+	if (!err) {
+		trace_destroy_fields(call);
+		destroy_preds(call);
+	}
+
+	return err;
 }
 
 /* Remove an event_call */
-void trace_remove_event_call(struct ftrace_event_call *call)
+int trace_remove_event_call(struct ftrace_event_call *call)
 {
+	int err;
+
 	mutex_lock(&event_mutex);
 	down_write(&trace_event_sem);
-	__trace_remove_event_call(call);
+	err = __trace_remove_event_call(call);
 	up_write(&trace_event_sem);
 	mutex_unlock(&event_mutex);
+
+	return err;
 }
 
 #define for_each_event(event, start, end)			\

