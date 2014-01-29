Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbaA2Oik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:38:40 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:42867 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaA2Oed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:34:33 -0500
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Boris BREZILLON <b.brezillon.dev@gmail.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        dev@linux-sunxi.org
Subject: [RFC PATCH v2 01/14] mtd: nand: retrieve ECC requirements from Hynix READ ID byte 4
Date: Wed, 29 Jan 2014 15:34:11 +0100
Message-Id: <1391006064-28890-2-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Hynix nand flashes store their ECC requirements in byte 4 of its id
(returned on READ ID command).

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 drivers/mtd/nand/nand_base.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index bd39f7b..15069ec 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -3202,6 +3202,43 @@ static void nand_decode_ext_id(struct mtd_info *mtd, struct nand_chip *chip,
 		else
 			mtd->erasesize = (64 * 1024) << tmp;
 		*busw = 0;
+
+		/* Retrieve ECC infos */
+		switch ((id_data[4] >> 4) & 0x7) {
+		case 1:
+			chip->ecc_step_ds = 512;
+			chip->ecc_strength_ds = 1;
+			break;
+		case 2:
+			chip->ecc_step_ds = 512;
+			chip->ecc_strength_ds = 2;
+			break;
+		case 3:
+			chip->ecc_step_ds = 512;
+			chip->ecc_strength_ds = 4;
+			break;
+		case 4:
+			chip->ecc_step_ds = 512;
+			chip->ecc_strength_ds = 8;
+			break;
+		case 5:
+			chip->ecc_step_ds = 1024;
+			chip->ecc_strength_ds = 24;
+			break;
+		case 6:
+			chip->ecc_step_ds = 1024;
+			chip->ecc_strength_ds = 32;
+			break;
+		case 7:
+			chip->ecc_step_ds = 1024;
+			chip->ecc_strength_ds = 40;
+			break;
+		case 0:
+		default:
+			chip->ecc_step_ds = 0;
+			chip->ecc_strength_ds = 0;
+			break;
+		}
 	} else {
 		/* Calc pagesize */
 		mtd->writesize = 1024 << (extid & 0x03);
-- 
1.7.9.5

