Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbaGCQMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:12:36 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:3745 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759144AbaGCQMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:12:25 -0400
Message-Id: <20140703161223.916756641@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 12:05:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 03/21] ftrace: Add ftrace_rec_counter() macro to simplify the code
References: <20140703160503.006976702@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-ftrace-Add-ftrace_rec_counter-macro-to-simplify-the-.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The ftrace dynamic record has a flags element that also has a counter.
Instead of hard coding "rec->flags & ~FTRACE_FL_MASK" all over the
place. Use a macro instead.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |  2 ++
 kernel/trace/ftrace.c  | 12 ++++++------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index e4e7df422021..e5baa6b2c93f 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -328,6 +328,8 @@ enum {
 #define FTRACE_FL_MASK		(FTRACE_FL_MASKED_BITS << FTRACE_REF_MAX_SHIFT)
 #define FTRACE_REF_MAX		((1UL << FTRACE_REF_MAX_SHIFT) - 1)
 
+#define ftrace_rec_count(rec)	((rec)->flags & ~FTRACE_FL_MASK)
+
 struct dyn_ftrace {
 	unsigned long		ip; /* address of mcount call-site */
 	unsigned long		flags;
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index b867c647e5bc..a58d840305c3 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1592,7 +1592,7 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 
 		if (inc) {
 			rec->flags++;
-			if (FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == FTRACE_REF_MAX))
+			if (FTRACE_WARN_ON(ftrace_rec_count(rec) == FTRACE_REF_MAX))
 				return;
 			/*
 			 * If any ops wants regs saved for this function
@@ -1601,7 +1601,7 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 			if (ops->flags & FTRACE_OPS_FL_SAVE_REGS)
 				rec->flags |= FTRACE_FL_REGS;
 		} else {
-			if (FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
+			if (FTRACE_WARN_ON(ftrace_rec_count(rec) == 0))
 				return;
 			rec->flags--;
 			/*
@@ -1610,7 +1610,7 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 			 * still any ops for this record that wants regs.
 			 * If not, we can stop recording them.
 			 */
-			if ((rec->flags & ~FTRACE_FL_MASK) > 0 &&
+			if (ftrace_rec_count(rec) > 0 &&
 			    rec->flags & FTRACE_FL_REGS &&
 			    ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
 				if (!test_rec_ops_needs_regs(rec))
@@ -1700,7 +1700,7 @@ static int ftrace_check_record(struct dyn_ftrace *rec, int enable, int update)
 	 * If we are disabling calls, then disable all records that
 	 * are enabled.
 	 */
-	if (enable && (rec->flags & ~FTRACE_FL_MASK))
+	if (enable && ftrace_rec_count(rec))
 		flag = FTRACE_FL_ENABLED;
 
 	/*
@@ -1746,7 +1746,7 @@ static int ftrace_check_record(struct dyn_ftrace *rec, int enable, int update)
 
 	if (update) {
 		/* If there's no more users, clear all flags */
-		if (!(rec->flags & ~FTRACE_FL_MASK))
+		if (!ftrace_rec_count(rec))
 			rec->flags = 0;
 		else
 			/* Just disable the record (keep REGS state) */
@@ -2685,7 +2685,7 @@ static int t_show(struct seq_file *m, void *v)
 	seq_printf(m, "%ps", (void *)rec->ip);
 	if (iter->flags & FTRACE_ITER_ENABLED)
 		seq_printf(m, " (%ld)%s",
-			   rec->flags & ~FTRACE_FL_MASK,
+			   ftrace_rec_count(rec),
 			   rec->flags & FTRACE_FL_REGS ? " R" : "");
 	seq_printf(m, "\n");
 
-- 
2.0.0


