Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965121Ab3CZPWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:22:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53845 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965095Ab3CZPWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 072/150] tracing: Keep overwrite in sync between regular and snapshot buffers
Date: Tue, 26 Mar 2013 15:19:31 +0000
Message-Id: <1364311249-14454-73-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/trace.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index bd1df78..199f77b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2776,8 +2776,12 @@ static void set_tracer_flags(unsigned int mask, int enabled)
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
1.8.1.2

