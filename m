Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab3G3Lb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 07:31:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9362 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab3G3Lby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 07:31:54 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=d_O34BjmFfwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=YYX2g-drga8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=3nbZYyFuAAAA:8 a=y4oymp9fq9aDtU_duecA:9 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130730113152.135431410@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 30 Jul 2013 07:27:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next-3.11][PATCH 1/8] tracing: Turn event/id->i_private into call->event.type
References: <20130730112718.273490378@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Turn-event-id-i_private-into-call-event.type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

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
---
 kernel/trace/trace_events.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 898f868..c2d13c5 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -409,6 +409,11 @@ static void put_system(struct ftrace_subsystem_dir *dir)
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
@@ -946,14 +951,18 @@ static int trace_format_open(struct inode *inode, struct file *file)
 static ssize_t
 event_id_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 {
-	struct ftrace_event_call *call = filp->private_data;
+	int id = (long)event_file_data(filp);
 	char buf[32];
 	int len;
 
 	if (*ppos)
 		return 0;
 
-	len = sprintf(buf, "%d\n", call->event.type);
+	if (unlikely(!id))
+		return -ENODEV;
+
+	len = sprintf(buf, "%d\n", id);
+
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, len);
 }
 
@@ -1240,7 +1249,6 @@ static const struct file_operations ftrace_event_format_fops = {
 };
 
 static const struct file_operations ftrace_event_id_fops = {
-	.open = tracing_open_generic,
 	.read = event_id_read,
 	.llseek = default_llseek,
 };
@@ -1488,8 +1496,8 @@ event_create_dir(struct dentry *parent,
 
 #ifdef CONFIG_PERF_EVENTS
 	if (call->event.type && call->class->reg)
-		trace_create_file("id", 0444, file->dir, call,
-		 		  id);
+		trace_create_file("id", 0444, file->dir,
+				  (void *)(long)call->event.type, id);
 #endif
 
 	/*
-- 
1.7.10.4


