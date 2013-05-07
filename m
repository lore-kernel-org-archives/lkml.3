Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473Ab3EGC0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:26:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63100 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933245Ab3EGCTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:32 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201778"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 34/48] Log audit tree related message in proper user namespace
Date: Tue, 7 May 2013 10:20:55 +0800
Message-Id: <1367893269-9308-35-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:30,
	Serialize complete at 2013/05/07 10:18:30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, we can log audit tree related message in the right
user namespace.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.h      |  4 ++--
 kernel/audit_tree.c | 27 ++++++++++++++-------------
 kernel/auditsc.c    |  6 ++++--
 3 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/kernel/audit.h b/kernel/audit.h
index 0079cdd..64ee671 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -129,7 +129,7 @@ extern void audit_trim_trees(void);
 extern int audit_tag_tree(char *old, char *new);
 extern const char *audit_tree_path(struct audit_tree *);
 extern void audit_put_tree(struct audit_tree *);
-extern void audit_kill_trees(struct list_head *);
+extern void audit_kill_trees(struct user_namespace *ns, struct list_head *);
 #else
 #define audit_remove_tree_rule(rule) BUG()
 #define audit_add_tree_rule(ns, rule) -EINVAL
@@ -138,7 +138,7 @@ extern void audit_kill_trees(struct list_head *);
 #define audit_put_tree(tree) (void)0
 #define audit_tag_tree(old, new) -EINVAL
 #define audit_tree_path(rule) ""	/* never called */
-#define audit_kill_trees(list) BUG()
+#define audit_kill_trees(ns, list) BUG()
 #endif
 
 extern char *audit_unpack_string(void **, size_t *, size_t);
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 4531d73..521766d 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -448,11 +448,12 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 	return 0;
 }
 
-static void audit_log_remove_rule(struct audit_krule *rule)
+static void audit_log_remove_rule(struct user_namespace *ns,
+				  struct audit_krule *rule)
 {
 	struct audit_buffer *ab;
 
-	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
+	ab = audit_log_start_ns(ns, NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE);
 	if (unlikely(!ab))
 		return;
 	audit_log_format(ab, "op=");
@@ -461,10 +462,10 @@ static void audit_log_remove_rule(struct audit_krule *rule)
 	audit_log_untrustedstring(ab, rule->tree->pathname);
 	audit_log_key(ab, rule->filterkey);
 	audit_log_format(ab, " list=%d res=1", rule->listnr);
-	audit_log_end(ab);
+	audit_log_end_ns(ns, ab);
 }
 
-static void kill_rules(struct audit_tree *tree)
+static void kill_rules(struct user_namespace *ns, struct audit_tree *tree)
 {
 	struct audit_krule *rule, *next;
 	struct audit_entry *entry;
@@ -475,7 +476,7 @@ static void kill_rules(struct audit_tree *tree)
 		list_del_init(&rule->rlist);
 		if (rule->tree) {
 			/* not a half-baked one */
-			audit_log_remove_rule(rule);
+			audit_log_remove_rule(ns, rule);
 			rule->tree = NULL;
 			list_del_rcu(&entry->list);
 			list_del(&entry->rule.list);
@@ -503,7 +504,7 @@ static void prune_one(struct audit_tree *victim)
 
 /* trim the uncommitted chunks from tree */
 
-static void trim_marked(struct audit_tree *tree)
+static void trim_marked(struct user_namespace *ns, struct audit_tree *tree)
 {
 	struct list_head *p, *q;
 	spin_lock(&hash_lock);
@@ -536,7 +537,7 @@ static void trim_marked(struct audit_tree *tree)
 		tree->goner = 1;
 		spin_unlock(&hash_lock);
 		mutex_lock(&audit_filter_mutex);
-		kill_rules(tree);
+		kill_rules(ns, tree);
 		list_del_init(&tree->list);
 		mutex_unlock(&audit_filter_mutex);
 		prune_one(tree);
@@ -616,7 +617,7 @@ void audit_trim_trees(void)
 				node->index &= ~(1U<<31);
 		}
 		spin_unlock(&hash_lock);
-		trim_marked(tree);
+		trim_marked(current_user_ns(), tree);
 		drop_collected_mounts(root_mnt);
 skip_it:
 		put_tree(tree);
@@ -693,7 +694,7 @@ int audit_add_tree_rule(struct user_namespace *ns, struct audit_krule *rule)
 			node->index &= ~(1U<<31);
 		spin_unlock(&hash_lock);
 	} else {
-		trim_marked(tree);
+		trim_marked(ns, tree);
 		goto Err;
 	}
 
@@ -797,7 +798,7 @@ int audit_tag_tree(char *old, char *new)
 				node->index &= ~(1U<<31);
 			spin_unlock(&hash_lock);
 		} else {
-			trim_marked(tree);
+			trim_marked(ns, tree);
 		}
 
 		put_tree(tree);
@@ -847,7 +848,7 @@ static void audit_schedule_prune(void)
  * ... and that one is done if evict_chunk() decides to delay until the end
  * of syscall.  Runs synchronously.
  */
-void audit_kill_trees(struct list_head *list)
+void audit_kill_trees(struct user_namespace *ns, struct list_head *list)
 {
 	mutex_lock(&audit_cmd_mutex);
 	mutex_lock(&audit_filter_mutex);
@@ -856,7 +857,7 @@ void audit_kill_trees(struct list_head *list)
 		struct audit_tree *victim;
 
 		victim = list_entry(list->next, struct audit_tree, list);
-		kill_rules(victim);
+		kill_rules(ns, victim);
 		list_del_init(&victim->list);
 
 		mutex_unlock(&audit_filter_mutex);
@@ -895,7 +896,7 @@ static void evict_chunk(struct audit_chunk *chunk)
 		list_del_init(&owner->same_root);
 		spin_unlock(&hash_lock);
 		if (!postponed) {
-			kill_rules(owner);
+			kill_rules(current_user_ns(), owner);
 			list_move(&owner->list, &prune_list);
 			need_prune = 1;
 		} else {
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 3e3e7c7..544eb82 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1737,7 +1737,8 @@ void __audit_free(struct task_struct *tsk)
 	if (context->in_syscall && context->current_state == AUDIT_RECORD_CONTEXT)
 		audit_log_exit(context, tsk);
 	if (!list_empty(&context->killed_trees))
-		audit_kill_trees(&context->killed_trees);
+		audit_kill_trees(task_cred_xxx(tsk, user_ns),
+				 &context->killed_trees);
 
 	audit_free_context(context);
 }
@@ -1815,6 +1816,7 @@ void __audit_syscall_exit(int success, long return_code)
 {
 	struct task_struct *tsk = current;
 	struct audit_context *context;
+	struct user_namespace *ns = current_user_ns();
 
 	if (success)
 		success = AUDITSC_SUCCESS;
@@ -1832,7 +1834,7 @@ void __audit_syscall_exit(int success, long return_code)
 	context->prio = context->state == AUDIT_RECORD_CONTEXT ? ~0ULL : 0;
 
 	if (!list_empty(&context->killed_trees))
-		audit_kill_trees(&context->killed_trees);
+		audit_kill_trees(ns, &context->killed_trees);
 
 	audit_free_names(context);
 	unroll_tree_refs(context, NULL, 0);
-- 
1.8.1.4

