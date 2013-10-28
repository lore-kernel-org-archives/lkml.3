Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab3J1MVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 08:21:52 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34953 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109Ab3J1MVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:21:51 -0400
From: Rashika Kheria <rashika.kheria@gmail.com>
To: opw-kernel@googlegroups.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minchan Kim <minchan@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v6 1/3] Staging: zram: Fix access of NULL pointer
Date: Mon, 28 Oct 2013 17:51:38 +0530
Message-Id: <cc16130b4e23207971139eff313a4ec71f51c187.1382962788.git.rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20131019110539.GA25167@gmail.com>
References: <20131019110539.GA25167@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the bug in reset_store caused by accessing NULL pointer.
Hence, It introduces a check for bdev. It also removes unnecessary check
of bdev for fsync_bdev().

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---

This revision fixes the following issues of the previous revision-
Seperating patches into Bug fix and Smatch fix 

 drivers/staging/zram/zram_drv.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 2c4ed52..d640a8f 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -648,6 +648,9 @@ static ssize_t reset_store(struct device *dev,
 	zram = dev_to_zram(dev);
 	bdev = bdget_disk(zram->disk, 0);
 
+	if (!bdev)
+		return -EBUSY;
+
 	/* Do not reset an active device! */
 	if (bdev->bd_holders)
 		return -EBUSY;
@@ -660,8 +663,7 @@ static ssize_t reset_store(struct device *dev,
 		return -EINVAL;
 
 	/* Make sure all pending I/O is finished */
-	if (bdev)
-		fsync_bdev(bdev);
+	fsync_bdev(bdev);
 
 	zram_reset_device(zram, true);
 	return len;
-- 
1.7.9.5

