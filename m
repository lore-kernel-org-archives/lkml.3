Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab3FKNNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 09:13:22 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:54551 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab3FKNNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 09:13:20 -0400
X-Nat-Received: from [202.181.97.72]:58377 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1370956398.19538
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH 2/4] LSM: Revive security_task_alloc() hook.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201306112211.GBH48909.SOFOFJHMtFQVLO@I-love.SAKURA.ne.jp>
In-Reply-To: <201306112211.GBH48909.SOFOFJHMtFQVLO@I-love.SAKURA.ne.jp>
Message-Id: <201306112213.DJJ13067.SLtQFOFOJFHMVO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 11 Jun 2013 22:13:16 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 11062013 #10379665, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5fc4d5f6d39e36f6b91ce6b26d084ef2354488c0 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Tue, 11 Jun 2013 21:33:49 +0900
Subject: [PATCH 2/4] LSM: Revive security_task_alloc() hook.

Revive a LSM hook which is called when a task_struct is allocated.
This hook is used by TOMOYO for inheriting per a task_struct variables.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 include/linux/security.h |   10 ++++++++++
 kernel/fork.c            |    7 ++++++-
 security/capability.c    |    6 ++++++
 security/security.c      |    5 +++++
 4 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 6f03e37..46566e3 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -660,6 +660,9 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	manual page for definitions of the @clone_flags.
  *	@clone_flags contains the flags indicating what should be shared.
  *	Return 0 if permission is granted.
+ * @task_alloc:
+ *	@task task being allocated.
+ *	Handle allocation of task-related resources.
  * @task_free:
  *	@task task being freed
  *	Handle release of task-related resources. (Note that this can be called
@@ -1528,6 +1531,7 @@ struct security_operations {
 	int (*file_open) (struct file *file, const struct cred *cred);
 
 	int (*task_create) (unsigned long clone_flags);
+	int (*task_alloc) (struct task_struct *task);
 	void (*task_free) (struct task_struct *task);
 	int (*cred_alloc_blank) (struct cred *cred, gfp_t gfp);
 	void (*cred_free) (struct cred *cred);
@@ -1792,6 +1796,7 @@ int security_file_send_sigiotask(struct task_struct *tsk,
 int security_file_receive(struct file *file);
 int security_file_open(struct file *file, const struct cred *cred);
 int security_task_create(unsigned long clone_flags);
+int security_task_alloc(struct task_struct *task);
 void security_task_free(struct task_struct *task);
 int security_cred_alloc_blank(struct cred *cred, gfp_t gfp);
 void security_cred_free(struct cred *cred);
@@ -2281,6 +2286,11 @@ static inline int security_task_create(unsigned long clone_flags)
 	return 0;
 }
 
+static inline int security_task_alloc(struct task_struct *task)
+{
+	return 0;
+}
+
 static inline void security_task_free(struct task_struct *task)
 { }
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 987b28a..fed8f5d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1315,9 +1315,12 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	retval = perf_event_init_task(p);
 	if (retval)
 		goto bad_fork_cleanup_policy;
-	retval = audit_alloc(p);
+	retval = security_task_alloc(p);
 	if (retval)
 		goto bad_fork_cleanup_policy;
+	retval = audit_alloc(p);
+	if (retval)
+		goto bad_fork_cleanup_security;
 	/* copy all the process information */
 	retval = copy_semundo(clone_flags, p);
 	if (retval)
@@ -1512,6 +1515,8 @@ bad_fork_cleanup_semundo:
 	exit_sem(p);
 bad_fork_cleanup_audit:
 	audit_free(p);
+bad_fork_cleanup_security:
+	security_task_free(p);
 bad_fork_cleanup_policy:
 	perf_event_free_task(p);
 #ifdef CONFIG_NUMA
diff --git a/security/capability.c b/security/capability.c
index 34b6f09..3ddc282 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -363,6 +363,11 @@ static int cap_task_create(unsigned long clone_flags)
 	return 0;
 }
 
+static int cap_task_alloc(struct task_struct *task)
+{
+	return 0;
+}
+
 static void cap_task_free(struct task_struct *task)
 {
 }
@@ -990,6 +995,7 @@ void __init security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, file_receive);
 	set_to_cap_if_null(ops, file_open);
 	set_to_cap_if_null(ops, task_create);
+	set_to_cap_if_null(ops, task_alloc);
 	set_to_cap_if_null(ops, task_free);
 	set_to_cap_if_null(ops, cred_alloc_blank);
 	set_to_cap_if_null(ops, cred_free);
diff --git a/security/security.c b/security/security.c
index 7123178..3aeaecf 100644
--- a/security/security.c
+++ b/security/security.c
@@ -782,6 +782,11 @@ int security_task_create(unsigned long clone_flags)
 	return security_ops->task_create(clone_flags);
 }
 
+int security_task_alloc(struct task_struct *task)
+{
+	return security_ops->task_alloc(task);
+}
+
 void security_task_free(struct task_struct *task)
 {
 #ifdef CONFIG_SECURITY_YAMA_STACKED
-- 
1.7.1
