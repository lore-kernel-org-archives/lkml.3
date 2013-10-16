Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761556Ab3JPWD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 18:03:26 -0400
Received: from natasha.panasas.com ([67.152.220.90]:50197 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760975Ab3JPWCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 18:02:34 -0400
From: Jim Lieb <jlieb@panasas.com>
To: tytso@mit.edu, viro@zeniv.linux.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@redhat.com, jlayton@redhat.com, Jim Lieb <jlieb@panasas.com>
Subject: [PATCH 1/3] switch_creds:  Syscall to switch creds for file server ops
Date: Wed, 16 Oct 2013 15:01:57 -0700
Message-Id: <1381960919-4542-2-git-send-email-jlieb@panasas.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381960919-4542-1-git-send-email-jlieb@panasas.com>
References: <1381960919-4542-1-git-send-email-jlieb@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File servers must do some operations with the credentials of
their client.  This syscall switches the key credentials similar
to nfsd_setuser() in fs/nfsd/auth.c  with the capability of retaining a
handle to the credentials by way of an fd for an open anonymous file.
This makes switching for subsequent operations for that client more efficient.

Signed-off-by: Jim Lieb <jlieb@panasas.com>
---
 include/linux/cred.h     |  15 ++++
 include/linux/syscalls.h |   2 +
 kernel/sys.c             | 175 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sys_ni.c          |   3 +
 4 files changed, 195 insertions(+)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index 04421e8..66a006e 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -138,6 +138,21 @@ struct cred {
 	struct rcu_head	rcu;		/* RCU deletion hook */
 };
 
+/* switch_creds() syscall parameters*/
+
+#define SWCREDS_REVERT 0
+#define SWCREDS_FROMFD 1
+#define SWCREDS_FSIDS  2
+
+/* arg for SWCREDS_FSIDS command */
+
+struct user_creds {
+	uid_t		uid;
+	gid_t		gid;
+	unsigned	ngroups;
+	gid_t		altgroups[0];
+};
+
 extern void __put_cred(struct cred *);
 extern void exit_creds(struct task_struct *);
 extern int copy_creds(struct task_struct *, unsigned long);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 7fac04e..3550a8f 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -64,6 +64,7 @@ struct old_linux_dirent;
 struct perf_event_attr;
 struct file_handle;
 struct sigaltstack;
+struct user_creds;
 
 #include <linux/types.h>
 #include <linux/aio_abi.h>
@@ -231,6 +232,7 @@ asmlinkage long sys_setresuid(uid_t ruid, uid_t euid, uid_t suid);
 asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid);
 asmlinkage long sys_setfsuid(uid_t uid);
 asmlinkage long sys_setfsgid(gid_t gid);
+asmlinkage long sys_switch_creds(int cmd, unsigned long arg);
 asmlinkage long sys_setpgid(pid_t pid, pid_t pgid);
 asmlinkage long sys_setsid(void);
 asmlinkage long sys_setgroups(int gidsetsize, gid_t __user *grouplist);
diff --git a/kernel/sys.c b/kernel/sys.c
index c18ecca..cebc661 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -53,6 +53,7 @@
 #include <linux/rcupdate.h>
 #include <linux/uidgid.h>
 #include <linux/cred.h>
+#include <linux/anon_inodes.h>
 
 #include <linux/kmsg_dump.h>
 /* Move somewhere else to avoid recompiling? */
@@ -798,6 +799,180 @@ change_okay:
 	return old_fsgid;
 }
 
