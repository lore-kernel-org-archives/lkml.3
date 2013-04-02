Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094Ab3DBXLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:11:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933131Ab3DBWMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [ 051/124] vfs: Carefully propogate mounts across user namespaces
Date: Tue,  2 Apr 2013 15:10:33 -0700
Message-Id: <20130402221110.126307433@linuxfoundation.org>
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

commit 132c94e31b8bca8ea921f9f96a57d684fa4ae0a9 upstream.

As a matter of policy MNT_READONLY should not be changable if the
original mounter had more privileges than creator of the mount
namespace.

Add the flag CL_UNPRIVILEGED to note when we are copying a mount from
a mount namespace that requires more privileges to a mount namespace
that requires fewer privileges.

When the CL_UNPRIVILEGED flag is set cause clone_mnt to set MNT_NO_REMOUNT
if any of the mnt flags that should never be changed are set.

This protects both mount propagation and the initial creation of a less
privileged mount namespace.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Reported-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namespace.c |    6 +++++-
 fs/pnode.c     |    6 ++++++
 fs/pnode.h     |    1 +
 3 files changed, 12 insertions(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -798,6 +798,10 @@ static struct mount *clone_mnt(struct mo
 	}
 
 	mnt->mnt.mnt_flags = old->mnt.mnt_flags & ~MNT_WRITE_HOLD;
+	/* Don't allow unprivileged users to change mount flags */
+	if ((flag & CL_UNPRIVILEGED) && (mnt->mnt.mnt_flags & MNT_READONLY))
+		mnt->mnt.mnt_flags |= MNT_LOCK_READONLY;
+
 	atomic_inc(&sb->s_active);
 	mnt->mnt.mnt_sb = sb;
 	mnt->mnt.mnt_root = dget(root);
@@ -2368,7 +2372,7 @@ static struct mnt_namespace *dup_mnt_ns(
 	/* First pass: copy the tree topology */
 	copy_flags = CL_COPY_ALL | CL_EXPIRE;
 	if (user_ns != mnt_ns->user_ns)
-		copy_flags |= CL_SHARED_TO_SLAVE;
+		copy_flags |= CL_SHARED_TO_SLAVE | CL_UNPRIVILEGED;
 	new = copy_tree(old, old->mnt.mnt_root, copy_flags);
 	if (IS_ERR(new)) {
 		up_write(&namespace_sem);
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -9,6 +9,7 @@
 #include <linux/mnt_namespace.h>
 #include <linux/mount.h>
 #include <linux/fs.h>
+#include <linux/nsproxy.h>
 #include "internal.h"
 #include "pnode.h"
 
@@ -220,6 +221,7 @@ static struct mount *get_source(struct m
 int propagate_mnt(struct mount *dest_mnt, struct dentry *dest_dentry,
 		    struct mount *source_mnt, struct list_head *tree_list)
 {
+	struct user_namespace *user_ns = current->nsproxy->mnt_ns->user_ns;
 	struct mount *m, *child;
 	int ret = 0;
 	struct mount *prev_dest_mnt = dest_mnt;
@@ -237,6 +239,10 @@ int propagate_mnt(struct mount *dest_mnt
 
 		source =  get_source(m, prev_dest_mnt, prev_src_mnt, &type);
 
+		/* Notice when we are propagating across user namespaces */
+		if (m->mnt_ns->user_ns != user_ns)
+			type |= CL_UNPRIVILEGED;
+
 		child = copy_tree(source, source->mnt.mnt_root, type);
 		if (IS_ERR(child)) {
 			ret = PTR_ERR(child);
--- a/fs/pnode.h
+++ b/fs/pnode.h
@@ -23,6 +23,7 @@
 #define CL_MAKE_SHARED 		0x08
 #define CL_PRIVATE 		0x10
 #define CL_SHARED_TO_SLAVE	0x20
+#define CL_UNPRIVILEGED		0x40
 
 static inline void set_mnt_shared(struct mount *mnt)
 {


