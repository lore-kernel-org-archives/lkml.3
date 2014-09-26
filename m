Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbaIZKd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:33:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738AbaIZJp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:45:59 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 015/142] ext4: update i_disksize coherently with block allocation on error path
Date: Fri, 26 Sep 2014 11:43:46 +0200
Message-Id: <978945187b6a4a6fdb0e9e1ed48fda1895d6eb3a.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Monakhov <dmonakhov@openvz.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6603120e96eae9a5d6228681ae55c7fdc998d1bb upstream.

In case of delalloc block i_disksize may be less than i_size. So we
have to update i_disksize each time we allocated and submitted some
blocks beyond i_disksize.  We weren't doing this on the error paths,
so fix this.

testcase: xfstest generic/019

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ext4/inode.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e5d9908c0bc3..d65a6260ad61 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2192,6 +2192,7 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 	struct ext4_map_blocks *map = &mpd->map;
 	int err;
 	loff_t disksize;
+	int progress = 0;
 
 	mpd->io_submit.io_end->offset =
 				((loff_t)map->m_lblk) << inode->i_blkbits;
@@ -2208,8 +2209,11 @@ static int mpage_map_and_submit_extent(handle_t *handle,
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
@@ -2226,15 +2230,17 @@ static int mpage_map_and_submit_extent(handle_t *handle,
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
2.1.0

