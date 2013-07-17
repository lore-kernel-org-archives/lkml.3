Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934466Ab3GQXQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:16:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56570 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934399Ab3GQWzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:55:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 086/145] ext4: fix data offset overflow in ext4_xattr_fiemap() on 32-bit archs
Date: Wed, 17 Jul 2013 15:46:58 -0700
Message-Id: <1374101277-7915-87-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit a60697f411eb365fb09e639e6f183fe33d1eb796 upstream.

On 32-bit architectures with 32-bit sector_t computation of data offset
in ext4_xattr_fiemap() can overflow resulting in reporting bogus data
location. Fix the problem by typing block number to proper type before
shifting.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/extents.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4d315a0..a5ce6ce 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4618,7 +4618,7 @@ static int ext4_xattr_fiemap(struct inode *inode,
 		error = ext4_get_inode_loc(inode, &iloc);
 		if (error)
 			return error;
-		physical = iloc.bh->b_blocknr << blockbits;
+		physical = (__u64)iloc.bh->b_blocknr << blockbits;
 		offset = EXT4_GOOD_OLD_INODE_SIZE +
 				EXT4_I(inode)->i_extra_isize;
 		physical += offset;
@@ -4626,7 +4626,7 @@ static int ext4_xattr_fiemap(struct inode *inode,
 		flags |= FIEMAP_EXTENT_DATA_INLINE;
 		brelse(iloc.bh);
 	} else { /* external block */
-		physical = EXT4_I(inode)->i_file_acl << blockbits;
+		physical = (__u64)EXT4_I(inode)->i_file_acl << blockbits;
 		length = inode->i_sb->s_blocksize;
 	}
 
-- 
1.8.1.2

