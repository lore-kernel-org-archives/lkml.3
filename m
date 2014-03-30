Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbaCaAIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:08:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754312AbaC3Xmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:42:43 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.653725009@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 035/200] ftrace: Fix synchronization location
 disabling and freeing ftrace_ops
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit a4c35ed241129dd142be4cadb1e5a474a56d5464 upstream.

The synchronization needed after ftrace_ops are unregistered must happen
after the callback is disabled from becing called by functions.

The current location happens after the function is being removed from the
internal lists, but not after the function callbacks were disabled, leaving
the functions susceptible of being called after their callbacks are freed.

This affects perf and any externel users of function tracing (LTTng and
SystemTap).

Fixes: cdbe61bfe704 "ftrace: Allow dynamically allocated function tracers"
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[bwh: Backported to 3.2: drop change for control ops]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/ftrace.c | 58 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 26 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -319,17 +319,6 @@ static int __unregister_ftrace_function(
 	if (ftrace_enabled)
 		update_ftrace_function();
 
-	/*
-	 * Dynamic ops may be freed, we must make sure that all
-	 * callers are done before leaving this function.
-	 *
-	 * Again, normal synchronize_sched() is not good enough.
-	 * We need to do a hard force of sched synchronization.
-	 */
-	if (ops->flags & FTRACE_OPS_FL_DYNAMIC)
-		schedule_on_each_cpu(ftrace_sync);
-
-
 	return 0;
 }
 
@@ -1790,6 +1779,24 @@ static int ftrace_shutdown(struct ftrace
 		return 0;
 
 	ftrace_run_update_code(command);
+
+	/*
+	 * Dynamic ops may be freed, we must make sure that all
+	 * callers are done before leaving this function.
+	 * The same goes for freeing the per_cpu data of the control
+	 * ops.
+	 *
+	 * Again, normal synchronize_sched() is not good enough.
+	 * We need to do a hard force of sched synchronization.
+	 * This is because we use preempt_disable() to do RCU, but
+	 * the function tracers can be called where RCU is not watching
+	 * (like before user_exit()). We can not rely on the RCU
+	 * infrastructure to do the synchronization, thus we must do it
+	 * ourselves.
+	 */
+	if (ops->flags & (FTRACE_OPS_FL_DYNAMIC))
+		schedule_on_each_cpu(ftrace_sync);
+
 	return 0;
 }
 

