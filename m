Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab3BEJMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:12:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724Ab3BEJMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:12:48 -0500
From: Lukas Czerner <lczerner@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v2 15/18] ext4: remove unused code from ext4_remove_blocks()
Date: Tue,  5 Feb 2013 10:12:08 +0100
Message-Id: <1360055531-26309-16-git-send-email-lczerner@redhat.com>
In-Reply-To: <1360055531-26309-1-git-send-email-lczerner@redhat.com>
References: <1360055531-26309-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "head removal" branch in the condition is never used in any code
path in ext4 since the function only caller ext4_ext_rm_leaf() will make
sure that the extent is properly split before removing blocks. Note that
there is a bug in this branch anyway.

This commit removes the unused code completely and makes use of
ext4_error() instead of printk if dubious range is provided.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c |   21 ++++-----------------
 1 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7b44dc1..966a09e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2414,23 +2414,10 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 			*partial_cluster = EXT4_B2C(sbi, pblk);
 		else
 			*partial_cluster = 0;
-	} else if (from == le32_to_cpu(ex->ee_block)
-		   && to <= le32_to_cpu(ex->ee_block) + ee_len - 1) {
-		/* head removal */
-		ext4_lblk_t num;
-		ext4_fsblk_t start;
-
-		num = to - from;
-		start = ext4_ext_pblock(ex);
-
-		ext_debug("free first %u blocks starting %llu\n", num, start);
-		ext4_free_blocks(handle, inode, NULL, start, num, flags);
-
-	} else {
-		printk(KERN_INFO "strange request: removal(2) "
-				"%u-%u from %u:%u\n",
-				from, to, le32_to_cpu(ex->ee_block), ee_len);
-	}
+	} else
+		ext4_error(sbi->s_sb, "strange request: removal(2) "
+			   "%u-%u from %u:%u\n",
+			   from, to, le32_to_cpu(ex->ee_block), ee_len);
 	return 0;
 }
 
-- 
1.7.7.6

