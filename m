Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaBXRai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:30:38 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:55338 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbaBXRaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:30:01 -0500
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: [RFC PATCH 1/2] mtd: nand: add manufacturer specific init infrastructure
Date: Mon, 24 Feb 2014 18:29:52 +0100
Message-Id: <1393262993-22040-2-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393262993-22040-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1393262993-22040-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new fields in nand_manufacturers and nand_chip struct to provide
manufacturer specific handling like read retries.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 drivers/mtd/nand/nand_base.c |    7 +++++++
 include/linux/mtd/nand.h     |    4 ++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 9715a7b..8b16479 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -3610,6 +3610,13 @@ ident_done:
 	if (mtd->writesize > 512 && chip->cmdfunc == nand_command)
 		chip->cmdfunc = nand_command_lp;
 
+	if (nand_manuf_ids[maf_idx].init) {
+		int err;
+		err = nand_manuf_ids[maf_idx].init(mtd, id_data);
+		if (err)
+			return ERR_PTR(err);
+	}
+
 	pr_info("device found, Manufacturer ID: 0x%02x, Chip ID: 0x%02x\n",
 		*maf_id, *dev_id);
 	pr_info("%s %s\n", nand_manuf_ids[maf_idx].name,
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 32f8612..6189312 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -575,6 +575,9 @@ struct nand_chip {
 	int (*onfi_get_features)(struct mtd_info *mtd, struct nand_chip *chip,
 			int feature_addr, uint8_t *subfeature_para);
 	int (*setup_read_retry)(struct mtd_info *mtd, int retry_mode);
+	void (*manuf_cleanup)(struct mtd_info *mtd);
+
+	void *manuf_priv;
 
 	int chip_delay;
 	unsigned int options;
@@ -720,6 +723,7 @@ struct nand_flash_dev {
 struct nand_manufacturers {
 	int id;
 	char *name;
+	int (*init)(struct mtd_info *mtd, const uint8_t *id);
 };
 
 extern struct nand_flash_dev nand_flash_ids[];
-- 
1.7.9.5