+static int swcreds_release(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+#ifdef CONFIG_PROC_FS
+static int swcreds_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	const struct group_info *group_info = f->f_cred->group_info;
+	int ret;
+
+	ret = seq_printf(m, "setcreds: fsuid = %d, fsgid = %d, ngroups = %d\n",
+			 from_kuid_munged(current_user_ns(),
+					  f->f_cred->fsuid),
+			 from_kgid_munged(current_user_ns(),
+					  f->f_cred->fsgid),
+			 group_info->ngroups);
+	if (!ret) {
+		int i;
+
+		for (i = 0; i < f->f_cred->group_info->ngroups; i++) {
+			ret = seq_printf(m, "altgroup[%d] = %d\n",
+					 i,
+					 from_kgid_munged(current_user_ns(),
+							  GROUP_AT(group_info,
+								   i)));
+			if (ret)
+				break;
+		}
+	}
+	return ret;
+}
+#endif
+
+static const struct file_operations swcreds_fops = {
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo = swcreds_show_fdinfo,
+#endif
+	.release = swcreds_release
+};
+
+/* do_switch_creds - set thread creds from struct pointed to by arg
+ *
+ * Does setfsuid, setfsgid, setgroups for thread in one call and one rcu update.
+ * drop special root capabilities as well which are not dropped by setfsuid.
+ * This code is similar to nfsd_setuid in concept.
+ */
+
+static int do_switch_creds(unsigned long arg)
+{
+	const struct user_creds  __user *creds;
+	const gid_t __user *alt_groups;
+	const struct cred *old = current_cred();
+	int i, new_fd;
+	struct cred *new;
+	struct user_creds ncred;
+	struct group_info *group_info;
+	int retval;
+
+	creds  = (const struct user_creds  __user *)arg;
+	/* validate and copyin creds */
+	if (copy_from_user(&ncred, creds, sizeof(struct user_creds)))
+		return -EFAULT;
+
+	if (ncred.ngroups > NGROUPS_MAX)
+		return -EINVAL;
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+	group_info = groups_alloc(ncred.ngroups);
+	if (!group_info) {
+		abort_creds(new);
+		return -ENOMEM;
+	}
+	new->fsuid = make_kuid(old->user_ns, ncred.uid);
+	new->fsgid = make_kgid(old->user_ns, ncred.gid);
+	alt_groups = &creds->altgroups[0];
+	for (i = 0; i < ncred.ngroups; i++) {
+		kgid_t kgid;
+		gid_t gid;
+
+		if (get_user(gid, alt_groups+i)) {
+			retval = -EFAULT;
+			goto bad_altgrp;
+		}
+		kgid = make_kgid(old->user_ns, gid);
+		if (!gid_valid(kgid)) {
+			retval = -EINVAL;
+			goto bad_altgrp;
+		}
+		GROUP_AT(group_info, i) = kgid;
+	}
+	retval = set_groups(new, group_info);
+	put_group_info(group_info);
+	if (retval < 0) {
+		abort_creds(new);
+		return retval;
+	}
+	/* We need to be the real user in capabilities as well.
+	 * don't leak my root caps into the mix */
+	new->cap_effective = cap_drop_nfsd_set(new->cap_effective);
+	old = override_creds(new);
+	/* now open a anon file to preserve these creds
+	 * and return the fd
+	 */
+	new_fd = anon_inode_getfd("[switch_creds]",
+				  &swcreds_fops,
+				  NULL,
+				  (O_RDONLY|O_CLOEXEC));
+	if (new_fd < 0) {
+		revert_creds(old);
+		abort_creds(new);
+	}
+	return new_fd;
+
+bad_altgrp:
+	put_group_info(group_info);
+	abort_creds(new);
+	return retval;
+}
+
+/**
+ *  switch_creds -- Change user (client) file system credentials
+ *
+ *  Switch the thread's current file access credentials from the argument.
+ *  The end result is the thread has the fsuid, fsgid, altgroups and
+ *  non-root capabilities of the user we want to be for subsequent syscalls.
+ *
+ *  @cmd  SWCREDS_REVERT  revert thread's creds to its real creds.
+ *                        Always returns 0
+ *        SWCREDS_FROM_FD override current creds with creds from open file.
+ *                        Returns 0 or file related error.
+ *        SWCREDS_FSIDS   set fsuid, fsgid, altgroups from arg
+ *                        Return fd or error
+ *  @arg fd or pointer to creds struct
+ *
+ *  The returned fd is a somewhat useless but minimally resource consuming
+ *  anon file that can only be used to store the new creds state.
+ *
+ *  Return 0, fd, or error.
+ */
+
+SYSCALL_DEFINE2(switch_creds, int, cmd, unsigned long, arg)
+{
+	const struct cred *old;
+
+	old = current_cred();
+	if (!ns_capable(old->user_ns, CAP_SETGID) ||
+	    !ns_capable(old->user_ns, CAP_SETUID))
+		return -EPERM;
+
+	if (cmd == SWCREDS_REVERT) {
+		if (current->real_cred != current->cred) {
+			revert_creds(current->real_cred);
+			return 0;
+		}
+	}
+	if (cmd == SWCREDS_FROMFD) {
+		struct fd f;
+		const struct cred *file_cred;
+
+		f = fdget(arg);
+		if (unlikely(!f.file))
+			return -EBADF;
+		file_cred = f.file->f_cred;
+		(void)override_creds(file_cred);
+		fdput(f);
+		return 0;
+	} else if (cmd == SWCREDS_FSIDS) {
+		return do_switch_creds(arg);
+	}
+	return -EINVAL;
+}
+
 /**
  * sys_getpid - return the thread group id of the current process
  *
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 7078052..7573cad 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -209,3 +209,6 @@ cond_syscall(compat_sys_open_by_handle_at);
 
 /* compare kernel pointers */
 cond_syscall(sys_kcmp);
+
+/* switch task creds */
+cond_syscall(sys_switch_creds);
-- 
1.8.3.1

