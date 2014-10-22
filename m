Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901AbaJVUOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:14:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932838AbaJVUOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:14:20 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: hch@lst.de, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 1/4] blockdev: Don't use i_devices inode field
Date: Wed, 22 Oct 2014 22:14:10 +0200
Message-Id: <1414008853-13200-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1414008853-13200-1-git-send-email-jack@suse.cz>
References: <1414008853-13200-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Block devices use i_devices inode field to track all inodes that
reference a particular block device (through i_bdev field) so that this
reference can be removed when block device inode is being evicted from
memory. However we get a reference to the block device (in fact an inode
holding the block device structure) when setting up i_bdev in
bd_acquire() and we drop the reference only in bd_forget() when clearing
i_bdev. Thus inode holding block device structure can be evicted only
after all inodes referencing it are evicted and the whole excercise with
i_devices is pointless. Remove the i_devices handling.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/block_dev.c     | 17 +++--------------
 include/linux/fs.h |  1 -
 2 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index cc9d4114cda0..493cd69df9a6 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -458,7 +458,6 @@ static void init_once(void *foo)
 
 	memset(bdev, 0, sizeof(*bdev));
 	mutex_init(&bdev->bd_mutex);
-	INIT_LIST_HEAD(&bdev->bd_inodes);
 	INIT_LIST_HEAD(&bdev->bd_list);
 #ifdef CONFIG_SYSFS
 	INIT_LIST_HEAD(&bdev->bd_holder_disks);
@@ -468,24 +467,14 @@ static void init_once(void *foo)
 	mutex_init(&bdev->bd_fsfreeze_mutex);
 }
 
-static inline void __bd_forget(struct inode *inode)
-{
-	list_del_init(&inode->i_devices);
-	inode->i_bdev = NULL;
-	inode->i_mapping = &inode->i_data;
-}
-
 static void bdev_evict_inode(struct inode *inode)
 {
 	struct block_device *bdev = &BDEV_I(inode)->bdev;
-	struct list_head *p;
+
 	truncate_inode_pages_final(&inode->i_data);
 	invalidate_inode_buffers(inode); /* is it needed here? */
 	clear_inode(inode);
 	spin_lock(&bdev_lock);
-	while ( (p = bdev->bd_inodes.next) != &bdev->bd_inodes ) {
-		__bd_forget(list_entry(p, struct inode, i_devices));
-	}
 	list_del_init(&bdev->bd_list);
 	spin_unlock(&bdev_lock);
 }
@@ -645,7 +634,6 @@ static struct block_device *bd_acquire(struct inode *inode)
 			ihold(bdev->bd_inode);
 			inode->i_bdev = bdev;
 			inode->i_mapping = bdev->bd_inode->i_mapping;
-			list_add(&inode->i_devices, &bdev->bd_inodes);
 		}
 		spin_unlock(&bdev_lock);
 	}
@@ -666,7 +654,8 @@ void bd_forget(struct inode *inode)
 	spin_lock(&bdev_lock);
 	if (!sb_is_blkdev_sb(inode->i_sb))
 		bdev = inode->i_bdev;
-	__bd_forget(inode);
+	inode->i_bdev = NULL;
+	inode->i_mapping = &inode->i_data;
 	spin_unlock(&bdev_lock);
 
 	if (bdev)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a957d4366c24..d7fd7959a933 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -413,7 +413,6 @@ struct block_device {
 	struct inode *		bd_inode;	/* will die */
 	struct super_block *	bd_super;
 	struct mutex		bd_mutex;	/* open/close mutex */
-	struct list_head	bd_inodes;
 	void *			bd_claiming;
 	void *			bd_holder;
 	int			bd_holders;
-- 
1.8.1.4

