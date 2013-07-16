Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab3GPTCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:02:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956Ab3GPTCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:02:30 -0400
Date: Tue, 16 Jul 2013 20:57:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/4] tracing: Turn "id"->i_private into call->event.type
Message-ID: <20130716185723.GA21193@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716185658.GA21167@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ftrace_event_id_fops and event_id_read() is overcomplicated.

1. Change event_create_dir() to pass "data = call->event.type"
   to debugfs_create_file().

   This means that ftrace_event_id_fops doesn't need .open()
   and event_id_read() can simply print (int)i_private

2. event_id_read() has no reason to kmalloc "struct trace_seq"
   (more than PAGE_SIZE!), it can use a small buffer.

Note: "if (*ppos) return 0" looks strange and unneeded,
simple_read_from_buffer(ppos) should handle this case corrrectly.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_events.c |   26 +++++++++-----------------
 1 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index cbd1a57..cefbe85 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -962,24 +962,17 @@ static int trace_format_open(struct inode *inode, struct file *file)
 static ssize_t
 event_id_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 {
-	struct ftrace_event_call *call = filp->private_data;
-	struct trace_seq *s;
-	int r;
+	int id = (long)ACCESS_ONCE(file_inode(filp)->i_private);
+	char buf[32];
+	int len;
 
+	if (!id)
+		return -ENODEV;
 	if (*ppos)
 		return 0;
 
-	s = kmalloc(sizeof(*s), GFP_KERNEL);
-	if (!s)
-		return -ENOMEM;
-
-	trace_seq_init(s);
-	trace_seq_printf(s, "%d\n", call->event.type);
-
-	r = simple_read_from_buffer(ubuf, cnt, ppos,
-				    s->buffer, s->len);
-	kfree(s);
-	return r;
+	len = sprintf(buf, "%d\n", id);
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, len);
 }
 
 static ssize_t
@@ -1264,7 +1257,6 @@ static const struct file_operations ftrace_event_format_fops = {
 };
 
 static const struct file_operations ftrace_event_id_fops = {
-	.open = tracing_open_generic,
 	.read = event_id_read,
 	.llseek = default_llseek,
 };
@@ -1496,8 +1488,8 @@ event_create_dir(struct dentry *parent,
 
 #ifdef CONFIG_PERF_EVENTS
 	if (call->event.type && call->class->reg)
-		trace_create_file("id", 0444, file->dir, call,
-		 		  id);
+		trace_create_file("id", 0444, file->dir,
+				  (void*)(long)call->event.type, id);
 #endif
 
 	/*
-- 
1.5.5.1

