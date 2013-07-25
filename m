Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab3GYTes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 15:34:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756292Ab3GYTep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 15:34:45 -0400
Date: Thu, 25 Jul 2013 21:27:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: PATCH? debugfs_remove_recursive() must not rely on
	list_empty(d_subdirs)
Message-ID: <20130725192742.GA14060@redhat.com>
References: <20130723205854.GA9036@redhat.com> <20130724184640.GA21322@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130724184640.GA21322@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

debugfs_remove_recursive() looks wrong to me. The patch below is
probably wrong too and it was only slightly tested, but could you
please confirm my understanding?

First of all, the usage of simple_release_fs() doesn't look correct
but please ignore, the patch doesn't try to fix this.

The problem is, debugfs_remove_recursive() wrongly (I think) assumes
that a) !list_empty(d_subdirs) means that this dir should be removed,
and b) if d_subdirs does not becomes empty after __debugfs_remove()
debugfs_remove_recursive() gives up and doesn't even try to remove
other entries.

I think this is wrong, and at least we need the additional
debugfs_positive() check before list_empty() or just simple_empty()
instead.

Test-case. Suppose we have

	dir1/
		dir2/
			file2
		file1

somewhere in debugfs.

Suppose that someone opens dir1/dir2/file2 and keeps it opened.

Now. debugfs_remove_recursive(dir1/dir2) succeeds, and dir1/di2 goes
away.

But debugfs_remove_recursive(dir1) silently fails and doesn't remove
this directory. Because it tries to delete (the already deleted)
dir1/dir2/file2 again and then fails due to "Avoid infinite loop"
logic.

The patch seems to fix the problem. Note also that the new code
tries to remove as much as possible, iow it does not give up if
__debugfs_remove() fails for any reason. However I am not sure
we want this, perhaps it should simply abort and return the err.

To simplify the review, this is how it looks with the patch applied:

	void debugfs_remove_recursive(struct dentry *dentry)
	{
		struct dentry *child, *next, *parent;

		if (IS_ERR_OR_NULL(dentry))
			return;

		parent = dentry->d_parent;
		if (!parent || !parent->d_inode)
			return;

		parent = dentry;
	 down:
		mutex_lock(&parent->d_inode->i_mutex);
		child = list_first_entry(&parent->d_subdirs, struct dentry, d_u.d_child);

		while (&child->d_u.d_child != &parent->d_subdirs) {
			next = list_next_entry(child, d_u.d_child);

			if (!debugfs_positive(child))
				goto next;

			/* XXX: simple_empty(child) instead ? */
			if (!list_empty(&child->d_subdirs)) {
				mutex_unlock(&parent->d_inode->i_mutex);
				parent = child;
				goto down;
			}
	 up:
			__debugfs_remove(child, parent);
	 next:
			child = next;
		}

		mutex_unlock(&parent->d_inode->i_mutex);
		if (parent != dentry) {
			child = parent;
			next = list_next_entry(child, d_u.d_child);
			parent = parent->d_parent;
			mutex_lock(&parent->d_inode->i_mutex);
			goto up;
		}

		parent = dentry->d_parent;
		mutex_lock(&parent->d_inode->i_mutex);
		__debugfs_remove(dentry, parent);
		mutex_unlock(&parent->d_inode->i_mutex);
		simple_release_fs(&debugfs_mount, &debugfs_mount_count);
	}

Oleg.
---
 debugfs/inode.c |   69 +++++++++++++++++++++-----------------------------------
 1 file changed, 26 insertions(+), 43 deletions(-)

--- x/fs/debugfs/inode.c	2013-07-25 19:08:08.000000000 +0200
+++ x/fs/debugfs/inode.c	2013-07-25 21:18:26.000000000 +0200
@@ -532,6 +532,9 @@ void debugfs_remove(struct dentry *dentr
 }
 EXPORT_SYMBOL_GPL(debugfs_remove);
 
+#define list_next_entry(pos, member) \
+	list_entry(pos->member.next, typeof(*pos), member)
+
 /**
  * debugfs_remove_recursive - recursively removes a directory
  * @dentry: a pointer to a the dentry of the directory to be removed.
@@ -546,8 +549,7 @@ EXPORT_SYMBOL_GPL(debugfs_remove);
  */
 void debugfs_remove_recursive(struct dentry *dentry)
 {
-	struct dentry *child;
-	struct dentry *parent;
+	struct dentry *child, *next, *parent;
 
 	if (IS_ERR_OR_NULL(dentry))
 		return;
@@ -557,54 +559,35 @@ void debugfs_remove_recursive(struct den
 		return;
 
 	parent = dentry;
+ down:
 	mutex_lock(&parent->d_inode->i_mutex);
+	child = list_first_entry(&parent->d_subdirs, struct dentry, d_u.d_child);
 
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
+	while (&child->d_u.d_child != &parent->d_subdirs) {
+		next = list_next_entry(child, d_u.d_child);
+
+		if (!debugfs_positive(child))
+			goto next;
+
+		/* XXX: simple_empty(child) instead ? */
 		if (!list_empty(&child->d_subdirs)) {
 			mutex_unlock(&parent->d_inode->i_mutex);
 			parent = child;
-			mutex_lock(&parent->d_inode->i_mutex);
-			continue;
+			goto down;
 		}
+ up:
 		__debugfs_remove(child, parent);
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
+ next:
+ 		child = next;
+	}
+
+	mutex_unlock(&parent->d_inode->i_mutex);
+	if (parent != dentry) {
+		child = parent;
+		next = list_next_entry(child, d_u.d_child);
+		parent = parent->d_parent;
+		mutex_lock(&parent->d_inode->i_mutex);
+		goto up;
 	}
 
 	parent = dentry->d_parent;

