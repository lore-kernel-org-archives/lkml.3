Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaKZOGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:06:39 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20100 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaKZOGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:06:37 -0500
Date: Wed, 26 Nov 2014 17:06:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] tracing: off by one in __trace_array_vprintk()
Message-ID: <20141126140621.GA18740@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This check says "goto out;" if we had to truncate the string.

The "tbuffer" buffer has TRACE_BUF_SIZE bytes.  The vsnprintf() function
returns the number of characters (not counting the NUL char) which would
have been printed if there were space.  If we we tried to print
TRACE_BUF_SIZE characters, the last character would have been truncated
to make space for the NUL character so we should "goto out;".

My other concern here was that a few lines later we do:

	entry->buf[len] = '\0';

I worried that maybe we were putting the NUL char past the end of the
array but I wasn't smart enough to figure out the size of entry->buf[].

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 42a822d..22af2ae 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2161,7 +2161,7 @@ __trace_array_vprintk(struct ring_buffer *buffer,
 	}
 
 	len = vsnprintf(tbuffer, TRACE_BUF_SIZE, fmt, args);
-	if (len > TRACE_BUF_SIZE)
+	if (len >= TRACE_BUF_SIZE)
 		goto out;
 
 	local_save_flags(flags);
