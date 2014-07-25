Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703AbaGYNvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 09:51:11 -0400
Received: from mail-la0-f74.google.com ([209.85.215.74]:62658 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760392AbaGYNsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 09:48:13 -0400
From: David Drysdale <drysdale@google.com>
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>,
        Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org,
        David Drysdale <drysdale@google.com>
Subject: [PATCH 09/11] capsicum: add syscalls to limit FD rights
Date: Fri, 25 Jul 2014 14:47:05 +0100
Message-Id: <1406296033-32693-10-git-send-email-drysdale@google.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1406296033-32693-1-git-send-email-drysdale@google.com>
References: <1406296033-32693-1-git-send-email-drysdale@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the cap_rights_get(2) and cap_rights_set(2) syscalls to
allow retrieval and modification of the rights associated with
a file descriptor.

When a normal file descriptor has its rights restricted in any
way, it becomes a Capsicum capability file descriptor.  This is
a wrapper struct file that is installed in the fdtable in place
of the original file.  From this point on, when the FD is converted
to a struct file by fget() (or equivalent), the wrapper is checked
for the appropriate rights and the wrapped inner normal file is
returned.

When a Capsicum capability file descriptor has its rights restricted
further (they cannot be expanded), a new wrapper is created with
the restricted rights, also wrapping the same inner normal file.
In other words, the .underlying field in a struct capsicum_capability
is always a normal file, never another Capsicum capability file.

These syscalls specify the different components of the compound
rights structure separately, allowing components to be unspecified
for no change.

Note that in FreeBSD 10.x the function of this pair of syscalls
is implemented as 3 distinct pairs of syscalls, one pair for each
component of the compound rights (primary/fcntl/ioctl).

Signed-off-by: David Drysdale <drysdale@google.com>
---
 arch/x86/syscalls/syscall_64.tbl |   2 +
 include/linux/syscalls.h         |  12 ++++
 kernel/sys_ni.c                  |   4 ++
 security/capsicum.c              | 146 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 164 insertions(+)

diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index ec255a1646d2..d980d2b8bfad 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -323,6 +323,8 @@
 314	common	sched_setattr		sys_sched_setattr
 315	common	sched_getattr		sys_sched_getattr
 316	common	renameat2		sys_renameat2
+318	common	cap_rights_limit	sys_cap_rights_limit
+319	common	cap_rights_get		sys_cap_rights_get
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b0881a0ed322..d754f0846037 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -65,6 +65,7 @@ struct old_linux_dirent;
 struct perf_event_attr;
 struct file_handle;
 struct sigaltstack;
+struct cap_rights;
 
 #include <linux/types.h>
 #include <linux/aio_abi.h>
@@ -866,4 +867,15 @@ asmlinkage long sys_process_vm_writev(pid_t pid,
 asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
 			 unsigned long idx1, unsigned long idx2);
 asmlinkage long sys_finit_module(int fd, const char __user *uargs, int flags);
+asmlinkage long sys_cap_rights_limit(unsigned int orig_fd,
+				     const struct cap_rights __user *new_rights,
+				     unsigned int fcntls,
+				     int nioctls,
+				     unsigned int __user *ioctls);
+asmlinkage long sys_cap_rights_get(unsigned int fd,
+				   struct cap_rights __user *rightsp,
+				   unsigned int __user *fcntls,
+				   int __user *nioctls,
+				   unsigned int __user *ioctls);
+
 #endif
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 36441b51b5df..ef634cb1bc6c 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -213,3 +213,7 @@ cond_syscall(compat_sys_open_by_handle_at);
 
 /* compare kernel pointers */
 cond_syscall(sys_kcmp);
+
+/* capsicum object capabilities */
+cond_syscall(sys_cap_rights_get);
+cond_syscall(sys_cap_rights_limit);
diff --git a/security/capsicum.c b/security/capsicum.c
index 4a004829b9c8..42c14bab4b64 100644
--- a/security/capsicum.c
+++ b/security/capsicum.c
@@ -125,6 +125,152 @@ out_err:
 	return ERR_PTR(err);
 }
 
