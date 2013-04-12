Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab3DLS11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 14:27:27 -0400
Received: from masquerade.micron.com ([137.201.242.130]:25928 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab3DLS10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 14:27:26 -0400
Message-ID: <51685205.5080806@micron.com>
Date: Fri, 12 Apr 2013 23:57:17 +0530
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sam Bradshaw" <sbradshaw@micron.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 1/2] mtip32xx: fix a smatch warning
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19794.000
X-TM-AS-Result: No--6.008800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reported smatch warning:
drivers/block/mtip32xx/mtip32xx.c:4163 mtip_block_shutdown() warn: variable dereferenced before check 'dd->disk' (see line 4159)

dd->disk->disk_name accessed before the check if dd->disk is NULL. Fixed this
and access of dd->queue/dd->disk->queue.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 32c6780..d11ea92 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4156,26 +4156,24 @@ static int mtip_block_remove(struct driver_data *dd)
  */
 static int mtip_block_shutdown(struct driver_data *dd)
 {
-	dev_info(&dd->pdev->dev,
-		"Shutting down %s ...\n", dd->disk->disk_name);
-
 	/* Delete our gendisk structure, and cleanup the blk queue. */
 	if (dd->disk) {
-		if (dd->disk->queue)
+		dev_info(&dd->pdev->dev,
+			"Shutting down %s ...\n", dd->disk->disk_name);
+
+		if (dd->disk->queue) {
 			del_gendisk(dd->disk);
-		else
+			blk_cleanup_queue(dd->queue);
+		} else
 			put_disk(dd->disk);
+		dd->disk  = NULL;
+		dd->queue = NULL;
 	}
 
-
 	spin_lock(&rssd_index_lock);
 	ida_remove(&rssd_index_ida, dd->index);
 	spin_unlock(&rssd_index_lock);
 
-	blk_cleanup_queue(dd->queue);
-	dd->disk  = NULL;
-	dd->queue = NULL;
-
 	mtip_hw_shutdown(dd);
 	return 0;
 }
-- 
1.7.1

