Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbaIHMDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:03:17 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:43861 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237AbaIHMDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:03:16 -0400
From: Andrey Vagin <avagin@openvz.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: [PATCH] fs: don't remove inotify watchers from alive inode-s
Date: Mon,  8 Sep 2014 16:01:56 +0400
Message-Id: <1410177716-3965-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently watchers are removed in dentry_iput(), if n_link is zero.
But other detries can be linked with this inode. For example if we
create two hard links, open the first one and set a watcher on the
second one. Then if we remove both links, the watcher will be removed.
But we will have the alive file descriptor, which allows us to generate
more events.

With this patch, watchers will be removed, only if nlink is zero and
i_dentry list is empty.

Look at a following example:

	fd = inotify_init1(IN_NONBLOCK);
	deleted = open(path, O_CREAT | O_TRUNC | O_WRONLY, 0666);
	link(path, path_link);

	wd_deleted = inotify_add_watch(fd, path_link, IN_ALL_EVENTS);

	unlink(path);
	unlink(path_link);

	printf(" --- unlink\n");
	read_evetns(fd);

	close(deleted);
	printf(" --- close\n");
	read_evetns(fd);

Without this patch:
 --- unlink
4	(IN_ATTRIB)
400	(IN_DELETE_SELF)
8000	(IN_IGNORED)
 --- close
FAIL

With this patch:
 --- unlink
4	(IN_ATTRIB)
400	(IN_DELETE_SELF)
 --- close
8	(IN_CLOSE_WRITE)
400	(IN_DELETE_SELF)
8000	(IN_IGNORED)
PASS

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 fs/dcache.c              | 10 ++++++++--
 include/linux/fsnotify.h |  5 +++--
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index d30ce69..fb1ee58 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -279,13 +279,16 @@ static void dentry_iput(struct dentry * dentry)
 	__releases(dentry->d_inode->i_lock)
 {
 	struct inode *inode = dentry->d_inode;
+	bool last_dentry;
+
 	if (inode) {
 		dentry->d_inode = NULL;
 		hlist_del_init(&dentry->d_alias);
+		last_dentry = hlist_empty(&inode->i_dentry);
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&inode->i_lock);
 		if (!inode->i_nlink)
-			fsnotify_inoderemove(inode);
+			fsnotify_inoderemove(inode, last_dentry);
 		if (dentry->d_op && dentry->d_op->d_iput)
 			dentry->d_op->d_iput(dentry, inode);
 		else
@@ -304,14 +307,17 @@ static void dentry_unlink_inode(struct dentry * dentry)
 	__releases(dentry->d_inode->i_lock)
 {
 	struct inode *inode = dentry->d_inode;
+	bool last_dentry;
+
 	__d_clear_type(dentry);
 	dentry->d_inode = NULL;
 	hlist_del_init(&dentry->d_alias);
 	dentry_rcuwalk_barrier(dentry);
+	last_dentry = hlist_empty(&inode->i_dentry);
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&inode->i_lock);
 	if (!inode->i_nlink)
-		fsnotify_inoderemove(inode);
+		fsnotify_inoderemove(inode, last_dentry);
 	if (dentry->d_op && dentry->d_op->d_iput)
 		dentry->d_op->d_iput(dentry, inode);
 	else
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 1c804b0..63dae9d 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -144,10 +144,11 @@ static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
 /*
  * fsnotify_inoderemove - an inode is going away
  */
-static inline void fsnotify_inoderemove(struct inode *inode)
+static inline void fsnotify_inoderemove(struct inode *inode, bool delete)
 {
 	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
-	__fsnotify_inode_delete(inode);
+	if (delete)
+		__fsnotify_inode_delete(inode);
 }
 
 /*
-- 
1.9.3

