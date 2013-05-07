Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934174Ab3EGC1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:27:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59645 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932966Ab3EGCTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:31 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201773"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 28/48] Audit: make audit filter list per user namespace
Date: Tue, 7 May 2013 10:20:49 +0800
Message-Id: <1367893269-9308-29-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:29,
	Serialize complete at 2013/05/07 10:18:29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch just make the audit filter list per user namespace.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/user_namespace.h |  2 ++
 kernel/audit.c                 |  4 ++++
 kernel/auditfilter.c           | 23 +++++++----------------
 kernel/auditsc.c               | 12 +++++++++---
 kernel/user.c                  | 19 +++++++++++++++++++
 5 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index c870e28..d1dd5b9 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -6,6 +6,7 @@
 #include <linux/sched.h>
 #include <linux/err.h>
 #include <linux/skbuff.h>
+#include <uapi/linux/audit.h>
 
 #define UID_GID_MAP_MAX_EXTENTS 5
 
@@ -33,6 +34,7 @@ struct audit_ctrl {
 #define AUDIT_INODE_BUCKETS	32
 	struct list_head	inode_hash[AUDIT_INODE_BUCKETS];
 	struct list_head	tree_list;
+	struct list_head	filter_list[AUDIT_NR_FILTERS];
 	bool			ever_enabled;
 };
 #endif
diff --git a/kernel/audit.c b/kernel/audit.c
index a0544b1..1ca1714 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1609,6 +1609,10 @@ void audit_set_user_ns(struct user_namespace *ns)
 	for (i = 0; i < AUDIT_INODE_BUCKETS; i++)
 		INIT_LIST_HEAD(&ns->audit.inode_hash[i]);
 
+	if (ns != &init_user_ns)
+		for (i = 0; i < AUDIT_NR_FILTERS; i++)
+			INIT_LIST_HEAD(&ns->audit.filter_list[i]);
+
 	INIT_LIST_HEAD(&ns->audit.tree_list);
 
 	ns->audit.initialized = AUDIT_INITIALIZED;
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 3c8fb2e..dbf05a9 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -44,18 +44,6 @@
  * 		be written directly provided audit_filter_mutex is held.
  */
 
-/* Audit filter lists, defined in <linux/audit.h> */
-struct list_head audit_filter_list[AUDIT_NR_FILTERS] = {
-	LIST_HEAD_INIT(audit_filter_list[0]),
-	LIST_HEAD_INIT(audit_filter_list[1]),
-	LIST_HEAD_INIT(audit_filter_list[2]),
-	LIST_HEAD_INIT(audit_filter_list[3]),
-	LIST_HEAD_INIT(audit_filter_list[4]),
-	LIST_HEAD_INIT(audit_filter_list[5]),
-#if AUDIT_NR_FILTERS != 6
-#error Fix audit_filter_list initialiser
-#endif
-};
 static struct list_head audit_rules_list[AUDIT_NR_FILTERS] = {
 	LIST_HEAD_INIT(audit_rules_list[0]),
 	LIST_HEAD_INIT(audit_rules_list[1]),
@@ -908,7 +896,7 @@ static struct audit_entry *audit_find_rule(struct user_namespace *ns,
 		}
 		goto out;
 	} else {
-		*p = list = &audit_filter_list[entry->rule.listnr];
+		*p = list = &ns->audit.filter_list[entry->rule.listnr];
 	}
 
 	list_for_each_entry(e, list, list)
