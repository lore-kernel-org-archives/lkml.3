Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaAMUjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:39:25 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:36092 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaAMUjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:39:21 -0500
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Will Drewry <wad@chromium.org>, nschichan@freebox.fr,
        keescook@chromium.org, james.l.morris@oracle.com
Subject: [PATCH 1/2] seccomp: protect seccomp.filter pointer (w) with the task_lock
Date: Mon, 13 Jan 2014 14:30:20 -0600
Message-Id: <1389645028-17157-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally, task_struck.seccomp.filter is only ever read or modified by
the task that owns it (current).  This property aids in fast access
during system call filtering as read access is lockless.

Updating the pointer from another task, however, opens up race
conditions.  To allow cross-task filter pointer updates, writes to
the pointer are now protected by the task_lock.  Read access remains
lockless because pointer updates themselves are atomic.  However,
writes often entail additional checking (like maximum instruction
counts) which require locking to perform safely.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 include/linux/seccomp.h |    4 ++--
 kernel/seccomp.c        |   22 +++++++++++++---------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 6f19cfd..85c0895 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -17,8 +17,8 @@ struct seccomp_filter;
  * @filter: The metadata and ruleset for determining what system calls
  *          are allowed for a task.
  *
- *          @filter must only be accessed from the context of current as there
- *          is no locking.
+ *          @filter must always point to a valid seccomp_filter or NULL as it is
+ *          accessed without locking during system call entry.
  */
 struct seccomp {
 	int mode;
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index b7a1004..71512e4 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -201,18 +201,18 @@ static int seccomp_check_filter(struct sock_filter *filter, unsigned int flen)
  */
 static u32 seccomp_run_filters(int syscall)
 {
-	struct seccomp_filter *f;
+	struct seccomp_filter *f = ACCESS_ONCE(current->seccomp.filter);
 	u32 ret = SECCOMP_RET_ALLOW;
 
 	/* Ensure unexpected behavior doesn't result in failing open. */
-	if (WARN_ON(current->seccomp.filter == NULL))
+	if (WARN_ON(f == NULL))
 		return SECCOMP_RET_KILL;
 
 	/*
 	 * All filters in the list are evaluated and the lowest BPF return
 	 * value always takes priority (ignoring the DATA).
 	 */
-	for (f = current->seccomp.filter; f; f = f->prev) {
+	for (; f; f = ACCESS_ONCE(f->prev)) {
 		u32 cur_ret = sk_run_filter(NULL, f->insns);
 		if ((cur_ret & SECCOMP_RET_ACTION) < (ret & SECCOMP_RET_ACTION))
 			ret = cur_ret;
@@ -228,7 +228,7 @@ static u32 seccomp_run_filters(int syscall)
  */
 static long seccomp_attach_filter(struct sock_fprog *fprog)
 {
-	struct seccomp_filter *filter;
+	struct seccomp_filter *filter, *f;
 	unsigned long fp_size = fprog->len * sizeof(struct sock_filter);
 	unsigned long total_insns = fprog->len;
 	long ret;
@@ -236,11 +236,6 @@ static long seccomp_attach_filter(struct sock_fprog *fprog)
 	if (fprog->len == 0 || fprog->len > BPF_MAXINSNS)
 		return -EINVAL;
 
-	for (filter = current->seccomp.filter; filter; filter = filter->prev)
-		total_insns += filter->len + 4;  /* include a 4 instr penalty */
-	if (total_insns > MAX_INSNS_PER_PATH)
-		return -ENOMEM;
-
 	/*
 	 * Installing a seccomp filter requires that the task have
 	 * CAP_SYS_ADMIN in its namespace or be running with no_new_privs.
@@ -260,6 +255,13 @@ static long seccomp_attach_filter(struct sock_fprog *fprog)
 	atomic_set(&filter->usage, 1);
 	filter->len = fprog->len;
 
+	task_lock(current);  /* protect current->seccomp.filter from updates */
+	for (f = current->seccomp.filter; f; f = f->prev)
+		total_insns += f->len + 4;  /* include a 4 instr penalty */
+	ret = -ENOMEM;
+	if (total_insns > MAX_INSNS_PER_PATH)
+		goto fail;
+
 	/* Copy the instructions from fprog. */
 	ret = -EFAULT;
 	if (copy_from_user(filter->insns, fprog->filter, fp_size))
@@ -281,8 +283,10 @@ static long seccomp_attach_filter(struct sock_fprog *fprog)
 	 */
 	filter->prev = current->seccomp.filter;
 	current->seccomp.filter = filter;
+	task_unlock(current);
 	return 0;
 fail:
+	task_unlock(current);
 	kfree(filter);
 	return ret;
 }
-- 
1.7.9.5

