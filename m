Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab3H0BW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:22:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59439 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab3H0BHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [ 26/74] tracing: Turn event/id->i_private into call->event.type
Date: Mon, 26 Aug 2013 18:08:24 -0700
Message-Id: <20130827010429.939010127@linuxfoundation.org>
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

commit 1a11126bcb7c93c289bf3218fa546fd3b0c0df8b upstream.

event_id_read() is racy, ftrace_event_call can be already freed
by trace_remove_event_call() callers.

Change event_create_dir() to pass "data = call->event.type", this
is all event_id_read() needs. ftrace_event_id_fops no longer needs
tracing_open_generic().

We add the new helper, event_file_data(), to read ->i_private, it
will have more users.

Note: currently ACCESS_ONCE() and "id != 0" check are not needed,
but we are going to change event_remove/rmdir to clear ->i_private.

Link: http://lkml.kernel.org/r/20130726172532.GA3605@redhat.com

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_events.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -407,6 +407,11 @@ static void put_system(struct ftrace_sub
 	mutex_unlock(&event_mutex);
 }
 
+static void *event_file_data(struct file *filp)
+{
+	return ACCESS_ONCE(file_inode(filp)->i_private);
+}
+
 /*
  * Open and update trace_array ref count.
  * Must have the current trace_array passed to it.
@@ -960,19 +965,22 @@ static int trace_format_open(struct inod
 static ssize_t
 event_id_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 {
-	struct ftrace_event_call *call = filp->private_data;
+	int id = (long)event_file_data(filp);
 	struct trace_seq *s;
 	int r;
 
 	if (*ppos)
 		return 0;
 
+	if (unlikely(!id))
+		return -ENODEV;
+
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
 		return -ENOMEM;
 
 	trace_seq_init(s);
-	trace_seq_printf(s, "%d\n", call->event.type);
+	trace_seq_printf(s, "%d\n", id);
 
 	r = simple_read_from_buffer(ubuf, cnt, ppos,
 				    s->buffer, s->len);
@@ -1263,7 +1271,6 @@ static const struct file_operations ftra
 };
 
 static const struct file_operations ftrace_event_id_fops = {
-	.open = tracing_open_generic,
 	.read = event_id_read,
 	.llseek = default_llseek,
 };
@@ -1511,8 +1518,8 @@ event_create_dir(struct dentry *parent,
 
 #ifdef CONFIG_PERF_EVENTS
 	if (call->event.type && call->class->reg)
-		trace_create_file("id", 0444, file->dir, call,
-		 		  id);
+		trace_create_file("id", 0444, file->dir,
+				  (void *)(long)call->event.type, id);
 #endif
 
 	/*


