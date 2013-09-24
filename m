Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab3IXB1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 21:27:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:47387 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab3IXB1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 21:27:31 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-7e-5240ea82e932
From: Chao Yu <chao2.yu@samsung.com>
To: Kim Jaegeuk <jaegeuk.kim@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH RESEND] f2fs: remove unneeded write checkpoint in
 recover_fsync_data
Date: Tue, 24 Sep 2013 09:26:24 +0800
Message-id: <000201ceb8c5$3c983840$b5c8a8c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac64w/e8sq8INmoaQ7SSKZQHI/HRVQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jQd2mVw5BBnOXKFjcvjKJxeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aPnbPusnvsXvCZyaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	/r3/zF7QzFVx7PgilgbGhRxdjJwcEgImEsvv3mOHsMUkLtxbz9bFyMUhJDCdUWLuol9gCSGB
	H4wSBy+KgthsAioSyzv+M4HYIgLqEt/+zGEBaWAWmMYoMX/JdzaQhLBAosSfe79YQWwWAVWJ
	gw9egjXwClhKLJ/8jAXCFpT4MfkemM0soCHRv2gDG4QtL7F5zVtmiIsUJHacfc0IsUxPYseZ
	w1A14hIbj9ximcAoMAvJqFlIRs1CMmoWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3
	MYLD+5n0DsZVDRaHGAU4GJV4eC8kOAQJsSaWFVfmHmKU4GBWEuE9Gg0U4k1JrKxKLcqPLyrN
	SS0+xCjNwaIkznuw1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwOiQMC8jrNh2qvNqlgxz1ofCV07m
	N8rkzfe51/cgx/wc78y9z/VupEV2nqjquHDKO1P95J7kWW8/NM8yzFesSj/sGHT4r6Rl09X9
	LFN3BS05oJN5s/X87G7WvmnNzn9n74pt/zCt/Znl5f1vKzt0/82Yc1O/km3P0i9b4t7X1Pmo
	K3V3OG6//UmJpTgj0VCLuag4EQBKERbQawIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, recover_fsync_data still to write checkpoint when there is
nothing to recover with normal umount image.
It may reduce mount performance and flash memory lifetime, so let's remove
it.

Signed-off-by: Tan Shu <shu.tan@samsung.com>
Signed-off-by: Yu Chao <chao2.yu@samsung.com>
---
fs/f2fs/recovery.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 51ef5ee..d43e4cd 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -419,6 +419,7 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
 {
 	struct list_head inode_list;
 	int err;
+	int need_writecp = 0;
 
 	fsync_entry_slab = f2fs_kmem_cache_create("f2fs_fsync_inode_entry",
 			sizeof(struct fsync_inode_entry), NULL);
@@ -436,6 +437,8 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
 	if (list_empty(&inode_list))
 		goto out;
 
+	need_writecp = 1;
+
 	/* step #2: recover data */
 	err = recover_data(sbi, &inode_list, CURSEG_WARM_NODE);
 	BUG_ON(!list_empty(&inode_list));
@@ -443,7 +446,7 @@ out:
 	destroy_fsync_dnodes(&inode_list);
 	kmem_cache_destroy(fsync_entry_slab);
 	sbi->por_doing = 0;
-	if (!err)
+	if (!err && need_writecp)
 		write_checkpoint(sbi, false);
 	return err;
 }
---

