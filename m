Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab3L2CSm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:18:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55653 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753707Ab3L2CLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:11:18 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Brian Norris" <computersforpeace@gmail.com>,
        "Sourav Poddar" <sourav.poddar@ti.com>,
        "Yuhang Wang" <wangyuhang2014@gmail.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.422923750@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 035/185] mtd: m25p80: fix allocation size
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mtd/devices/m25p80.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -71,7 +71,7 @@
 
 /* Define max times to check status register before we give up. */
 #define	MAX_READY_WAIT_JIFFIES	(40 * HZ)	/* M25P16 specs 40s max chip erase */
-#define	MAX_CMD_SIZE		5
+#define	MAX_CMD_SIZE		6
 
 #ifdef CONFIG_M25PXX_USE_FAST_READ
 #define OPCODE_READ 	OPCODE_FAST_READ
@@ -874,14 +874,13 @@ static int __devinit m25p_probe(struct s
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
@@ -978,14 +977,10 @@ static int __devinit m25p_probe(struct s
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
 

