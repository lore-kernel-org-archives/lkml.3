Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaEZNlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:41:14 -0400
Received: from numidia.opendz.org ([98.142.220.152]:50440 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbaEZNlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:41:13 -0400
From: Djalal Harouni <tixxdz@opendz.org>
To: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Djalal Harouni <tixxdz@opendz.org>
Subject: [PATCH 2/9] procfs: add pid_entry_access() for proper checks on /proc/<pid>/*
Date: Mon, 26 May 2014 14:27:23 +0100
Message-Id: <1401110850-3552-3-git-send-email-tixxdz@opendz.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
References: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the helper pid_entry_access() to unify the permission checks during
->open()

This is a preparation patch.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/generic.c  | 22 ++++++++++++++++++++++
 fs/proc/internal.h |  2 ++
 2 files changed, 24 insertions(+)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index b7f268e..98ed927 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -23,6 +23,7 @@
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
 #include <linux/completion.h>
+#include <linux/ptrace.h>
 #include <asm/uaccess.h>
 
 #include "internal.h"
@@ -596,3 +597,24 @@ void *PDE_DATA(const struct inode *inode)
 	return __PDE_DATA(inode);
 }
 EXPORT_SYMBOL(PDE_DATA);
+
+int pid_entry_access(struct file *filp, unsigned int mode)
+{
+	int err = -ESRCH;
+	struct task_struct *task = get_proc_task(file_inode(filp));
+
+	if (!task)
+		return err;
+
+	err = mutex_lock_killable(&task->signal->cred_guard_mutex);
+	if (err)
+		goto out;
+
+	if (!ptrace_may_access(task, mode))
+		err = -EACCES;
+
+	mutex_unlock(&task->signal->cred_guard_mutex);
+out:
+	put_task_struct(task);
+	return err;
+}
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index e696284..4f828fa 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -202,6 +202,8 @@ static inline struct proc_dir_entry *pde_get(struct proc_dir_entry *pde)
 }
 extern void pde_put(struct proc_dir_entry *);
 
+extern int pid_entry_access(struct file *filp, unsigned int mode);
+
 /*
  * inode.c
  */
-- 
1.7.11.7

