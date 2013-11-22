Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab3KVRxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:53:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517Ab3KVRxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:53:34 -0500
Date: Fri, 22 Nov 2013 18:54:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Sameer Nanda <snanda@chromium.org>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] check_unsafe_exec: kill the dead -EAGAIN and
	clear_in_exec logic
Message-ID: <20131122175442.GA31453@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122175424.GA31432@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs_struct->in_exec == T means that this ->fs is used by a single
process (thread group), and one of the treads does do_execve().

To avoid the mt-exec races this code has the following complications:

	1. check_unsafe_exec() returns -EBUSY if ->in_exec was
	   already set by another thread.

	2. do_execve_common() records "clear_in_exec" to ensure
	   that the error path can only clear ->in_exec if it was
	   set by current.

However, after 9b1bf12d5d51 "signals: move cred_guard_mutex from
task_struct to signal_struct" we do not need these complications:

	1. We can't race with our sub-thread, this is called under
	   per-process ->cred_guard_mutex. And we can't race with
	   another CLONE_FS task, we already checked that this fs
	   is not shared.

	   We can remove the  dead -EAGAIN logic.

	2. "out_unmark:" in do_execve_common() is either called
	   under ->cred_guard_mutex, or after de_thread() which
	   kills other threads, so we can't race with sub-thread
	   which could set ->in_exec. And if ->fs is shared with
	   another process ->in_exec should be false anyway.

	   We can clear in_exec unconditionally.

This also means that check_unsafe_exec() can be void.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c |   29 ++++++++---------------------
 1 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 0cd9c25..60eb5c5 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1225,11 +1225,10 @@ EXPORT_SYMBOL(install_exec_creds);
  * - the caller must hold ->cred_guard_mutex to protect against
  *   PTRACE_ATTACH
  */
-static int check_unsafe_exec(struct linux_binprm *bprm)
+static void check_unsafe_exec(struct linux_binprm *bprm)
 {
 	struct task_struct *p = current, *t;
 	unsigned n_fs;
-	int res = 0;
 
 	if (p->ptrace) {
 		if (p->ptrace & PT_PTRACE_CAP)
@@ -1255,22 +1254,15 @@ static int check_unsafe_exec(struct linux_binprm *bprm)
 	}
 	rcu_read_unlock();
 
-	if (p->fs->users > n_fs) {
+	if (p->fs->users > n_fs)
 		bprm->unsafe |= LSM_UNSAFE_SHARE;
-	} else {
-		res = -EAGAIN;
-		if (!p->fs->in_exec) {
-			p->fs->in_exec = 1;
-			res = 1;
-		}
-	}
+	else
+		p->fs->in_exec = 1;
 	spin_unlock(&p->fs->lock);
-
-	return res;
 }
 
-/* 
- * Fill the binprm structure from the inode. 
+/*
+ * Fill the binprm structure from the inode.
  * Check permissions, then read the first 128 (BINPRM_BUF_SIZE) bytes
  *
  * This may be called multiple times for binary chains (scripts for example).
@@ -1461,7 +1453,6 @@ static int do_execve_common(const char *filename,
 	struct linux_binprm *bprm;
 	struct file *file;
 	struct files_struct *displaced;
-	bool clear_in_exec;
 	int retval;
 
 	/*
@@ -1493,10 +1484,7 @@ static int do_execve_common(const char *filename,
 	if (retval)
 		goto out_free;
 
-	retval = check_unsafe_exec(bprm);
-	if (retval < 0)
-		goto out_free;
-	clear_in_exec = retval;
+	check_unsafe_exec(bprm);
 	current->in_execve = 1;
 
 	file = open_exec(filename);
@@ -1565,8 +1553,7 @@ out_file:
 	}
 
 out_unmark:
-	if (clear_in_exec)
-		current->fs->in_exec = 0;
+	current->fs->in_exec = 0;
 	current->in_execve = 0;
 
 out_free:
-- 
1.5.5.1

