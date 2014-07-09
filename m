Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbaGIMio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:38:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36389 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755776AbaGIMij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:38:39 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <computersforpeace@gmail.com>
CC: <javier@dowhile0.org>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <dwmw2@infradead.org>,
        <jg1.han@samsung.com>, <nsekhar@ti.com>,
        <linux-mtd@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 04/10] mtd: nand: omap: Use GPMC APIs for NAND control
Date: Wed, 9 Jul 2014 15:37:24 +0300
Message-ID: <1404909450-11970-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404909450-11970-1-git-send-email-rogerq@ti.com>
References: <1404909450-11970-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the omap_gpmc_read_reg() and omap_gpmc_write_reg() APIs to
access the GPMC_STATUS, NAND_COMMAND, NAND_ADDRESS and NAND_DATA
registers from the GPMC register space.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mtd/nand/omap2.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 6f3d7cd..f50e71d 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -24,7 +24,7 @@
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-
+#include <linux/omap-gpmc-nand.h>
 #include <linux/mtd/nand_bch.h>
 #include <linux/platform_data/elm.h>
 
@@ -251,13 +251,16 @@ static void omap_hwcontrol(struct mtd_info *mtd, int cmd, unsigned int ctrl)
 
 	if (cmd != NAND_CMD_NONE) {
 		if (ctrl & NAND_CLE)
-			writeb(cmd, info->reg.gpmc_nand_command);
+			omap_gpmc_write_reg(info->gpmc_cs,
+					    OMAP_GPMC_NAND_COMMAND, cmd);
 
 		else if (ctrl & NAND_ALE)
-			writeb(cmd, info->reg.gpmc_nand_address);
+			omap_gpmc_write_reg(info->gpmc_cs,
+					    OMAP_GPMC_NAND_ADDRESS, cmd);
 
 		else /* NAND_NCE */
-			writeb(cmd, info->reg.gpmc_nand_data);
+			omap_gpmc_write_reg(info->gpmc_cs,
+					    OMAP_GPMC_NAND_DATA, cmd);
 	}
 }
 
@@ -291,7 +294,7 @@ static void omap_write_buf8(struct mtd_info *mtd, const u_char *buf, int len)
 		iowrite8(*p++, info->nand.IO_ADDR_W);
 		/* wait until buffer is available for write */
 		do {
-			status = readl(info->reg.gpmc_status) &
+			status = omap_gpmc_read_reg(0, OMAP_GPMC_STATUS) &
 					STATUS_BUFF_EMPTY;
 		} while (!status);
 	}
@@ -329,7 +332,7 @@ static void omap_write_buf16(struct mtd_info *mtd, const u_char * buf, int len)
 		iowrite16(*p++, info->nand.IO_ADDR_W);
 		/* wait until buffer is available for write */
 		do {
-			status = readl(info->reg.gpmc_status) &
+			status = omap_gpmc_read_reg(0, OMAP_GPMC_STATUS) &
 					STATUS_BUFF_EMPTY;
 		} while (!status);
 	}
@@ -1011,15 +1014,16 @@ static int omap_wait(struct mtd_info *mtd, struct nand_chip *chip)
 	else
 		timeo += msecs_to_jiffies(20);
 
-	writeb(NAND_CMD_STATUS & 0xFF, info->reg.gpmc_nand_command);
+	omap_gpmc_write_reg(info->gpmc_cs, OMAP_GPMC_NAND_COMMAND,
+			    NAND_CMD_STATUS);
 	while (time_before(jiffies, timeo)) {
-		status = readb(info->reg.gpmc_nand_data);
+		status = omap_gpmc_read_reg(info->gpmc_cs, OMAP_GPMC_NAND_DATA);
 		if (status & NAND_STATUS_READY)
 			break;
 		cond_resched();
 	}
 
-	status = readb(info->reg.gpmc_nand_data);
+	status = omap_gpmc_read_reg(info->gpmc_cs, OMAP_GPMC_NAND_DATA);
 	return status;
 }
 
@@ -1030,10 +1034,8 @@ static int omap_wait(struct mtd_info *mtd, struct nand_chip *chip)
 static int omap_dev_ready(struct mtd_info *mtd)
 {
 	unsigned int val = 0;
-	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
-							mtd);
 
-	val = readl(info->reg.gpmc_status);
+	val = omap_gpmc_read_reg(0, OMAP_GPMC_STATUS);
 
 	if ((val & 0x100) == 0x100) {
 		return 1;
-- 
1.8.3.2

