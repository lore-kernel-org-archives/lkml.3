Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaHKDui (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 23:50:38 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:46413 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbaHKDug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 23:50:36 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] seccomp: Replace BUG(!spin_is_locked()) with assert_spin_lock
Date: Sun, 10 Aug 2014 20:50:30 -0700
Message-Id: <1407729030-30283-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current upstream kernel hangs with mips and powerpc targets in
uniprocessor mode if SECCOMP is configured.

Bisect points to commit dbd952127d11 ("seccomp: introduce writer locking").
Turns out that code such as
	BUG_ON(!spin_is_locked(&list_lock));
can not be used in uniprocessor mode because spin_is_locked() always
returns false in this configuration, and that assert_spin_locked()
exists for that very purpose and must be used instead.

Fixes: dbd952127d11 ("seccomp: introduce writer locking")
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 kernel/fork.c    |  2 +-
 kernel/seccomp.c | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 1380d8a..0cf9cdb 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1105,7 +1105,7 @@ static void copy_seccomp(struct task_struct *p)
 	 * needed because this new task is not yet running and cannot
 	 * be racing exec.
 	 */
-	BUG_ON(!spin_is_locked(&current->sighand->siglock));
+	assert_spin_locked(&current->sighand->siglock);
 
 	/* Ref-count the new filter user, and assign it. */
 	get_seccomp_filter(current);
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 25b0043..44eb005 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -203,7 +203,7 @@ static u32 seccomp_run_filters(int syscall)
 
 static inline bool seccomp_may_assign_mode(unsigned long seccomp_mode)
 {
-	BUG_ON(!spin_is_locked(&current->sighand->siglock));
+	assert_spin_locked(&current->sighand->siglock);
 
 	if (current->seccomp.mode && current->seccomp.mode != seccomp_mode)
 		return false;
@@ -214,7 +214,7 @@ static inline bool seccomp_may_assign_mode(unsigned long seccomp_mode)
 static inline void seccomp_assign_mode(struct task_struct *task,
 				       unsigned long seccomp_mode)
 {
-	BUG_ON(!spin_is_locked(&task->sighand->siglock));
+	assert_spin_locked(&task->sighand->siglock);
 
 	task->seccomp.mode = seccomp_mode;
 	/*
@@ -253,7 +253,7 @@ static inline pid_t seccomp_can_sync_threads(void)
 	struct task_struct *thread, *caller;
 
 	BUG_ON(!mutex_is_locked(&current->signal->cred_guard_mutex));
-	BUG_ON(!spin_is_locked(&current->sighand->siglock));
+	assert_spin_locked(&current->sighand->siglock);
 
 	/* Validate all threads being eligible for synchronization. */
 	caller = current;
@@ -294,7 +294,7 @@ static inline void seccomp_sync_threads(void)
 	struct task_struct *thread, *caller;
 
 	BUG_ON(!mutex_is_locked(&current->signal->cred_guard_mutex));
-	BUG_ON(!spin_is_locked(&current->sighand->siglock));
+	assert_spin_locked(&current->sighand->siglock);
 
 	/* Synchronize all threads. */
 	caller = current;
@@ -464,7 +464,7 @@ static long seccomp_attach_filter(unsigned int flags,
 	unsigned long total_insns;
 	struct seccomp_filter *walker;
 
-	BUG_ON(!spin_is_locked(&current->sighand->siglock));
+	assert_spin_locked(&current->sighand->siglock);
 
 	/* Validate resulting filter length. */
 	total_insns = filter->prog->len;
-- 
1.9.1

