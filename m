Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbaJCKhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 06:37:06 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:39336 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbaJCKhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 06:37:04 -0400
From: Andrey Vagin <avagin@openvz.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.debian@gmx.de>,
        Jan Kara <jack@suse.cz>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: [PATCH] fs: don't remove inotify watchers from alive inode-s (v3)
Date: Fri,  3 Oct 2014 14:35:23 +0400
Message-Id: <1412332523-25212-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently watchers are removed in dentry_iput(), if n_link is zero.  But
other detries can be linked with this inode.

For example if we create two hard links, open the first one and set an
inotify watcher on one of them.  Then if we remove the opened file and
then another file, the inotify watcher will be removed. But we will have
the alive file descriptor, which allows us to generate more events.

And here is another behaviour, if files are removed in another order.
The watcher will not be removed and we will keep getting inotify events
for that inode.

This patch removes difference of behaviours for these cases. Watchers
are removed, only if nlink is zero and i_dentry list is empty. The
resulting behaviour is the same with what has been described in the
second case.

Look at a following example:

	fd = inotify_init1(IN_NONBLOCK);
	deleted = open(path, O_CREAT | O_TRUNC | O_WRONLY, 0666);
	link(path, path_link);

	wd_deleted = inotify_add_watch(fd, path_link, IN_ALL_EVENTS);

	unlink(path);
	unlink(path_link);

	printf(" --- unlink path, path_link\n");
	read_evetns(fd);

	close(deleted);
	printf(" --- close\n");
	read_evetns(fd);
	printf(" --- end\n");

We expect to get the same set of events for this case and for the
case, when files are deleted in another order. But now we get the
different set of events.

The first case, when "path" is deleted before "path_link"
 --- unlink path, path_link
4	(IN_ATTRIB)
400	(IN_DELETE_SELF)
8000	(IN_IGNORED)
 --- close
 --- end

and for the case, when "path_link" is deleted before "path"
 --- unlink path_link, path
4	(IN_ATTRIB)
 --- close
8	(IN_CLOSE_WRITE)
400	(IN_DELETE_SELF)
8000	(IN_IGNORED)
 --- end

With this patch we have the same output for both cases:
 --- unlink
4	(IN_ATTRIB)
 --- close
8	(IN_CLOSE_WRITE)
400	(IN_DELETE_SELF)
8000	(IN_IGNORED)
 --- end
PASS

So without the patch you don't receive some events if the file has at
least 2 hardlinks and then gets unlinked. I think the risk that some
application relies on *not* getting those events is pretty low
(especially since in the common case of file without hardlinks you will
get all those events). // Jan Kara

In CRIU we are suffering from the current situation. We found this weird
behaviour while been testing the results of restore of deleted files.
When criu observes opened descriptor on deleted file its contents get
written into criu image file which we call "ghost" files.  On restore we
create a temporary ghost file with some unique name. Then we restore
file descriptors which were opened at the moment of checkpoint: we
create a hardlink to this ghost file, then open it and this is done for
every descriptor we need to recover. Then if there were a watch mark on
the ghost file we restore them as well but at the end we need to do a
cleanup and finally remove the ghost file itself which cause the
problem. When we remove ghost file inode->n_link becomes 0 thus our
restored inotify are dropped off by the kernel while here still opened
files are floating around. I can't say that it's catastrophical but if
there a chance to fix it on kernel level making events flow more sane,
this would be just great, also our primary target is to make c/r process
transparent to the userspace and without the patch i fear we can't reach
it. // Cyrill Gorcunov and me.

v2: generate IN_DELETE_SELF when the last link to the file is removed
v3: expand the changelog

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Heinrich Schuchardt <xypron.debian@gmx.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 fs/dcache.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 7a5b514..3a0e3bc 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -278,12 +278,15 @@ static void dentry_iput(struct dentry * dentry)
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
-		if (!inode->i_nlink)
+		if (!inode->i_nlink && last_dentry)
 			fsnotify_inoderemove(inode);
 		if (dentry->d_op && dentry->d_op->d_iput)
 			dentry->d_op->d_iput(dentry, inode);
@@ -303,13 +306,16 @@ static void dentry_unlink_inode(struct dentry * dentry)
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
-	if (!inode->i_nlink)
+	if (!inode->i_nlink && last_dentry)
 		fsnotify_inoderemove(inode);
 	if (dentry->d_op && dentry->d_op->d_iput)
 		dentry->d_op->d_iput(dentry, inode);
-- 
1.9.3

