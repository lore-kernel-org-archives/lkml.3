Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbaKZPFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:05:52 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25049 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbaKZPFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:05:51 -0500
Date: Wed, 26 Nov 2014 18:05:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] tracing: off by one in __trace_array_vprintk()
Message-ID: <20141126150541.GU4893@mwanda>
References: <20141126140621.GA18740@mwanda>
 <20141126092706.5d4038d4@gandalf.local.home>
 <20141126143719.GT4893@mwanda>
 <20141126094306.4f465616@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126094306.4f465616@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 09:43:06AM -0500, Steven Rostedt wrote:
> I highly doubt it's much of a speed up. And we do that by sacrificing
> that one byte of buffer, which would lose the printk if len does equal
> TRACE_BUF_SIZE.
> 
> I don't see a bug here. What exactly are you trying to fix?

Heh.  vsnprintf() is going to put a NUL char at the end of the string
even if you don't plan to use it.  :P

Another option would be to just print truncated output.  We could use
vscnprintf() and remove the off by one limit check.

regards,
dan carpenter

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
