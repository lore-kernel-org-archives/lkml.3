Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaIVSL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:11:59 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50855 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754563AbaIVSL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:11:57 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Yassin Jaffer <yassinjaffer@gmail.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 1/2] mtd: nand: support ONFI timing mode retrieval for non-ONFI NANDs
Date: Mon, 22 Sep 2014 20:11:50 +0200
Message-Id: <1411409511-4381-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411409511-4381-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1411409511-4381-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an onfi_timing_mode_default field to nand_chip and nand_flash_dev in
order to support NAND timings definition for non-ONFI NAND.

NAND that support better timings mode than the default one have to define
a new entry in the nand_ids table.

The default timing mode should be deduced from timings description from
the datasheet and the ONFI specification
(www.onfi.org/~/media/ONFI/specs/onfi_3_1_spec.pdf, chapter 4.15
"Timing Parameters").
You should choose the closest mode that fit the timings requirements of
your NAND chip.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/mtd/nand/nand_base.c |  2 ++
 include/linux/mtd/nand.h     | 11 +++++++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index ae6e7c4..c37fa2a 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -3594,6 +3594,8 @@ static bool find_full_id_nand(struct mtd_info *mtd, struct nand_chip *chip,
 		chip->options |= type->options;
 		chip->ecc_strength_ds = NAND_ECC_STRENGTH(type);
 		chip->ecc_step_ds = NAND_ECC_STEP(type);
+		chip->onfi_timing_mode_default =
+					type->onfi_timing_mode_default;
 
 		*busw = type->options & NAND_BUSWIDTH_16;
 
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index b7c1199..b0b74cc 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -587,6 +587,11 @@ struct nand_buffers {
  * @ecc_step_ds:	[INTERN] ECC step required by the @ecc_strength_ds,
  *                      also from the datasheet. It is the recommended ECC step
  *			size, if known; if unknown, set to zero.
+ * @onfi_timing_mode_default: [INTERN] default ONFI timing mode. This field is
+ *			      either deduced from the datasheet if the NAND
+ *			      chip is not ONFI compliant or set to 0 if it is
+ *			      (an ONFI chip is always configured in mode 0
+ *			      after a NAND reset)
  * @numchips:		[INTERN] number of physical chips
  * @chipsize:		[INTERN] the size of one chip for multichip arrays
  * @pagemask:		[INTERN] page number mask = number of (pages / chip) - 1
@@ -671,6 +676,7 @@ struct nand_chip {
 	uint8_t bits_per_cell;
 	uint16_t ecc_strength_ds;
 	uint16_t ecc_step_ds;
+	int onfi_timing_mode_default;
 	int badblockpos;
 	int badblockbits;
 
@@ -773,6 +779,10 @@ struct nand_chip {
  *               @ecc_step_ds in nand_chip{}, also from the datasheet.
  *               For example, the "4bit ECC for each 512Byte" can be set with
  *               NAND_ECC_INFO(4, 512).
+ * @onfi_timing_mode_default: the default ONFI timing mode entered after a NAND
+ *			      reset. Should be deduced from timings described
+ *			      in the datasheet.
+ *
  */
 struct nand_flash_dev {
 	char *name;
@@ -793,6 +803,7 @@ struct nand_flash_dev {
 		uint16_t strength_ds;
 		uint16_t step_ds;
 	} ecc;
+	int onfi_timing_mode_default;
 };
 
 /**
-- 
1.9.1

