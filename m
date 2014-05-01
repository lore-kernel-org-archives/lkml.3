Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbaEAKAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 06:00:01 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:61376 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116AbaEAJ6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:58:33 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 43/47] mtd: nand: stm_nand_bch: read and write buffers (FLEX)
Date: Thu,  1 May 2014 10:56:50 +0100
Message-Id: <1398938214-17847-44-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

read or write in 4 Byte chunks at a time until there is less than
8 Bytes remaining, at which point split down into reading the
reset a single Byte at a time.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 72 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 046e435..ba6ac8f 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -770,6 +770,75 @@ static void flex_addr(struct nandi_controller *nandi,
 	writel(addr, nandi->base + NANDHAM_FLEX_ADD);
 }
 
+static void flex_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nandi_controller *nandi = chip->priv;
+	int aligned;
+
+	emiss_nandi_select(STM_NANDI_HAMMING);
+
+	/* Read bytes until buf is 4-byte aligned */
+	while (len && ((unsigned int)buf & 0x3)) {
+		*buf++ = (uint8_t)(readl(nandi->base + NANDHAM_FLEX_DATA)
+				   & 0xff);
+		len--;
+	};
+
+	/* Use 'BEATS_4'/readsl */
+	if (len > 8) {
+		aligned = len & ~0x3;
+		writel(FLEX_DATA_CFG_BEATS_4 | FLEX_DATA_CFG_CSN,
+		       nandi->base + NANDHAM_FLEX_DATAREAD_CONFIG);
+
+		readsl(nandi->base + NANDHAM_FLEX_DATA, buf, aligned >> 2);
+
+		buf += aligned;
+		len -= aligned;
+
+		writel(FLEX_DATA_CFG_BEATS_1 | FLEX_DATA_CFG_CSN,
+		       nandi->base + NANDHAM_FLEX_DATAREAD_CONFIG);
+	}
+
+	/* Mop up remaining bytes */
+	while (len > 0) {
+		*buf++ = (uint8_t)(readl(nandi->base + NANDHAM_FLEX_DATA)
+				   & 0xff);
+		len--;
+	}
+}
+
+static void flex_write_buf(struct mtd_info *mtd, const uint8_t *buf, int len)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nandi_controller *nandi = chip->priv;
+	int aligned;
+
+	/* Write bytes until buf is 4-byte aligned */
+	while (len && ((unsigned int)buf & 0x3)) {
+		writel(*buf++, nandi->base + NANDHAM_FLEX_DATA);
+		len--;
+	};
+
+	/* USE 'BEATS_4/writesl */
+	if (len > 8) {
+		aligned = len & ~0x3;
+		writel(FLEX_DATA_CFG_BEATS_4 | FLEX_DATA_CFG_CSN,
+		       nandi->base + NANDHAM_FLEX_DATAWRITE_CONFIG);
+		writesl(nandi->base + NANDHAM_FLEX_DATA, buf, aligned >> 2);
+		buf += aligned;
+		len -= aligned;
+		writel(FLEX_DATA_CFG_BEATS_1 | FLEX_DATA_CFG_CSN,
+		       nandi->base + NANDHAM_FLEX_DATAWRITE_CONFIG);
+	}
+
+	/* Mop up remaining bytes */
+	while (len > 0) {
+		writel(*buf++, nandi->base + NANDHAM_FLEX_DATA);
+		len--;
+	}
+}
+
 static int flex_read_raw(struct nandi_controller *nandi,
 			 uint32_t page_addr,
 			 uint32_t col_addr,
@@ -1416,6 +1485,9 @@ static void nandi_set_mtd_defaults(struct nandi_controller *nandi,
 	chip->ecc.layout = &info->ecclayout;
 	chip->options |= NAND_NO_SUBPAGE_WRITE;
 
+	chip->read_buf = flex_read_buf;
+	chip->write_buf = flex_write_buf;
+
 	chip->bbt_options |= NAND_BBT_USE_FLASH;
 
 	/* mtd_info */
-- 
1.8.3.2

