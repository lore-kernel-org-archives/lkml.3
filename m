Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaKQTLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:11:20 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:25801 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752446AbaKQTLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:11:18 -0500
Date: Mon, 17 Nov 2014 14:11:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 1/2] tracing: Clean up tracing_fill_pipe_page()
Message-ID: <20141117141108.347a30e5@gandalf.local.home>
In-Reply-To: <20141117123250.10f6f57c@gandalf.local.home>
References: <20141115045847.712848224@goodmis.org>
	<20141115050603.904875201@goodmis.org>
	<20141117123250.10f6f57c@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I don't like the fact that I did a code structure change with this
> patch. This patch should be just a simple conversion of len to
> seq_buf_used(). I'm going to strip this change out and put it before
> this patch.


The function tracing_fill_pipe_page() logic is a little confusing with the
use of count saving the seq.len and reusing it.

Instead of subtracting a number that is calculated from the saved
value of the seq.len from seq.len, just save the seq.len at the start
and if we need to reset it, just assign it again.

When the seq_buf overflow is len == size + 1, the current logic will
break. Changing it to use a saved length for resetting back to the
original value is more robust and will work when we change the way
seq_buf sets the overflow.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7d7a07e9b9e9..2dbc18e5f929 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4575,23 +4575,37 @@ static size_t
 tracing_fill_pipe_page(size_t rem, struct trace_iterator *iter)
 {
 	size_t count;
+	int save_len;
 	int ret;
 
 	/* Seq buffer is page-sized, exactly what we need. */
 	for (;;) {
-		count = iter->seq.seq.len;
+		save_len = iter->seq.seq.len;
 		ret = print_trace_line(iter);
-		count = iter->seq.seq.len - count;
-		if (rem < count) {
-			rem = 0;
-			iter->seq.seq.len -= count;
+
+		if (trace_seq_has_overflowed(&iter->seq)) {
+			iter->seq.seq.len = save_len;
 			break;
 		}
+
+		/*
+		 * This should not be hit, because it should only
+		 * be set if the iter->seq overflowed. But check it
+		 * anyway to be safe.
+		 */
 		if (ret == TRACE_TYPE_PARTIAL_LINE) {
-			iter->seq.seq.len -= count;
+			iter->seq.seq.len = save_len;
 			break;
 		}
 
+		count = iter->seq.seq.len - save_len;
+		if (rem < count) {
+			rem = 0;
+			iter->seq.seq.len = save_len;
+			break;
+		}
+
+
 		if (ret != TRACE_TYPE_NO_CONSUME)
 			trace_consume(iter);
 		rem -= count;
-- 
1.8.1.4

