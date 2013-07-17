Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965096Ab3GQXLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:11:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56681 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964994Ab3GQWzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:55:55 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 087/145] ext4: fix overflows in SEEK_HOLE, SEEK_DATA implementations
Date: Wed, 17 Jul 2013 15:46:59 -0700
Message-Id: <1374101277-7915-88-git-send-email-kamal@canonical.com>
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

commit e7293fd146846e2a44d29e0477e0860c60fb856b upstream.

ext4_lblk_t is just u32 so multiplying it by blocksize can easily
overflow for files larger than 4 GB. Fix that by properly typing the
block offsets before shifting.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
[ luis: backported to 3.8: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/file.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 405565a..216a633 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -311,7 +311,7 @@ static int ext4_find_unwritten_pgoff(struct inode *inode,
 	blkbits = inode->i_sb->s_blocksize_bits;
 	startoff = *offset;
 	lastoff = startoff;
-	endoff = (map->m_lblk + map->m_len) << blkbits;
+	endoff = (loff_t)(map->m_lblk + map->m_len) << blkbits;
 
 	index = startoff >> PAGE_CACHE_SHIFT;
 	end = endoff >> PAGE_CACHE_SHIFT;
@@ -456,7 +456,7 @@ static loff_t ext4_seek_data(struct file *file, loff_t offset, loff_t maxsize)
 		ret = ext4_map_blocks(NULL, inode, &map, 0);
 		if (ret > 0 && !(map.m_flags & EXT4_MAP_UNWRITTEN)) {
 			if (last != start)
-				dataoff = last << blkbits;
+				dataoff = (loff_t)last << blkbits;
 			break;
 		}
 
@@ -469,7 +469,7 @@ static loff_t ext4_seek_data(struct file *file, loff_t offset, loff_t maxsize)
 		if (last >= es.start &&
 		    last < es.start + es.len) {
 			if (last != start)
-				dataoff = last << blkbits;
+				dataoff = (loff_t)last << blkbits;
 			break;
 		}
 
@@ -487,7 +487,7 @@ static loff_t ext4_seek_data(struct file *file, loff_t offset, loff_t maxsize)
 		}
 
 		last++;
-		dataoff = last << blkbits;
+		dataoff = (loff_t)last << blkbits;
 	} while (last <= end);
 
 	mutex_unlock(&inode->i_mutex);
@@ -541,7 +541,7 @@ static loff_t ext4_seek_hole(struct file *file, loff_t offset, loff_t maxsize)
 		ret = ext4_map_blocks(NULL, inode, &map, 0);
 		if (ret > 0 && !(map.m_flags & EXT4_MAP_UNWRITTEN)) {
 			last += ret;
-			holeoff = last << blkbits;
+			holeoff = (loff_t)last << blkbits;
 			continue;
 		}
 
@@ -554,7 +554,7 @@ static loff_t ext4_seek_hole(struct file *file, loff_t offset, loff_t maxsize)
 		if (last >= es.start &&
 		    last < es.start + es.len) {
 			last = es.start + es.len;
-			holeoff = last << blkbits;
+			holeoff = (loff_t)last << blkbits;
 			continue;
 		}
 
@@ -569,7 +569,7 @@ static loff_t ext4_seek_hole(struct file *file, loff_t offset, loff_t maxsize)
 							      &map, &holeoff);
 			if (!unwritten) {
 				last += ret;
-				holeoff = last << blkbits;
+				holeoff = (loff_t)last << blkbits;
 				continue;
 			}
 		}
-- 
1.8.1.2

