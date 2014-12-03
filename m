Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaLCLat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:30:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54685 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbaLCL1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:47 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sougata Santra <sougata@tuxera.com>,
        Vyacheslav Dubeyko <slava@dubeyko.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 086/101] fs/hfsplus/extents.c: fix concurrent acess of alloc_blocks
Date: Wed,  3 Dec 2014 12:26:48 +0100
Message-Id: <7357404a711a32bcade125a84a07edca78e71361.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sougata Santra <sougata@tuxera.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d7bdb996aef67ea24c62707ca4e29b07025e9683 upstream.

Concurrent access to alloc_blocks in hfsplus_inode_info() is protected
by extents_lock mutex.  This patch fixes two instances where
alloc_blocks modification was not protected with this lock.

This fixes possible allocation bitmap corruption in race conditions
while extending and truncating files.

[akpm@linux-foundation.org: take extents_lock before taking a copy of ->alloc_blocks]
[akpm@linux-foundation.org: remove now-unused label `out']
Signed-off-by: Sougata Santra <sougata@tuxera.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/hfsplus/extents.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index fbb212fbb1ef..f0f601c83ad6 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -498,11 +498,13 @@ int hfsplus_file_extend(struct inode *inode)
 			goto insert_extent;
 	}
 out:
-	mutex_unlock(&hip->extents_lock);
 	if (!res) {
 		hip->alloc_blocks += len;
+		mutex_unlock(&hip->extents_lock);
 		hfsplus_mark_inode_dirty(inode, HFSPLUS_I_ALLOC_DIRTY);
+		return 0;
 	}
+	mutex_unlock(&hip->extents_lock);
 	return res;
 
 insert_extent:
@@ -556,11 +558,13 @@ void hfsplus_file_truncate(struct inode *inode)
 
 	blk_cnt = (inode->i_size + HFSPLUS_SB(sb)->alloc_blksz - 1) >>
 			HFSPLUS_SB(sb)->alloc_blksz_shift;
+
+	mutex_lock(&hip->extents_lock);
+
 	alloc_cnt = hip->alloc_blocks;
 	if (blk_cnt == alloc_cnt)
-		goto out;
+		goto out_unlock;
 
-	mutex_lock(&hip->extents_lock);
 	res = hfs_find_init(HFSPLUS_SB(sb)->ext_tree, &fd);
 	if (res) {
 		mutex_unlock(&hip->extents_lock);
@@ -592,10 +596,10 @@ void hfsplus_file_truncate(struct inode *inode)
 		hfs_brec_remove(&fd);
 	}
 	hfs_find_exit(&fd);
-	mutex_unlock(&hip->extents_lock);
 
 	hip->alloc_blocks = blk_cnt;
-out:
+out_unlock:
+	mutex_unlock(&hip->extents_lock);
 	hip->phys_size = inode->i_size;
 	hip->fs_blocks = (inode->i_size + sb->s_blocksize - 1) >>
 		sb->s_blocksize_bits;
-- 
2.1.3

