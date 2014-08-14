Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbaHNFQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 01:16:47 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54024 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaHNFQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 01:16:46 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <53EC463A.8060100@lge.com>
Date: Thu, 14 Aug 2014 14:16:42 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org
CC: Minchan Kim <minchan@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
        =?EUC-KR?B?wMywx8ij?= <gunho.lee@lge.com>
Subject: [PATCH 2/3] ext4: allocate buffer-cache for superblock in, non-movable
 area
References: <53EC4531.1000904@lge.com>
In-Reply-To: <53EC4531.1000904@lge.com>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A buffer-cache for superblock is disturbing page migration,
because the buffer-cache is not released until unmount.
The buffer-cache must be allocated from non-movable area.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 fs/ext4/super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 32b43ad..0630a88 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3435,7 +3435,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
                logical_sb_block = sb_block;
        }

-       if (!(bh = sb_bread(sb, logical_sb_block))) {
+       if (!(bh = sb_bread_nonmovable(sb, logical_sb_block))) {
                ext4_msg(sb, KERN_ERR, "unable to read superblock");
                goto out_fail;
        }
@@ -3645,7 +3645,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
                brelse(bh);
                logical_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
                offset = do_div(logical_sb_block, blocksize);
-               bh = sb_bread(sb, logical_sb_block);
+               bh = sb_bread_nonmovable(sb, logical_sb_block);
                if (!bh) {
                        ext4_msg(sb, KERN_ERR,
                               "Can't read superblock on 2nd try");
@@ -3867,7 +3867,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)

        for (i = 0; i < db_count; i++) {
                block = descriptor_loc(sb, logical_sb_block, i);
-               sbi->s_group_desc[i] = sb_bread(sb, block);
+               sbi->s_group_desc[i] = sb_bread_nonmovable(sb, block);
                if (!sbi->s_group_desc[i]) {
                        ext4_msg(sb, KERN_ERR,
                               "can't read group descriptor %d", i);
--
1.7.9.5

