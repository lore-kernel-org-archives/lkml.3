Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab3AKNR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:17:29 -0500
Received: from masquerade.micron.com ([137.201.242.130]:59663 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab3AKNR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:17:26 -0500
Message-ID: <50F010D8.3020901@micron.com>
Date: Fri, 11 Jan 2013 18:47:12 +0530
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sam Bradshaw" <sbradshaw@micron.com>,
        "Selvan Mani (smani) [CONT - Type 2]" <smani@micron.com>
Subject: [PATCH 3/3] mtip32xx: fix for crash when the device surprise removed
 during rebuild
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19546.007
X-TM-AS-Result: No--12.664600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When rebuild is in progress, disk->queue is yet to be created. Surprise
removing the device will call remove()-> del_gendisk(). del_gendisk()
expect disk->queue be not NULL. Fix is to call put_disk() when disk_queue
is NULL.

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index a070a68..cfe65cf 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3967,7 +3967,12 @@ static int mtip_block_remove(struct driver_data *dd)
 	 * Delete our gendisk structure. This also removes the device
 	 * from /dev
 	 */
-	del_gendisk(dd->disk);
+	if (dd->disk) {
+		if (dd->disk->queue)
+			del_gendisk(dd->disk);
+		else
+			put_disk(dd->disk);
+	}
 
 	spin_lock(&rssd_index_lock);
 	ida_remove(&rssd_index_ida, dd->index);
@@ -4001,7 +4006,13 @@ static int mtip_block_shutdown(struct driver_data *dd)
 		"Shutting down %s ...\n", dd->disk->disk_name);
 
 	/* Delete our gendisk structure, and cleanup the blk queue. */
-	del_gendisk(dd->disk);
+	if (dd->disk) {
+		if (dd->disk->queue)
+			del_gendisk(dd->disk);
+		else
+			put_disk(dd->disk);
+	}
+
 
 	spin_lock(&rssd_index_lock);
 	ida_remove(&rssd_index_ida, dd->index);
-- 
1.7.1

