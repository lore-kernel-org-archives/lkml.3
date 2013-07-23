Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab3GWVEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:04:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968Ab3GWVE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:04:28 -0400
Date: Tue, 23 Jul 2013 22:59:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] tracing: Turn event/id->i_private into call->event.type
Message-ID: <20130723205909.GA9055@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723205854.GA9036@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

event_id_read() is racy, ftrace_event_call can be already freed
by trace_remove_event_call() callers.

Change event_create_dir() to pass "data = call->event.type", this
is all event_id_read() needs. ftrace_event_id_fops no longer needs
tracing_open_generic().

We add the new helper, event_file_data(), to read ->i_private, it
will have more users.

Note: currently ACCESS_ONCE() and "id != 0" check are not needed,
but we are going to change event_remove/rmdir to clear ->i_mutex.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_events.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 76eed53..77990c4 100644
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
@@ -946,14 +951,17 @@ static int trace_format_open(struct inode *inode, struct file *file)
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
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, len);
 }
 
@@ -1240,7 +1248,6 @@ static const struct file_operations ftrace_event_format_fops = {
 };
 
 static const struct file_operations ftrace_event_id_fops = {
-	.open = tracing_open_generic,
 	.read = event_id_read,
 	.llseek = default_llseek,
 };
@@ -1488,8 +1495,8 @@ event_create_dir(struct dentry *parent,
 
 #ifdef CONFIG_PERF_EVENTS
 	if (call->event.type && call->class->reg)
-		trace_create_file("id", 0444, file->dir, call,
-		 		  id);
+		trace_create_file("id", 0444, file->dir,
+				  (void *)(long)call->event.type, id);
 #endif
 
 	/*
-- 
1.5.5.1

