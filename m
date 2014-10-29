Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607AbaJ2KLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:11:14 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45651 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbaJ2KLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:11:08 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
X-Google-Original-From: Rostislav Lisovy <lisovy@merica.cz>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Roger Quadros <rogerq@ti.com>, sojkam1@fel.cvut.cz, michal.vokac@comap.cz,
        lisovy@gmail.com, Rostislav Lisovy <lisovy@merica.cz>
Subject: [PATCH v4] mtd: nand: omap: Synchronize the access to the ECC engine
Date: Wed, 29 Oct 2014 11:10:59 +0100
Message-Id: <1414577459-26135-1-git-send-email-lisovy@merica.cz>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AM335x Technical Reference Manual (spruh73j.pdf) says
"Because the ECC engine includes only one accumulation context,
it can be allocated to only one chip-select at a time ... "
(7.1.3.3.12.3). Since the commit 97a288ba2cfa ("ARM: omap2+:
gpmc-nand: Use dynamic platform_device_alloc()") gpmc-nand
driver supports multiple NAND flash devices connected to
the single controller.
Use global 'struct nand_hw_control' among multiple NAND
instances to synchronize the access to the single ECC Engine.

Tested with custom AM335x board using 2x NAND flash chips.

Signed-off-by: Rostislav Lisovy <lisovy@merica.cz>
Acked-by: Roger Quadros <rogerq@ti.com>
---
Changes since v3:
* Make the omap_gpmc_controller static (Frans Klaver)

Changes since v2:
* Do not use custom locks. Use global 'struct nand_hw_control'
  among multiple NAND instances and it will do the work for us
  (Roger Quadros)

Changes since v1:
* Since not all the read/write operations are performed by the
  omap_read(write)_page_bch() functions use the locks directly on
  those places that configure the ECC engine (take the lock) and
  read the result from the ECC engine (release the lock).
  This approach should cover read/write operations with all
  possible ECC modes. (Roger Quadros)


 drivers/mtd/nand/omap2.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index b0f89d8..ec040b4 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -144,8 +144,13 @@ static u_char bch8_vector[] = {0xf3, 0xdb, 0x14, 0x16, 0x8b, 0xd2, 0xbe, 0xcc,
 	0xac, 0x6b, 0xff, 0x99, 0x7b};
 static u_char bch4_vector[] = {0x00, 0x6b, 0x31, 0xdd, 0x41, 0xbc, 0x10};
 
+/* Shared among all NAND instances to synchronize the access to the ECC Engine */
+static struct nand_hw_control omap_gpmc_controller = {
+	.lock = __SPIN_LOCK_UNLOCKED(omap_gpmc_controller.lock),
+	.wq = __WAIT_QUEUE_HEAD_INITIALIZER(omap_gpmc_controller.wq),
+};
+
 struct omap_nand_info {
-	struct nand_hw_control		controller;
 	struct omap_nand_platform_data	*pdata;
 	struct mtd_info			mtd;
 	struct nand_chip		nand;
@@ -1685,9 +1690,6 @@ static int omap_nand_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, info);
 
-	spin_lock_init(&info->controller.lock);
-	init_waitqueue_head(&info->controller.wq);
-
 	info->pdev		= pdev;
 	info->gpmc_cs		= pdata->cs;
 	info->reg		= pdata->reg;
@@ -1707,7 +1709,7 @@ static int omap_nand_probe(struct platform_device *pdev)
 
 	info->phys_base = res->start;
 
-	nand_chip->controller = &info->controller;
+	nand_chip->controller = &omap_gpmc_controller;
 
 	nand_chip->IO_ADDR_W = nand_chip->IO_ADDR_R;
 	nand_chip->cmd_ctrl  = omap_hwcontrol;
-- 
1.9.1

