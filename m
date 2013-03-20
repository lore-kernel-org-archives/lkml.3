Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031Ab3CTNK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 09:10:27 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:41225 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab3CTNJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 09:09:14 -0400
From: tal.tchwella@gmail.com
To: linux-kernel@vger.kernel.org
Cc: tchwella@mit.edu
Subject: [PATCH 1/3] enabled chroot for all users
Date: Wed, 20 Mar 2013 06:09:05 -0700
Message-Id: <1363784947-24060-2-git-send-email-tal.tchwella@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363784947-24060-1-git-send-email-tal.tchwella@gmail.com>
References: <1363784947-24060-1-git-send-email-tal.tchwella@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tal Tchwella <tchwella@mit.edu>

This patch enables chroot for all users, not just root users,
by disabling the appropriate checks in fs/open.c.
It also disables nested chroots by non-root users,
so they will not be able to break out of a chroot using classic techniques.

Signed-off-by: Tal Tchwella <tchwella@mit.edu>
---
 fs/exec.c             |    3 +++
 fs/open.c             |    8 ++++++--
 include/linux/sched.h |   12 ++++++++++++
 init/main.c           |    1 +
 kernel/fork.c         |    2 ++
 5 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 7d27def..e2303ef 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1299,6 +1299,9 @@ int prepare_binprm(struct linux_binprm *bprm)
 	    !current->no_new_privs) {
 		/* Set-uid? */
 		if (mode & S_ISUID) {
+			/* chroot by a regular, non root, user? */
+			if (current->user_chroot == CHROOT_USER_MODE)
+				return -EACCES;
 			bprm->per_clear |= PER_CLEAR_ON_SETID;
 			bprm->cred->euid = inode->i_uid;
 		}
diff --git a/fs/open.c b/fs/open.c
index a47a0a7..82832d8 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -435,9 +435,13 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
 	if (error)
 		goto dput_and_out;
 
-	error = -EPERM;
+	/* Are we in a nested chroot by a regular, non root, user? */
+	if (current->user_chroot != CHROOT_USER_MODE)
+		current->user_chroot = CHROOT_ROOT_MODE;
+
 	if (!capable(CAP_SYS_CHROOT))
-		goto dput_and_out;
+		current->user_chroot = CHROOT_USER_MODE;
+
 	error = security_path_chroot(&path);
 	if (error)
 		goto dput_and_out;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9e960d4..315e6fe 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -30,6 +30,16 @@
 #define CLONE_NEWNET		0x40000000	/* New network namespace */
 #define CLONE_IO		0x80000000	/* Clone io context */
 
+ /*
+  * chroot syscall Modes: INIT, USER, ROOT
+  * Init mode is to be used only by main.
+  * User mode is initialized when a non-root user tries to enter chroot mode.
+  * ROOT mode is the normal mode of operation for chroot.
+  */
+#define CHROOT_INIT		0
+#define CHROOT_USER_MODE	1
+#define CHROOT_ROOT_MODE	2
+
 /*
  * Scheduling policies
  */
@@ -1232,6 +1242,8 @@ struct task_struct {
 	unsigned int flags;	/* per process flags, defined below */
 	unsigned int ptrace;
 
+	unsigned int user_chroot;
+
 #ifdef CONFIG_SMP
 	struct llist_node wake_entry;
 	int on_cpu;
diff --git a/init/main.c b/init/main.c
index 0ec0731..044c655 100644
--- a/init/main.c
+++ b/init/main.c
@@ -781,6 +781,7 @@ static noinline int init_post(void)
 
 
 	current->signal->flags |= SIGNAL_UNKILLABLE;
+	current->user_chroot = CHROOT_INIT;
 
 	if (ramdisk_execute_command) {
 		run_init_process(ramdisk_execute_command);
diff --git a/kernel/fork.c b/kernel/fork.c
index 0269b2a..7f6d662 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -276,6 +276,8 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 	if (err)
 		goto out;
 
+	tsk->user_chroot = orig->user_chroot;
+
 	tsk->stack = ti;
 
 	setup_thread_stack(tsk, orig);
-- 
1.7.9.5

