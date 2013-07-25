Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab3GYOYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 10:24:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755609Ab3GYOYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 10:24:15 -0400
Date: Thu, 25 Jul 2013 16:18:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] tracing: Change remove_event_file_dir() to clear
	"d_subdirs"->i_private
Message-ID: <20130725141853.GA15965@redhat.com>
References: <20130723205927.GA9082@redhat.com> <1374696480.3356.158.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374696480.3356.158.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24, Steven Rostedt wrote:
>
> On Tue, 2013-07-23 at 22:59 +0200, Oleg Nesterov wrote:
> > Change remove_event_file_dir() ->i_private for every file we
> > are going to remove.
> >
> > tracing_open_generic_file() and tracing_release_generic_file()
> > can go away, ftrace_enable_fops and ftrace_event_filter_fops()
> > use tracing_open_generic() but only to check tracing_disabled.
> >
> > This fixes all races with event_remove() or instance_delete().
> > f_op->read/write/whatever can never use the freed file/call,
> > all event/* files were changed to check and use ->i_private
> > under event_mutex.
> >
> > Note: this doesn't not fix other problems, event_remove() can
> > destroy the active ftrace_event_call, we need more changes but
> > those changes are completely orthogonal.
>
> Hmm, but this patch opens up that race right? We remove the tr ref
> counter updates here.

But we do not care or I missed something. instance_delete() takes
event_mutex and does __trace_remove_event_dirs() before anything
else. (perhaps it makes sense to move list_del() down but afaics
currently this doesn't matter).

If event_enable_write() takes this mutex first we can pretend it
was called even before instance_delete(). Otherwise _write() will
notice i_private == NULL and do nothing.

Let me also clarify which "other problems" problems I meant. We
still need the already discussed patch below, and we still need
the changes in kprobes/uprobes (you already made these patches).
Except, probe_remove_event_call() doesn't need the "call->flags"
check, of course.

Or I misunderstood?


As for you other comments - thanks, I'll update this series.

Oleg.

----------------------------------------------------------------------
tracing: trace_remove_event_call() should fail if call/file is in use


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



