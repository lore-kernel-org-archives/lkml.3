Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbaCEOhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:37:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41587 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758203AbaCEOhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:37:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 14/62] ext4: fix online resize with a non-standard blocks per group setting
Date: Wed,  5 Mar 2014 14:36:18 +0000
Message-Id: <1394030226-26652-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 3d2660d0c9c2f296837078c189b68a47f6b2e3b5 upstream.

The set_flexbg_block_bitmap() function assumed that the number of
blocks in a blockgroup was sb->blocksize * 8, which is normally true,
but not always!  Use EXT4_BLOCKS_PER_GROUP(sb) instead, to fix block
bitmap corruption after:

mke2fs -t ext4 -g 3072 -i 4096 /dev/vdd 1G
mount -t ext4 /dev/vdd /vdd
resize2fs /dev/vdd 8G

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reported-by: Jon Bernard <jbernard@tuxion.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/resize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index d0ba1a9..7a7316b 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -377,7 +377,7 @@ static int set_flexbg_block_bitmap(struct super_block *sb, handle_t *handle,
 		start = ext4_group_first_block_no(sb, group);
 		group -= flex_gd->groups[0].group;
 
-		count2 = sb->s_blocksize * 8 - (block - start);
+		count2 = EXT4_BLOCKS_PER_GROUP(sb) - (block - start);
 		if (count2 > count)
 			count2 = count;
 
-- 
1.9.0

