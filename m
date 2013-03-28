Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab3C1HQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 03:16:34 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:58839 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab3C1HQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 03:16:33 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: linkinjeon@gmail.com
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] fs: f2fs: Use kmemdup
Date: Thu, 28 Mar 2013 02:24:53 +0200
Message-Id: <1364430293-7624-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kmemdup instead of kzalloc and memcpy.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 fs/f2fs/node.c    |   12 +++++-------
 fs/f2fs/segment.c |    3 +--
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index e275218..9f5eca4 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1661,19 +1661,17 @@ static int init_node_manager(struct f2fs_sb_info *sbi)
 	spin_lock_init(&nm_i->free_nid_list_lock);
 	rwlock_init(&nm_i->nat_tree_lock);
 
-	nm_i->bitmap_size = __bitmap_size(sbi, NAT_BITMAP);
 	nm_i->init_scan_nid = le32_to_cpu(sbi->ckpt->next_free_nid);
 	nm_i->next_scan_nid = le32_to_cpu(sbi->ckpt->next_free_nid);
-
-	nm_i->nat_bitmap = kzalloc(nm_i->bitmap_size, GFP_KERNEL);
-	if (!nm_i->nat_bitmap)
-		return -ENOMEM;
+	nm_i->bitmap_size = __bitmap_size(sbi, NAT_BITMAP);
 	version_bitmap = __bitmap_ptr(sbi, NAT_BITMAP);
 	if (!version_bitmap)
 		return -EFAULT;
 
-	/* copy version bitmap */
-	memcpy(nm_i->nat_bitmap, version_bitmap, nm_i->bitmap_size);
+	nm_i->nat_bitmap = kmemdup(version_bitmap, nm_i->bitmap_size,
+					GFP_KERNEL);
+	if (!nm_i->nat_bitmap)
+		return -ENOMEM;
 	return 0;
 }
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 777f17e..1758149 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1403,10 +1403,9 @@ static int build_sit_info(struct f2fs_sb_info *sbi)
 	bitmap_size = __bitmap_size(sbi, SIT_BITMAP);
 	src_bitmap = __bitmap_ptr(sbi, SIT_BITMAP);
 
-	dst_bitmap = kzalloc(bitmap_size, GFP_KERNEL);
+	dst_bitmap = kmemdup(src_bitmap, bitmap_size, GFP_KERNEL);
 	if (!dst_bitmap)
 		return -ENOMEM;
-	memcpy(dst_bitmap, src_bitmap, bitmap_size);
 
 	/* init SIT information */
 	sit_i->s_ops = &default_salloc_ops;
-- 
1.7.9.5

