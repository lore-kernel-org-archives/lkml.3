Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201Ab3GCUga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:36:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2319 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab3GCUg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:36:29 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ys9SgDZjGkgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=_7JHcU0X-nEA:10 a=20KFwNOVAAAA:8 a=Npn9PEg5AAAA:8 a=582nHJB7H84X3RkH6xwA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372883787.22688.120.camel@gandalf.local.home>
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
Date: Wed, 03 Jul 2013 16:36:27 -0400
In-Reply-To: <1372883643.22688.118.camel@gandalf.local.home>
References: <51D16E1D.5040904@hitachi.com>
	 <20130702190037.GA6289@redhat.com> <20130702193425.GA8813@redhat.com>
	 <1372799087.22688.58.camel@gandalf.local.home>
	 <20130702213808.GA24757@redhat.com> <20130702222359.GA27629@redhat.com>
	 <51D38F8D.3010708@hitachi.com> <20130703172029.GA14309@redhat.com>
	 <20130703175420.GA25668@redhat.com>
	 <1372874547.22688.111.camel@gandalf.local.home>
	 <20130703191748.GA2884@redhat.com>
	 <1372883643.22688.118.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 16:34 -0400, Steven Rostedt wrote:
> OK, what about the below patch, followed by an updated version of your
> patch. I'll send that as a reply to this one.

This is a modification of your patch:

If you like it, please add a proper change log and SOB tag. Oh, and we
need to still update trace_kprobes.c

-- Steve

From: Oleg Nesterov <oleg@redhat.com>

Index: linux-trace.git/kernel/trace/trace_events.c
===================================================================
--- linux-trace.git.orig/kernel/trace/trace_events.c
+++ linux-trace.git/kernel/trace/trace_events.c
@@ -1761,16 +1761,45 @@ static void __trace_remove_event_call(st
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
Index: linux-trace.git/include/linux/ftrace_event.h
===================================================================
--- linux-trace.git.orig/include/linux/ftrace_event.h
+++ linux-trace.git/include/linux/ftrace_event.h
@@ -338,7 +338,7 @@ extern int trace_define_field(struct ftr
 			      const char *name, int offset, int size,
 			      int is_signed, int filter_type);
 extern int trace_add_event_call(struct ftrace_event_call *call);
-extern void trace_remove_event_call(struct ftrace_event_call *call);
+extern int trace_remove_event_call(struct ftrace_event_call *call);
 
 #define is_signed_type(type)	(((type)(-1)) < (type)1)
 



