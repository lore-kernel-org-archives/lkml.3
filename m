Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab3CBDBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:01:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5971 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab3CBDAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:00:52 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Tk41TGerlXUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=UU5mBSGWn-EA:10 a=20KFwNOVAAAA:8 a=b4krNuvFHoc07DN4Ah4A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130302030050.912324468@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 01 Mar 2013 21:48:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com
Subject: [for-next][PATCH 6/7] tracing: Fix read blocking on trace_pipe_raw
References: <20130302024833.624729274@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Fix-read-blocking-on-trace_pipe_raw.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If the ring buffer is empty, a read to trace_pipe_raw wont block.
The tracing code has the infrastructure to wake up waiting readers,
but the trace_pipe_raw doesn't take advantage of that.

When a read is done to trace_pipe_raw without the O_NONBLOCK flag
set, have the read block until there's data in the requested buffer.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b958e9d..32b003c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4339,6 +4339,7 @@ static int tracing_buffers_open(struct inode *inode, struct file *filp)
 
 	info->iter.tr		= tr;
 	info->iter.cpu_file	= tc->cpu;
+	info->iter.trace	= tr->current_trace;
 	info->spare		= NULL;
 	/* Force reading ring buffer for first read */
 	info->read		= (unsigned int)-1;
@@ -4378,18 +4379,29 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 	if (info->read < PAGE_SIZE)
 		goto read;
 
+ again:
 	trace_access_lock(iter->cpu_file);
 	ret = ring_buffer_read_page(iter->tr->buffer,
 				    &info->spare,
 				    count,
 				    iter->cpu_file, 0);
 	trace_access_unlock(iter->cpu_file);
-	if (ret < 0)
+
+	if (ret < 0) {
+		if (trace_empty(iter)) {
+			if ((filp->f_flags & O_NONBLOCK))
+				return -EAGAIN;
+			iter->trace->wait_pipe(iter);
+			if (signal_pending(current))
+				return -EINTR;
+			goto again;
+		}
 		return 0;
+	}
 
 	info->read = 0;
 
-read:
+ read:
 	size = PAGE_SIZE - info->read;
 	if (size > count)
 		size = count;
@@ -4566,7 +4578,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 			ret = -EAGAIN;
 			goto out;
 		}
-		default_wait_pipe(iter);
+		iter->trace->wait_pipe(iter);
 		if (signal_pending(current)) {
 			ret = -EINTR;
 			goto out;
-- 
1.7.10.4


