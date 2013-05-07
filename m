Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128Ab3EGCYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:24:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:2879 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933267Ab3EGCTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:32 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201782"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 32/48] Audit: pass proper user namespace to audit_filter_inode_name
Date: Tue, 7 May 2013 10:20:53 +0800
Message-Id: <1367893269-9308-33-git-send-email-gaofeng@cn.fujitsu.com>
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

We should use the right inode_hash list to filter the
task.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.h       |  5 +++--
 kernel/audit_watch.c |  3 ++-
 kernel/auditsc.c     | 14 ++++++++------
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/kernel/audit.h b/kernel/audit.h
index 7934598..0079cdd 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -157,11 +157,12 @@ static inline int audit_signal_info(int sig, struct task_struct *t)
 		return __audit_signal_info(sig, t);
 	return 0;
 }
-extern void audit_filter_inodes(struct task_struct *, struct audit_context *);
+extern void audit_filter_inodes(struct user_namespace *ns,
+				struct task_struct *, struct audit_context *);
 extern struct list_head *audit_killed_trees(void);
 #else
 #define audit_signal_info(s,t) AUDIT_DISABLED
-#define audit_filter_inodes(t,c) AUDIT_DISABLED
+#define audit_filter_inodes(n, t, c) AUDIT_DISABLED
 #endif
 
 extern struct mutex audit_cmd_mutex;
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index 27c7a3b..6be4cbe 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -274,7 +274,8 @@ static void audit_update_watch(struct audit_parent *parent,
 		/* If the update involves invalidating rules, do the inode-based
 		 * filtering now, so we don't omit records. */
 		if (invalidating && !audit_dummy_context())
-			audit_filter_inodes(current, current->audit_context);
+			audit_filter_inodes(current_user_ns(), current,
+					    current->audit_context);
 
 		/* updating ino will likely change which audit_hash_list we
 		 * are on so we need a new watch for the new list */
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 5401d21..3e3e7c7 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -900,12 +900,13 @@ static enum audit_state audit_filter_syscall(struct user_namespace *ns,
  * Given an audit_name check the inode hash table to see if they match.
  * Called holding the rcu read lock to protect the use of audit_inode_hash
  */
-static int audit_filter_inode_name(struct task_struct *tsk,
+static int audit_filter_inode_name(struct user_namespace *ns,
+				   struct task_struct *tsk,
 				   struct audit_names *n,
 				   struct audit_context *ctx) {
 	int word, bit;
 	int h = audit_hash_ino((u32)n->ino);
-	struct list_head *list = &init_user_ns.audit.inode_hash[h];
+	struct list_head *list = &ns->audit.inode_hash[h];
 	struct audit_entry *e;
 	enum audit_state state;
 
@@ -931,17 +932,18 @@ static int audit_filter_inode_name(struct task_struct *tsk,
  * buckets applicable to the inode numbers in audit_names.
  * Regarding audit_state, same rules apply as for audit_filter_syscall().
  */
-void audit_filter_inodes(struct task_struct *tsk, struct audit_context *ctx)
+void audit_filter_inodes(struct user_namespace *ns,
+			 struct task_struct *tsk, struct audit_context *ctx)
 {
 	struct audit_names *n;
 
-	if (init_user_ns.audit.pid && tsk->tgid == init_user_ns.audit.pid)
+	if (ns->audit.pid && tsk->tgid == ns->audit.pid)
 		return;
 
 	rcu_read_lock();
 
 	list_for_each_entry(n, &ctx->names_list, list) {
-		if (audit_filter_inode_name(tsk, n, ctx))
+		if (audit_filter_inode_name(ns, tsk, n, ctx))
 			break;
 	}
 	rcu_read_unlock();
@@ -979,7 +981,7 @@ static inline struct audit_context *audit_get_context(struct task_struct *tsk,
 	if (context->in_syscall && !context->dummy) {
 		audit_filter_syscall(ns, tsk, context,
 				&ns->audit.filter_list[AUDIT_FILTER_EXIT]);
-		audit_filter_inodes(tsk, context);
+		audit_filter_inodes(ns, tsk, context);
 	}
 
 	tsk->audit_context = NULL;
-- 
1.8.1.4

