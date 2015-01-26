Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbbAZPAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:00:12 -0500
Received: from down.free-electrons.com ([37.187.137.238]:36394 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751517AbbAZPAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:00:05 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Gregory Clement <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Brian Norris <computersforpeace@gmail.com>
Cc: linux-mtd@lists.infradead.org, Boris Brezillon <boris@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Lior Amsalem <alior@marvell.com>, linux-kernel@vger.kernel.org,
        Sudhakar Gundubogula <sudhakar@marvell.com>,
        Seif Mazareeb <seif@marvell.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 1/2] mtd: nand: pxa3xx: Fix PIO FIFO draining
Date: Mon, 26 Jan 2015 15:56:03 +0100
Message-Id: <1422284164-16867-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422284164-16867-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1422284164-16867-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NDDB register holds the data that are needed by the read and write
commands.

However, during a read PIO access, the datasheet specifies that after each 32
bits read in that register, when BCH is enabled, we have to make sure that the
RDDREQ bit is set in the NDSR register.

This fixes an issue that was seen on the Armada 385, and presumably other mvebu
SoCs, when a read on a newly erased page would end up in the driver reporting a
timeout from the NAND.

Cc: <stable@vger.kernel.org> # v3.14
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/mtd/nand/pxa3xx_nand.c | 45 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
index 96b0b1d27df1..e6918befb951 100644
--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -23,6 +23,7 @@
 #include <linux/mtd/partitions.h>
 #include <linux/io.h>
 #include <linux/irq.h>
+#include <linux/jiffies.h>
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -480,6 +481,38 @@ static void disable_int(struct pxa3xx_nand_info *info, uint32_t int_mask)
 	nand_writel(info, NDCR, ndcr | int_mask);
 }
 
+static void drain_fifo(struct pxa3xx_nand_info *info, void *data, int len)
+{
+	u32 *dst = (u32 *)data;
+
+	if (info->ecc_bch) {
+		while (len--) {
+			u32 timeout;
+
+			*dst++ = nand_readl(info, NDDB);
+
+			/*
+			 * According to the datasheet, when reading
+			 * from NDDB with BCH enabled, after each 32
+			 * bits reads, we have to make sure that the
+			 * NDSR.RDDREQ bit is set
+			 */
+			timeout = jiffies + msecs_to_jiffies(5);
+			while (!(nand_readl(info, NDSR) & NDSR_RDDREQ)) {
+				if (!time_before(jiffies, timeout)) {
+					dev_err(&info->pdev->dev,
+						"Timeout on RDDREQ while draining the FIFO\n");
+					return;
+				}
+
+				cpu_relax();
+			}
+		}
+	} else {
+		__raw_readsl(info->mmio_base + NDDB, data, len);
+	}
+}
+
 static void handle_data_pio(struct pxa3xx_nand_info *info)
 {
 	unsigned int do_bytes = min(info->data_size, info->chunk_size);
@@ -496,14 +529,14 @@ static void handle_data_pio(struct pxa3xx_nand_info *info)
 				      DIV_ROUND_UP(info->oob_size, 4));
 		break;
 	case STATE_PIO_READING:
-		__raw_readsl(info->mmio_base + NDDB,
-			     info->data_buff + info->data_buff_pos,
-			     DIV_ROUND_UP(do_bytes, 4));
+		drain_fifo(info,
+			   info->data_buff + info->data_buff_pos,
+			   DIV_ROUND_UP(do_bytes, 4));
 
 		if (info->oob_size > 0)
-			__raw_readsl(info->mmio_base + NDDB,
-				     info->oob_buff + info->oob_buff_pos,
-				     DIV_ROUND_UP(info->oob_size, 4));
+			drain_fifo(info,
+				   info->oob_buff + info->oob_buff_pos,
+				   DIV_ROUND_UP(info->oob_size, 4));
 		break;
 	default:
 		dev_err(&info->pdev->dev, "%s: invalid state %d\n", __func__,
-- 
2.2.2

