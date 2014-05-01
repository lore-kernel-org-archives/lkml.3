Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbaEAJ6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:58:21 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:41396 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977AbaEAJ6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:58:16 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 33/47] mtd: nand: stm_nand_bch: read and write raw (FLEX)
Date: Thu,  1 May 2014 10:56:40 +0100
Message-Id: <1398938214-17847-34-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once the correct READ/WRITE(SEQIN) commands and address locations have
been sent to the Controller, these calls are able to read/write the
requested information from the FLEX_DATA register.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index aba4bc5..32d2211 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -754,6 +754,41 @@ static void flex_addr(struct nandi_controller *nandi,
 	writel(addr, nandi->base + NANDHAM_FLEX_ADD);
 }
 
+static int flex_read_raw(struct nandi_controller *nandi,
+			 uint32_t page_addr,
+			 uint32_t col_addr,
+			 uint8_t *buf, uint32_t len)
+{
+	dev_dbg(nandi->dev, "%s %u bytes at [0x%06x,0x%04x]\n",
+		__func__, len, page_addr, col_addr);
+
+	BUG_ON(len & 0x3);
+	BUG_ON((unsigned long)buf & 0x3);
+
+	emiss_nandi_select(STM_NANDI_HAMMING);
+	nandi_enable_interrupts(nandi, NAND_INT_RBN);
+	reinit_completion(&nandi->rbn_completed);
+
+	writel(FLEX_DATA_CFG_BEATS_4 | FLEX_DATA_CFG_CSN,
+	       nandi->base + NANDHAM_FLEX_DATAREAD_CONFIG);
+
+	flex_cmd(nandi, NAND_CMD_READ0);
+	flex_addr(nandi, col_addr, 2);
+	flex_addr(nandi, page_addr, nandi->extra_addr ? 3 : 2);
+	flex_cmd(nandi, NAND_CMD_READSTART);
+
+	flex_wait_rbn(nandi);
+
+	readsl(nandi->base + NANDHAM_FLEX_DATA, buf, len / 4);
+
+	nandi_disable_interrupts(nandi, NAND_INT_RBN);
+
+	writel(FLEX_DATA_CFG_BEATS_1 | FLEX_DATA_CFG_CSN,
+	       nandi->base + NANDHAM_FLEX_DATAREAD_CONFIG);
+
+	return 0;
+}
+
 /*
  * Bad Block Tables/Bad Block Markers
  */
-- 
1.8.3.2

