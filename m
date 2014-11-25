Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaKYBHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 20:07:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbaKYBHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 20:07:33 -0500
Subject: [RFC PATCH 1/4] vfs - fs/namespaces.c: break out mntns_setfs() from
 mntns_install()
From: Ian Kent <ikent@redhat.com>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Oleg Nesterov <onestero@redhat.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Tue, 25 Nov 2014 09:07:21 +0800
Message-ID: <20141125010719.4974.68177.stgit@pluto.fritz.box>
In-Reply-To: <20141125005255.4974.54193.stgit@pluto.fritz.box>
References: <20141125005255.4974.54193.stgit@pluto.fritz.box>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some users of kmod.c's usermodehelper need to setup their fs_struct
root and pwd based on the callers namespaces after the kernel thread
runner has created a new process but before do_execve() is called.

Break out the fs_struct portion of mntns_install so it can be used
for this purpose.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Ian Kent <ikent@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Oleg Nesterov <onestero@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/namespace.c        |   41 +++++++++++++++++++++++++++++------------
 include/linux/mount.h |    1 +
 2 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 5b66b2b..3cdbb9e 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3165,11 +3165,38 @@ static void mntns_put(void *ns)
 	put_mnt_ns(ns);
 }
 
+/*
+ * Set fs root and pwd for a subsequent call to do_execve().
+ *
+ * This assumes that an nsproxy has been created within the
+ * namespace context that is the target for the exec so that
+ * mnt_ns is already set. Additionally, since the nsproxy is
+ * created within the requesting namespace context the security
+ * checks of mntns_install() aren't required.
+ */
+void mntns_setfs(struct mnt_namespace *mnt_ns)
+{
+	struct fs_struct *fs = current->fs;
+	struct path root;
+
+	/* Find the root */
+	root.mnt    = &mnt_ns->root->mnt;
+	root.dentry = mnt_ns->root->mnt.mnt_root;
+	path_get(&root);
+	while(d_mountpoint(root.dentry) && follow_down_one(&root))
+		;
+
+	/* Update the pwd and root */
+	set_fs_pwd(fs, &root);
+	set_fs_root(fs, &root);
+
+	path_put(&root);
+}
+
 static int mntns_install(struct nsproxy *nsproxy, void *ns)
 {
 	struct fs_struct *fs = current->fs;
 	struct mnt_namespace *mnt_ns = ns;
-	struct path root;
 
 	if (!ns_capable(mnt_ns->user_ns, CAP_SYS_ADMIN) ||
 	    !ns_capable(current_user_ns(), CAP_SYS_CHROOT) ||
@@ -3183,18 +3210,8 @@ static int mntns_install(struct nsproxy *nsproxy, void *ns)
 	put_mnt_ns(nsproxy->mnt_ns);
 	nsproxy->mnt_ns = mnt_ns;
 
-	/* Find the root */
-	root.mnt    = &mnt_ns->root->mnt;
-	root.dentry = mnt_ns->root->mnt.mnt_root;
-	path_get(&root);
-	while(d_mountpoint(root.dentry) && follow_down_one(&root))
-		;
-
-	/* Update the pwd and root */
-	set_fs_pwd(fs, &root);
-	set_fs_root(fs, &root);
+	mntns_setfs(mnt_ns);
 
-	path_put(&root);
 	return 0;
 }
 
diff --git a/include/linux/mount.h b/include/linux/mount.h
index c2c561d..a9f6548 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -80,6 +80,7 @@ extern void mntput(struct vfsmount *mnt);
 extern struct vfsmount *mntget(struct vfsmount *mnt);
 extern struct vfsmount *mnt_clone_internal(struct path *path);
 extern int __mnt_is_readonly(struct vfsmount *mnt);
+void mntns_setfs(struct mnt_namespace *mnt_ns);
 
 struct path;
 extern struct vfsmount *clone_private_mount(struct path *path);

