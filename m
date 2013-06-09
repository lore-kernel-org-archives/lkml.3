Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3FIMlm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 08:41:42 -0400
Received: from mout.gmx.net ([212.227.17.22]:50217 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296Ab3FIMlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 08:41:06 -0400
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX18F+NpZP2kFfH18xz89rPwU5J34pP3syWNlrmX7AE
	goDKpQdqt5jvIi
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 3/5] dnotify: replace dnotify_mark_mutex with mark mutex of dnotify_group
Date: Sun,  9 Jun 2013 14:40:44 +0200
Message-Id: <1370781646-10496-4-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370781646-10496-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1370781646-10496-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to use a special mutex to protect against the fcntl/close race
(see dnotify.c for a description of this race). Instead the dnotify_groups mark
mutex can be used.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/dnotify/dnotify.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index 2bfe6dc..1fedd5f 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -31,7 +31,6 @@ int dir_notify_enable __read_mostly = 1;
 static struct kmem_cache *dnotify_struct_cache __read_mostly;
 static struct kmem_cache *dnotify_mark_cache __read_mostly;
 static struct fsnotify_group *dnotify_group __read_mostly;
-static DEFINE_MUTEX(dnotify_mark_mutex);
 
 /*
  * dnotify will attach one of these to each inode (i_fsnotify_marks) which
@@ -183,7 +182,7 @@ void dnotify_flush(struct file *filp, fl_owner_t id)
 		return;
 	dn_mark = container_of(fsn_mark, struct dnotify_mark, fsn_mark);
 
-	mutex_lock(&dnotify_mark_mutex);
+	mutex_lock(&dnotify_group->mark_mutex);
 
 	spin_lock(&fsn_mark->lock);
 	prev = &dn_mark->dn;
@@ -199,11 +198,12 @@ void dnotify_flush(struct file *filp, fl_owner_t id)
 
 	spin_unlock(&fsn_mark->lock);
 
-	/* nothing else could have found us thanks to the dnotify_mark_mutex */
+	/* nothing else could have found us thanks to the dnotify_groups
+	   mark_mutex */
 	if (dn_mark->dn == NULL)
-		fsnotify_destroy_mark(fsn_mark, dnotify_group);
+		fsnotify_destroy_mark_locked(fsn_mark, dnotify_group);
 
-	mutex_unlock(&dnotify_mark_mutex);
+	mutex_unlock(&dnotify_group->mark_mutex);
 
 	fsnotify_put_mark(fsn_mark);
 }
@@ -326,7 +326,7 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 	new_dn_mark->dn = NULL;
 
 	/* this is needed to prevent the fcntl/close race described below */
-	mutex_lock(&dnotify_mark_mutex);
+	mutex_lock(&dnotify_group->mark_mutex);
 
 	/* add the new_fsn_mark or find an old one. */
 	fsn_mark = fsnotify_find_inode_mark(dnotify_group, inode);
@@ -334,7 +334,8 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 		dn_mark = container_of(fsn_mark, struct dnotify_mark, fsn_mark);
 		spin_lock(&fsn_mark->lock);
 	} else {
-		fsnotify_add_mark(new_fsn_mark, dnotify_group, inode, NULL, 0);
+		fsnotify_add_mark_locked(new_fsn_mark, dnotify_group, inode,
+					 NULL, 0);
 		spin_lock(&new_fsn_mark->lock);
 		fsn_mark = new_fsn_mark;
 		dn_mark = new_dn_mark;
@@ -348,9 +349,9 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 
 	/* if (f != filp) means that we lost a race and another task/thread
 	 * actually closed the fd we are still playing with before we grabbed
-	 * the dnotify_mark_mutex and fsn_mark->lock.  Since closing the fd is the
-	 * only time we clean up the marks we need to get our mark off
-	 * the list. */
+	 * the dnotify_groups mark_mutex and fsn_mark->lock.  Since closing the
+	 * fd is the only time we clean up the marks we need to get our mark
+	 * off the list. */
 	if (f != filp) {
 		/* if we added ourselves, shoot ourselves, it's possible that
 		 * the flush actually did shoot this fsn_mark.  That's fine too
@@ -385,9 +386,9 @@ out:
 	spin_unlock(&fsn_mark->lock);
 
 	if (destroy)
-		fsnotify_destroy_mark(fsn_mark, dnotify_group);
+		fsnotify_destroy_mark_locked(fsn_mark, dnotify_group);
 
-	mutex_unlock(&dnotify_mark_mutex);
+	mutex_unlock(&dnotify_group->mark_mutex);
 	fsnotify_put_mark(fsn_mark);
 out_err:
 	if (new_fsn_mark)
-- 
1.7.9.5

