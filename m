Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965380Ab3GCUVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:21:37 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:24441 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964853Ab3GCUVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:21:33 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Joel Becker <jlbec@evilplan.org>, Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v3 12/25] config-fs: Change how dentry's d_lock and d_count fields are accessed
Date: Wed,  3 Jul 2013 16:21:20 -0400
Message-Id: <1372882880-22911-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of the changes made in dcache.h header file, files that use
the d_lock and d_count fields of the dentry structure need to be
changed accordingly.  All the d_lock's spin_lock() and spin_unlock()
calls are replaced by the corresponding d_lock() and d_unlock() calls.
References to d_count are replaced by the d_ret_count() calls.
There is no change in logic and everything should just work.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/configfs/configfs_internal.h |    4 ++--
 fs/configfs/dir.c               |    2 +-
 fs/configfs/inode.c             |    6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/configfs/configfs_internal.h b/fs/configfs/configfs_internal.h
index b5f0a3b..35c03d5 100644
--- a/fs/configfs/configfs_internal.h
+++ b/fs/configfs/configfs_internal.h
@@ -120,7 +120,7 @@ static inline struct config_item *configfs_get_config_item(struct dentry *dentry
 {
 	struct config_item * item = NULL;
 
-	spin_lock(&dentry->d_lock);
+	d_lock(dentry);
 	if (!d_unhashed(dentry)) {
 		struct configfs_dirent * sd = dentry->d_fsdata;
 		if (sd->s_type & CONFIGFS_ITEM_LINK) {
@@ -129,7 +129,7 @@ static inline struct config_item *configfs_get_config_item(struct dentry *dentry
 		} else
 			item = config_item_get(sd->s_element);
 	}
-	spin_unlock(&dentry->d_lock);
+	d_unlock(dentry);
 
 	return item;
 }
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 7aabc6a..9089d78 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -387,7 +387,7 @@ static void remove_dir(struct dentry * d)
 	if (d->d_inode)
 		simple_rmdir(parent->d_inode,d);
 
-	pr_debug(" o %s removing done (%d)\n",d->d_name.name, d->d_count);
+	pr_debug(" o %s removing done (%d)\n", d->d_name.name, d_ret_count(d));
 
 	dput(parent);
 }
diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index a9d35b0..83838f7 100644
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -249,14 +249,14 @@ void configfs_drop_dentry(struct configfs_dirent * sd, struct dentry * parent)
 	struct dentry * dentry = sd->s_dentry;
 
 	if (dentry) {
-		spin_lock(&dentry->d_lock);
+		d_lock(dentry);
 		if (!(d_unhashed(dentry) && dentry->d_inode)) {
 			dget_dlock(dentry);
 			__d_drop(dentry);
-			spin_unlock(&dentry->d_lock);
+			d_unlock(dentry);
 			simple_unlink(parent->d_inode, dentry);
 		} else
-			spin_unlock(&dentry->d_lock);
+			d_unlock(dentry);
 	}
 }
 
-- 
1.7.1

