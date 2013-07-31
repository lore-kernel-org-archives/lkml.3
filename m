Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab3GaEQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 00:16:48 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:35001 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751127Ab3GaEQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 00:16:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgDAKOO+FF5LPxHgWdsb2JhbABbwz0XDgEBFiYogiQBAQUnLxYNEAgYMTkDGxmID7hqkBuDcwOUCJhJKg
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, davej@redhat.com,
        viro@zeniv.linux.org.uk, jack@suse.cz, glommer@parallels.com
Subject: [PATCH 04/11] sync: serialise per-superblock sync operations
Date: Wed, 31 Jul 2013 14:15:43 +1000
Message-Id: <1375244150-27296-5-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375244150-27296-1-git-send-email-david@fromorbit.com>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When competing sync(2) calls walk the same filesystem, they need to
walk the list of inodes on the superblock to find all the inodes
that we need to wait for IO completion on. However, when multiple
wait_sb_inodes() calls do this at the same time, they contend on the
the inode_sb_list_lock and the contention causes system wide
slowdowns. In effect, concurrent sync(2) calls can take longer and
burn more CPU than if they were serialised.

Stop the worst of the contention by adding a per-sb mutex to wrap
around wait_sb_inodes() so that we only execute one sync(2) IO
completion walk per superblock superblock at a time and hence avoid
contention being triggered by concurrent sync(2) calls.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/fs-writeback.c  | 11 +++++++++++
 fs/super.c         |  1 +
 include/linux/fs.h |  2 ++
 3 files changed, 14 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index ca66dc8..56272ec 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1207,6 +1207,15 @@ out_unlock_inode:
 }
 EXPORT_SYMBOL(__mark_inode_dirty);
 
+/*
+ * The @s_sync_lock is used to serialise concurrent sync operations
+ * to avoid lock contention problems with concurrent wait_sb_inodes() calls.
+ * Concurrent callers will block on the s_sync_lock rather than doing contending
+ * walks. The queueing maintains sync(2) required behaviour as all the IO that
+ * has been issued up to the time this function is enter is guaranteed to be
+ * completed by the time we have gained the lock and waited for all IO that is
+ * in progress regardless of the order callers are granted the lock.
+ */
 static void wait_sb_inodes(struct super_block *sb)
 {
 	struct inode *inode, *old_inode = NULL;
@@ -1217,6 +1226,7 @@ static void wait_sb_inodes(struct super_block *sb)
 	 */
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
+	mutex_lock(&sb->s_sync_lock);
 	spin_lock(&sb->s_inode_list_lock);
 
 	/*
@@ -1258,6 +1268,7 @@ static void wait_sb_inodes(struct super_block *sb)
 	}
 	spin_unlock(&sb->s_inode_list_lock);
 	iput(old_inode);
+	mutex_unlock(&sb->s_sync_lock);
 }
 
 /**
diff --git a/fs/super.c b/fs/super.c
index d4d753e..7f98fd6 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -200,6 +200,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 		s->s_bdi = &default_backing_dev_info;
 		INIT_HLIST_NODE(&s->s_instances);
 		INIT_HLIST_BL_HEAD(&s->s_anon);
+		mutex_init(&s->s_sync_lock);
 		INIT_LIST_HEAD(&s->s_inodes);
 		spin_lock_init(&s->s_inode_list_lock);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 923b465..971e8be 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1321,6 +1321,8 @@ struct super_block {
 	/* Being remounted read-only */
 	int s_readonly_remount;
 
+	struct mutex		s_sync_lock;	/* sync serialisation lock */
+
 	/*
 	 * Keep the lru lists last in the structure so they always sit on their
 	 * own individual cachelines.
-- 
1.8.3.2

