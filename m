Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab3FKNOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 09:14:39 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57303 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab3FKNOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 09:14:37 -0400
X-Nat-Received: from [202.181.97.72]:52627 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1370956476.23149
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH 4/4] TOMOYO: Allow caching policy manager's state until execve() request.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201306112211.GBH48909.SOFOFJHMtFQVLO@I-love.SAKURA.ne.jp>
In-Reply-To: <201306112211.GBH48909.SOFOFJHMtFQVLO@I-love.SAKURA.ne.jp>
Message-Id: <201306112214.IEC51535.OFSMHOQFLJOtFV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 11 Jun 2013 22:14:34 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 11062013 #10379665, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 05dfa116d92f31b9def142790748a2b479800718 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Tue, 11 Jun 2013 21:39:12 +0900
Subject: [PATCH 4/4] TOMOYO: Allow caching policy manager's state until execve() request.

Extend the lifetime of the per a task_struct variable from "start of execve()
to end of do_execve()" to "arbitrary moment to the end of exexve()" so that
we can remember that the current thread (and threads created afterwards from
current thread) can update policy without checking permission to update policy
for each line.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/tomoyo/common.c |   22 +++++++++++++++++++++-
 security/tomoyo/common.h |    6 ++++++
 security/tomoyo/tomoyo.c |   32 +++++++++++++++++++++++++++++++-
 3 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index 283862a..40ae993 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -921,10 +921,14 @@ static bool tomoyo_manager(void)
 	const char *exe;
 	const struct task_struct *task = current;
 	const struct tomoyo_path_info *domainname = tomoyo_domain()->domainname;
+	struct tomoyo_security *security;
 	bool found = false;
 
 	if (!tomoyo_policy_loaded)
 		return true;
+	security = tomoyo_find_task_security();
+	if (security && (security->tomoyo_flags & TOMOYO_TASK_IS_MANAGER))
+		return true;
 	if (!tomoyo_manage_by_non_root &&
 	    (!uid_eq(task->cred->uid,  GLOBAL_ROOT_UID) ||
 	     !uid_eq(task->cred->euid, GLOBAL_ROOT_UID)))
@@ -951,7 +955,23 @@ static bool tomoyo_manager(void)
 		}
 	}
 	kfree(exe);
-	return found;
+	if (!found)
+		return false;
+	/*
+	 * Remember that the current thread is allowed to update
+	 * policies until do_execve().
+	 */
+	if (security) {
+		security->tomoyo_flags |= TOMOYO_TASK_IS_MANAGER;
+		return true;
+	}
+	security = kzalloc(sizeof(*security), GFP_KERNEL);
+	if (security) {
+		security->task = task;
+		security->tomoyo_flags |= TOMOYO_TASK_IS_MANAGER;
+		tomoyo_add_task_security(security);
+	}
+	return true;
 }
 
 static struct tomoyo_domain_info *tomoyo_find_domain_by_qid
diff --git a/security/tomoyo/common.h b/security/tomoyo/common.h
index 60e5800..923d237 100644
--- a/security/tomoyo/common.h
+++ b/security/tomoyo/common.h
@@ -38,6 +38,11 @@
 
 /* Current thread is doing do_execve() ? */
 #define TOMOYO_TASK_IS_IN_EXECVE 1
+/*
+ * Current thread is allowed to modify policy via /sys/kernel/security/tomoyo/
+ * interface?
+ */
+#define TOMOYO_TASK_IS_MANAGER   2
 
 /*
  * TOMOYO uses this hash only when appending a string into the string
@@ -927,6 +932,7 @@ struct tomoyo_policy_namespace {
 /********** Function prototypes. **********/
 
 struct tomoyo_security *tomoyo_find_task_security(void);
+void tomoyo_add_task_security(struct tomoyo_security *ptr);
 bool tomoyo_address_matches_group(const bool is_ipv6, const __be32 *address,
 				  const struct tomoyo_group *group);
 bool tomoyo_compare_number_union(const unsigned long value,
diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index 7039302..de4c7f9 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -35,7 +35,7 @@ static void tomoyo_del_task_security(struct tomoyo_security *ptr)
  *
  * Returns nothing.
  */
-static void tomoyo_add_task_security(struct tomoyo_security *ptr)
+void tomoyo_add_task_security(struct tomoyo_security *ptr)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&tomoyo_task_security_list_lock, flags);
@@ -84,6 +84,29 @@ static void tomoyo_task_free(struct task_struct *task)
 }
 
 /**
+ * tomoyo_task_alloc - Make snapshot of security context for new task.
+ *
+ * @p: Pointer to "struct task_struct".
+ *
+ * Returns 0 on success, negative value otherwise.
+ */
+static int tomoyo_task_alloc(struct task_struct *p)
+{
+	struct tomoyo_security *old_security = tomoyo_find_task_security();
+	struct tomoyo_security *new_security;
+	
+	if (!old_security)
+		return 0;
+	new_security = kzalloc(sizeof(*new_security), GFP_KERNEL);
+	if (!new_security)
+		return -ENOMEM;
+	new_security->task = p;
+	new_security->tomoyo_flags = old_security->tomoyo_flags;
+	tomoyo_add_task_security(new_security);
+	return 0;
+}
+
+/**
  * tomoyo_bprm_committing_creds - Forget the proposed domain.
  *
  * @bprm: Pointer to "struct linux_binprm".
@@ -209,6 +232,12 @@ static int tomoyo_bprm_set_creds(struct linux_binprm *bprm)
 	 * execve operation.
 	 */
 	bprm->cred->security = NULL;
+	/* Clear the manager flag. */
+	{
+		struct tomoyo_security *ptr = tomoyo_find_task_security();
+		if (ptr)
+			ptr->tomoyo_flags &= ~TOMOYO_TASK_IS_MANAGER;
+	}
 	return 0;
 }
 
@@ -655,6 +684,7 @@ static int tomoyo_socket_sendmsg(struct socket *sock, struct msghdr *msg,
  */
 static struct security_operations tomoyo_security_ops = {
 	.name                = "tomoyo",
+	.task_alloc          = tomoyo_task_alloc,
 	.task_free           = tomoyo_task_free,
 	.cred_alloc_blank    = tomoyo_cred_alloc_blank,
 	.cred_prepare        = tomoyo_cred_prepare,
-- 
1.7.1
