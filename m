Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964800AbaICX1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:27:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125AbaICWPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:15:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Monakhov <dmonakhov@openvz.org>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3.14 68/88] ext4: update i_disksize coherently with block allocation on error path
Date: Wed,  3 Sep 2014 15:05:42 -0700
Message-Id: <20140903220517.994000256@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220515.958924632@linuxfoundation.org>
References: <20140903220515.958924632@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2195,6 +2195,7 @@ static int mpage_map_and_submit_extent(h
 	struct ext4_map_blocks *map = &mpd->map;
 	int err;
 	loff_t disksize;
+	int progress = 0;
 
 	mpd->io_submit.io_end->offset =
 				((loff_t)map->m_lblk) << inode->i_blkbits;
@@ -2211,8 +2212,11 @@ static int mpage_map_and_submit_extent(h
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
@@ -2229,15 +2233,17 @@ static int mpage_map_and_submit_extent(h
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