@@ -1416,10 +1404,12 @@ int audit_filter_user(void)
 {
 	enum audit_state state = AUDIT_DISABLED;
 	struct audit_entry *e;
+	struct user_namespace *ns = current_user_ns();
 	int ret = 1;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_USER], list) {
+	list_for_each_entry_rcu(e, &ns->audit.filter_list[AUDIT_FILTER_USER],
+				list) {
 		if (audit_filter_user_rules(&e->rule, &state)) {
 			if (state == AUDIT_DISABLED)
 				ret = 0;
@@ -1434,13 +1424,14 @@ int audit_filter_user(void)
 int audit_filter_type(int type)
 {
 	struct audit_entry *e;
+	struct user_namespace *ns = current_user_ns();
 	int result = 0;
 
 	rcu_read_lock();
-	if (list_empty(&audit_filter_list[AUDIT_FILTER_TYPE]))
+	if (list_empty(&ns->audit.filter_list[AUDIT_FILTER_TYPE]))
 		goto unlock_and_return;
 
-	list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_TYPE],
+	list_for_each_entry_rcu(e, &ns->audit.filter_list[AUDIT_FILTER_TYPE],
 				list) {
 		int i;
 		for (i = 0; i < e->rule.field_count; i++) {
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 55bd99e..29c3e05 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -844,9 +844,11 @@ static enum audit_state audit_filter_task(struct task_struct *tsk, char **key)
 {
 	struct audit_entry *e;
 	enum audit_state   state;
+	struct user_namespace *ns = current_user_ns();
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_TASK], list) {
+	list_for_each_entry_rcu(e, &ns->audit.filter_list[AUDIT_FILTER_TASK],
+				list) {
 		if (audit_filter_rules(tsk, &e->rule, NULL, NULL,
 				       &state, true)) {
 			if (state == AUDIT_RECORD_CONTEXT)
@@ -949,6 +951,7 @@ static inline struct audit_context *audit_get_context(struct task_struct *tsk,
 						      long return_code)
 {
 	struct audit_context *context = tsk->audit_context;
+	struct user_namespace *ns = task_cred_xxx(tsk, user_ns);
 
 	if (!context)
 		return NULL;
@@ -973,7 +976,8 @@ static inline struct audit_context *audit_get_context(struct task_struct *tsk,
 		context->return_code  = return_code;
 
 	if (context->in_syscall && !context->dummy) {
-		audit_filter_syscall(tsk, context, &audit_filter_list[AUDIT_FILTER_EXIT]);
+		audit_filter_syscall(tsk, context,
+				&ns->audit.filter_list[AUDIT_FILTER_EXIT]);
 		audit_filter_inodes(tsk, context);
 	}
 
@@ -1759,6 +1763,7 @@ void __audit_syscall_entry(int arch, int major,
 	struct task_struct *tsk = current;
 	struct audit_context *context = tsk->audit_context;
 	enum audit_state     state;
+	struct user_namespace *ns = current_user_ns();
 
 	if (!context)
 		return;
@@ -1779,7 +1784,8 @@ void __audit_syscall_entry(int arch, int major,
 	context->dummy = !audit_n_rules;
 	if (!context->dummy && state == AUDIT_BUILD_CONTEXT) {
 		context->prio = 0;
-		state = audit_filter_syscall(tsk, context, &audit_filter_list[AUDIT_FILTER_ENTRY]);
+		state = audit_filter_syscall(tsk, context,
+			&ns->audit.filter_list[AUDIT_FILTER_ENTRY]);
 	}
 	if (state == AUDIT_DISABLED)
 		return;
diff --git a/kernel/user.c b/kernel/user.c
index 69b4c3d..637bd39 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -51,6 +51,25 @@ struct user_namespace init_user_ns = {
 	.owner = GLOBAL_ROOT_UID,
 	.group = GLOBAL_ROOT_GID,
 	.proc_inum = PROC_USER_INIT_INO,
+#ifdef CONFIG_AUDIT
+	.audit = {
+		.filter_list[0] =
+			LIST_HEAD_INIT(init_user_ns.audit.filter_list[0]),
+		.filter_list[1] =
+			LIST_HEAD_INIT(init_user_ns.audit.filter_list[1]),
+		.filter_list[2] =
+			LIST_HEAD_INIT(init_user_ns.audit.filter_list[2]),
+		.filter_list[3] =
+			LIST_HEAD_INIT(init_user_ns.audit.filter_list[3]),
+		.filter_list[4] =
+			LIST_HEAD_INIT(init_user_ns.audit.filter_list[4]),
+		.filter_list[5] =
+			LIST_HEAD_INIT(init_user_ns.audit.filter_list[5]),
+#if AUDIT_NR_FILTERS != 6
+#error Fix audit_filter_list of init_user_ns initialiser
+#endif
+	},
+#endif
 	.may_mount_sysfs = true,
 	.may_mount_proc = true,
 };
-- 
1.8.1.4

