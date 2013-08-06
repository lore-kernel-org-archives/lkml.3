Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab3HFIow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:44:52 -0400
Received: from intranet.asianux.com ([58.214.24.6]:21376 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab3HFIor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:44:47 -0400
X-Spam-Score: -100.8
Message-ID: <5200B740.2080702@asianux.com>
Date: Tue, 06 Aug 2013 16:43:44 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, holt@sgi.com
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/sys.c: improve the usage of return value
References: <5200AD26.8070701@asianux.com> <5200B017.7030401@asianux.com> <5200B088.9040305@asianux.com>
In-Reply-To: <5200B088.9040305@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve the usage of return value, so not only can make code clearer
to readers, but also can improve the performance.

Assign the return error code only when error occurs, so can save some
instructions.

For getcpu(), uname(), newuname(), and override_release(), can remove
the return variable to make code clearer and save some instructions.

Also modify the related code to pass "./scripts/checkpatch.pl" checking.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/sys.c |  147 +++++++++++++++++++++++++++++++---------------------------
 1 files changed, 79 insertions(+), 68 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 771129b..a63a350 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -386,13 +386,14 @@ SYSCALL_DEFINE1(setgid, gid_t, gid)
 		return -ENOMEM;
 	old = current_cred();
 
-	retval = -EPERM;
 	if (nsown_capable(CAP_SETGID))
 		new->gid = new->egid = new->sgid = new->fsgid = kgid;
 	else if (gid_eq(kgid, old->gid) || gid_eq(kgid, old->sgid))
 		new->egid = new->fsgid = kgid;
-	else
+	else {
+		retval = -EPERM;
 		goto error;
+	}
 
 	return commit_creds(new);
 
@@ -533,7 +534,6 @@ SYSCALL_DEFINE1(setuid, uid_t, uid)
 		return -ENOMEM;
 	old = current_cred();
 
-	retval = -EPERM;
 	if (nsown_capable(CAP_SETUID)) {
 		new->suid = new->uid = kuid;
 		if (!uid_eq(kuid, old->uid)) {
@@ -542,6 +542,7 @@ SYSCALL_DEFINE1(setuid, uid_t, uid)
 				goto error;
 		}
 	} else if (!uid_eq(kuid, old->uid) && !uid_eq(kuid, new->suid)) {
+		retval = -EPERM;
 		goto error;
 	}
 
@@ -919,31 +920,35 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid_t, pgid)
 	 */
 	write_lock_irq(&tasklist_lock);
 
-	err = -ESRCH;
 	p = find_task_by_vpid(pid);
-	if (!p)
+	if (!p) {
+		err = -ESRCH;
 		goto out;
+	}
 
-	err = -EINVAL;
-	if (!thread_group_leader(p))
+	if (!thread_group_leader(p)) {
+		err = -EINVAL;
 		goto out;
+	}
 
 	if (same_thread_group(p->real_parent, group_leader)) {
-		err = -EPERM;
-		if (task_session(p) != task_session(group_leader))
+		if (task_session(p) != task_session(group_leader)) {
+			err = -EPERM;
 			goto out;
-		err = -EACCES;
-		if (p->did_exec)
+		}
+		if (p->did_exec) {
+			err = -EACCES;
 			goto out;
-	} else {
+		}
+	} else if (p != group_leader) {
 		err = -ESRCH;
-		if (p != group_leader)
-			goto out;
+		goto out;
 	}
 
-	err = -EPERM;
-	if (p->signal->leader)
+	if (p->signal->leader) {
+		err = -EPERM;
 		goto out;
+	}
 
 	pgrp = task_pid(p);
 	if (pgid != pid) {
@@ -951,8 +956,10 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid_t, pgid)
 
 		pgrp = find_vpid(pgid);
 		g = pid_task(pgrp, PIDTYPE_PGID);
