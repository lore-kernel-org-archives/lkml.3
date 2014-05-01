Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbaEAKFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 06:05:12 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:33246 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816AbaEAJ54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:57:56 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 23/47] mtd: nand: stm_nand_bch: erase one block (BCH)
Date: Thu,  1 May 2014 10:56:30 +0100
Message-Id: <1398938214-17847-24-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a function which simply erases a single flash block.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 40767b8..6d7ab79 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -458,6 +458,33 @@ static void bch_wait_seq(struct nandi_controller *nandi)
 		dev_err(nandi->dev, "BCH Seq timeout\n");
 }
 
+static uint8_t bch_erase_block(struct nandi_controller *nandi,
+			       loff_t offs)
+{
+	struct bch_prog *prog = &bch_prog_erase_block;
+	uint8_t status;
+
+	dev_dbg(nandi->dev, "%s: offs = 0x%012llx\n", __func__, offs);
+
+	prog->extra = (uint32_t)(offs >> nandi->page_shift);
+
+	emiss_nandi_select(STM_NANDI_BCH);
+
+	nandi_enable_interrupts(nandi, NANDBCH_INT_SEQNODESOVER);
+	reinit_completion(&nandi->seq_completed);
+
+	bch_load_prog_cpu(nandi, prog);
+
+	bch_wait_seq(nandi);
+
+	nandi_disable_interrupts(nandi, NANDBCH_INT_SEQNODESOVER);
+
+	status = (uint8_t)(readl(nandi->base +
+				 NANDBCH_CHECK_STATUS_REG_A) & 0xff);
+
+	return status;
+}
+
 /*
  * Initialisation
  */
-- 
1.8.3.2

