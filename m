Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab3HESrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:47:04 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:44251 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab3HESrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:47:03 -0400
From: Manish Sharma <manishrma@gmail.com>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernelnewbies@kernelnewbies.org, Manish Sharma <manishrma@gmail.com>
Subject: [PATCH 1/1] Squashfs: Optimized uncompressed buffer loop
Date: Tue,  6 Aug 2013 00:16:27 +0530
Message-Id: <1375728387-3595-1-git-send-email-manishrma@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merged the two for loops. We might get a little gain by overlapping
wait_on_bh and the memcpy operations.

Signed-off-by: Manish Sharma <manishrma@gmail.com>
---
 fs/squashfs/block.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index fb50652..5012f98 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -169,12 +169,6 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
		 */
		int i, in, pg_offset = 0;

-		for (i = 0; i < b; i++) {
-			wait_on_buffer(bh[i]);
-			if (!buffer_uptodate(bh[i]))
-				goto block_release;
-		}
-
		for (bytes = length; k < b; k++) {
			in = min(bytes, msblk->devblksize - offset);
			bytes -= in;
@@ -185,6 +179,9 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
				}
				avail = min_t(int, in, PAGE_CACHE_SIZE -
						pg_offset);
+				wait_on_buffer(bh[k]);
+				if (!buffer_uptodate(bh[k]))
+					goto block_release;
				memcpy(buffer[page] + pg_offset,
						bh[k]->b_data + offset, avail);
				in -= avail;
--
1.7.9.5
