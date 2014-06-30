Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbaF3MI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:08:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52031 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753672AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Ben Myers <bpm@sgi.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 040/181] xfs: prevent stack overflows from page cache allocation
Date: Mon, 30 Jun 2014 13:51:01 +0200
Message-Id: <b8876e2d4890836c35847fa31c1c5fa4d591b5c4.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ad22c7a043c2cc6792820e6c5da699935933e87d upstream.

Page cache allocation doesn't always go through ->begin_write and
hence we don't always get the opportunity to set the allocation
context to GFP_NOFS. Failing to do this means we open up the direct
relcaim stack to recurse into the filesystem and consume a
significant amount of stack.

On RHEL6.4 kernels we are seeing ra_submit() and
generic_file_splice_read() from an nfsd context recursing into the
filesystem via the inode cache shrinker and evicting inodes. This is
causing truncation to be run (e.g EOF block freeing) and causing
bmap btree block merges and free space btree block splits to occur.
These btree manipulations are occurring with the call chain already
30 functions deep and hence there is not enough stack space to
complete such operations.

To avoid these specific overruns, we need to prevent the page cache
allocation from recursing via direct reclaim. We can do that because
the allocation functions take the allocation context from that which
is stored in the mapping for the inode. We don't set that right now,
so the default is GFP_HIGHUSER_MOVABLE, which is effectively a
GFP_KERNEL context. We need it to be the equivalent of GFP_NOFS, so
when we initialise an inode, set the mapping gfp mask appropriately.

This makes the use of AOP_FLAG_NOFS redundant from other parts of
the XFS IO path, so get rid of it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/xfs/xfs_aops.c | 3 +--
 fs/xfs/xfs_iops.c | 9 +++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e51e581454e9..be9a1fa2721b 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1569,8 +1569,7 @@ xfs_vm_write_begin(
 
 	ASSERT(len <= PAGE_CACHE_SIZE);
 
-	page = grab_cache_page_write_begin(mapping, index,
-					   flags | AOP_FLAG_NOFS);
+	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page)
 		return -ENOMEM;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 2b8952d9199b..584996c1bea7 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1169,6 +1169,7 @@ xfs_setup_inode(
 	struct xfs_inode	*ip)
 {
 	struct inode		*inode = &ip->i_vnode;
+	gfp_t			gfp_mask;
 
 	inode->i_ino = ip->i_ino;
 	inode->i_state = I_NEW;
@@ -1229,6 +1230,14 @@ xfs_setup_inode(
 	}
 
 	/*
+	 * Ensure all page cache allocations are done from GFP_NOFS context to
+	 * prevent direct reclaim recursion back into the filesystem and blowing
+	 * stacks or deadlocking.
+	 */
+	gfp_mask = mapping_gfp_mask(inode->i_mapping);
+	mapping_set_gfp_mask(inode->i_mapping, (gfp_mask & ~(__GFP_FS)));
+
+	/*
 	 * If there is no attribute fork no ACL can exist on this inode,
 	 * and it can't have any file capabilities attached to it either.
 	 */
-- 
2.0.0