+/* Takes ownership of rights->ioctls */
+static int capsicum_rights_limit(unsigned int fd,
+				 struct capsicum_rights *rights)
+{
+	int rc = -EBADF;
+	struct capsicum_capability *cap;
+	struct file *capf = NULL;
+	struct file *file;  /* current file for fd */
+	struct file *underlying; /* base file for capability */
+	struct files_struct *files = current->files;
+	struct fdtable *fdt;
+
+	/* Allocate capability before taking files->file_lock */
+	capf = capsicum_cap_alloc(rights, true);
+	rights->ioctls = NULL;  /* capsicum_cap_alloc took ownership */
+	if (IS_ERR(capf))
+		return PTR_ERR(capf);
+	cap = capf->private_data;
+
+	spin_lock(&files->file_lock);
+	fdt = files_fdtable(files);
+	if (fd >= fdt->max_fds)
+		goto out_err;
+	file = fdt->fd[fd];
+	if (!file)
+		goto out_err;
+
+	/* If we're limiting an existing Capsicum capability object, ensure
+	 * we wrap its underlying normal file. */
+	if (capsicum_is_cap(file)) {
+		struct capsicum_capability *old_cap = file->private_data;
+		/* Reject attempts to widen existing rights */
+		if (!cap_rights_contains(&old_cap->rights, &cap->rights)) {
+			rc = -ENOTCAPABLE;
+			goto out_err;
+		}
+		underlying = old_cap->underlying;
+	} else {
+		underlying = file;
+	}
+	if (!atomic_long_inc_not_zero(&underlying->f_count)) {
+		rc = -EBADF;
+		goto out_err;
+	}
+	cap->underlying = underlying;
+
+	fput(file);
+	rcu_assign_pointer(fdt->fd[fd], capf);
+	spin_unlock(&files->file_lock);
+	return 0;
+out_err:
+	spin_unlock(&files->file_lock);
+	fput(capf);
+	return rc;
+}
+
+SYSCALL_DEFINE5(cap_rights_limit,
+		unsigned int, fd,
+		const struct cap_rights __user *, new_rights,
+		unsigned int, new_fcntls,
+		int, nioctls,
+		unsigned int __user *, new_ioctls)
+{
+	struct capsicum_rights rights;
+
+	if (!new_rights)
+		return -EFAULT;
+	if (nioctls < 0 && nioctls != -1)
+		return -EINVAL;
+	if (copy_from_user(&rights.primary, new_rights,
+			   sizeof(struct cap_rights)))
+		return -EFAULT;
+	rights.fcntls = new_fcntls;
+	rights.nioctls = nioctls;
+	if (rights.nioctls > 0) {
+		size_t size;
+
+		if (!new_ioctls)
+			return -EINVAL;
+		size = rights.nioctls * sizeof(unsigned int);
+		rights.ioctls = kmalloc(size, GFP_KERNEL);
+		if (!rights.ioctls)
+			return -ENOMEM;
+		if (copy_from_user(rights.ioctls, new_ioctls, size)) {
+			kfree(rights.ioctls);
+			return -EFAULT;
+		}
+	} else {
+		rights.ioctls = NULL;
+	}
+	if (cap_rights_regularize(&rights))
+		return -ENOTCAPABLE;
+
+	return capsicum_rights_limit(fd, &rights);
+}
+
+SYSCALL_DEFINE5(cap_rights_get,
+		unsigned int, fd,
+		struct cap_rights __user *, rightsp,
+		unsigned int __user *, fcntls,
+		int __user *, nioctls,
+		unsigned int __user *, ioctls)
+{
+	int result = -EFAULT;
+	struct file *file;
+	struct capsicum_rights *rights = &all_rights;
+	int ioctls_to_copy = -1;
+
+	file = fget_raw(fd);
+	if (file == NULL)
+		return -EBADF;
+	if (capsicum_is_cap(file)) {
+		struct capsicum_capability *cap = file->private_data;
+
+		rights = &cap->rights;
+	}
+
+	if (rightsp) {
+		if (copy_to_user(rightsp, &rights->primary,
+				 sizeof(struct cap_rights)))
+			goto out;
+	}
+	if (fcntls) {
+		if (put_user(rights->fcntls, fcntls))
+			goto out;
+	}
+	if (nioctls) {
+		int n;
+
+		if (get_user(n, nioctls))
+			goto out;
+		if (put_user(rights->nioctls, nioctls))
+			goto out;
+		ioctls_to_copy = min(rights->nioctls, n);
+	}
+	if (ioctls && ioctls_to_copy > 0) {
+		if (copy_to_user(ioctls, rights->ioctls,
+				 ioctls_to_copy * sizeof(unsigned int)))
+			goto out;
+	}
+	result = 0;
+out:
+	fput(file);
+	return result;
+}
+
 /*
  * File operations functions.
  */
-- 
2.0.0.526.g5318336

