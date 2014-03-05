Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbaCEPWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:22:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40872 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920AbaCEOZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 037/131] ext4: fix online resize with a non-standard blocks per group setting
Date: Wed,  5 Mar 2014 14:22:41 +0000
Message-Id: <1394029455-23128-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

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
index 69a6261..f3b84cd 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -409,7 +409,7 @@ static int set_flexbg_block_bitmap(struct super_block *sb, handle_t *handle,
 		start = ext4_group_first_block_no(sb, group);
 		group -= flex_gd->groups[0].group;
 
-		count2 = sb->s_blocksize * 8 - (block - start);
+		count2 = EXT4_BLOCKS_PER_GROUP(sb) - (block - start);
 		if (count2 > count)
 			count2 = count;
 
-- 
1.9.0

