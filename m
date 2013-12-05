Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933704Ab3LER7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:59:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38107 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab3LERgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:36:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Brian Norris <computersforpeace@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 17/90] mtd: m25p80: fix allocation size
Date: Thu,  5 Dec 2013 17:34:59 +0000
Message-Id: <1386264972-5399-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mtd/devices/m25p80.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 5d0d68c..e857734 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -71,7 +71,7 @@
 
 /* Define max times to check status register before we give up. */
 #define	MAX_READY_WAIT_JIFFIES	(40 * HZ)	/* M25P16 specs 40s max chip erase */
-#define	MAX_CMD_SIZE		5
+#define	MAX_CMD_SIZE		6
 
 #ifdef CONFIG_M25PXX_USE_FAST_READ
 #define OPCODE_READ 	OPCODE_FAST_READ
@@ -848,14 +848,13 @@ static int __devinit m25p_probe(struct spi_device *spi)
 		}
 	}
 
-	flash = kzalloc(sizeof *flash, GFP_KERNEL);
+	flash = devm_kzalloc(&spi->dev, sizeof(*flash), GFP_KERNEL);
 	if (!flash)
 		return -ENOMEM;
-	flash->command = kmalloc(MAX_CMD_SIZE + FAST_READ_DUMMY_BYTE, GFP_KERNEL);
-	if (!flash->command) {
-		kfree(flash);
+
+	flash->command = devm_kzalloc(&spi->dev, MAX_CMD_SIZE, GFP_KERNEL);
+	if (!flash->command)
 		return -ENOMEM;
-	}
 
 	flash->spi = spi;
 	mutex_init(&flash->lock);
@@ -952,14 +951,10 @@ static int __devinit m25p_probe(struct spi_device *spi)
 static int __devexit m25p_remove(struct spi_device *spi)
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

