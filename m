Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbaBEUIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:08:06 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48524 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbaBEUHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:33 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Brian Foster <bfoster@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 171/213] ext4: don't let i_reserved_meta_blocks go negative
Date: Wed, 5 Feb 2014 15:02:06 -0500
Message-ID: <1391630568-49251-172-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 97795d2a5b8d3c8dc4365d4bd3404191840453ba upstream.

If we hit a condition where we have allocated metadata blocks that
were not appropriately reserved, we risk underflow of
ei->i_reserved_meta_blocks.  In turn, this can throw
sbi->s_dirtyclusters_counter significantly out of whack and undermine
the nondelalloc fallback logic in ext4_nonda_switch().  Warn if this
occurs and set i_allocated_meta_blocks to avoid this problem.

This condition is reproduced by xfstests 270 against ext2 with
delalloc enabled:

Mar 28 08:58:02 localhost kernel: [  171.526344] EXT4-fs (loop1): delayed block allocation failed for inode 14 at logical offset 64486 with max blocks 64 with error -28
Mar 28 08:58:02 localhost kernel: [  171.526346] EXT4-fs (loop1): This should not happen!! Data will be lost

270 ultimately fails with an inconsistent filesystem and requires an
fsck to repair.  The cause of the error is an underflow in
ext4_da_update_reserve_space() due to an unreserved meta block
allocation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/inode.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b8965bb679ee..893da43223d4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1089,6 +1089,15 @@ void ext4_da_update_reserve_space(struct inode *inode,
 		used = ei->i_reserved_data_blocks;
 	}
 
+	if (unlikely(ei->i_allocated_meta_blocks > ei->i_reserved_meta_blocks)) {
+		ext4_msg(inode->i_sb, KERN_NOTICE, "%s: ino %lu, allocated %d "
+			 "with only %d reserved metadata blocks\n", __func__,
+			 inode->i_ino, ei->i_allocated_meta_blocks,
+			 ei->i_reserved_meta_blocks);
+		WARN_ON(1);
+		ei->i_allocated_meta_blocks = ei->i_reserved_meta_blocks;
+	}
+
 	/* Update per-inode reservations */
 	ei->i_reserved_data_blocks -= used;
 	used += ei->i_allocated_meta_blocks;
-- 
1.8.5.2

