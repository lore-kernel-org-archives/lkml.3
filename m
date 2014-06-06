Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaFFRWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:22:50 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:27385 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752655AbaFFRVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:21:07 -0400
Message-Id: <20140606172105.000489056@goodmis.org>
User-Agent: quilt/0.63-1
Date: Fri, 06 Jun 2014 12:30:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [for-next][PATCH 6/6] tracing: Fix leak of ring buffer data when new instances creation
 fails
References: <20140606163034.516780857@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0005-tracing-Fix-leak-of-ring-buffer-data-when-new-instan.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Yoshihiro Yunomae reported that the ring buffer data for a trace
instance does not get properly cleaned up when it fails. He proposed
a patch that manually cleaned the data up and addad a bunch of labels.
The labels are not needed because all trace array is allocated with
a kzalloc which initializes it to 0 and all kfree()s can take a NULL
pointer and will ignore it.

Adding a new helper function free_trace_buffers() that can also take
null buffers to free the buffers that were allocated by
allocate_trace_buffers().

Link: http://lkml.kernel.org/r/20140605223522.32311.31664.stgit@yunodevel

Reported-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e29edee1542a..26cfff38e2ab 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6232,6 +6232,25 @@ static int allocate_trace_buffers(struct trace_array *tr, int size)
 	return 0;
 }
 
+static void free_trace_buffers(struct trace_array *tr)
+{
+	if (!tr)
+		return;
+
+	if (tr->trace_buffer.buffer) {
+		ring_buffer_free(tr->trace_buffer.buffer);
+		tr->trace_buffer.buffer = NULL;
+		free_percpu(tr->trace_buffer.data);
+	}
+
+#ifdef CONFIG_TRACER_MAX_TRACE
+	if (tr->max_buffer.buffer) {
+		ring_buffer_free(tr->max_buffer.buffer);
+		tr->max_buffer.buffer = NULL;
+	}
+#endif
+}
+
 static int new_instance_create(const char *name)
 {
 	struct trace_array *tr;
@@ -6290,8 +6309,7 @@ static int new_instance_create(const char *name)
 	return 0;
 
  out_free_tr:
-	if (tr->trace_buffer.buffer)
-		ring_buffer_free(tr->trace_buffer.buffer);
+	free_trace_buffers(tr);
 	free_cpumask_var(tr->tracing_cpumask);
 	kfree(tr->name);
 	kfree(tr);
-- 
2.0.0.rc2


