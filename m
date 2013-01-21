Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab3AUVTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:19:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23974 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab3AUVRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:17:30 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=lPpVPdXHcmIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=tWq_-l4uvrUA:10 a=GvQkQWPkAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=NufY4J3AAAAA:8 a=lSNQQfP47xnSsY6BjWYA:9 a=Wwjp7rKQgkIA:10 a=MSl-tDqOz04A:10 a=re9sYKne76oA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130121211727.747368115@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 21 Jan 2013 16:14:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Christoph Lameter <cl@linux.com>, Shan Wei <davidshan@tencent.com>
Subject: [PATCH 03/13 -next] tracing: Use this_cpu_ptr per-cpu helper
References: <20130121211403.337052956@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Use-this_cpu_ptr-per-cpu-helper.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>

typeof(&buffer) is a pointer to array of 1024 char, or char (*)[1024].
But, typeof(&buffer[0]) is a pointer to char which match the return type of get_trace_buf().
As well-known, the value of &buffer is equal to &buffer[0].
so return this_cpu_ptr(&percpu_buffer->buffer[0]) can avoid type cast.

Link: http://lkml.kernel.org/r/50A1A800.3020102@gmail.com

Reviewed-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Shan Wei <davidshan@tencent.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/blktrace.c |    2 +-
 kernel/trace/trace.c    |    5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index c0bd030..71259e2 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -147,7 +147,7 @@ void __trace_note_message(struct blk_trace *bt, const char *fmt, ...)
 		return;
 
 	local_irq_save(flags);
-	buf = per_cpu_ptr(bt->msg_data, smp_processor_id());
+	buf = this_cpu_ptr(bt->msg_data);
 	va_start(args, fmt);
 	n = vscnprintf(buf, BLK_TN_MAX_MSG, fmt, args);
 	va_end(args);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3c13e46..f8b7c62 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1517,7 +1517,6 @@ static struct trace_buffer_struct *trace_percpu_nmi_buffer;
 static char *get_trace_buf(void)
 {
 	struct trace_buffer_struct *percpu_buffer;
-	struct trace_buffer_struct *buffer;
 
 	/*
 	 * If we have allocated per cpu buffers, then we do not
@@ -1535,9 +1534,7 @@ static char *get_trace_buf(void)
 	if (!percpu_buffer)
 		return NULL;
 
-	buffer = per_cpu_ptr(percpu_buffer, smp_processor_id());
-
-	return buffer->buffer;
+	return this_cpu_ptr(&percpu_buffer->buffer[0]);
 }
 
 static int alloc_percpu_trace_buffer(void)
-- 
1.7.10.4


