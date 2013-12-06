Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422895Ab3LFXQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:16:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48641 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422840Ab3LFXQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:16:48 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Brian Norris <computersforpeace@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 070/152] mtd: m25p80: fix allocation size
Date: Fri,  6 Dec 2013 15:09:54 -0800
Message-Id: <1386371476-2477-71-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <computersforpeace@gmail.com>

commit 778d226a1462572b51d6777cdb1d611543410cb4 upstream.

This patch fixes two memory errors:

1. During a probe failure (in mtd_device_parse_register?) the command
   buffer would not be freed.

2. The command buffer's size is determined based on the 'fast_read'
   boolean, but the assignment of fast_read is made after this
   allocation. Thus, the buffer may be allocated "too small".

To fix the first, just switch to the devres version of kzalloc.

To fix the second, increase MAX_CMD_SIZE unconditionally. It's not worth
saving a byte to fiddle around with the conditions here.

This problem was reported by Yuhang Wang a while back.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Reported-by: Yuhang Wang <wangyuhang2014@gmail.com>
Reviewed-by: Sourav Poddar <sourav.poddar@ti.com>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mtd/devices/m25p80.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 4eeeb2d..ae5ccf5 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -71,7 +71,7 @@
 
 /* Define max times to check status register before we give up. */
 #define	MAX_READY_WAIT_JIFFIES	(40 * HZ)	/* M25P16 specs 40s max chip erase */
-#define	MAX_CMD_SIZE		5
+#define	MAX_CMD_SIZE		6
 
 #define JEDEC_MFR(_jedec_id)	((_jedec_id) >> 16)
 
@@ -861,15 +861,13 @@ static int m25p_probe(struct spi_device *spi)
 		}
 	}
 
-	flash = kzalloc(sizeof *flash, GFP_KERNEL);
+	flash = devm_kzalloc(&spi->dev, sizeof(*flash), GFP_KERNEL);
 	if (!flash)
 		return -ENOMEM;
-	flash->command = kmalloc(MAX_CMD_SIZE + (flash->fast_read ? 1 : 0),
-					GFP_KERNEL);
-	if (!flash->command) {
-		kfree(flash);
+
+	flash->command = devm_kzalloc(&spi->dev, MAX_CMD_SIZE, GFP_KERNEL);
+	if (!flash->command)
 		return -ENOMEM;
-	}
 
 	flash->spi = spi;
 	mutex_init(&flash->lock);
@@ -976,14 +974,10 @@ static int m25p_probe(struct spi_device *spi)
 static int m25p_remove(struct spi_device *spi)
 {
 	struct m25p	*flash = dev_get_drvdata(&spi->dev);
-	int		status;
 
 	/* Clean up MTD stuff. */
-	status = mtd_device_unregister(&flash->mtd);
-	if (status == 0) {
-		kfree(flash->command);
-		kfree(flash);
-	}
+	mtd_device_unregister(&flash->mtd);
+
 	return 0;
 }
 
-- 
1.8.3.2

