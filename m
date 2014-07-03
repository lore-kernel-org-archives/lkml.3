Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307AbaGCQS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:18:27 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:62039 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759132AbaGCQMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:12:24 -0400
Message-Id: <20140703161223.606579136@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 12:05:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 01/21] ftrace: Allow no regs if no more callbacks require it
References: <20140703160503.006976702@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-ftrace-Allow-no-regs-if-no-more-callbacks-require-it.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When registering a function callback for the function tracer, the ops
can specify if it wants to save full regs (like an interrupt would)
for each function that it traces, or if it does not care about regs
and just wants to have the fastest return possible.

Once a ops has registered a function, if other ops register that
function they all will receive the regs too. That's because it does
the work once, it does it for everyone.

Now if the ops wanting regs unregisters the function so that there's
only ops left that do not care about regs, those ops will still
continue getting regs and going through the work for it on that
function. This is because the disabling of the rec counter only
sees the ops registered, and does not see the ops that are still
attached, and does not know if the current ops that are still attached
want regs or not. To play it safe, it just keeps regs being processed
until no function is registered anymore.

Instead of doing that, check the ops that are still registered for that
function and if none want regs for it anymore, then disable the
processing of regs.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5b372e3ed675..b867c647e5bc 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1492,6 +1492,26 @@ int ftrace_text_reserved(const void *start, const void *end)
 	return (int)!!ret;
 }
 
+/* Test if ops registered to this rec needs regs */
+static bool test_rec_ops_needs_regs(struct dyn_ftrace *rec)
+{
+	struct ftrace_ops *ops;
+	bool keep_regs = false;
+
+	for (ops = ftrace_ops_list;
+	     ops != &ftrace_list_end; ops = ops->next) {
+		/* pass rec in as regs to have non-NULL val */
+		if (ftrace_ops_test(ops, rec->ip, rec)) {
+			if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
+				keep_regs = true;
+				break;
+			}
+		}
+	}
+
+	return  keep_regs;
+}
+
 static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 				     int filter_hash,
 				     bool inc)
@@ -1584,6 +1604,18 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 			if (FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
 				return;
 			rec->flags--;
+			/*
+			 * If the rec had REGS enabled and the ops that is
+			 * being removed had REGS set, then see if there is
+			 * still any ops for this record that wants regs.
+			 * If not, we can stop recording them.
+			 */
+			if ((rec->flags & ~FTRACE_FL_MASK) > 0 &&
+			    rec->flags & FTRACE_FL_REGS &&
+			    ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
+				if (!test_rec_ops_needs_regs(rec))
+					rec->flags &= ~FTRACE_FL_REGS;
+			}
 		}
 		count++;
 		/* Shortcut, if we handled all records, we are done. */
-- 
2.0.0


