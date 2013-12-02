Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab3LBUIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:08:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39211 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab3LBTRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Brian Norris <computersforpeace@gmail.com>,
        Yuhang Wang <wangyuhang2014@gmail.com>,
        Sourav Poddar <sourav.poddar@ti.com>
Subject: [PATCH 3.12 069/212] mtd: m25p80: fix allocation size
Date: Mon,  2 Dec 2013 11:14:20 -0800
Message-Id: <20131202191255.637787419@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/devices/m25p80.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -78,7 +78,7 @@
 
 /* Define max times to check status register before we give up. */
 #define	MAX_READY_WAIT_JIFFIES	(40 * HZ)	/* M25P16 specs 40s max chip erase */
-#define	MAX_CMD_SIZE		5
+#define	MAX_CMD_SIZE		6
 
 #define JEDEC_MFR(_jedec_id)	((_jedec_id) >> 16)
 
@@ -992,15 +992,13 @@ static int m25p_probe(struct spi_device
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
@@ -1133,14 +1131,10 @@ static int m25p_probe(struct spi_device
 static int m25p_remove(struct spi_device *spi)
 {
 	struct m25p	*flash = spi_get_drvdata(spi);
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
 


