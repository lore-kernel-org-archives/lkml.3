Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab3IVHwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 03:52:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:55781 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3IVHwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 03:52:18 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-30-523ea1b15721
From: Chao Yu <chao2.yu@samsung.com>
To: Kim Jaegeuk <jaegeuk.kim@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH] f2fs: remove unneeded write checkpoint in
 recover_fsync_data
Date: Sun, 22 Sep 2013 15:51:47 +0800
Message-id: <000101ceb768$a8b43ff0$fa1cbfd0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac63VkmhIfow/QVmRaynF6PpdxFRQg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t9jQd2NC+2CDBac07K4fWUSi8WlRe4W
	e/aeZLG4vGsOm0XrwvPMDqweO2fdZffYveAzk0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	TGsrLvjHWdF5W7mBcTZHFyMnh4SAicStG8eYIWwxiQv31rN1MXJxCAlMZ5TYd6yTCcL5wSix
	ePM/FpAqNgEVieUd/5lAbBEBdYlvf+awgBQxC0xjlJi/5DsbSEJYIEqia8EJxi5GDg4WAVWJ
	+52iIGFeAUuJJc8g5vAKCEr8mHwPzGYW0JDoX7SBDcKWl9i85i3URQoSO86+ZoTYpSfR/mId
	E0SNuMTGI7dYJjAKzEIyahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxN
	jODQfia9g3FVg8UhRgEORiUe3go2uyAh1sSy4srcQ4wSHMxKIrxK1UAh3pTEyqrUovz4otKc
	1OJDjNIcLErivAdbrQOFBNITS1KzU1MLUotgskwcnFINjJsm8yzZcimX4Vse3zOfh+F1D9Rm
	VRmmrVFnfBrG5Lu3w1Ju9bcd6zo3yHm8nMRxJVpMet5j5f/fFlvIufOkcd9x+7l8es9drQIf
	vfLehzYzC499nunu4rxScWrb7zOXJnHondp7WaXoEpeh5e7NytEJdSoi9Wqbjp00CBNJ9uBe
	3nHZ3XCXqRJLcUaioRZzUXEiAFcZzmxpAgAA
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
index 51ef5ee..6988e1b 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -419,6 +419,7 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
 {
 	struct list_head inode_list;
 	int err;
+	int is_writecp = 0;
 
 	fsync_entry_slab = f2fs_kmem_cache_create("f2fs_fsync_inode_entry",
 			sizeof(struct fsync_inode_entry), NULL);
@@ -436,6 +437,8 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
 	if (list_empty(&inode_list))
 		goto out;
 
+	is_writecp = 1;
+
 	/* step #2: recover data */
 	err = recover_data(sbi, &inode_list, CURSEG_WARM_NODE);
 	BUG_ON(!list_empty(&inode_list));
@@ -443,7 +446,7 @@ out:
 	destroy_fsync_dnodes(&inode_list);
 	kmem_cache_destroy(fsync_entry_slab);
 	sbi->por_doing = 0;
-	if (!err)
+	if (!err && is_writecp)
 		write_checkpoint(sbi, false);
 	return err;
 }
---

