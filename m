Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab3LKVDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:03:21 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:64156 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab3LKVDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:03:14 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, kay@vrfy.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] kernfs: allow negative dentries
Date: Wed, 11 Dec 2013 16:02:59 -0500
Message-Id: <1386795780-23324-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386795780-23324-1-git-send-email-tj@kernel.org>
References: <1386795780-23324-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernfs doesn't allow negative dentries - kernfs_iop_lookup() returns
ERR_PTR(-ENOENT) instead of NULL which short-circuits negative dentry
creation and kernfs's d_delete() callback, kernfs_dop_delete(),
returns 1 for all removed nodes.  This in turn allows
kernfs_dop_revalidate() to assume that there's no negative dentry for
kernfs.

This worked fine for sysfs but kernfs is scheduled to grow mkdir(2)
support which depend on negative dentries.  This patch updates so that
kernfs allows negative dentries.  The required changes are almost
trivial - kernfs_iop_lookup() now returns NULL instead of
ERR_PTR(-ENOENT) when the target kernfs_node doesn't exist,
kernfs_dop_delete() is removed and kernfs_dop_revalidate() is updated
to check whether the target dentry is negative and request fresh
lookup if so.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c | 37 +++++++++++++------------------------
 1 file changed, 13 insertions(+), 24 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index d33af95..42c5b9f 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -264,12 +264,6 @@ void kernfs_put(struct kernfs_node *kn)
 }
 EXPORT_SYMBOL_GPL(kernfs_put);
 
-static int kernfs_dop_delete(const struct dentry *dentry)
-{
-	struct kernfs_node *kn = dentry->d_fsdata;
-	return !(kn && !(kn->flags & KERNFS_REMOVED));
-}
-
 static int kernfs_dop_revalidate(struct dentry *dentry, unsigned int flags)
 {
 	struct kernfs_node *kn;
@@ -277,6 +271,10 @@ static int kernfs_dop_revalidate(struct dentry *dentry, unsigned int flags)
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
 
+	/* Always perform fresh lookup for negatives */
+	if (!dentry->d_inode)
+		goto out_bad_unlocked;
+
 	kn = dentry->d_fsdata;
 	mutex_lock(&kernfs_mutex);
 
@@ -301,22 +299,14 @@ static int kernfs_dop_revalidate(struct dentry *dentry, unsigned int flags)
 out_valid:
 	return 1;
 out_bad:
-	/*
-	 * Remove the dentry from the dcache hashes.
-	 * If this is a deleted dentry we use d_drop instead of d_delete
-	 * so kernfs doesn't need to cope with negative dentries.
-	 *
-	 * If this is a dentry that has simply been renamed we
-	 * use d_drop to remove it from the dcache lookup on its
-	 * old parent.  If this dentry persists later when a lookup
-	 * is performed at its new name the dentry will be readded
-	 * to the dcache hashes.
-	 */
 	mutex_unlock(&kernfs_mutex);
-
-	/* If we have submounts we must allow the vfs caches
-	 * to lie about the state of the filesystem to prevent
-	 * leaks and other nasty things.
+out_bad_unlocked:
+	/*
+	 * @dentry doesn't match the underlying kernfs node, drop the
+	 * dentry and force lookup.  If we have submounts we must allow the
+	 * vfs caches to lie about the state of the filesystem to prevent
+	 * leaks and other nasty things, so use check_submounts_and_drop()
+	 * instead of d_drop().
 	 */
 	if (check_submounts_and_drop(dentry) != 0)
 		goto out_valid;
@@ -331,7 +321,6 @@ static void kernfs_dop_release(struct dentry *dentry)
 
 const struct dentry_operations kernfs_dops = {
 	.d_revalidate	= kernfs_dop_revalidate,
-	.d_delete	= kernfs_dop_delete,
 	.d_release	= kernfs_dop_release,
 };
 
@@ -682,7 +671,7 @@ static struct dentry *kernfs_iop_lookup(struct inode *dir,
 					struct dentry *dentry,
 					unsigned int flags)
 {
-	struct dentry *ret = NULL;
+	struct dentry *ret;
 	struct kernfs_node *parent = dentry->d_parent->d_fsdata;
 	struct kernfs_node *kn;
 	struct inode *inode;
@@ -697,7 +686,7 @@ static struct dentry *kernfs_iop_lookup(struct inode *dir,
 
 	/* no such entry */
 	if (!kn) {
-		ret = ERR_PTR(-ENOENT);
+		ret = NULL;
 		goto out_unlock;
 	}
 	kernfs_get(kn);
-- 
1.8.4.2

