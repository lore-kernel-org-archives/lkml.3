Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964937AbaD3Mmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:42:35 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:45406 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758768AbaD3Mmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:42:32 -0400
Message-Id: <20140430124231.304968038@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 30 Apr 2014 08:41:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 3/4] tracing: Break out of tracing_wait_pipe() before wait_pipe() is
 called
References: <20140430124153.334527053@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-tracing-Break-out-of-tracing_wait_pipe-before-wait_p.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When reading from trace_pipe, if tracing is off but nothing was read
it should block. If something is read and tracing is off, then EOF
is returned. If tracing is on and there's nothing to read, it will block.

But because the check of whether tracing is off and something was read
is done after the block on the pipe, it is hit or miss if the EOF is
returned or not leading to inconsistent behavior.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index cb41e98..e058c60 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4237,15 +4237,6 @@ static int tracing_wait_pipe(struct file *filp)
 			return -EAGAIN;
 		}
 
-		mutex_unlock(&iter->mutex);
-
-		iter->trace->wait_pipe(iter);
-
-		mutex_lock(&iter->mutex);
-
-		if (signal_pending(current))
-			return -EINTR;
-
 		/*
 		 * We block until we read something and tracing is disabled.
 		 * We still block if tracing is disabled, but we have never
@@ -4257,6 +4248,15 @@ static int tracing_wait_pipe(struct file *filp)
 		 */
 		if (!tracing_is_on() && iter->pos)
 			break;
+
+		mutex_unlock(&iter->mutex);
+
+		iter->trace->wait_pipe(iter);
+
+		mutex_lock(&iter->mutex);
+
+		if (signal_pending(current))
+			return -EINTR;
 	}
 
 	return 1;
-- 
1.8.5.3


