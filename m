Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab3CYBQL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:16:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34013 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756061Ab3CYBQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:03 -0400
Message-Id: <20130325010530.219076216@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:24 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Subject: [ 060/104] tracing: Keep overwrite in sync between regular and snapshot buffers
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 80902822658aab18330569587cdb69ac1dfdcea8 upstream.

Changing the overwrite mode for the ring buffer via the trace
option only sets the normal buffer. But the snapshot buffer could
swap with it, and then the snapshot would be in non overwrite mode
and the normal buffer would be in overwrite mode, even though the
option flag states otherwise.

Keep the two buffers overwrite modes in sync.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/trace.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2650,8 +2650,12 @@ static void set_tracer_flags(unsigned in
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


