Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936508Ab3DKVI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:08:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935682Ab3DKUtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:11 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=4o32hI98Tu0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=UUfvP-JnFb4A:10 a=PtDNVHqPAAAA:8 a=VwQbUJbxAAAA:8 a=DfNHnWVPAAAA:8 a=SOq6UgPBAAAA:8 a=5lgaCMr79_1aLC8ADEQA:9 a=wYE_KDyynt4A:10 a=lBRciGGoxdUA:10 a=5y_flRe8UpcA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202604.189219756@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [ 109/171 ] userns: Dont allow creation if the user is chrooted
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0109-userns-Don-t-allow-creation-if-the-user-is-chrooted.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit 3151527ee007b73a0ebd296010f1c0454a919c7d ]

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

Cc: stable@vger.kernel.org
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Reported-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/namespace.c            |   25 +++++++++++++++++++++++++
 include/linux/fs_struct.h |    2 ++
 kernel/user_namespace.c   |    9 +++++++++
 3 files changed, 36 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 7bdf790..c48b0d3 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2681,3 +2681,28 @@ bool our_mnt(struct vfsmount *mnt)
 {
 	return check_mnt(real_mount(mnt));
 }
+
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
diff --git a/include/linux/fs_struct.h b/include/linux/fs_struct.h
index 003dc0f..961cdaa 100644
--- a/include/linux/fs_struct.h
+++ b/include/linux/fs_struct.h
@@ -51,4 +51,6 @@ static inline void get_fs_root_and_pwd(struct fs_struct *fs, struct path *root,
 	spin_unlock(&fs->lock);
 }
 
+extern bool current_chrooted(void);
+
 #endif /* _LINUX_FS_STRUCT_H */
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 8660231..a74dc5b 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -39,6 +39,15 @@ int create_user_ns(struct cred *new)
 	kuid_t owner = new->euid;
 	kgid_t group = new->egid;
 
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
-- 
1.7.10.4