-		if (!g || task_session(g) != task_session(group_leader))
+		if (!g || task_session(g) != task_session(group_leader)) {
+			err = -EPERM;
 			goto out;
+		}
 	}
 
 	err = security_task_setpgid(p, pgid);
@@ -962,7 +969,6 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid_t, pgid)
 	if (task_pgrp(p) != pgrp)
 		change_pid(p, PIDTYPE_PGID, pgrp);
 
-	err = 0;
 out:
 	/* All paths lead to here, thus we are safe. -DaveM */
 	write_unlock_irq(&tasklist_lock);
@@ -980,14 +986,16 @@ SYSCALL_DEFINE1(getpgid, pid_t, pid)
 	if (!pid)
 		grp = task_pgrp(current);
 	else {
-		retval = -ESRCH;
 		p = find_task_by_vpid(pid);
-		if (!p)
+		if (!p) {
+			retval = -ESRCH;
 			goto out;
+		}
 		grp = task_pgrp(p);
-		if (!grp)
+		if (!grp) {
+			retval = -ESRCH;
 			goto out;
-
+		}
 		retval = security_task_getpgid(p);
 		if (retval)
 			goto out;
@@ -1017,14 +1025,16 @@ SYSCALL_DEFINE1(getsid, pid_t, pid)
 	if (!pid)
 		sid = task_session(current);
 	else {
-		retval = -ESRCH;
 		p = find_task_by_vpid(pid);
-		if (!p)
+		if (!p) {
+			retval = -ESRCH;
 			goto out;
+		}
 		sid = task_session(p);
-		if (!sid)
+		if (!sid) {
+			retval = -ESRCH;
 			goto out;
-
+		}
 		retval = security_task_getsid(p);
 		if (retval)
 			goto out;
@@ -1096,8 +1106,6 @@ DECLARE_RWSEM(uts_sem);
  */
 static int override_release(char __user *release, size_t len)
 {
-	int ret = 0;
-
 	if (current->personality & UNAME26) {
 		const char *rest = UTS_RELEASE;
 		char buf[65] = { 0 };
@@ -1115,25 +1123,25 @@ static int override_release(char __user *release, size_t len)
 		v = ((LINUX_VERSION_CODE >> 8) & 0xff) + 40;
 		copy = clamp_t(size_t, len, 1, sizeof(buf));
 		copy = scnprintf(buf, copy, "2.6.%u%s", v, rest);
-		ret = copy_to_user(release, buf, copy + 1);
+		return copy_to_user(release, buf, copy + 1);
 	}
-	return ret;
+	return 0;
 }
 
 SYSCALL_DEFINE1(newuname, struct new_utsname __user *, name)
 {
-	int errno = 0;
-
 	down_read(&uts_sem);
-	if (copy_to_user(name, utsname(), sizeof *name))
-		errno = -EFAULT;
+	if (copy_to_user(name, utsname(), sizeof(*name))) {
+		up_read(&uts_sem);
+		return -EFAULT;
+	}
 	up_read(&uts_sem);
 
-	if (!errno && override_release(name->release, sizeof(name->release)))
-		errno = -EFAULT;
-	if (!errno && override_architecture(name))
-		errno = -EFAULT;
-	return errno;
+	if (override_release(name->release, sizeof(name->release)))
+		return -EFAULT;
+	if (override_architecture(name))
+		return -EFAULT;
+	return 0;
 }
 
 #ifdef __ARCH_WANT_SYS_OLD_UNAME
@@ -1142,21 +1150,21 @@ SYSCALL_DEFINE1(newuname, struct new_utsname __user *, name)
  */
 SYSCALL_DEFINE1(uname, struct old_utsname __user *, name)
 {
-	int error = 0;
-
 	if (!name)
 		return -EFAULT;
 
 	down_read(&uts_sem);
-	if (copy_to_user(name, utsname(), sizeof(*name)))
-		error = -EFAULT;
+	if (copy_to_user(name, utsname(), sizeof(*name))) {
+		up_read(&uts_sem);
+		return -EFAULT;
+	}
 	up_read(&uts_sem);
 
-	if (!error && override_release(name->release, sizeof(name->release)))
-		error = -EFAULT;
-	if (!error && override_architecture(name))
-		error = -EFAULT;
-	return error;
+	if (override_release(name->release, sizeof(name->release)))
+		return -EFAULT;
+	if (override_architecture(name))
+		return -EFAULT;
+	return 0;
 }
 
 SYSCALL_DEFINE1(olduname, struct oldold_utsname __user *, name)
@@ -1185,12 +1193,14 @@ SYSCALL_DEFINE1(olduname, struct oldold_utsname __user *, name)
 				__OLD_UTS_LEN);
 	error |= __put_user(0, name->machine + __OLD_UTS_LEN);
 	up_read(&uts_sem);
+	if (error)
+		return -EFAULT;
 
-	if (!error && override_architecture(name))
-		error = -EFAULT;
-	if (!error && override_release(name->release, sizeof(name->release)))
-		error = -EFAULT;
-	return error ? -EFAULT : 0;
+	if (override_architecture(name))
+		return -EFAULT;
+	if (override_release(name->release, sizeof(name->release)))
+		return -EFAULT;
+	return 0;
 }
 #endif
 
