Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbaEAKCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 06:02:44 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:54534 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953AbaEAJ6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:58:14 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 32/47] mtd: nand: stm_nand_bch: add Hamming-FLEX operations
Date: Thu,  1 May 2014 10:56:39 +0100
Message-Id: <1398938214-17847-33-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Including; a check for Ready/NotBusy (RBn) (i.e. wait for current
operation to finish and a method to issue Flex commands to the
controller.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index e909d80..aba4bc5 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -719,6 +719,42 @@ static int bch_write(struct mtd_info *mtd, struct nand_chip *chip,
 }
 
 /*
+ * Hamming-FLEX operations
+ */
+static int flex_wait_rbn(struct nandi_controller *nandi)
+{
+	int ret;
+
+	ret = wait_for_completion_timeout(&nandi->rbn_completed, HZ/2);
+	if (!ret)
+		dev_err(nandi->dev, "FLEX RBn timeout\n");
+
+	return ret;
+}
+
+static void flex_cmd(struct nandi_controller *nandi, uint8_t cmd)
+{
+	uint32_t val;
+
+	val = (FLEX_CMD_CSN | FLEX_CMD_BEATS_1 | cmd);
+	writel(val, nandi->base + NANDHAM_FLEX_CMD);
+}
+
+static void flex_addr(struct nandi_controller *nandi,
+		      uint32_t addr, int cycles)
+{
+	addr &= 0x00ffffff;
+
+	BUG_ON(cycles < 1);
+	BUG_ON(cycles > 3);
+
+	addr |= (FLEX_ADDR_CSN | FLEX_ADDR_ADD8_VALID);
+	addr |= (cycles & 0x3) << 28;
+
+	writel(addr, nandi->base + NANDHAM_FLEX_ADD);
+}
+
+/*
  * Bad Block Tables/Bad Block Markers
  */
 #define BBT_MARK_BAD_FACTORY	0x0
-- 
1.8.3.2

