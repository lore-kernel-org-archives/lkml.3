Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142Ab3GCUeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:34:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19868 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab3GCUeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:34:06 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ys9SgDZjGkgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=_7JHcU0X-nEA:10 a=UG8OMjjE1b24vJNOs9MA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372883643.22688.118.camel@gandalf.local.home>
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
Date: Wed, 03 Jul 2013 16:34:03 -0400
In-Reply-To: <20130703191748.GA2884@redhat.com>
References: <51D16E1D.5040904@hitachi.com>
	 <20130702190037.GA6289@redhat.com> <20130702193425.GA8813@redhat.com>
	 <1372799087.22688.58.camel@gandalf.local.home>
	 <20130702213808.GA24757@redhat.com> <20130702222359.GA27629@redhat.com>
	 <51D38F8D.3010708@hitachi.com> <20130703172029.GA14309@redhat.com>
	 <20130703175420.GA25668@redhat.com>
	 <1372874547.22688.111.camel@gandalf.local.home>
	 <20130703191748.GA2884@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 21:17 +0200, Oleg Nesterov wrote:
> On 07/03, Steven Rostedt wrote:
> >
> > On Wed, 2013-07-03 at 19:54 +0200, Oleg Nesterov wrote:
> > > On 07/03, Oleg Nesterov wrote:
> > > >
> > > > IOW. So far _I think_ we just need the additional changes in
> > > > trace_remove_event_call() if it succeeds (with the patch I sent)
> > > > to prevent the races like above, but I didn't even try to think
> > > > about this problem.
> > >
> > > And I guess greatly underestimated the problem(s). When I look at
> > > this code now, it seems that, say, event_enable_write() will use
> > > the already freed ftrace_event_file in this case.
> > >
> > > Still I think this is another (although closely related) problem.
> >
> > Correct, and I think if we fix that problem, it will encapsulate fixing
> > the kprobe race too.
> 
> I do not think so, but I can be easily wrong. Again, we shouldn't
> destroy the event if there is a perf_event attached to this tp_event.
> And we can't (afaics!) rely on TRACE_REG_UNREGISTER from event_remove()
> paths, FTRACE_EVENT_FL_SOFT_MODE can nack it.
> 
> So I still think that we also need something like the patch I sent.
> But please forget about this for the moment.
> 
> Can't we do something like below? Just in case, of course this change
> is incomplete, just to explain what I mean... And of course I how no
> idea if the change in debugfs is safe, I never looked into fs/debugfs
> before. But, perhaps, somehow we can clear i_private under event_mutex
> and kernel/trace can use file_inode() instead of filp->private_data ?
> 
> Oleg.
> 
> 
> diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
> index 4888cb3..c23d41e 100644
> --- a/fs/debugfs/inode.c
> +++ b/fs/debugfs/inode.c
> @@ -475,6 +475,7 @@ static int __debugfs_remove(struct dentry *dentry, struct dentry *parent)
>  				kfree(dentry->d_inode->i_private);
>  				/* fall through */
>  			default:
> +				dentry->d_inode->i_private = NULL;
>  				simple_unlink(parent->d_inode, dentry);
>  				break;
>  			}

No, I would avoid any changes to the debugfs infrastructure.

OK, what about the below patch, followed by an updated version of your
patch. I'll send that as a reply to this one.

