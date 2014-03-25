Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaCYIVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:21:51 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:40213 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbaCYIVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:21:47 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 46/47] mtd: nand: mtd_nand_bch: add remaining FLEX functions
Date: Tue, 25 Mar 2014 08:20:03 +0000
Message-Id: <1395735604-26706-47-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Including a dummy function for selecting chips which isn't supported by
our driver, the wait function as requested by the NAND sub system, a read
Byte function also requested by NAND and finally a command function which
provides a partial implementation of MTD/NAND Interface, based on
Hamming-FLEX operation which allows us to make use of nand_base.c functions
where possible (i.e.nand_scan_ident()).

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 101 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 975326e..4103d4f 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -686,6 +686,103 @@ static void flex_addr(struct nandi_controller *nandi,
 	writel(addr, nandi->base + NANDHAM_FLEX_ADD);
 }
 
+/*
+ * Partial implementation of MTD/NAND Interface, based on Hamming-FLEX
+ * operation.
+ *
+ * Allows us to make use of nand_base.c functions where possible
+ * (e.g. nand_scan_ident() and friends).
+ */
+static void flex_command_lp(struct mtd_info *mtd, unsigned int command,
+			    int column, int page)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nandi_controller *nandi = chip->priv;
+
+	emiss_nandi_select(STM_NANDI_HAMMING);
+
+	switch (command) {
+	case NAND_CMD_READOOB:
+		/* Emulate NAND_CMD_READOOB */
+		column += mtd->writesize;
+		command = NAND_CMD_READ0;
+		break;
+	case NAND_CMD_READ0:
+	case NAND_CMD_ERASE1:
+	case NAND_CMD_SEQIN:
+	case NAND_CMD_RESET:
+	case NAND_CMD_PARAM:
+		/* Prime RBn wait */
+		nandi_enable_interrupts(nandi, NAND_INT_RBN);
+		reinit_completion(&nandi->rbn_completed);
+		break;
+	case NAND_CMD_READID:
+	case NAND_CMD_STATUS:
+	case NAND_CMD_ERASE2:
+		break;
+	default:
+		/* Catch unexpected commands */
+		BUG();
+	}
+
+	/*
+	 * Command Cycle
+	 */
+	flex_cmd(nandi, command);
+
+	/*
+	 * Address Cycles
+	 */
+	if (column != -1)
+		flex_addr(nandi, column,
+			  (command == NAND_CMD_READID) ? 1 : 2);
+
+	if (page != -1)
+		flex_addr(nandi, page, nandi->extra_addr ? 3 : 2);
+
+	/* Complete 'READ0' command */
+	if (command == NAND_CMD_READ0)
+		flex_cmd(nandi, NAND_CMD_READSTART);
+
+	/* Wait for RBn, if required                        */
+	/* (Note, other commands may handle wait elsewhere) */
+	if (command == NAND_CMD_RESET ||
+	    command == NAND_CMD_READ0 ||
+	    command == NAND_CMD_PARAM) {
+		flex_wait_rbn(nandi);
+		nandi_disable_interrupts(nandi, NAND_INT_RBN);
+	}
+}
+
+static uint8_t flex_read_byte(struct mtd_info *mtd)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nandi_controller *nandi = chip->priv;
+
+	emiss_nandi_select(STM_NANDI_HAMMING);
+
+	return (uint8_t)(readl(nandi->base + NANDHAM_FLEX_DATA) & 0xff);
+}
+
+static int flex_wait_func(struct mtd_info *mtd, struct nand_chip *chip)
+{
+	struct nandi_controller *nandi = chip->priv;
+
+	emiss_nandi_select(STM_NANDI_HAMMING);
+
+	flex_wait_rbn(nandi);
+
+	flex_cmd(nandi, NAND_CMD_STATUS);
+
+	return (int)(readl(nandi->base + NANDHAM_FLEX_DATA) & 0xff);
+}
+
+/* Multi-CS devices not supported */
+static void flex_select_chip(struct mtd_info *mtd, int chipnr)
+{
+
+}
+
 static void flex_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
 {
 	struct nand_chip *chip = mtd->priv;
@@ -1812,6 +1909,10 @@ static void nandi_set_mtd_defaults(struct nandi_controller *nandi,
 	chip->priv = nandi;
 	chip->ecc.layout = &info->ecclayout;
 
+	chip->cmdfunc = flex_command_lp;
+	chip->read_byte = flex_read_byte;
+	chip->select_chip = flex_select_chip;
+	chip->waitfunc = flex_wait_func;
 	chip->read_buf = flex_read_buf;
 	chip->write_buf = flex_write_buf;
 
-- 
1.8.3.2

