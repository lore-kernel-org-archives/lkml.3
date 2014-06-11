Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbaFKCBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 22:01:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:11842 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752087AbaFKCBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 22:01:11 -0400
Message-Id: <20140611020108.447564022@goodmis.org>
User-Agent: quilt/0.63-1
Date: Tue, 10 Jun 2014 21:59:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>
Subject: [for-next][PATCH 3/4] tracing: Fix leak of per cpu max data in instances
References: <20140611015948.013451560@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-tracing-Fix-leak-of-per-cpu-max-data-in-instances.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The freeing of an instance, if max data is configured, there will be
per cpu data structures created. But these are not freed when the instance
is deleted, which causes a memory leak.

A new helper function is added that frees the individual buffers within a
trace array, instead of duplicating the code. This way changes made for one
are applied to the other (normal buffer vs max buffer).

Link: http://lkml.kernel.org/r/87k38pbake.fsf@sejong.aot.lge.com

Reported-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2b458c60e0da..384ede311717 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6242,22 +6242,25 @@ static int allocate_trace_buffers(struct trace_array *tr, int size)
 	return 0;
 }
 
+static void free_trace_buffer(struct trace_buffer *buf)
+{
+	if (buf->buffer) {
+		ring_buffer_free(buf->buffer);
+		buf->buffer = NULL;
+		free_percpu(buf->data);
+		buf->data = NULL;
+	}
+}
+
 static void free_trace_buffers(struct trace_array *tr)
 {
 	if (!tr)
 		return;
 
-	if (tr->trace_buffer.buffer) {
-		ring_buffer_free(tr->trace_buffer.buffer);
-		tr->trace_buffer.buffer = NULL;
-		free_percpu(tr->trace_buffer.data);
-	}
+	free_trace_buffer(&tr->trace_buffer);
 
 #ifdef CONFIG_TRACER_MAX_TRACE
-	if (tr->max_buffer.buffer) {
-		ring_buffer_free(tr->max_buffer.buffer);
-		tr->max_buffer.buffer = NULL;
-	}
+	free_trace_buffer(&tr->max_buffer);
 #endif
 }
 
-- 
2.0.0.rc2


