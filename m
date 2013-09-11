Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab3IKLAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:00:45 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:48807 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab3IKLAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:00:42 -0400
Date: Wed, 11 Sep 2013 19:00:31 +0800
From: majianpeng <majianpeng@gmail.com>
To: axboe <axboe@kernel.dk>, viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 1/2] block: Set inode of block_device size to zero when delete gendisk.
X-Priority: 3
X-GUID: E072949A-D9E5-4B84-A396-DE2E19640EF8
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.93[cn]
Mime-Version: 1.0
Message-ID: <201309111900280892484@gmail.com>
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8BB175t004179

When remove gendisk, set the size of inode of block_device to zero.
This is mainly let the vfs know disk removed.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 block/genhd.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index dadf42b..c3a54b4 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -634,6 +634,7 @@ void del_gendisk(struct gendisk *disk)
 {
 	struct disk_part_iter piter;
 	struct hd_struct *part;
+	struct block_device *bdev;
 
 	disk_del_events(disk);
 
@@ -655,6 +656,19 @@ void del_gendisk(struct gendisk *disk)
 	blk_unregister_queue(disk);
 	blk_unregister_region(disk_devt(disk), disk->minors);
 
+	/*
+	 * When used buffer-mode on raw blockdevice,the disk removed.
+	 * But the vfs don't know.So tell the vfs size of disk became zero,
+	 * the buffer write  can return
+	 */
+	bdev = bdget_disk(disk, 0);
+	if (bdev) {
+		mutex_lock(&bdev->bd_inode->i_mutex);
+		i_size_write(bdev->bd_inode, 0);
+		mutex_unlock(&bdev->bd_inode->i_mutex);
+		bdput(bdev);
+	}
+
 	part_stat_set_all(&disk->part0, 0);
 	disk->part0.stamp = 0;
 
-- 
1.8.4-rc0
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
