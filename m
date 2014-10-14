Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583AbaJNXyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 19:54:55 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:39473 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460AbaJNXyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 19:54:52 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Michael j Theall <mtheall@us.ibm.com>, fuse-devel@lists.sourceforge.net,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3] fs: Treat foreign mounts as nosuid
Date: Tue, 14 Oct 2014 16:54:47 -0700
Message-Id: <252a4d87d99fc2b5fe4411c838f65b312c4e13cd.1413330857.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a process gets access to a mount from a different namespace user
namespace, that process should not be able to take advantage of
setuid files or selinux entrypoints from that filesystem.
Technically, trusting mounts created by the same or ancestor user
namespaces ought to be safe, but it's simpler to distrust all
foreign mounts.

This will make it safer to allow more complex filesystems to be
mounted in non-root user namespaces.

This does not remove the need for MNT_LOCK_NOSUID.  The setuid,
setgid, and file capability bits can no longer be abused if code in
a user namespace were to clear nosuid on an untrusted filesystem,
but this patch, by itself, is insufficient to protect the system
from abuse of files that, when execed, would increase MAC privilege.

As a more concrete explanation, any task that can manipulate a
vfsmount associated with a given user namespace already has
capabilities in that namespace and all of its descendents.  If they
can cause a malicious setuid, setgid, or file-caps executable to
appear in that mount, then that executable will only allow them to
elevate privileges in exactly the set of namespaces in which they
are already privileges.

On the other hand, if they can cause a malicious executable to
appear with a dangerous MAC label, running it could change the
caller's security context in a way that should not have been
possible, even inside the namespace in which the task is confined.

As a hardening measure, this would have made CVE-2014-5207 much
more difficult to exploit.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

Changes from v2:
 - Fix comment typo.

Changes from v1:
 - Treat all foreign mounts as nosuid, not just non-self-or-ancestor
   userns mounts.

 fs/exec.c                |  2 +-
 fs/namespace.c           | 13 +++++++++++++
 include/linux/mount.h    |  1 +
 security/commoncap.c     |  2 +-
 security/selinux/hooks.c |  4 ++--
 5 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index a2b42a98c743..ac0bb22aa3ed 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1267,7 +1267,7 @@ int prepare_binprm(struct linux_binprm *bprm)
 	bprm->cred->euid = current_euid();
 	bprm->cred->egid = current_egid();
 
-	if (!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID) &&
+	if (mnt_may_suid(bprm->file->f_path.mnt) &&
 	    !task_no_new_privs(current) &&
 	    kuid_has_mapping(bprm->cred->user_ns, inode->i_uid) &&
 	    kgid_has_mapping(bprm->cred->user_ns, inode->i_gid)) {
diff --git a/fs/namespace.c b/fs/namespace.c
index ef42d9bee212..4df0b393c29d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3019,6 +3019,19 @@ found:
 	return visible;
 }
 
+bool mnt_may_suid(struct vfsmount *mnt)
+{
+	/*
+	 * Foreign mounts (accessed via fchdir or through /proc
+	 * symlinks) are always treated as if they are nosuid.  This
+	 * prevents namespaces from trusting potentially unsafe
+	 * suid/sgid bits, file caps, or security labels that originate
+	 * in other namespaces.
+	 */
+	return real_mount(mnt)->mnt_ns == current->nsproxy->mnt_ns &&
+		!(mnt->mnt_flags & MNT_NOSUID);
+}
+
 static void *mntns_get(struct task_struct *task)
 {
 	struct mnt_namespace *ns = NULL;
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 9262e4bf0cc3..b7b84bafe09b 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -80,6 +80,7 @@ extern void mntput(struct vfsmount *mnt);
 extern struct vfsmount *mntget(struct vfsmount *mnt);
 extern struct vfsmount *mnt_clone_internal(struct path *path);
 extern int __mnt_is_readonly(struct vfsmount *mnt);
+extern bool mnt_may_suid(struct vfsmount *mnt);
 
 struct file_system_type;
 extern struct vfsmount *vfs_kern_mount(struct file_system_type *type,
diff --git a/security/commoncap.c b/security/commoncap.c
index bab0611afc1e..52b3eed065e0 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -443,7 +443,7 @@ static int get_file_caps(struct linux_binprm *bprm, bool *effective, bool *has_c
 	if (!file_caps_enabled)
 		return 0;
 
-	if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
+	if (!mnt_may_suid(bprm->file->f_path.mnt))
 		return 0;
 
 	dentry = dget(bprm->file->f_dentry);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index b0e940497e23..2089fd0d539e 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2139,7 +2139,7 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
 		 */
 		if (bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS)
 			return -EPERM;
-		if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
+		if (!mnt_may_suid(bprm->file->f_path.mnt))
 			return -EACCES;
 	} else {
 		/* Check for a default transition on this program. */
@@ -2153,7 +2153,7 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
 	ad.type = LSM_AUDIT_DATA_PATH;
 	ad.u.path = bprm->file->f_path;
 
-	if ((bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID) ||
+	if (!mnt_may_suid(bprm->file->f_path.mnt) ||
 	    (bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS))
 		new_tsec->sid = old_tsec->sid;
 
-- 
1.9.3

