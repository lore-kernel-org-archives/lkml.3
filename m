Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab3J3NKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:10:49 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:59811 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab3J3NKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:10:48 -0400
From: Rashika Kheria <rashika.kheria@gmail.com>
To: opw-kernel@googlegroups.com, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH v8 2/3] Staging: zram: Fix decrement of variable by calling bdput()
Date: Wed, 30 Oct 2013 18:40:37 +0530
Message-Id: <1a9bd106783c1209626074deaf7fe1126530742f.1383138164.git.rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20131019110539.GA25167@gmail.com>
References: <20131019110539.GA25167@gmail.com>
In-Reply-To: <3d7e050910ca994862e7880b4bd3681267681b56.1383138164.git.rashika.kheria@gmail.com>
References: <3d7e050910ca994862e7880b4bd3681267681b56.1383138164.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Jerome Marchand "The code in reset_store get the block device
(bdget_disk()) but it does not put it (bdput()) when it's done using it.
The usage count is therefore incremented but never decremented."

This patch also puts bdput() for all error cases.

Cc: stable@vger.kernel.org
Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---

This revision fixes the following issues of the previous revision-
Proper error handling

 drivers/staging/zram/zram_drv.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 012ba15..0bc2835 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -648,25 +648,36 @@ static ssize_t reset_store(struct device *dev,
 	zram = dev_to_zram(dev);
 	bdev = bdget_disk(zram->disk, 0);
 
-	if (!bdev)
-		return -ENOMEM;
+	if (!bdev) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	/* Do not reset an active device! */
-	if (bdev->bd_holders)
-		return -EBUSY;
+	if (bdev->bd_holders) {
+		ret = -EBUSY;
+		goto out;
+	}
 
 	ret = kstrtou16(buf, 10, &do_reset);
 	if (ret)
-		return ret;
+		goto out;
 
-	if (!do_reset)
-		return -EINVAL;
+	if (!do_reset) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	/* Make sure all pending I/O is finished */
 	fsync_bdev(bdev);
+	bdput(bdev);
 
 	zram_reset_device(zram, true);
 	return len;
+
+out:	
+	bdput(bdev);
+	return ret;
 }
 
 static void __zram_make_request(struct zram *zram, struct bio *bio, int rw)
-- 
1.7.9.5

