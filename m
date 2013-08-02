Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab3HBOcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:32:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49588 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3HBOch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:32:37 -0400
Date: Fri, 2 Aug 2013 07:32:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davej@redhat.com, viro@zeniv.linux.org.uk, jack@suse.cz,
        glommer@parallels.com
Subject: Re: [PATCH 02/11] inode: add IOP_NOTHASHED to avoid inode hash lock
 in evict
Message-ID: <20130802143234.GB30827@infradead.org>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
 <1375244150-27296-3-git-send-email-david@fromorbit.com>
 <20130801081235.GA7261@infradead.org>
 <20130802011133.GT7118@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130802011133.GT7118@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 11:11:33AM +1000, Dave Chinner wrote:
> But that doesn't fix the problem of taking the hash lock in evict()
> when it is not necessary. If everything sets I_NEEDS_WRITEBACK, and
> we still fake hashing the inode, how are do we know that we don't
> need to unhash it in evict()?

The idea is to keep evict as-is but make the flag that an inode needs
writeback entirely separate from the is hashed check.

I've attached a draft patch implementing my idea belo.  It does survive
booting and data copies to ext4 or xfs filesystems is persistent with
it, so it works for some defintion of working.

Bedxies splitting and proper documentation we probably also want to get
rid of the inode_unhashed check in generic_drop_inode and replace it
with an is_bad_inode, just special casing unhashed inodes in coda to
keep the behaviour for it the same.


diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 68851ff..e36cad9 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1147,22 +1147,12 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		inode->i_state |= flags;
 
 		/*
-		 * If the inode is being synced, just update its dirty state.
-		 * The unlocker will place the inode on the appropriate
-		 * superblock list, based upon its state.
+		 * If an inode isn't fully constructed yet or being torn
+		 * down let it on the list it is on currently.  For inodes
+		 * undergoing sync we will move it to the right list once
+		 * syncing it has been finished.
 		 */
-		if (inode->i_state & I_SYNC)
-			goto out_unlock_inode;
-
-		/*
-		 * Only add valid (hashed) inodes to the superblock's
-		 * dirty list.  Add blockdev inodes as well.
-		 */
-		if (!S_ISBLK(inode->i_mode)) {
-			if (inode_unhashed(inode))
-				goto out_unlock_inode;
-		}
-		if (inode->i_state & I_FREEING)
+		if (inode->i_state & (I_NEW | I_SYNC | I_FREEING))
 			goto out_unlock_inode;
 
 		/*
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 96dda62..4bd3be0 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1168,8 +1168,6 @@ xfs_setup_inode(
 	inode->i_state = I_NEW;
 
 	inode_sb_list_add(inode);
-	/* make the inode look hashed for the writeback code */
-	hlist_add_fake(&inode->i_hash);
 
 	inode->i_mode	= ip->i_d.di_mode;
 	set_nlink(inode, ip->i_d.di_nlink);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 19922eb..c5fdf48 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1026,9 +1026,7 @@ STATIC int
 xfs_fs_drop_inode(
 	struct inode		*inode)
 {
-	struct xfs_inode	*ip = XFS_I(inode);
-
-	return generic_drop_inode(inode) || (ip->i_flags & XFS_IDONTCACHE);
+	return !inode->i_nlink || (XFS_I(inode)->i_flags & XFS_IDONTCACHE);
 }
 
 STATIC void