@@ -1648,10 +1658,11 @@ static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
 	 * sure that this one is executable as well, to avoid breaking an
 	 * overall picture.
 	 */
-	err = -EACCES;
-	if (!S_ISREG(inode->i_mode)	||
-	    exe.file->f_path.mnt->mnt_flags & MNT_NOEXEC)
+	if (!S_ISREG(inode->i_mode) ||
+	    exe.file->f_path.mnt->mnt_flags & MNT_NOEXEC) {
+		err = -EACCES;
 		goto exit;
+	}
 
 	err = inode_permission(inode, MAY_EXEC);
 	if (err)
@@ -1662,15 +1673,16 @@ static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
 	/*
 	 * Forbid mm->exe_file change if old file still mapped.
 	 */
-	err = -EBUSY;
 	if (mm->exe_file) {
 		struct vm_area_struct *vma;
 
 		for (vma = mm->mmap; vma; vma = vma->vm_next)
 			if (vma->vm_file &&
 			    path_equal(&vma->vm_file->f_path,
-				       &mm->exe_file->f_path))
+				       &mm->exe_file->f_path)) {
+				err = -EBUSY;
 				goto exit_unlock;
+			}
 	}
 
 	/*
@@ -1679,11 +1691,10 @@ static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
 	 * could make a snapshot over all processes running and monitor
 	 * /proc/pid/exe changes to notice unusual activity if needed.
 	 */
-	err = -EPERM;
-	if (test_and_set_bit(MMF_EXE_FILE_CHANGED, &mm->flags))
+	if (test_and_set_bit(MMF_EXE_FILE_CHANGED, &mm->flags)) {
+		err = -EPERM;
 		goto exit_unlock;
-
-	err = 0;
+	}
 	set_mm_exe_file(mm, exe.file);	/* this grabs a reference to exe.file */
 exit_unlock:
 	up_write(&mm->mmap_sem);
@@ -2009,13 +2020,13 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 SYSCALL_DEFINE3(getcpu, unsigned __user *, cpup, unsigned __user *, nodep,
 		struct getcpu_cache __user *, unused)
 {
-	int err = 0;
 	int cpu = raw_smp_processor_id();
-	if (cpup)
-		err |= put_user(cpu, cpup);
-	if (nodep)
-		err |= put_user(cpu_to_node(cpu), nodep);
-	return err ? -EFAULT : 0;
+
+	if (cpup && put_user(cpu, cpup))
+		return -EFAULT;
+	if (nodep && put_user(cpu_to_node(cpu), nodep))
+		return -EFAULT;
+	return 0;
 }
 
 /**
-- 
1.7.7.6
