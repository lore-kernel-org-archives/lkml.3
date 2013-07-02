Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab3GBVEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 17:04:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8212 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab3GBVEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 17:04:48 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ys9SgDZjGkgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=_7JHcU0X-nEA:10 a=gQT4rB9ohYaRWIPJonsA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372799087.22688.58.camel@gandalf.local.home>
Subject: Re: PATCH? trace_remove_event_call() should fail if call is active
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Date: Tue, 02 Jul 2013 17:04:47 -0400
In-Reply-To: <20130702193425.GA8813@redhat.com>
References: <51C951CD.50701@huawei.com> <20130625172359.GA8523@redhat.com>
	 <20130626185205.GA27894@redhat.com> <51CBEE3E.70103@hitachi.com>
	 <20130627161716.GA17889@redhat.com> <51CCF8BA.4030601@hitachi.com>
	 <20130628180946.GA30838@redhat.com> <51D16E1D.5040904@hitachi.com>
	 <20130702190037.GA6289@redhat.com> <20130702193425.GA8813@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-02 at 21:34 +0200, Oleg Nesterov wrote:
> To remind/summarise, the usage of unregister_trace_probe() in
> trace_kprobe.c and trace_uprobe.c is racy.
> 
> unregister_trace_probe() checks trace_probe_is_enabled() but
> we can't trust the result, we can race with kprobe_register()
> which is going to set TP_FLAG_TRACE/PROFILE.
> 
> And we can't add the new lock (or reuse probe_lock) to avoid
> the race. kprobe_register() is called under event_mutex, so
> unregister_trace_probe() can't hold this new lock around
> unregister_probe_event() which takes event_mutex.
> 
> And we shouldn't shift event_mutex from trace_remove_event_call()
> to its callers, this lock should be private to the core tracing
> code.
> 
> 
> Masami, Steven. What do you think about the patch below?
> 
> To simplify, lets ignore trace_module_remove_events() which calls
> __trace_remove_event_call() too, although at first glance this
> case should be fine too.

We can't ignore modules. If it fails to be removed, then it will leak
memory.

> 
> It really seems to me that trace_remove_event_call() should not
> succeed if this ftrace_event_call is "active". Even if we forget
> about perf, ftrace_event_enable_disable(file, 0) doesn't guarantee
> reg(call, TRACE_REG_UNREGISTER) if SOFT_MODE is set.
> 
> 
> 
> If something like this patch can work then we can fix trace_kprobe.
> unregister_trace_probe() can do unregister_probe_event() first and
> abort if trace_remove_event_call() fails.
> 
> As for release_all_trace_probes(), we lose the all-or-nothing
> semantics, but probably this is fine.
> 
> Or I misunderstood this logic completely?

I'm actually worried about this change.

But what if we simply add a new event file flag called
FTRACE_EVENT_FL_SHUTDOWN. Which will not allow the event to be enabled
anymore. What do you think about this patch?

We set the SHUTDOWN flag, which is done under the event_mutex, and then
we can check the trace_probe_is_enabled(), as that gets set under the
event_mutex, and only if the SHUTDOWN flag was not previously set. If we
fail, then we just re-enable the event and return. Otherwise, we
shouldn't have to worry about the event being set again.

