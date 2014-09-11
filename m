Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbaIKOwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:52:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:38878 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752930AbaIKOtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:49:10 -0400
Message-Id: <20140911144908.204180198@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 11 Sep 2014 10:47:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 4/9] ftrace: Remove freeing of old_hash from ftrace_hash_move()
References: <20140911144744.907770249@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0004-ftrace-Remove-freeing-of-old_hash-from-ftrace_hash_m.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

ftrace_hash_move() currently frees the old hash that is passed to it
after replacing the pointer with the new hash. Instead of having the
function do that chore, have the caller perform the free.

This lets the ftrace_hash_move() be used a bit more freely, which
is needed for changing the way the trampoline logic is done.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 708aea493d96..2c4eef49b1af 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1316,7 +1316,6 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
 	struct ftrace_func_entry *entry;
 	struct hlist_node *tn;
 	struct hlist_head *hhd;
-	struct ftrace_hash *old_hash;
 	struct ftrace_hash *new_hash;
 	int size = src->count;
 	int bits = 0;
@@ -1361,9 +1360,7 @@ update:
 	 */
 	ftrace_hash_rec_disable_modify(ops, enable);
 
-	old_hash = *dst;
 	rcu_assign_pointer(*dst, new_hash);
-	free_ftrace_hash_rcu(old_hash);
 
 	ftrace_hash_rec_enable_modify(ops, enable);
 
@@ -3408,6 +3405,7 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 {
 	struct ftrace_func_probe *entry;
 	struct ftrace_hash **orig_hash = &trace_probe_ops.func_hash->filter_hash;
+	struct ftrace_hash *old_hash = *orig_hash;
 	struct ftrace_hash *hash;
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec;
@@ -3426,7 +3424,7 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 
 	mutex_lock(&trace_probe_ops.func_hash->regex_lock);
 
-	hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
+	hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, old_hash);
 	if (!hash) {
 		count = -ENOMEM;
 		goto out;
@@ -3485,7 +3483,9 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 	} while_for_each_ftrace_rec();
 
 	ret = ftrace_hash_move(&trace_probe_ops, 1, orig_hash, hash);
-	if (ret < 0)
+	if (!ret)
+		free_ftrace_hash_rcu(old_hash);
+	else
 		count = ret;
 
 	__enable_ftrace_function_probe();
@@ -3512,6 +3512,7 @@ __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 	struct ftrace_func_probe *entry;
 	struct ftrace_func_probe *p;
 	struct ftrace_hash **orig_hash = &trace_probe_ops.func_hash->filter_hash;
+	struct ftrace_hash *old_hash = *orig_hash;
 	struct list_head free_list;
 	struct ftrace_hash *hash;
 	struct hlist_node *tmp;
@@ -3519,6 +3520,7 @@ __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 	int type = MATCH_FULL;
 	int i, len = 0;
 	char *search;
+	int ret;
 
 	if (glob && (strcmp(glob, "*") == 0 || !strlen(glob)))
 		glob = NULL;
@@ -3577,8 +3579,11 @@ __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 	 * Remove after the disable is called. Otherwise, if the last
 	 * probe is removed, a null hash means *all enabled*.
 	 */
-	ftrace_hash_move(&trace_probe_ops, 1, orig_hash, hash);
+	ret = ftrace_hash_move(&trace_probe_ops, 1, orig_hash, hash);
 	synchronize_sched();
+	if (!ret)
+		free_ftrace_hash_rcu(old_hash);
+
 	list_for_each_entry_safe(entry, p, &free_list, free_list) {
 		list_del(&entry->free_list);
 		ftrace_free_entry(entry);
@@ -3776,6 +3781,7 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 		unsigned long ip, int remove, int reset, int enable)
 {
 	struct ftrace_hash **orig_hash;
+	struct ftrace_hash *old_hash;
 	struct ftrace_hash *hash;
 	int ret;
 
@@ -3810,10 +3816,12 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 	}
 
 	mutex_lock(&ftrace_lock);
+	old_hash = *orig_hash;
 	ret = ftrace_hash_move(ops, enable, orig_hash, hash);
-	if (!ret)
+	if (!ret) {
 		ftrace_ops_update_code(ops);
-
+		free_ftrace_hash_rcu(old_hash);
+	}
 	mutex_unlock(&ftrace_lock);
 
  out_regex_unlock:
@@ -4022,6 +4030,7 @@ int ftrace_regex_release(struct inode *inode, struct file *file)
 	struct seq_file *m = (struct seq_file *)file->private_data;
 	struct ftrace_iterator *iter;
 	struct ftrace_hash **orig_hash;
+	struct ftrace_hash *old_hash;
 	struct trace_parser *parser;
 	int filter_hash;
 	int ret;
@@ -4051,11 +4060,13 @@ int ftrace_regex_release(struct inode *inode, struct file *file)
 			orig_hash = &iter->ops->func_hash->notrace_hash;
 
 		mutex_lock(&ftrace_lock);
+		old_hash = *orig_hash;
 		ret = ftrace_hash_move(iter->ops, filter_hash,
 				       orig_hash, iter->hash);
-		if (!ret)
+		if (!ret) {
 			ftrace_ops_update_code(iter->ops);
-
+			free_ftrace_hash_rcu(old_hash);
+		}
 		mutex_unlock(&ftrace_lock);
 	}
 
-- 
2.0.1


