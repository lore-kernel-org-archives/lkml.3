Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbaLWQQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 11:16:53 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:42927 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756384AbaLWQQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 11:16:51 -0500
Message-Id: <20141223161635.568603635@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 23 Dec 2014 11:13:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 1/2] tracing: Add ref count to tracer for when they are being read by pipe
References: <20141223161340.297942985@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-tracing-Add-ref-count-to-tracer-for-when-they-are-be.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When one of the trace pipe files are being read (by either the trace_pipe
or trace_pipe_raw), do not allow the current_trace to change. By adding
a ref count that is incremented when the pipe files are opened, will
prevent the current_trace from being changed.

This will allow for the removal of the global trace_types_lock from
reading the pipe buffers (which is currently a bottle neck).

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 16 +++++++++++++++-
 kernel/trace/trace.h |  1 +
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2e767972e99c..ed3fba1d6570 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4140,6 +4140,12 @@ static int tracing_set_tracer(struct trace_array *tr, const char *buf)
 		goto out;
 	}
 
+	/* If trace pipe files are being read, we can't change the tracer */
+	if (tr->current_trace->ref) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	trace_branch_disable();
 
 	tr->current_trace->enabled--;
@@ -4363,6 +4369,8 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 		iter->trace->pipe_open(iter);
 
 	nonseekable_open(inode, filp);
+
+	tr->current_trace->ref++;
 out:
 	mutex_unlock(&trace_types_lock);
 	return ret;
@@ -4382,6 +4390,8 @@ static int tracing_release_pipe(struct inode *inode, struct file *file)
 
 	mutex_lock(&trace_types_lock);
 
+	tr->current_trace->ref--;
+
 	if (iter->trace->pipe_close)
 		iter->trace->pipe_close(iter);
 
@@ -5331,6 +5341,8 @@ static int tracing_buffers_open(struct inode *inode, struct file *filp)
 
 	filp->private_data = info;
 
+	tr->current_trace->ref++;
+
 	mutex_unlock(&trace_types_lock);
 
 	ret = nonseekable_open(inode, filp);
@@ -5437,6 +5449,8 @@ static int tracing_buffers_release(struct inode *inode, struct file *file)
 
 	mutex_lock(&trace_types_lock);
 
+	iter->tr->current_trace->ref--;
+
 	__trace_array_put(iter->tr);
 
 	if (info->spare)
@@ -6416,7 +6430,7 @@ static int instance_delete(const char *name)
 		goto out_unlock;
 
 	ret = -EBUSY;
-	if (tr->ref)
+	if (tr->ref || (tr->current_trace && tr->current_trace->ref))
 		goto out_unlock;
 
 	list_del(&tr->list);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 8de48bac1ce2..0eddfeb05fee 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -388,6 +388,7 @@ struct tracer {
 	struct tracer		*next;
 	struct tracer_flags	*flags;
 	int			enabled;
+	int			ref;
 	bool			print_max;
 	bool			allow_instances;
 #ifdef CONFIG_TRACER_MAX_TRACE
-- 
2.1.3


