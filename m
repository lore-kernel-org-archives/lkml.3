Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502AbaKTPav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:30:51 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:62952 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751103AbaKTP1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:27:18 -0500
Message-Id: <20141120152716.574751217@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Nov 2014 10:21:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [for-next][PATCH 06/15] tracing: Clean up tracing_fill_pipe_page()
References: <20141120152120.168868031@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0006-tracing-Clean-up-tracing_fill_pipe_page.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The function tracing_fill_pipe_page() logic is a little confusing with the
use of count saving the seq.len and reusing it.

Instead of subtracting a number that is calculated from the saved
value of the seq.len from seq.len, just save the seq.len at the start
and if we need to reset it, just assign it again.

When the seq_buf overflow is len == size + 1, the current logic will
break. Changing it to use a saved length for resetting back to the
original value is more robust and will work when we change the way
seq_buf sets the overflow.

Link: http://lkml.kernel.org/r/20141118161546.GJ23958@pathway.suse.cz

Reviewed-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7d7a07e9b9e9..0aa75be843a0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4575,20 +4575,33 @@ static size_t
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
+			break;
+		}
+
+		count = iter->seq.seq.len - save_len;
+		if (rem < count) {
+			rem = 0;
+			iter->seq.seq.len = save_len;
 			break;
 		}
 
-- 
2.1.1


