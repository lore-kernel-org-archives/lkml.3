Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab3FPAtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 20:49:22 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:62819 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab3FPAtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 20:49:20 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH 2/2] f2fs: optimise the init_dirty_segmap function
Date: Sun, 16 Jun 2013 09:49:11 +0900
Message-Id: <1371343751-2710-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Optimise the while loop condition

Since this condition will always be true and while loop will
be terminated by the following condition in code:

if (segno >= TOTAL_SEGS(sbi))
    break;
Hence we can replace the while loop condition with while(1)
instead of always checking for segno to be less than Total segs.

Also we do not need to use TOTAL_SEGS() everytime. We can store
this value in a local variable since this value is constant.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
---
 fs/f2fs/segment.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index b15debc..e351222 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1582,13 +1582,13 @@ static void init_dirty_segmap(struct f2fs_sb_info *sbi)
 {
 	struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);
 	struct free_segmap_info *free_i = FREE_I(sbi);
-	unsigned int segno = 0, offset = 0;
+	unsigned int segno = 0, offset = 0, total_segs = TOTAL_SEGS(sbi);
 	unsigned short valid_blocks;
 
-	while (segno < TOTAL_SEGS(sbi)) {
+	while (1) {
 		/* find dirty segment based on free segmap */
-		segno = find_next_inuse(free_i, TOTAL_SEGS(sbi), offset);
-		if (segno >= TOTAL_SEGS(sbi))
+		segno = find_next_inuse(free_i, total_segs, offset);
+		if (segno >= total_segs)
 			break;
 		offset = segno + 1;
 		valid_blocks = get_valid_blocks(sbi, segno, 0);
-- 
1.7.9.5

