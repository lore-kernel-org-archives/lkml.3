Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652Ab3GDDko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 23:40:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3357 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933456Ab3GDDkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 23:40:40 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=N292umeCppEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=XYSkxpo84ZsA:10 a=VwQbUJbxAAAA:8 a=3nbZYyFuAAAA:8 a=UG8OMjjE1b24vJNOs9MA:9 a=jeBq3FmKZ4MA:10 a=EvKJbDF4Ut8A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130704034038.501144114@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 23:33:48 -0400
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
Subject: [RFC][PATCH 1/4] tracing: Add ref count to ftrace_event_call
References: <20130704033347.807661713@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Add-ref-count-to-ftrace_event_call.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When one of the event files is opened, we need to prevent them from
being removed. Modules do with with the module owner set (automated
from the VFS layer).  The ftrace buffer instances have a ref count added
to the trace_array when the enabled file is opened (the others are not
that big of a deal, as they only reference the event calls which
still exist when an instance disappears). But kprobes and uprobes
do not have any protection.

 # cd /sys/kernel/debug/tracing
 # echo 'p:sigprocmask sigprocmask' > kprobe_events || exit -1
 # enable_probe() {
	sleep 10
	echo 1
 }
 # file=events/kprobes/sigprocmask/enable
 # enable_probe > $file &
 > kprobe_events

The above will corrupt the kprobe system, as the write to the enable
file will happen after the kprobe was deleted.

Trying to create the probe again fails:

 # echo 'p:sigprocmask sigprocmask' > kprobe_events
 # cat kprobe_events
p:kprobes/sigprocmask sigprocmask
 # ls events/kprobes/
enable  filter

Notice that the sigprocmask does not exist.

The first step to fix this is by adding ref counts to the ftrace_event_calls.
Using the flags field, and protecting the updates with the event_mutex
the ref count will be use the first 20 bits of the flags field, and the
current flags will be shifted 20 bits.

Link: http://lkml.kernel.org/r/1372883643.22688.118.camel@gandalf.local.home

Suggested-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    6 ++++
 kernel/trace/trace_events.c  |   76 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 77 insertions(+), 5 deletions(-)

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
index 7d85429..90cf243 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -391,6 +391,28 @@ static void __get_system_dir(struct ftrace_subsystem_dir *dir)
 	__get_system(dir->subsystem);
 }
 
+static int ftrace_event_call_get(struct ftrace_event_call *call)
+{
+	int ret = 0;
+
+	mutex_lock(&event_mutex);
+	if ((call->flags & TRACE_EVENT_FL_REF_MASK) == TRACE_EVENT_FL_REF_MAX - 1)
+		ret = -EBUSY;
+	else
+		call->flags++;
+	mutex_unlock(&event_mutex);
+
+	return ret;
+}
+
+static void ftrace_event_call_put(struct ftrace_event_call *call)
+{
+	mutex_lock(&event_mutex);
+	if (!WARN_ON_ONCE(!(call->flags & TRACE_EVENT_FL_REF_MASK)))
+		call->flags--;
+	mutex_unlock(&event_mutex);
+}
+
 static void __put_system_dir(struct ftrace_subsystem_dir *dir)
 {
 	WARN_ON_ONCE(dir->ref_count == 0);
@@ -424,7 +446,15 @@ static int tracing_open_generic_file(struct inode *inode, struct file *filp)
 
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
 
@@ -433,12 +463,40 @@ static int tracing_release_generic_file(struct inode *inode, struct file *filp)
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
@@ -949,10 +1007,16 @@ static int trace_format_open(struct inode *inode, struct file *file)
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
 
@@ -1260,20 +1324,22 @@ static const struct file_operations ftrace_event_format_fops = {
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
-- 
1.7.10.4


