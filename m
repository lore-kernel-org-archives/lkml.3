Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938Ab3GaERH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 00:17:07 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:35001 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750819Ab3GaEQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 00:16:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgDAKOO+FF5LPxHgWdsb2JhbABbwiaBFxcOAQEWJiiCJAEBBScvIxAIGDE5AxsZiA+4ao40gT8og3MDogCKUSqBLA
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, davej@redhat.com,
        viro@zeniv.linux.org.uk, jack@suse.cz, glommer@parallels.com
Subject: [PATCH 02/11] inode: add IOP_NOTHASHED to avoid inode hash lock in evict
Date: Wed, 31 Jul 2013 14:15:41 +1000
Message-Id: <1375244150-27296-3-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375244150-27296-1-git-send-email-david@fromorbit.com>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Some filesystems don't use the VFS inode hash and fake the fact they
are hashed so that all the writeback code works correctly. However,
this means the evict() path still tries to remove the inode from the
hash, meaning that the inode_hash_lock() needs to be taken
unnecessarily. Hence under certain workloads the inode_hash_lock can
be contended even if the inode is never actually hashed.

To avoid this, add an inode opflag to allow inode_hash_remove() to
avoid taking the hash lock on inodes have never actually been
hashed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iops.c  | 2 ++
 include/linux/fs.h | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 96dda62..68a8264 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1168,8 +1168,10 @@ xfs_setup_inode(
 	inode->i_state = I_NEW;
 
 	inode_sb_list_add(inode);
+
 	/* make the inode look hashed for the writeback code */
 	hlist_add_fake(&inode->i_hash);
+	inode->i_opflags |= IOP_NOTHASHED;
 
 	inode->i_mode	= ip->i_d.di_mode;
 	set_nlink(inode, ip->i_d.di_nlink);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b09ddc0..51cf6ed 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -515,6 +515,7 @@ struct posix_acl;
 #define IOP_FASTPERM	0x0001
 #define IOP_LOOKUP	0x0002
 #define IOP_NOFOLLOW	0x0004
+#define IOP_NOTHASHED	0x0008	/* inode never hashed, avoid unhashing */
 
 /*
  * Keep mostly read-only and often accessed (especially for
@@ -2371,7 +2372,7 @@ static inline void insert_inode_hash(struct inode *inode)
 extern void __remove_inode_hash(struct inode *);
 static inline void remove_inode_hash(struct inode *inode)
 {
-	if (!inode_unhashed(inode))
+	if (!((inode->i_opflags & IOP_NOTHASHED) || inode_unhashed(inode)))
 		__remove_inode_hash(inode);
 }
 
-- 
1.8.3.2

