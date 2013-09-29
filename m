Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab3I2Hga (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 03:36:30 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50009 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3I2Hg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 03:36:27 -0400
Date: Sun, 29 Sep 2013 15:36:25 +0800
From: majianpeng <majianpeng@gmail.com>
To: axboe <axboe@kernel.dk>
Cc: "Jeff Moyer" <jmoyer@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH] block: Don't reread partitions of disk which already mouted.
X-Priority: 3
X-GUID: EB7A6798-AD45-409F-A2F2-7BAB3A953AB8
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.93[cn]
Mime-Version: 1.0
Message-ID: <201309291536174186150@gmail.com>
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8T7aonE001257

If reread partitions of disk, the paths are:
blkdev_ioctl->blkdev_reread_part->rescan_partitions->drop_partitions
->invalidate_partition->__invalidate_device
In func __invalidate_device, if disk already mounted, it will do
shrink_dcache_sb and invalidate_inodes.
This operation will effect the fs.
So add a judgement before doing rescan_partiontions to judge disk
whether mounted.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 block/ioctl.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/ioctl.c b/block/ioctl.c
index a31d91d..374af7e 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -154,11 +154,19 @@ static int blkdev_reread_part(struct block_device *bdev)
 {
 	struct gendisk *disk = bdev->bd_disk;
 	int res;
+	struct super_block *sb;
 
 	if (!disk_part_scan_enabled(disk) || bdev != bdev->bd_contains)
 		return -EINVAL;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
+
+	sb = get_super(bdev);
+	if (sb) {
+		drop_super(sb);
+		return -EBUSY;
+	}
+
 	if (!mutex_trylock(&bdev->bd_mutex))
 		return -EBUSY;
 	res = rescan_partitions(disk, bdev);
-- 
1.8.4
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
