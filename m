Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbaBKVrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:47:36 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:36855 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbaBKVrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:47:33 -0500
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gupta Pekon <pekon@ti.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: [RFC PATCH v2 4/4] mtd: nand: add NAND partition support to the sunxi driver
Date: Tue, 11 Feb 2014 22:46:49 +0100
Message-Id: <1392155209-14495-5-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392155209-14495-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1392155209-14495-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 drivers/mtd/nand/sunxi_nand.c |   69 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 66 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/sunxi_nand.c b/drivers/mtd/nand/sunxi_nand.c
index f24ad8b..4693d9f 100644
--- a/drivers/mtd/nand/sunxi_nand.c
+++ b/drivers/mtd/nand/sunxi_nand.c
@@ -168,6 +168,17 @@ struct sunxi_nand_hw_ecc {
 	struct nand_ecclayout layout;
 };
 
+struct sunxi_nand_part {
+	struct nand_part part;
+	struct nand_ecc_ctrl ecc;
+};
+
+static inline struct sunxi_nand_part *
+to_sunxi_nand_part(struct nand_part *part)
+{
+	return container_of(part, struct sunxi_nand_part, part);
+}
+
 struct sunxi_nand_chip {
 	struct list_head node;
 	struct nand_chip nand;
@@ -780,12 +791,58 @@ static int sunxi_nand_chip_ecc_init(struct device *dev,
 	return 0;
 }
 
+static void sunxi_nand_part_release(struct nand_part *part)
+{
+	kfree(to_sunxi_nand_part(part));
+}
+
+struct nand_part *sunxi_ofnandpart_parse(void *priv, struct mtd_info *master,
+					 struct device_node *pp)
+{
+	int mode = of_get_nand_ecc_mode(pp);
+	struct sunxi_nand_part *part;
+	struct nand_chip *chip = master->priv;
+	u32 strength;
+	u32 blk_size;
+
+	if (mode < 0)
+		return nandpart_alloc();
+
+	part = kzalloc(sizeof(*part), GFP_KERNEL);
+	part->part.release = sunxi_nand_part_release;
+
+	part->ecc.size = chip->ecc_step_ds;
+	part->ecc.strength = chip->ecc_strength_ds;
+	if (!of_get_nand_ecc_level(pp, &strength, &blk_size)) {
+		part->ecc.size = blk_size;
+		part->ecc.strength = strength;
+	}
+
+	part->ecc.mode = mode;
+	switch (mode) {
+	case NAND_ECC_SOFT_BCH:
+		part->ecc.bytes = ((part->ecc.strength *
+				    fls(8 * part->ecc.size)) + 7) / 8;
+		break;
+	case NAND_ECC_HW:
+		break;
+	case NAND_ECC_NONE:
+		break;
+	default:
+		break;
+	}
+
+	part->part.ecc = &part->ecc;
+
+	return &part->part;
+}
+
 static int sunxi_nand_chip_init(struct device *dev, struct sunxi_nfc *nfc,
 				struct device_node *np)
 {
 	const struct nand_sdr_timings *timings;
 	struct sunxi_nand_chip *chip;
-	struct mtd_part_parser_data ppdata;
+	struct ofnandpart_data ppdata;
 	struct mtd_info *mtd;
 	struct nand_chip *nand;
 	int nsels;
@@ -889,9 +946,15 @@ static int sunxi_nand_chip_init(struct device *dev, struct sunxi_nfc *nfc,
 		mtd->name = chip->default_name;
 	}
 
-	ppdata.of_node = np;
-	ret = mtd_device_parse_register(mtd, NULL, &ppdata, NULL, 0);
+	ppdata.node = np;
+	ppdata.parse = sunxi_ofnandpart_parse;
+	ret = ofnandpart_parse(mtd, &ppdata);
 	if (!ret)
+		ret = mtd_device_register(mtd, NULL, 0);
+	else if (ret > 0)
+		ret = 0;
+
+	if (ret)
 		return ret;
 
 	list_add_tail(&chip->node, &nfc->chips);
-- 
1.7.9.5