-- Steve

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 4372658..5b525d6 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -253,6 +253,7 @@ enum {
 	FTRACE_EVENT_FL_RECORDED_CMD_BIT,
 	FTRACE_EVENT_FL_SOFT_MODE_BIT,
 	FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
+	FTRACE_EVENT_FL_SHUTDOWN_BIT,
 };
 
 /*
@@ -262,12 +263,15 @@ enum {
  *  SOFT_MODE     - The event is enabled/disabled by SOFT_DISABLED
  *  SOFT_DISABLED - When set, do not trace the event (even though its
  *                   tracepoint may be enabled)
+ *  SHUTDOWN      - The event is going away, don't allow it to be enabled
+ *                  anymore.
  */
 enum {
 	FTRACE_EVENT_FL_ENABLED		= (1 << FTRACE_EVENT_FL_ENABLED_BIT),
 	FTRACE_EVENT_FL_RECORDED_CMD	= (1 << FTRACE_EVENT_FL_RECORDED_CMD_BIT),
 	FTRACE_EVENT_FL_SOFT_MODE	= (1 << FTRACE_EVENT_FL_SOFT_MODE_BIT),
 	FTRACE_EVENT_FL_SOFT_DISABLED	= (1 << FTRACE_EVENT_FL_SOFT_DISABLED_BIT),
+	FTRACE_EVENT_FL_SHUTDOWN	= (1 << FTRACE_EVENT_FL_SHUTDOWN_BIT),
 };
 
 struct ftrace_event_file {
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index c7fbf93..dd5f16d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -229,6 +229,9 @@ extern struct mutex trace_types_lock;
 extern int trace_array_get(struct trace_array *tr);
 extern void trace_array_put(struct trace_array *tr);
 
+extern void ftrace_event_shutdown(struct ftrace_event_call *call);
+extern void ftrace_event_restart(struct ftrace_event_call *call);
+
 /*
  * The global tracer (top) should be the first trace array added,
  * but we check the flag anyway.
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 734901d..ef282402 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -299,6 +299,13 @@ static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
 		break;
 	case 1:
 		/*
+		 * If the event is set to go away, do not allow anyone to
+		 * enable it anymore.
+		 */
+		if (file->flags & FTRACE_EVENT_FL_SHUTDOWN)
+			return -EBUSY;
+
+		/*
 		 * When soft_disable is set and enable is set, we want to
 		 * register the tracepoint for the event, but leave the event
 		 * as is. That means, if the event was already enabled, we do
@@ -342,6 +349,56 @@ static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
 	return ret;
 }
 
+void ftrace_event_shutdown(struct ftrace_event_call *call)
+{
+	struct trace_array *tr;
+	struct ftrace_event_file *file;
+
+	mutex_lock(&trace_types_lock);
+	mutex_lock(&event_mutex);
+
+	do_for_each_event_file(tr, file) {
+		if (file->event_call != call)
+			continue;
+		set_bit(FTRACE_EVENT_FL_SHUTDOWN, &file->flags);
+		/*
+		 * The do_for_each_event_file() is
+		 * a double loop. After finding the call for this
+ 		 * trace_array, we use break to jump to the next
+		 * trace_array.
+		 */
+		break;
+	} while_for_each_event_file();
+
+	mutex_unlock(&event_mutex);
+	mutex_unlock(&trace_types_lock);
+}
+
+void ftrace_event_restart(struct ftrace_event_call *call)
+{
+	struct trace_array *tr;
+	struct ftrace_event_file *file;
+
+	mutex_lock(&trace_types_lock);
+	mutex_lock(&event_mutex);
+
+	do_for_each_event_file(tr, file) {
+		if (file->event_call != call)
+			continue;
+		clear_bit(FTRACE_EVENT_FL_SHUTDOWN, &file->flags);
+		/*
+		 * The do_for_each_event_file() is
+		 * a double loop. After finding the call for this
+ 		 * trace_array, we use break to jump to the next
+		 * trace_array.
+		 */
+		break;
+	} while_for_each_event_file();
+
+	mutex_unlock(&event_mutex);
+	mutex_unlock(&trace_types_lock);
+}
+
 static int ftrace_event_enable_disable(struct ftrace_event_file *file,
 				       int enable)
 {
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 7ed6976..0408b9f 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -336,9 +336,14 @@ static void __unregister_trace_probe(struct trace_probe *tp)
 /* Unregister a trace_probe and probe_event: call with locking probe_lock */
 static int unregister_trace_probe(struct trace_probe *tp)
 {
+	/* Prevent the event from being enabled */
+	ftrace_event_shutdown(tp->call);
+
 	/* Enabled event can not be unregistered */
-	if (trace_probe_is_enabled(tp))
+	if (trace_probe_is_enabled(tp)) {
+		ftrace_event_restart(tp->call);
 		return -EBUSY;
+	}
 
 	__unregister_trace_probe(tp);
 	list_del(&tp->list);