-- Steve

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 4372658..72ff2c6 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -195,6 +195,7 @@ extern int ftrace_event_reg(struct ftrace_event_call *event,
 			    enum trace_reg type, void *data);
 
 enum {
+	TRACE_EVENT_FL_REF_MAX_BIT = 20,
 	TRACE_EVENT_FL_FILTERED_BIT,
 	TRACE_EVENT_FL_CAP_ANY_BIT,
 	TRACE_EVENT_FL_NO_SET_FILTER_BIT,
@@ -203,6 +204,8 @@ enum {
 };
 
 /*
+ * Event ref count uses the first 20 bits of the flags field.
+ *
  * Event flags:
  *  FILTERED	  - The event has a filter attached
  *  CAP_ANY	  - Any user can enable for perf
@@ -213,6 +216,7 @@ enum {
  *                     it is best to clear the buffers that used it).
  */
 enum {
+	TRACE_EVENT_FL_REF_MAX		= (1 << TRACE_EVENT_FL_REF_MAX_BIT),
 	TRACE_EVENT_FL_FILTERED		= (1 << TRACE_EVENT_FL_FILTERED_BIT),
 	TRACE_EVENT_FL_CAP_ANY		= (1 << TRACE_EVENT_FL_CAP_ANY_BIT),
 	TRACE_EVENT_FL_NO_SET_FILTER	= (1 << TRACE_EVENT_FL_NO_SET_FILTER_BIT),
@@ -220,6 +224,8 @@ enum {
 	TRACE_EVENT_FL_WAS_ENABLED	= (1 << TRACE_EVENT_FL_WAS_ENABLED_BIT),
 };
 
+#define TRACE_EVENT_FL_REF_MASK	(TRACE_EVENT_FL_REF_MAX - 1)
+
 struct ftrace_event_call {
 	struct list_head	list;
 	struct ftrace_event_class *class;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 7d85429..16f3236 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -391,6 +391,23 @@ static void __get_system_dir(struct ftrace_subsystem_dir *dir)
 	__get_system(dir->subsystem);
 }
 
+static int ftrace_event_call_get(struct ftrace_event_call *call)
+{
+	if ((call->flags & TRACE_EVENT_FL_REF_MASK) == TRACE_EVENT_FL_REF_MAX - 1)
+		return -EBUSY;
+
+	call->flags++;
+	return 0;
+}
+
+static void ftrace_event_call_put(struct ftrace_event_call *call)
+{
+	if (WARN_ON_ONCE(!(call->flags & TRACE_EVENT_FL_REF_MASK)))
+		return;
+
+	call->flags--;
+}
+
 static void __put_system_dir(struct ftrace_subsystem_dir *dir)
 {
 	WARN_ON_ONCE(dir->ref_count == 0);
@@ -424,7 +441,15 @@ static int tracing_open_generic_file(struct inode *inode, struct file *filp)
 
 	ret = tracing_open_generic(inode, filp);
 	if (ret < 0)
-		trace_array_put(tr);
+		goto fail;
+
+	ret = ftrace_event_call_get(file->event_call);
+	if (ret < 0)
+		goto fail;
+
+	return 0;
+ fail:
+	trace_array_put(tr);
 	return ret;
 }
 
@@ -433,12 +458,40 @@ static int tracing_release_generic_file(struct inode *inode, struct file *filp)
 	struct ftrace_event_file *file = inode->i_private;
 	struct trace_array *tr = file->tr;
 
+	ftrace_event_call_put(file->event_call);
 	trace_array_put(tr);
 
 	return 0;
 }
 
 /*
+ * Open and update call ref count.
+ * Must have ftrace_event_call passed in.
+ */
+static int tracing_open_generic_call(struct inode *inode, struct file *filp)
+{
+	struct ftrace_event_call *call = inode->i_private;
+
+	return ftrace_event_call_get(call);
+}
+
+static int tracing_release_generic_call(struct inode *inode, struct file *filp)
+{
+	struct ftrace_event_call *call = inode->i_private;
+
+	ftrace_event_call_put(call);
+	return 0;
+}
+
+static int tracing_seq_release_call(struct inode *inode, struct file *filp)
+{
+	struct ftrace_event_call *call = inode->i_private;
+
+	ftrace_event_call_put(call);
+	return seq_release(inode, filp);
+}
+
+/*
  * __ftrace_set_clr_event(NULL, NULL, NULL, set) will set/unset all events.
  */
 static int
@@ -949,10 +1002,16 @@ static int trace_format_open(struct inode *inode, struct file *file)
 	struct seq_file *m;
 	int ret;
 
-	ret = seq_open(file, &trace_format_seq_ops);
+	ret = ftrace_event_call_get(call);
 	if (ret < 0)
 		return ret;
 
+	ret = seq_open(file, &trace_format_seq_ops);
+	if (ret < 0) {
+		ftrace_event_call_put(call);
+		return ret;
+	}
+
 	m = file->private_data;
 	m->private = call;
 
@@ -1260,20 +1319,22 @@ static const struct file_operations ftrace_event_format_fops = {
 	.open = trace_format_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
-	.release = seq_release,
+	.release = tracing_seq_release_call,
 };
 
 static const struct file_operations ftrace_event_id_fops = {
-	.open = tracing_open_generic,
+	.open = tracing_open_generic_call,
 	.read = event_id_read,
 	.llseek = default_llseek,
+	.release = tracing_release_generic_call,
 };
 
 static const struct file_operations ftrace_event_filter_fops = {
-	.open = tracing_open_generic,
+	.open = tracing_open_generic_call,
 	.read = event_filter_read,
 	.write = event_filter_write,
 	.llseek = default_llseek,
+	.release = tracing_release_generic_call,
 };
 
 static const struct file_operations ftrace_subsystem_filter_fops = {


