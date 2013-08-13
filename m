Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729Ab3HMGjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:39:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500Ab3HMGes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:34:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [ 13/17] debugfs: debugfs_remove_recursive() must not rely on list_empty(d_subdirs)
Date: Mon, 12 Aug 2013 23:35:59 -0700
Message-Id: <20130813063502.789393673@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063501.728847844@linuxfoundation.org>
References: <20130813063501.728847844@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 776164c1faac4966ab14418bb0922e1820da1d19 upstream.

debugfs_remove_recursive() is wrong,

1. it wrongly assumes that !list_empty(d_subdirs) means that this
   dir should be removed.

   This is not that bad by itself, but:

2. if d_subdirs does not becomes empty after __debugfs_remove()
   it gives up and silently fails, it doesn't even try to remove
   other entries.

   However ->d_subdirs can be non-empty because it still has the
   already deleted !debugfs_positive() entries.

3. simple_release_fs() is called even if __debugfs_remove() fails.

Suppose we have

	dir1/
		dir2/
			file2
		file1

and someone opens dir1/dir2/file2.

Now, debugfs_remove_recursive(dir1/dir2) succeeds, and dir1/dir2 goes
away.

But debugfs_remove_recursive(dir1) silently fails and doesn't remove
this directory. Because it tries to delete (the already deleted)
dir1/dir2/file2 again and then fails due to "Avoid infinite loop"
logic.

Test-case:

	#!/bin/sh

	cd /sys/kernel/debug/tracing
	echo 'p:probe/sigprocmask sigprocmask' >> kprobe_events
	sleep 1000 < events/probe/sigprocmask/id &
	echo -n >| kprobe_events

	[ -d events/probe ] && echo "ERR!! failed to rm probe"

And after that it is not possible to create another probe entry.

With this patch debugfs_remove_recursive() skips !debugfs_positive()
files although this is not strictly needed. The most important change
is that it does not try to make ->d_subdirs empty, it simply scans
the whole list(s) recursively and removes as much as possible.

Link: http://lkml.kernel.org/r/20130726151256.GC19472@redhat.com

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/debugfs/inode.c |   69 ++++++++++++++++-------------------------------------
 1 file changed, 22 insertions(+), 47 deletions(-)

--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -527,8 +527,7 @@ EXPORT_SYMBOL_GPL(debugfs_remove);
  */
 void debugfs_remove_recursive(struct dentry *dentry)
 {
-	struct dentry *child;
-	struct dentry *parent;
+	struct dentry *child, *next, *parent;
 
 	if (!dentry)
 		return;
@@ -538,61 +537,37 @@ void debugfs_remove_recursive(struct den
 		return;
 
 	parent = dentry;
+ down:
 	mutex_lock(&parent->d_inode->i_mutex);
+	list_for_each_entry_safe(child, next, &parent->d_subdirs, d_u.d_child) {
+		if (!debugfs_positive(child))
+			continue;
 
-	while (1) {
-		/*
-		 * When all dentries under "parent" has been removed,
-		 * walk up the tree until we reach our starting point.
-		 */
-		if (list_empty(&parent->d_subdirs)) {
-			mutex_unlock(&parent->d_inode->i_mutex);
-			if (parent == dentry)
-				break;
-			parent = parent->d_parent;
-			mutex_lock(&parent->d_inode->i_mutex);
-		}
-		child = list_entry(parent->d_subdirs.next, struct dentry,
-				d_u.d_child);
- next_sibling:
-
-		/*
-		 * If "child" isn't empty, walk down the tree and
-		 * remove all its descendants first.
-		 */
+		/* perhaps simple_empty(child) makes more sense */
 		if (!list_empty(&child->d_subdirs)) {
 			mutex_unlock(&parent->d_inode->i_mutex);
 			parent = child;
-			mutex_lock(&parent->d_inode->i_mutex);
-			continue;
+			goto down;
 		}
-		__debugfs_remove(child, parent);
-		if (parent->d_subdirs.next == &child->d_u.d_child) {
-			/*
-			 * Try the next sibling.
-			 */
-			if (child->d_u.d_child.next != &parent->d_subdirs) {
-				child = list_entry(child->d_u.d_child.next,
-						   struct dentry,
-						   d_u.d_child);
-				goto next_sibling;
-			}
-
-			/*
-			 * Avoid infinite loop if we fail to remove
-			 * one dentry.
-			 */
-			mutex_unlock(&parent->d_inode->i_mutex);
-			break;
-		}
-		simple_release_fs(&debugfs_mount, &debugfs_mount_count);
+ up:
+		if (!__debugfs_remove(child, parent))
+			simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 	}
 
-	parent = dentry->d_parent;
+	mutex_unlock(&parent->d_inode->i_mutex);
+	child = parent;
+	parent = parent->d_parent;
 	mutex_lock(&parent->d_inode->i_mutex);
-	__debugfs_remove(dentry, parent);
+
+	if (child != dentry) {
+		next = list_entry(child->d_u.d_child.next, struct dentry,
+					d_u.d_child);
+		goto up;
+	}
+
+	if (!__debugfs_remove(child, parent))
+		simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 	mutex_unlock(&parent->d_inode->i_mutex);
-	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 }
 EXPORT_SYMBOL_GPL(debugfs_remove_recursive);
 


