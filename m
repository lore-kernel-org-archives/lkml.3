Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254AbaFJU06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:26:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35117 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbaFJTtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:49:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 124/160] fix races between __d_instantiate() and checks of dentry flags
Date: Tue, 10 Jun 2014 12:46:04 -0700
Message-Id: <1402429600-20477-125-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 22213318af7ae265bc6cd8aef2febbc2d69a2440 upstream.

in non-lazy walk we need to be careful about dentry switching from
negative to positive - both ->d_flags and ->d_inode are updated,
and in some places we might see only one store.  The cases where
dentry has been obtained by dcache lookup with ->i_mutex held on
parent are safe - ->d_lock and ->i_mutex provide all the barriers
we need.  However, there are several places where we run into
trouble:
	* do_last() fetches ->d_inode, then checks ->d_flags and
assumes that inode won't be NULL unless d_is_negative() is true.
Race with e.g. creat() - we might have fetched the old value of
->d_inode (still NULL) and new value of ->d_flags (already not
DCACHE_MISS_TYPE).  Lin Ming has observed and reported the resulting
oops.
	* a bunch of places checks ->d_inode for being non-NULL,
then checks ->d_flags for "is it a symlink".  Race with symlink(2)
in case if our CPU sees ->d_inode update first - we see non-NULL
there, but ->d_flags still contains DCACHE_MISS_TYPE instead of
DCACHE_SYMLINK_TYPE.  Result: false negative on "should we follow
link here?", with subsequent unpleasantness.

Reported-and-tested-by: Lin Ming <minggr@gmail.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/dcache.c | 3 +--
 fs/namei.c  | 6 +++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index ca02c13..7f3b400 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1647,8 +1647,7 @@ static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 	unsigned add_flags = d_flags_for_inode(inode);
 
 	spin_lock(&dentry->d_lock);
-	dentry->d_flags &= ~DCACHE_ENTRY_TYPE;
-	dentry->d_flags |= add_flags;
+	__d_set_type(dentry, add_flags);
 	if (inode)
 		hlist_add_head(&dentry->d_alias, &inode->i_dentry);
 	dentry->d_inode = inode;
diff --git a/fs/namei.c b/fs/namei.c
index 399f637..3a1ea70a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1526,7 +1526,7 @@ static inline int walk_component(struct nameidata *nd, struct path *path,
 		inode = path->dentry->d_inode;
 	}
 	err = -ENOENT;
-	if (!inode)
+	if (!inode || d_is_negative(path->dentry))
 		goto out_path_put;
 
 	if (should_follow_link(path->dentry, follow)) {
@@ -2229,7 +2229,7 @@ mountpoint_last(struct nameidata *nd, struct path *path)
 	mutex_unlock(&dir->d_inode->i_mutex);
 
 done:
-	if (!dentry->d_inode) {
+	if (!dentry->d_inode || d_is_negative(dentry)) {
 		error = -ENOENT;
 		dput(dentry);
 		goto out;
@@ -2971,7 +2971,7 @@ retry_lookup:
 finish_lookup:
 	/* we _can_ be in RCU mode here */
 	error = -ENOENT;
-	if (d_is_negative(path->dentry)) {
+	if (!inode || d_is_negative(path->dentry)) {
 		path_to_nameidata(path, nd);
 		goto out;
 	}
-- 
1.9.1

