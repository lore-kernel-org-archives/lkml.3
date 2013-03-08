Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684Ab3CHDHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:07:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3964 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760296Ab3CHDG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:06:56 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Gf9Xbig2tE4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=yOr_a1ZMFNYA:10 a=20KFwNOVAAAA:8 a=rbCik682QfO4IbMgahoA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130308030654.046198011@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Mar 2013 22:00:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [for-next][PATCH 14/17] tracing: Prevent deleting instances when they are being read
References: <20130308025958.501479677@goodmis.org>
Content-Disposition: inline; filename=0014-tracing-Prevent-deleting-instances-when-they-are-bei.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <srostedt@redhat.com>

Add a ref count to the trace_array structure and prevent removal
of instances that have open descriptors.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   23 +++++++++++++++++++++++
 kernel/trace/trace.h |    1 +
 2 files changed, 24 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e6547ea..8ede7d1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2612,6 +2612,8 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 		tracing_iter_reset(iter, cpu);
 	}
 
+	tr->ref++;
+
 	mutex_unlock(&trace_types_lock);
 
 	return iter;
@@ -2648,6 +2650,10 @@ static int tracing_release(struct inode *inode, struct file *file)
 	tr = iter->tr;
 
 	mutex_lock(&trace_types_lock);
+
+	WARN_ON(!tr->ref);
+	tr->ref--;
+
 	for_each_tracing_cpu(cpu) {
 		if (iter->buffer_iter[cpu])
 			ring_buffer_read_finish(iter->buffer_iter[cpu]);
@@ -4431,6 +4437,10 @@ static int tracing_buffers_open(struct inode *inode, struct file *filp)
 	if (!info)
 		return -ENOMEM;
 
+	mutex_lock(&trace_types_lock);
+
+	tr->ref++;
+
 	info->iter.tr		= tr;
 	info->iter.cpu_file	= tc->cpu;
 	info->iter.trace	= tr->current_trace;
@@ -4441,6 +4451,8 @@ static int tracing_buffers_open(struct inode *inode, struct file *filp)
 
 	filp->private_data = info;
 
+	mutex_unlock(&trace_types_lock);
+
 	return nonseekable_open(inode, filp);
 }
 
@@ -4539,10 +4551,17 @@ static int tracing_buffers_release(struct inode *inode, struct file *file)
 	struct ftrace_buffer_info *info = file->private_data;
 	struct trace_iterator *iter = &info->iter;
 
+	mutex_lock(&trace_types_lock);
+
+	WARN_ON(!iter->tr->ref);
+	iter->tr->ref--;
+
 	if (info->spare)
 		ring_buffer_free_read_page(iter->trace_buffer->buffer, info->spare);
 	kfree(info);
 
+	mutex_unlock(&trace_types_lock);
+
 	return 0;
 }
 
@@ -5375,6 +5394,10 @@ static int instance_delete(const char *name)
 	if (!found)
 		goto out_unlock;
 
+	ret = -EBUSY;
+	if (tr->ref)
+		goto out_unlock;
+
 	list_del(&tr->list);
 
 	event_trace_del_tracer(tr);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 6111933..a19459d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -219,6 +219,7 @@ struct trace_array {
 	struct list_head	systems;
 	struct list_head	events;
 	struct task_struct	*waiter;
+	int			ref;
 };
 
 enum {
-- 
1.7.10.4


