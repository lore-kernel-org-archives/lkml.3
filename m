Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751070AbaK0P4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:56:21 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:20888 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaK0P4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:56:20 -0500
Date: Thu, 27 Nov 2014 18:57:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch v2] tracing: truncated output is better than nothing
Message-ID: <20141127155752.GA21914@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126102244.4bffa4b2@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initial reason for this patch is that I noticed that:

	if (len > TRACE_BUF_SIZE)

is off by one.  In this code, if len == TRACE_BUF_SIZE, then it means we
have truncated the last character off the output string.  If we truncate
two or more characters then we exit without printing.

After some discussion, we decided that printing truncated data is better
than not printing at all so we should just use vscnprintf() and remove
the test entirely.  Also I have updated memcpy() to copy the NUL char
instead of setting the NUL in a separate step.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 42a822d..ab76b7b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2160,9 +2160,7 @@ __trace_array_vprintk(struct ring_buffer *buffer,
 		goto out;
 	}
 
-	len = vsnprintf(tbuffer, TRACE_BUF_SIZE, fmt, args);
-	if (len > TRACE_BUF_SIZE)
-		goto out;
+	len = vscnprintf(tbuffer, TRACE_BUF_SIZE, fmt, args);
 
 	local_save_flags(flags);
 	size = sizeof(*entry) + len + 1;
@@ -2173,8 +2171,7 @@ __trace_array_vprintk(struct ring_buffer *buffer,
 	entry = ring_buffer_event_data(event);
 	entry->ip = ip;
 
-	memcpy(&entry->buf, tbuffer, len);
-	entry->buf[len] = '\0';
+	memcpy(&entry->buf, tbuffer, len + 1);
 	if (!call_filter_check_discard(call, entry, buffer, event)) {
 		__buffer_unlock_commit(buffer, event);
 		ftrace_trace_stack(buffer, flags, 6, pc);
