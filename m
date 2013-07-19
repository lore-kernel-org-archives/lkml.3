Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966025Ab3GSFsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:48:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965267Ab3GSFWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:22:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Zheng Liu <wenqing.lz@taobao.com>
Subject: [ 31/38] ext4: fix overflows in SEEK_HOLE, SEEK_DATA implementations
Date: Thu, 18 Jul 2013 22:21:47 -0700
Message-Id: <20130719052050.008903462@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052047.858393825@linuxfoundation.org>
References: <20130719052047.858393825@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit e7293fd146846e2a44d29e0477e0860c60fb856b upstream.

ext4_lblk_t is just u32 so multiplying it by blocksize can easily
overflow for files larger than 4 GB. Fix that by properly typing the
block offsets before shifting.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/file.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -311,7 +311,7 @@ static int ext4_find_unwritten_pgoff(str
 	blkbits = inode->i_sb->s_blocksize_bits;
 	startoff = *offset;
 	lastoff = startoff;
-	endoff = (map->m_lblk + map->m_len) << blkbits;
+	endoff = (loff_t)(map->m_lblk + map->m_len) << blkbits;
 
 	index = startoff >> PAGE_CACHE_SHIFT;
 	end = endoff >> PAGE_CACHE_SHIFT;
@@ -456,7 +456,7 @@ static loff_t ext4_seek_data(struct file
 		ret = ext4_map_blocks(NULL, inode, &map, 0);
 		if (ret > 0 && !(map.m_flags & EXT4_MAP_UNWRITTEN)) {
 			if (last != start)
-				dataoff = last << blkbits;
+				dataoff = (loff_t)last << blkbits;
 			break;
 		}
 
@@ -467,7 +467,7 @@ static loff_t ext4_seek_data(struct file
 		ext4_es_find_delayed_extent(inode, last, &es);
 		if (es.es_len != 0 && in_range(last, es.es_lblk, es.es_len)) {
 			if (last != start)
-				dataoff = last << blkbits;
+				dataoff = (loff_t)last << blkbits;
 			break;
 		}
 
@@ -485,7 +485,7 @@ static loff_t ext4_seek_data(struct file
 		}
 
 		last++;
-		dataoff = last << blkbits;
+		dataoff = (loff_t)last << blkbits;
 	} while (last <= end);
 
 	mutex_unlock(&inode->i_mutex);
@@ -539,7 +539,7 @@ static loff_t ext4_seek_hole(struct file
 		ret = ext4_map_blocks(NULL, inode, &map, 0);
 		if (ret > 0 && !(map.m_flags & EXT4_MAP_UNWRITTEN)) {
 			last += ret;
-			holeoff = last << blkbits;
+			holeoff = (loff_t)last << blkbits;
 			continue;
 		}
 
@@ -550,7 +550,7 @@ static loff_t ext4_seek_hole(struct file
 		ext4_es_find_delayed_extent(inode, last, &es);
 		if (es.es_len != 0 && in_range(last, es.es_lblk, es.es_len)) {
 			last = es.es_lblk + es.es_len;
-			holeoff = last << blkbits;
+			holeoff = (loff_t)last << blkbits;
 			continue;
 		}
 
@@ -565,7 +565,7 @@ static loff_t ext4_seek_hole(struct file
 							      &map, &holeoff);
 			if (!unwritten) {
 				last += ret;
-				holeoff = last << blkbits;
+				holeoff = (loff_t)last << blkbits;
 				continue;
 			}
 		}


