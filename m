Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbaFZBQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 21:16:36 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:55637 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757421AbaFZBQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 21:16:34 -0400
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Alexander E. Patrakov" <patrakov@gmail.com>,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Minchan Kim <minchan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] zram: revalidate disk after capacity change
Date: Thu, 26 Jun 2014 10:16:25 +0900
Message-Id: <1403745385-18952-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander reported mkswap on /dev/zram0 is failed if other process
is opening the block device file.

Step is as follows,

0. Reset the unused zram device.
1. Use a program that opens /dev/zram0 with O_RDWR and sleeps
   until killed.
2. While that program sleeps, echo the correct value to
   /sys/block/zram0/disksize.
3. Verify (e.g. in /proc/partitions) that the disk size is applied
   correctly. It is.
4. While that program still sleeps, attempt to mkswap /dev/zram0.
   This fails: mkswap: error: swap area needs to be at least 40 KiB

When I investigated, the size get by ioctl(fd, BLKGETSIZE64, xxx)
on mkswap to get a size of blockdev was zero although zram0 has
right size by 2.

The reason is zram didn't revalidate disk after changing capacity
so that size of blockdev's inode is not uptodate until all of file
is close.

This patch should fix the BUG.

Cc: stable@vger.kernel.org
Reported-and-Tested-by: Alexander E. Patrakov <patrakov@gmail.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/block/zram/zram_drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 48eccb3..089e72c 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -622,8 +622,10 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
 	memset(&zram->stats, 0, sizeof(zram->stats));
 
 	zram->disksize = 0;
-	if (reset_capacity)
+	if (reset_capacity) {
 		set_capacity(zram->disk, 0);
+		revalidate_disk(zram->disk);
+	}
 	up_write(&zram->init_lock);
 }
 
@@ -664,6 +666,7 @@ static ssize_t disksize_store(struct device *dev,
 	zram->comp = comp;
 	zram->disksize = disksize;
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
+	revalidate_disk(zram->disk);
 	up_write(&zram->init_lock);
 	return len;
 
-- 
2.0.0

