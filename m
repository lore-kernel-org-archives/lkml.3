Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab3DBXMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:12:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933085Ab3DBWMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [ 049/124] userns:  Dont allow creation if the user is chrooted
Date: Tue,  2 Apr 2013 15:10:31 -0700
Message-Id: <20130402221109.873021700@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 3151527ee007b73a0ebd296010f1c0454a919c7d upstream.

Guarantee that the policy of which files may be access that is
established by setting the root directory will not be violated
by user namespaces by verifying that the root directory points
to the root of the mount namespace at the time of user namespace
creation.

Changing the root is a privileged operation, and as a matter of policy
it serves to limit unprivileged processes to files below the current
root directory.

For reasons of simplicity and comprehensibility the privilege to
change the root directory is gated solely on the CAP_SYS_CHROOT
capability in the user namespace.  Therefore when creating a user
namespace we must ensure that the policy of which files may be access
can not be violated by changing the root directory.

Anyone who runs a processes in a chroot and would like to use user
namespace can setup the same view of filesystems with a mount
namespace instead.  With this result that this is not a practical
limitation for using user namespaces.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Reported-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namespace.c            |   24 ++++++++++++++++++++++++
 include/linux/fs_struct.h |    2 ++
 kernel/user_namespace.c   |    9 +++++++++
 3 files changed, 35 insertions(+)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2758,6 +2758,30 @@ bool our_mnt(struct vfsmount *mnt)
 	return check_mnt(real_mount(mnt));
 }
 
+bool current_chrooted(void)
+{
+	/* Does the current process have a non-standard root */
+	struct path ns_root;
+	struct path fs_root;
+	bool chrooted;
+
+	/* Find the namespace root */
+	ns_root.mnt = &current->nsproxy->mnt_ns->root->mnt;
+	ns_root.dentry = ns_root.mnt->mnt_root;
+	path_get(&ns_root);
+	while (d_mountpoint(ns_root.dentry) && follow_down_one(&ns_root))
+		;
+
+	get_fs_root(current->fs, &fs_root);
+
+	chrooted = !path_equal(&fs_root, &ns_root);
+
+	path_put(&fs_root);
+	path_put(&ns_root);
+
+	return chrooted;
+}
+
 static void *mntns_get(struct task_struct *task)
 {
 	struct mnt_namespace *ns = NULL;
--- a/include/linux/fs_struct.h
+++ b/include/linux/fs_struct.h
@@ -50,4 +50,6 @@ static inline void get_fs_root_and_pwd(s
 	spin_unlock(&fs->lock);
 }
 
+extern bool current_chrooted(void);
+
 #endif /* _LINUX_FS_STRUCT_H */
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -61,6 +61,15 @@ int create_user_ns(struct cred *new)
 	kgid_t group = new->egid;
 	int ret;
 
+	/*
+	 * Verify that we can not violate the policy of which files
+	 * may be accessed that is specified by the root directory,
+	 * by verifing that the root directory is at the root of the
+	 * mount namespace which allows all files to be accessed.
+	 */
+	if (current_chrooted())
+		return -EPERM;
+
 	/* The creator needs a mapping in the parent user namespace
 	 * or else we won't be able to reasonably tell userspace who
 	 * created a user_namespace.


