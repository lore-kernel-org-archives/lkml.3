Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab3FKNOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 09:14:08 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:55354 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab3FKNOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 09:14:04 -0400
X-Nat-Received: from [202.181.97.72]:65283 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1370956442.22712
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH 3/4] TOMOYO: Remember the proposed domain while in execve() request.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201306112211.GBH48909.SOFOFJHMtFQVLO@I-love.SAKURA.ne.jp>
In-Reply-To: <201306112211.GBH48909.SOFOFJHMtFQVLO@I-love.SAKURA.ne.jp>
Message-Id: <201306112214.HDB65102.OOtFSOHFLQFVJM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 11 Jun 2013 22:14:01 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 11062013 #10379665, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2567f2c896e1fe57f096619cfe750ebc9fc2ad01 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Tue, 11 Jun 2013 21:35:29 +0900
Subject: [PATCH 3/4] TOMOYO: Remember the proposed domain while in execve() request.

Introduce per a task_struct variable which remembers the proposed domain
so that TOMOYO can find the proposed domain before execve() succeeds.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/tomoyo/common.h |   34 +++++++++-
 security/tomoyo/tomoyo.c |  163 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 191 insertions(+), 6 deletions(-)

diff --git a/security/tomoyo/common.h b/security/tomoyo/common.h
index b897d48..60e5800 100644
--- a/security/tomoyo/common.h
+++ b/security/tomoyo/common.h
@@ -36,6 +36,9 @@
 
 /********** Constants definitions. **********/
 
+/* Current thread is doing do_execve() ? */
+#define TOMOYO_TASK_IS_IN_EXECVE 1
+
 /*
  * TOMOYO uses this hash only when appending a string into the string
  * table. Frequency of appending strings is very low. So we don't need
@@ -398,6 +401,16 @@ enum tomoyo_pref_index {
 
 /********** Structure definitions. **********/
 
