Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbaDNVoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:44:25 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:55354 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661AbaDNVoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:44:14 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, john@johnmccutchan.com, rlove@rlove.org,
        eparis@parisplace.org, gregkh@linuxfoundation.org,
        serge.hallyn@ubuntu.com, lennart@poettering.net, kay@vrfy.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/3] kernfs: make kernfs_notify() trigger inotify events too
Date: Mon, 14 Apr 2014 17:44:05 -0400
Message-Id: <1397511846-2904-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1397511846-2904-1-git-send-email-tj@kernel.org>
References: <1397511846-2904-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernfs_notify() is used to indicate either new data is available or
the content of a file has changed.  It currently only triggers poll
which may not be the most convenient to monitor especially when there
are a lot to monitor.  Let's hook it up to fsnotify too so that the
events can be monitored via inotify too.

fsnotify_modify() requires file * but kernfs_notify() doesn't have any
specific file associated; however, we can walk all super_blocks
associated with a kernfs_root and as kernfs always associate one ino
with inode and one dentry with an inode, it's trivial to look up the
dentry associated with a given kernfs_node.  As any active monitor
would pin dentry, just looking up existing dentry is enough.  This
patch looks up the dentry associated with the specified kernfs_node
and generates events equivalent to fsnotify_modify().

Note that as fsnotify doesn't provide fsnotify_modify() equivalent
which can be called with dentry, kernfs_notify() directly calls
fsnotify_parent() and fsnotify().  It might be better to add a wrapper
in fsnotify.h instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>
---
 fs/kernfs/file.c | 41 +++++++++++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 6 deletions(-)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 8034706..98bacd9 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -14,6 +14,7 @@
 #include <linux/poll.h>
 #include <linux/pagemap.h>
 #include <linux/sched.h>
+#include <linux/fsnotify.h>
 
 #include "kernfs-internal.h"
 
@@ -785,20 +786,48 @@ static unsigned int kernfs_fop_poll(struct file *filp, poll_table *wait)
  */
 void kernfs_notify(struct kernfs_node *kn)
 {
+	struct kernfs_root *root = kernfs_root(kn);
 	struct kernfs_open_node *on;
+	struct kernfs_super_info *info;
 	unsigned long flags;
 
+	if (WARN_ON(kernfs_type(kn) != KERNFS_FILE))
+		return;
+
+	/* kick poll */
 	spin_lock_irqsave(&kernfs_open_node_lock, flags);
 
-	if (!WARN_ON(kernfs_type(kn) != KERNFS_FILE)) {
-		on = kn->attr.open;
-		if (on) {
-			atomic_inc(&on->event);
-			wake_up_interruptible(&on->poll);
-		}
+	on = kn->attr.open;
+	if (on) {
+		atomic_inc(&on->event);
+		wake_up_interruptible(&on->poll);
 	}
 
 	spin_unlock_irqrestore(&kernfs_open_node_lock, flags);
+
+	/* kick fsnotify */
+	mutex_lock(&kernfs_mutex);
+
+	list_for_each_entry(info, &root->supers, node) {
+		struct inode *inode;
+		struct dentry *dentry;
+
+		inode = ilookup(info->sb, kn->ino);
+		if (!inode)
+			continue;
+
+		dentry = d_find_any_alias(inode);
+		if (dentry) {
+			fsnotify_parent(NULL, dentry, FS_MODIFY);
+			fsnotify(inode, FS_MODIFY, inode, FSNOTIFY_EVENT_INODE,
+				 NULL, 0);
+			dput(dentry);
+		}
+
+		iput(inode);
+	}
+
+	mutex_unlock(&kernfs_mutex);
 }
 EXPORT_SYMBOL_GPL(kernfs_notify);
 
-- 
1.9.0

