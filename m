Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab3KAOG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:06:26 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:40445 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab3KAOGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:06:24 -0400
From: Rashika Kheria <rashika.kheria@gmail.com>
To: opw-kernel@googlegroups.com, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH v10] Staging: zram: Fix memory leak by refcount mismatch
Date: Fri,  1 Nov 2013 19:36:09 +0530
Message-Id: <1383314769-3667-1-git-send-email-rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20131019110539.GA25167@gmail.com>
References: <20131019110539.GA25167@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Minchan Kim and Jerome Marchand "The code in reset_store
get the block device (bdget_disk()) but it does not put it (bdput()) when
it's done using it. The usage count is therefore incremented but never
decremented."

This patch also puts bdput() for all error cases.

Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---

This revision fixes the following issue of the previous revision-
Incorrect Subject Line

 drivers/staging/zram/zram_drv.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 012ba15..a1f8b1f 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -652,21 +652,30 @@ static ssize_t reset_store(struct device *dev,
 		return -ENOMEM;
 
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

