Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab3DKUaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:30:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27951 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759136Ab3DKU0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:17 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=LWr3OH_o5uUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=H2NsGy_EcaQA:10 a=VwQbUJbxAAAA:8 a=Wh8kfBTXKzvaumMlS68A:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202552.386927342@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [ 038/171 ] tracing: Keep overwrite in sync between regular and snapshot buffers
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0038-tracing-Keep-overwrite-in-sync-between-regular-and-s.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

[ Upstream commit 80902822658aab18330569587cdb69ac1dfdcea8 ]

Changing the overwrite mode for the ring buffer via the trace
option only sets the normal buffer. But the snapshot buffer could
swap with it, and then the snapshot would be in non overwrite mode
and the normal buffer would be in overwrite mode, even though the
option flag states otherwise.

Keep the two buffers overwrite modes in sync.

Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 06b227d..1f84103 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2791,8 +2791,12 @@ static void set_tracer_flags(unsigned int mask, int enabled)
 	if (mask == TRACE_ITER_RECORD_CMD)
 		trace_event_enable_cmd_record(enabled);
 
-	if (mask == TRACE_ITER_OVERWRITE)
+	if (mask == TRACE_ITER_OVERWRITE) {
 		ring_buffer_change_overwrite(global_trace.buffer, enabled);
+#ifdef CONFIG_TRACER_MAX_TRACE
+		ring_buffer_change_overwrite(max_tr.buffer, enabled);
+#endif
+	}
 }
 
 static ssize_t
-- 
1.7.10.4


