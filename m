Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbaHLCPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 22:15:33 -0400
Received: from tundra.namei.org ([65.99.196.166]:34218 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144AbaHLCPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 22:15:32 -0400
Date: Tue, 12 Aug 2014 12:15:29 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] seccomp fix for 3.17
Message-ID: <alpine.LRH.2.11.1408121213510.8993@namei.org>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull this fix for the seccomp code.

The following changes since commit c8d6637d0497d62093dbba0694c7b3a80b79bfe1:

  Merge tag 'modules-next-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux (2014-08-10 21:31:58 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Guenter Roeck (1):
      seccomp: Replace BUG(!spin_is_locked()) with assert_spin_lock

 kernel/fork.c    |    2 +-
 kernel/seccomp.c |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

---

commit 69f6a34bdeea4fec50bb90619bc9602973119572
Author: Guenter Roeck <linux@roeck-us.net>
Date:   Sun Aug 10 20:50:30 2014 -0700

    seccomp: Replace BUG(!spin_is_locked()) with assert_spin_lock
    
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
    Signed-off-by: Kees Cook <keescook@chromium.org>

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
