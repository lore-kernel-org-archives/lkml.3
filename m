Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaLCWOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 17:14:46 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:32890 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751896AbaLCWNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 17:13:53 -0500
Message-Id: <20141203221351.970987371@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 03 Dec 2014 17:13:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [for-next][PATCH 5/5] tracing: Truncated output is better than nothing
References: <20141203221311.563559646@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0005-tracing-Truncated-output-is-better-than-nothing.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

The initial reason for this patch is that I noticed that:

	if (len > TRACE_BUF_SIZE)

is off by one.  In this code, if len == TRACE_BUF_SIZE, then it means we
have truncated the last character off the output string.  If we truncate
two or more characters then we exit without printing.

After some discussion, we decided that printing truncated data is better
than not printing at all so we should just use vscnprintf() and remove
the test entirely.  Also I have updated memcpy() to copy the NUL char
instead of setting the NUL in a separate step.

Link: http://lkml.kernel.org/r/20141127155752.GA21914@mwanda

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3ce3c4ccfc94..4ceb2546c7ef 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2158,9 +2158,7 @@ __trace_array_vprintk(struct ring_buffer *buffer,
 		goto out;
 	}
 
-	len = vsnprintf(tbuffer, TRACE_BUF_SIZE, fmt, args);
-	if (len > TRACE_BUF_SIZE)
-		goto out;
+	len = vscnprintf(tbuffer, TRACE_BUF_SIZE, fmt, args);
 
 	local_save_flags(flags);
 	size = sizeof(*entry) + len + 1;
@@ -2171,8 +2169,7 @@ __trace_array_vprintk(struct ring_buffer *buffer,
 	entry = ring_buffer_event_data(event);
 	entry->ip = ip;
 
-	memcpy(&entry->buf, tbuffer, len);
-	entry->buf[len] = '\0';
+	memcpy(&entry->buf, tbuffer, len + 1);
 	if (!call_filter_check_discard(call, entry, buffer, event)) {
 		__buffer_unlock_commit(buffer, event);
 		ftrace_trace_stack(buffer, flags, 6, pc);
-- 
2.1.3


