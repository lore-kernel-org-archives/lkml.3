Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbaAXMSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 07:18:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbaAXMR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 07:17:57 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] VFS: Make delayed_free() call free_vfsmnt()
From: David Howells <dhowells@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 24 Jan 2014 12:17:54 +0000
Message-ID: <20140124121754.22031.42018.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make delayed_free() call free_vfsmnt() so that we don't have two functions
doing the same job.  This requires the calls to mnt_free_id() in free_vfsmnt()
to be moved into the callers of that function.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namespace.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index be32ebccdeb1..b1695fe3ee59 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -540,13 +540,17 @@ int sb_prepare_remount_readonly(struct super_block *sb)
 static void free_vfsmnt(struct mount *mnt)
 {
 	kfree(mnt->mnt_devname);
-	mnt_free_id(mnt);
 #ifdef CONFIG_SMP
 	free_percpu(mnt->mnt_pcp);
 #endif
 	kmem_cache_free(mnt_cache, mnt);
 }
 
+static void delayed_free_vfsmnt(struct rcu_head *head)
+{
+	free_vfsmnt(container_of(head, struct mount, mnt_rcu));
+}
+
 /* call under rcu_read_lock */
 bool legitimize_mnt(struct vfsmount *bastard, unsigned seq)
 {
@@ -812,6 +816,7 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
 
 	root = mount_fs(type, flags, name, data);
 	if (IS_ERR(root)) {
+		mnt_free_id(mnt);
 		free_vfsmnt(mnt);
 		return ERR_CAST(root);
 	}
@@ -892,20 +897,11 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 	return mnt;
 
  out_free:
+	mnt_free_id(mnt);
 	free_vfsmnt(mnt);
 	return ERR_PTR(err);
 }
 
-static void delayed_free(struct rcu_head *head)
-{
-	struct mount *mnt = container_of(head, struct mount, mnt_rcu);
-	kfree(mnt->mnt_devname);
-#ifdef CONFIG_SMP
-	free_percpu(mnt->mnt_pcp);
-#endif
-	kmem_cache_free(mnt_cache, mnt);
-}
-
 static void mntput_no_expire(struct mount *mnt)
 {
 put_again:
@@ -955,7 +951,7 @@ put_again:
 	dput(mnt->mnt.mnt_root);
 	deactivate_super(mnt->mnt.mnt_sb);
 	mnt_free_id(mnt);
-	call_rcu(&mnt->mnt_rcu, delayed_free);
+	call_rcu(&mnt->mnt_rcu, delayed_free_vfsmnt);
 }
 
 void mntput(struct vfsmount *mnt)