+/* Per a task_struct variable. */
+struct tomoyo_security {
+	struct list_head list;
+	const struct task_struct *task;
+	/* NULL unless tomoyo_flags has TOMOYO_TASK_IS_IN_EXECVE flag. */
+	struct tomoyo_domain_info *tomoyo_domain_info;
+	u32 tomoyo_flags;
+	struct rcu_head rcu;
+};
+
 /* Common header for holding ACL entries. */
 struct tomoyo_acl_head {
 	struct list_head list;
@@ -913,6 +926,7 @@ struct tomoyo_policy_namespace {
 
 /********** Function prototypes. **********/
 
+struct tomoyo_security *tomoyo_find_task_security(void);
 bool tomoyo_address_matches_group(const bool is_ipv6, const __be32 *address,
 				  const struct tomoyo_group *group);
 bool tomoyo_compare_number_union(const unsigned long value,
@@ -1202,7 +1216,25 @@ static inline void tomoyo_put_group(struct tomoyo_group *group)
  */
 static inline struct tomoyo_domain_info *tomoyo_domain(void)
 {
-	return current_cred()->security;
+	/*
+	 * Return the proposed domain stored in "struct linux_binprm *"
+	 * if current thread is in do_execve(). The proposed domain will be
+	 * cleared when do_execve() finished.
+	 */
+	struct tomoyo_security *ptr = tomoyo_find_task_security();
+	return ptr && (ptr->tomoyo_flags & TOMOYO_TASK_IS_IN_EXECVE) ?
+		ptr->tomoyo_domain_info : current_cred()->security;
+}
+
+/**
+ * tomoyo_current_flags - Get flags for current thread.
+ *
+ * Returns flags for current thread.
+ */
+static inline u32 tomoyo_current_flags(void)
+{
+	struct tomoyo_security *ptr = tomoyo_find_task_security();
+	return ptr ? ptr->tomoyo_flags : 0;
 }
 
 /**
diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index f0b756e..7039302 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -7,6 +7,110 @@
 #include <linux/security.h>
 #include "common.h"
 
+/* List of "struct tomoyo_security" associated with "struct task_struct". */
+static LIST_HEAD(tomoyo_task_security_list);
+/* Lock for protecting tomoyo_task_security_list list. */
+static DEFINE_SPINLOCK(tomoyo_task_security_list_lock);
+
+/**
+ * tomoyo_del_task_security - Release "struct tomoyo_security".
+ *
+ * @ptr: Pointer to "struct tomoyo_security".
+ *
+ * Returns nothing.
+ */
+static void tomoyo_del_task_security(struct tomoyo_security *ptr)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&tomoyo_task_security_list_lock, flags);
+	list_del_rcu(&ptr->list);
+	spin_unlock_irqrestore(&tomoyo_task_security_list_lock, flags);
+	kfree_rcu(ptr, rcu);
+}
+
+/**
+ * tomoyo_add_task_security - Add "struct tomoyo_security" to list.
+ *
+ * @ptr:  Pointer to "struct tomoyo_security".
+ *
+ * Returns nothing.
+ */
+static void tomoyo_add_task_security(struct tomoyo_security *ptr)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&tomoyo_task_security_list_lock, flags);
+	list_add_rcu(&ptr->list, &tomoyo_task_security_list);
+	spin_unlock_irqrestore(&tomoyo_task_security_list_lock, flags);
+}
+
+/**
+ * tomoyo_find_task_security - Find "struct tomoyo_security" for current thread.
+ *
+ * Returns pointer to "struct tomoyo_security" if found, NULL otherwise.
+ */
+struct tomoyo_security *tomoyo_find_task_security(void)
+{
+	const struct task_struct *task = current;
+	struct tomoyo_security *ptr;
+	rcu_read_lock();
+	list_for_each_entry_rcu(ptr, &tomoyo_task_security_list, list) {
+		if (ptr->task != task)
+			continue;
+		rcu_read_unlock();
+		return ptr;
+	}
+	rcu_read_unlock();
+	return NULL;
+}
+
+/**
+ * tomoyo_task_free - Schedule for garbage collection.
+ *
+ * @task: Unused.
+ *
+ * Returns nothing.
+ */
+static void tomoyo_task_free(struct task_struct *task)
+{
+	struct tomoyo_security *ptr;
+	rcu_read_lock();
+	list_for_each_entry_rcu(ptr, &tomoyo_task_security_list, list) {
+		if (ptr->task != task)
+			continue;
+		tomoyo_del_task_security(ptr);
+		break;
+	}
+	rcu_read_unlock();
+}
+
+/**
+ * tomoyo_bprm_committing_creds - Forget the proposed domain.
+ *
+ * @bprm: Pointer to "struct linux_binprm".
+ *
+ * Returns nothing.
+ */
+static void tomoyo_bprm_committing_creds(struct linux_binprm *bprm)
+{
+	struct tomoyo_security *ptr = tomoyo_find_task_security();
+	if (ptr)
+		tomoyo_del_task_security(ptr);
+}
+
+/**
+ * tomoyo_bprm_aborting_creds - Forget the proposed domain.
+ *
+ * @bprm: Pointer to "struct linux_binprm".
+ *
+ * Returns nothing.
+ */
+static void tomoyo_bprm_aborting_creds(struct linux_binprm *bprm)
+{
+	struct tomoyo_security *ptr = tomoyo_find_task_security();
+	if (ptr)
+		tomoyo_del_task_security(ptr);
+}
+
 /**
  * tomoyo_cred_alloc_blank - Target for security_cred_alloc_blank().
  *
@@ -124,12 +228,48 @@ static int tomoyo_bprm_check_security(struct linux_binprm *bprm)
 	 * using current domain.
 	 */
 	if (!domain) {
+		struct tomoyo_security *entry;
 		const int idx = tomoyo_read_lock();
 		const int err = tomoyo_find_next_domain(bprm);
 		tomoyo_read_unlock(idx);
-		return err;
+		if (err)
+			return err;
+		domain = bprm->cred->security;
+		/*
+		 * For backward compatibility, don't check read permission
+		 * against binary loaders. This will be done by not setting
+		 * TOMOYO_TASK_IS_IN_EXECVE flag.
+		 */
+		if (domain->ns->profile_version == 20110903)
+			return 0;
+		/*
+		 * Remember the proposed domain associated with
+		 * "struct task_struct" so that read permission will later be
+		 * checked against interpreters and binary loaders at
+		 * tomoyo_file_open().
+		 */
+		entry = tomoyo_find_task_security();
+		if (!entry)
+			entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+		if (!entry)
+			return -ENOMEM;
+		entry->tomoyo_flags |= TOMOYO_TASK_IS_IN_EXECVE;
+		entry->tomoyo_domain_info = domain;
+		if (!entry->list.next) {
+			entry->task = current;
+			tomoyo_add_task_security(entry);
+		}
+		return 0;
 	}
 	/*
+	 * By setting TOMOYO_TASK_IS_IN_EXECVE flag, read permission will later
+	 * be checked against interpreters and binary loaders at
+	 * tomoyo_file_open().
+	 */
+	if (tomoyo_current_flags() & TOMOYO_TASK_IS_IN_EXECVE)
+		return 0;
+	/*
+	 * Backward compatibility.
 	 * Read permission is checked against interpreters using next domain.
 	 */
 	return tomoyo_check_open_permission(domain, &bprm->file->f_path,
@@ -328,11 +468,21 @@ static int tomoyo_file_fcntl(struct file *file, unsigned int cmd,
  */
 static int tomoyo_file_open(struct file *f, const struct cred *cred)
 {
-	int flags = f->f_flags;
-	/* Don't check read permission here if called from do_execve(). */
-	if (current->in_execve)
+	struct tomoyo_domain_info *domain = tomoyo_domain();
+
+	/*
+	 * Don't check read permission here if this hook is called for checking
+	 * the executable passed to do_execve(); execute permission will later
+	 * be checked at tomoyo_bprm_check_security().
+	 *
+	 * Check read permission here if this hook is called for checking the
+	 * interpreters and binary loaders needed by the executable passed to
+	 * do_execve().
+	 */
+	if (current->in_execve &&
+	    !(tomoyo_current_flags() & TOMOYO_TASK_IS_IN_EXECVE))
 		return 0;
-	return tomoyo_check_open_permission(tomoyo_domain(), &f->f_path, flags);
+	return tomoyo_check_open_permission(domain, &f->f_path, f->f_flags);
 }
 
 /**
@@ -505,12 +655,15 @@ static int tomoyo_socket_sendmsg(struct socket *sock, struct msghdr *msg,
  */
 static struct security_operations tomoyo_security_ops = {
 	.name                = "tomoyo",
+	.task_free           = tomoyo_task_free,
 	.cred_alloc_blank    = tomoyo_cred_alloc_blank,
 	.cred_prepare        = tomoyo_cred_prepare,
 	.cred_transfer	     = tomoyo_cred_transfer,
 	.cred_free           = tomoyo_cred_free,
 	.bprm_set_creds      = tomoyo_bprm_set_creds,
 	.bprm_check_security = tomoyo_bprm_check_security,
+	.bprm_committing_creds = tomoyo_bprm_committing_creds,
+	.bprm_aborting_creds = tomoyo_bprm_aborting_creds,
 	.file_fcntl          = tomoyo_file_fcntl,
 	.file_open           = tomoyo_file_open,
 	.path_truncate       = tomoyo_path_truncate,
-- 
1.7.1
