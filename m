Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab3FIMlR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 08:41:17 -0400
Received: from mout.gmx.net ([212.227.15.18]:62742 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844Ab3FIMlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 08:41:05 -0400
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1+Hb3A9iqyH+wnDttA6qLNZMT3na7KSP8fONtv2Hj
	7edC55TmFZsES0
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 2/5] fanotify: Put duplicate code for adding vfsmount/inode marks into an own function
Date: Sun,  9 Jun 2013 14:40:43 +0200
Message-Id: <1370781646-10496-3-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370781646-10496-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1370781646-10496-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code under the groups mark_mutex in fanotify_add_inode_mark() and
fanotify_add_vfsmount_mark() is almost identical. So put it into a seperate
function.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/fanotify/fanotify_user.c |   71 ++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 36 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 213f0a1..6c307d7 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -601,33 +601,45 @@ static __u32 fanotify_mark_add_to_mask(struct fsnotify_mark *fsn_mark,
 	return mask & ~oldmask;
 }
 
+static struct fsnotify_mark *fanotify_add_new_mark(struct fsnotify_group *group,
+						   struct inode *inode,
+						   struct vfsmount *mnt)
+{
+	struct fsnotify_mark *mark;
+	int ret;
+
+	if (atomic_read(&group->num_marks) > group->fanotify_data.max_marks)
+		return ERR_PTR(-ENOSPC);
+
+	mark = kmem_cache_alloc(fanotify_mark_cache, GFP_KERNEL);
+	if (!mark)
+		return ERR_PTR(-ENOMEM);
+
+	fsnotify_init_mark(mark, fanotify_free_mark);
+	ret = fsnotify_add_mark_locked(mark, group, inode, mnt, 0);
+	if (ret) {
+		fsnotify_put_mark(mark);
+		return ERR_PTR(ret);
+	}
+
+	return mark;
+}
+
+
 static int fanotify_add_vfsmount_mark(struct fsnotify_group *group,
 				      struct vfsmount *mnt, __u32 mask,
 				      unsigned int flags)
 {
 	struct fsnotify_mark *fsn_mark;
 	__u32 added;
-	int ret = 0;
 
 	mutex_lock(&group->mark_mutex);
 	fsn_mark = fsnotify_find_vfsmount_mark(group, mnt);
 	if (!fsn_mark) {
-		if (atomic_read(&group->num_marks) > group->fanotify_data.max_marks) {
-			mutex_unlock(&group->mark_mutex);
-			return -ENOSPC;
-		}
-
-		fsn_mark = kmem_cache_alloc(fanotify_mark_cache, GFP_KERNEL);
-		if (!fsn_mark) {
-			mutex_unlock(&group->mark_mutex);
-			return -ENOMEM;
-		}
-
-		fsnotify_init_mark(fsn_mark, fanotify_free_mark);
-		ret = fsnotify_add_mark_locked(fsn_mark, group, NULL, mnt, 0);
-		if (ret) {
+		fsn_mark = fanotify_add_new_mark(group, NULL, mnt);
+		if (IS_ERR(fsn_mark)) {
 			mutex_unlock(&group->mark_mutex);
-			goto err;
+			return PTR_ERR(fsn_mark);
 		}
 	}
 	added = fanotify_mark_add_to_mask(fsn_mark, mask, flags);
@@ -635,9 +647,9 @@ static int fanotify_add_vfsmount_mark(struct fsnotify_group *group,
 
 	if (added & ~real_mount(mnt)->mnt_fsnotify_mask)
 		fsnotify_recalc_vfsmount_mask(mnt);
-err:
+
 	fsnotify_put_mark(fsn_mark);
-	return ret;
+	return 0;
 }
 
 static int fanotify_add_inode_mark(struct fsnotify_group *group,
@@ -646,7 +658,6 @@ static int fanotify_add_inode_mark(struct fsnotify_group *group,
 {
 	struct fsnotify_mark *fsn_mark;
 	__u32 added;
-	int ret = 0;
 
 	pr_debug("%s: group=%p inode=%p\n", __func__, group, inode);
 
@@ -663,22 +674,10 @@ static int fanotify_add_inode_mark(struct fsnotify_group *group,
 	mutex_lock(&group->mark_mutex);
 	fsn_mark = fsnotify_find_inode_mark(group, inode);
 	if (!fsn_mark) {
-		if (atomic_read(&group->num_marks) > group->fanotify_data.max_marks) {
+		fsn_mark = fanotify_add_new_mark(group, inode, NULL);
+		if (IS_ERR(fsn_mark)) {
 			mutex_unlock(&group->mark_mutex);
-			return -ENOSPC;
-		}
-
-		fsn_mark = kmem_cache_alloc(fanotify_mark_cache, GFP_KERNEL);
-		if (!fsn_mark) {
-			mutex_unlock(&group->mark_mutex);
-			return -ENOMEM;
-		}
-
-		fsnotify_init_mark(fsn_mark, fanotify_free_mark);
-		ret = fsnotify_add_mark_locked(fsn_mark, group, inode, NULL, 0);
-		if (ret) {
-			mutex_unlock(&group->mark_mutex);
-			goto err;
+			return PTR_ERR(fsn_mark);
 		}
 	}
 	added = fanotify_mark_add_to_mask(fsn_mark, mask, flags);
@@ -686,9 +685,9 @@ static int fanotify_add_inode_mark(struct fsnotify_group *group,
 
 	if (added & ~inode->i_fsnotify_mask)
 		fsnotify_recalc_inode_mask(inode);
-err:
+
 	fsnotify_put_mark(fsn_mark);
-	return ret;
+	return 0;
 }
 
 /* fanotify syscalls */
-- 
1.7.9.5

