Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3FIMls (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 08:41:48 -0400
Received: from mout.gmx.net ([212.227.15.18]:64127 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab3FIMlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 08:41:04 -0400
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX18J4wUh1e8Je0I1R8Bq4IX/v9yNsXjnoi89Sb2uhD
	NVc9Qh+RscWt0w
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 1/5] fanotify: Fix races when adding/removing marks
Date: Sun,  9 Jun 2013 14:40:42 +0200
Message-Id: <1370781646-10496-2-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370781646-10496-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1370781646-10496-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For both, adding an event to an existing mark and destroying a mark we first
have to find it via fsnotify_find_[inode|vfsmount]_mark(). But getting the mark
and adding an event (or destroying it) is not done atomically. This opens a
race where a thread is about to destroy a mark while another thread still finds
the same mark and adds an event to its mask although it will be destroyed.

Another race exists concerning the excess of a groups number of marks limit:
When a mark is added the number of group marks is checked against the max number
of marks per group and increased afterwards. Since check and increment is also
not done atomically, this may result in 2 or more processes passing the check
at the same time and increasing the number of group marks above the allowed limit.

With this patch both races are avoided by doing the concerning operations with
the groups mark mutex locked.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/fanotify/fanotify_user.c |   49 +++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 12 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 5d84442..213f0a1 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -525,14 +525,18 @@ static int fanotify_remove_vfsmount_mark(struct fsnotify_group *group,
 	__u32 removed;
 	int destroy_mark;
 
+	mutex_lock(&group->mark_mutex);
 	fsn_mark = fsnotify_find_vfsmount_mark(group, mnt);
-	if (!fsn_mark)
+	if (!fsn_mark) {
+		mutex_unlock(&group->mark_mutex);
 		return -ENOENT;
+	}
 
 	removed = fanotify_mark_remove_from_mask(fsn_mark, mask, flags,
 						 &destroy_mark);
 	if (destroy_mark)
-		fsnotify_destroy_mark(fsn_mark, group);
+		fsnotify_destroy_mark_locked(fsn_mark, group);
+	mutex_unlock(&group->mark_mutex);
 
 	fsnotify_put_mark(fsn_mark);
 	if (removed & real_mount(mnt)->mnt_fsnotify_mask)
@@ -549,14 +553,19 @@ static int fanotify_remove_inode_mark(struct fsnotify_group *group,
 	__u32 removed;
 	int destroy_mark;
 
+	mutex_lock(&group->mark_mutex);
 	fsn_mark = fsnotify_find_inode_mark(group, inode);
-	if (!fsn_mark)
+	if (!fsn_mark) {
+		mutex_unlock(&group->mark_mutex);
 		return -ENOENT;
+	}
 
 	removed = fanotify_mark_remove_from_mask(fsn_mark, mask, flags,
 						 &destroy_mark);
 	if (destroy_mark)
-		fsnotify_destroy_mark(fsn_mark, group);
+		fsnotify_destroy_mark_locked(fsn_mark, group);
+	mutex_unlock(&group->mark_mutex);
+
 	/* matches the fsnotify_find_inode_mark() */
 	fsnotify_put_mark(fsn_mark);
 	if (removed & inode->i_fsnotify_mask)
@@ -600,21 +609,29 @@ static int fanotify_add_vfsmount_mark(struct fsnotify_group *group,
 	__u32 added;
 	int ret = 0;
 
+	mutex_lock(&group->mark_mutex);
 	fsn_mark = fsnotify_find_vfsmount_mark(group, mnt);
 	if (!fsn_mark) {
-		if (atomic_read(&group->num_marks) > group->fanotify_data.max_marks)
+		if (atomic_read(&group->num_marks) > group->fanotify_data.max_marks) {
+			mutex_unlock(&group->mark_mutex);
 			return -ENOSPC;
+		}
 
 		fsn_mark = kmem_cache_alloc(fanotify_mark_cache, GFP_KERNEL);
-		if (!fsn_mark)
+		if (!fsn_mark) {
+			mutex_unlock(&group->mark_mutex);
 			return -ENOMEM;
+		}
 
 		fsnotify_init_mark(fsn_mark, fanotify_free_mark);
-		ret = fsnotify_add_mark(fsn_mark, group, NULL, mnt, 0);
-		if (ret)
+		ret = fsnotify_add_mark_locked(fsn_mark, group, NULL, mnt, 0);
+		if (ret) {
+			mutex_unlock(&group->mark_mutex);
 			goto err;
+		}
 	}
 	added = fanotify_mark_add_to_mask(fsn_mark, mask, flags);
+	mutex_unlock(&group->mark_mutex);
 
 	if (added & ~real_mount(mnt)->mnt_fsnotify_mask)
 		fsnotify_recalc_vfsmount_mask(mnt);
@@ -643,21 +660,29 @@ static int fanotify_add_inode_mark(struct fsnotify_group *group,
 	    (atomic_read(&inode->i_writecount) > 0))
 		return 0;
 
+	mutex_lock(&group->mark_mutex);
 	fsn_mark = fsnotify_find_inode_mark(group, inode);
 	if (!fsn_mark) {
-		if (atomic_read(&group->num_marks) > group->fanotify_data.max_marks)
+		if (atomic_read(&group->num_marks) > group->fanotify_data.max_marks) {
+			mutex_unlock(&group->mark_mutex);
 			return -ENOSPC;
+		}
 
 		fsn_mark = kmem_cache_alloc(fanotify_mark_cache, GFP_KERNEL);
-		if (!fsn_mark)
+		if (!fsn_mark) {
+			mutex_unlock(&group->mark_mutex);
 			return -ENOMEM;
+		}
 
 		fsnotify_init_mark(fsn_mark, fanotify_free_mark);
-		ret = fsnotify_add_mark(fsn_mark, group, inode, NULL, 0);
-		if (ret)
+		ret = fsnotify_add_mark_locked(fsn_mark, group, inode, NULL, 0);
+		if (ret) {
+			mutex_unlock(&group->mark_mutex);
 			goto err;
+		}
 	}
 	added = fanotify_mark_add_to_mask(fsn_mark, mask, flags);
+	mutex_unlock(&group->mark_mutex);
 
 	if (added & ~inode->i_fsnotify_mask)
 		fsnotify_recalc_inode_mask(inode);
-- 
1.7.9.5

