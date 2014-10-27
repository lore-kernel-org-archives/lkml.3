Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaJ0R7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:59:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:44979 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752013AbaJ0R6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:58:48 -0400
Message-Id: <20141027175845.080742922@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 27 Oct 2014 13:56:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] ftrace: Set ops->old_hash on modifying what an ops hooks to
References: <20141027175606.622391559@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-ftrace-Set-ops-old_hash-on-modifying-what-an-ops-hoo.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The code that checks for trampolines when modifying function hooks
tests against a modified ops "old_hash". But the ops old_hash pointer
is not being updated before the changes are made, making it possible
to not find the right hash to the callback and possibly causing
ftrace to break in accounting and disable itself.

Have the ops set its old_hash before the modifying takes place.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index fb186b9ddf51..483b8c1b1de0 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2293,10 +2293,13 @@ static void ftrace_run_update_code(int command)
 	FTRACE_WARN_ON(ret);
 }
 
-static void ftrace_run_modify_code(struct ftrace_ops *ops, int command)
+static void ftrace_run_modify_code(struct ftrace_ops *ops, int command,
+				   struct ftrace_hash *old_hash)
 {
 	ops->flags |= FTRACE_OPS_FL_MODIFYING;
+	ops->old_hash.filter_hash = old_hash;
 	ftrace_run_update_code(command);
+	ops->old_hash.filter_hash = NULL;
 	ops->flags &= ~FTRACE_OPS_FL_MODIFYING;
 }
 
@@ -3340,7 +3343,7 @@ static struct ftrace_ops trace_probe_ops __read_mostly =
 
 static int ftrace_probe_registered;
 
-static void __enable_ftrace_function_probe(void)
+static void __enable_ftrace_function_probe(struct ftrace_hash *old_hash)
 {
 	int ret;
 	int i;
@@ -3348,7 +3351,8 @@ static void __enable_ftrace_function_probe(void)
 	if (ftrace_probe_registered) {
 		/* still need to update the function call sites */
 		if (ftrace_enabled)
-			ftrace_run_modify_code(&trace_probe_ops, FTRACE_UPDATE_CALLS);
+			ftrace_run_modify_code(&trace_probe_ops, FTRACE_UPDATE_CALLS,
+					       old_hash);
 		return;
 	}
 
@@ -3477,13 +3481,14 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 	} while_for_each_ftrace_rec();
 
 	ret = ftrace_hash_move(&trace_probe_ops, 1, orig_hash, hash);
+
+	__enable_ftrace_function_probe(old_hash);
+
 	if (!ret)
 		free_ftrace_hash_rcu(old_hash);
 	else
 		count = ret;
 
-	__enable_ftrace_function_probe();
-
  out_unlock:
 	mutex_unlock(&ftrace_lock);
  out:
@@ -3764,10 +3769,11 @@ ftrace_match_addr(struct ftrace_hash *hash, unsigned long ip, int remove)
 	return add_hash_entry(hash, ip);
 }
 
-static void ftrace_ops_update_code(struct ftrace_ops *ops)
+static void ftrace_ops_update_code(struct ftrace_ops *ops,
+				   struct ftrace_hash *old_hash)
 {
 	if (ops->flags & FTRACE_OPS_FL_ENABLED && ftrace_enabled)
-		ftrace_run_modify_code(ops, FTRACE_UPDATE_CALLS);
+		ftrace_run_modify_code(ops, FTRACE_UPDATE_CALLS, old_hash);
 }
 
 static int
@@ -3813,7 +3819,7 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 	old_hash = *orig_hash;
 	ret = ftrace_hash_move(ops, enable, orig_hash, hash);
 	if (!ret) {
-		ftrace_ops_update_code(ops);
+		ftrace_ops_update_code(ops, old_hash);
 		free_ftrace_hash_rcu(old_hash);
 	}
 	mutex_unlock(&ftrace_lock);
@@ -4058,7 +4064,7 @@ int ftrace_regex_release(struct inode *inode, struct file *file)
 		ret = ftrace_hash_move(iter->ops, filter_hash,
 				       orig_hash, iter->hash);
 		if (!ret) {
-			ftrace_ops_update_code(iter->ops);
+			ftrace_ops_update_code(iter->ops, old_hash);
 			free_ftrace_hash_rcu(old_hash);
 		}
 		mutex_unlock(&ftrace_lock);
-- 
2.1.1


