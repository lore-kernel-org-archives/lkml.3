Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760584AbaGYOGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:06:32 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:20299 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760509AbaGYOGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:06:17 -0400
Message-Id: <20140725140612.497746850@goodmis.org>
User-Agent: quilt/0.63-1
Date: Fri, 25 Jul 2014 10:05:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH 1/4] ftrace: Rename ftrace_ops field from trampolines to nr_trampolines
References: <20140725140514.377803118@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-ftrace-Rename-ftrace_ops-field-from-trampolines-to-n.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Having two fields within the same struct that is off by one character
can be confusing and error prone. Rename the counter "trampolines"
to "nr_trampolines" to explicitly show it is a counter and not to
be confused by the "trampoline" field.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |  2 +-
 kernel/trace/ftrace.c  | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 7a5b7b97e539..6bb5e3f2a3b4 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -120,7 +120,7 @@ struct ftrace_ops {
 	void				*private;
 	int __percpu			*disabled;
 #ifdef CONFIG_DYNAMIC_FTRACE
-	int				trampolines;
+	int				nr_trampolines;
 	struct ftrace_hash		*notrace_hash;
 	struct ftrace_hash		*filter_hash;
 	struct ftrace_hash		*tramp_hash;
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 762806026561..eda69c9f78d0 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1513,7 +1513,7 @@ static void ftrace_remove_tramp(struct ftrace_ops *ops,
 	 * The tramp_hash entry will be removed at time
 	 * of update.
 	 */
-	ops->trampolines--;
+	ops->nr_trampolines--;
 	rec->flags &= ~FTRACE_FL_TRAMP;
 }
 
@@ -1522,7 +1522,7 @@ static void ftrace_clear_tramps(struct dyn_ftrace *rec)
 	struct ftrace_ops *op;
 
 	do_for_each_ftrace_op(op, ftrace_ops_list) {
-		if (op->trampolines)
+		if (op->nr_trampolines)
 			ftrace_remove_tramp(op, rec);
 	} while_for_each_ftrace_op(op);
 }
@@ -1617,7 +1617,7 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 			 */
 			if (ftrace_rec_count(rec) == 1 && ops->trampoline) {
 				rec->flags |= FTRACE_FL_TRAMP;
-				ops->trampolines++;
+				ops->nr_trampolines++;
 			} else {
 				/*
 				 * If we are adding another function callback
@@ -2185,7 +2185,7 @@ static int ftrace_save_ops_tramp_hash(struct ftrace_ops *ops)
 	int size, bits;
 	int ret;
 
-	size = ops->trampolines;
+	size = ops->nr_trampolines;
 	bits = 0;
 	/*
 	 * Make the hash size about 1/2 the # found
@@ -2239,7 +2239,7 @@ static int ftrace_save_tramp_hashes(void)
 		free_ftrace_hash(op->tramp_hash);
 		op->tramp_hash = NULL;
 
-		if (op->trampolines) {
+		if (op->nr_trampolines) {
 			ret = ftrace_save_ops_tramp_hash(op);
 			if (ret)
 				return ret;
-- 
2.0.1


