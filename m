Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbaI3WAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:00:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60903 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaI3VhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:37:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 073/103] ext4: update i_disksize coherently with block allocation on error path
Date: Tue, 30 Sep 2014 14:31:18 -0700
Message-Id: <1412112708-27356-74-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit 6603120e96eae9a5d6228681ae55c7fdc998d1bb upstream.

In case of delalloc block i_disksize may be less than i_size. So we
have to update i_disksize each time we allocated and submitted some
blocks beyond i_disksize.  We weren't doing this on the error paths,
so fix this.

testcase: xfstest generic/019

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/inode.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 23e8c80..2d782aa 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2201,6 +2201,7 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 	struct ext4_map_blocks *map = &mpd->map;
 	int err;
 	loff_t disksize;
+	int progress = 0;
 
 	mpd->io_submit.io_end->offset =
 				((loff_t)map->m_lblk) << inode->i_blkbits;
@@ -2217,8 +2218,11 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 			 * is non-zero, a commit should free up blocks.
 			 */
 			if ((err == -ENOMEM) ||
-			    (err == -ENOSPC && ext4_count_free_clusters(sb)))
+			    (err == -ENOSPC && ext4_count_free_clusters(sb))) {
+				if (progress)
+					goto update_disksize;
 				return err;
+			}
 			ext4_msg(sb, KERN_CRIT,
 				 "Delayed block allocation failed for "
 				 "inode %lu at logical offset %llu with"
@@ -2235,15 +2239,17 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 			*give_up_on_write = true;
 			return err;
 		}
+		progress = 1;
 		/*
 		 * Update buffer state, submit mapped pages, and get us new
 		 * extent to map
 		 */
 		err = mpage_map_and_submit_buffers(mpd);
 		if (err < 0)
-			return err;
+			goto update_disksize;
 	} while (map->m_len);
 
+update_disksize:
 	/*
 	 * Update on-disk size after IO is submitted.  Races with
 	 * truncate are avoided by checking i_size under i_data_sem.
-- 
1.9.1

