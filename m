Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117AbaGCPLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:11:09 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:61257 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678AbaGCPLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:11:06 -0400
Message-Id: <20140703151102.745184283@openvz.org>
User-Agent: quilt/0.60-1
Date: Thu, 03 Jul 2014 18:33:19 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: gorcunov@openvz.org, Kees Cook <keescook@chromium.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [RFC 1/2] prctl: PR_SET_MM -- Factor out mmap_sem when update mm::exe_file
References: <20140703143318.568554771@openvz.org>
Content-Disposition: inline; filename=prctl-rework-prctl_set_mm_exe_file-locked
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of taking mm->mmap_sem inside prctl_set_mm_exe_file move
it out of and rename the helper to prctl_set_mm_exe_file_locked.
This will allow to reuse this function in a next patch.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
---
 kernel/sys.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

Index: linux-2.6.git/kernel/sys.c
===================================================================
--- linux-2.6.git.orig/kernel/sys.c
+++ linux-2.6.git/kernel/sys.c
@@ -1628,12 +1628,14 @@ SYSCALL_DEFINE1(umask, int, mask)
 	return mask;
 }
 
-static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
+static int prctl_set_mm_exe_file_locked(struct mm_struct *mm, unsigned int fd)
 {
 	struct fd exe;
 	struct inode *inode;
 	int err;
 
+	VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
+
 	exe = fdget(fd);
 	if (!exe.file)
 		return -EBADF;
@@ -1654,8 +1656,6 @@ static int prctl_set_mm_exe_file(struct
 	if (err)
 		goto exit;
 
-	down_write(&mm->mmap_sem);
-
 	/*
 	 * Forbid mm->exe_file change if old file still mapped.
 	 */
@@ -1667,7 +1667,7 @@ static int prctl_set_mm_exe_file(struct
 			if (vma->vm_file &&
 			    path_equal(&vma->vm_file->f_path,
 				       &mm->exe_file->f_path))
-				goto exit_unlock;
+				goto exit;
 	}
 
 	/*
@@ -1678,13 +1678,10 @@ static int prctl_set_mm_exe_file(struct
 	 */
 	err = -EPERM;
 	if (test_and_set_bit(MMF_EXE_FILE_CHANGED, &mm->flags))
-		goto exit_unlock;
+		goto exit;
 
 	err = 0;
 	set_mm_exe_file(mm, exe.file);	/* this grabs a reference to exe.file */
-exit_unlock:
-	up_write(&mm->mmap_sem);
-
 exit:
 	fdput(exe);
 	return err;
@@ -1704,8 +1701,12 @@ static int prctl_set_mm(int opt, unsigne
 	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
 
-	if (opt == PR_SET_MM_EXE_FILE)
-		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
+	if (opt == PR_SET_MM_EXE_FILE) {
+		down_write(&mm->mmap_sem);
+		error = prctl_set_mm_exe_file_locked(mm, (unsigned int)addr);
+		up_write(&mm->mmap_sem);
+		return error;
+	}
 
 	if (addr >= TASK_SIZE || addr < mmap_min_addr)
 		return -EINVAL;

