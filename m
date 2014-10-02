Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaJBMQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:16:24 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34746 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbaJBMQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:16:22 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
X-Google-Original-From: Rostislav Lisovy <lisovy@merica.cz>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Roger Quadros <rogerq@ti.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lisovy@gmail.com, michal.vokac@comap.cz, sojkam1@fel.cvut.cz,
        Rostislav Lisovy <lisovy@merica.cz>
Subject: [PATCH v2 1/2] mtd: nand: omap: Do not use global variables
Date: Thu,  2 Oct 2014 14:16:12 +0200
Message-Id: <1412252173-20454-1-git-send-email-lisovy@merica.cz>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the commit 97a288ba2cfa ("ARM: omap2+: gpmc-nand: Use
dynamic platform_device_alloc()") gpmc-nand driver supports
multiple NAND flash devices connected to the single controller.
Remove global variable to make the code thread-safe.

Signed-off-by: Rostislav Lisovy <lisovy@merica.cz>
---
Changes since v1:
* Do not dynamically allocate the 'struct nand_ecclayout' but rather
  include it in the 'struct omap_nand_info' (Roger Quadros)


 drivers/mtd/nand/omap2.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 3b357e9..f0dcdb6 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -144,9 +144,6 @@ static u_char bch8_vector[] = {0xf3, 0xdb, 0x14, 0x16, 0x8b, 0xd2, 0xbe, 0xcc,
 	0xac, 0x6b, 0xff, 0x99, 0x7b};
 static u_char bch4_vector[] = {0x00, 0x6b, 0x31, 0xdd, 0x41, 0xbc, 0x10};
 
-/* oob info generated runtime depending on ecc algorithm and layout selected */
-static struct nand_ecclayout omap_oobinfo;
-
 struct omap_nand_info {
 	struct nand_hw_control		controller;
 	struct omap_nand_platform_data	*pdata;
@@ -168,6 +165,8 @@ struct omap_nand_info {
 	u_char				*buf;
 	int					buf_len;
 	struct gpmc_nand_regs		reg;
+	/* generated on runtime depending on ecc algorithm and layout selected */
+	struct nand_ecclayout		oobinfo;
 	/* fields specific for BCHx_HW ECC scheme */
 	struct device			*elm_dev;
 	struct device_node		*of_node;
@@ -1840,7 +1839,7 @@ static int omap_nand_probe(struct platform_device *pdev)
 	}
 
 	/* populate MTD interface based on ECC scheme */
-	ecclayout		= &omap_oobinfo;
+	ecclayout		= &info->oobinfo;
 	switch (info->ecc_opt) {
 	case OMAP_ECC_HAM1_CODE_SW:
 		nand_chip->ecc.mode = NAND_ECC_SOFT;
-- 
1.9.1

