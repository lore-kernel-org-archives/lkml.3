Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbaGIMih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:38:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36367 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbaGIMie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:38:34 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <computersforpeace@gmail.com>
CC: <javier@dowhile0.org>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <dwmw2@infradead.org>,
        <jg1.han@samsung.com>, <nsekhar@ti.com>,
        <linux-mtd@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 01/10] mtd: nand: omap: Use a single hardware controller instance
Date: Wed, 9 Jul 2014 15:37:21 +0300
Message-ID: <1404909450-11970-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404909450-11970-1-git-send-email-rogerq@ti.com>
References: <1404909450-11970-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is only one NAND controller (ECC generator) that needs to be
shared among multiple devices. So point nand_chip->hwcontrol to
a single omap_hw_controller instance.
This way the NAND base driver can take care of serializing access
to this single controller (via nand_chip->controller->lock)
when multiple NAND devices are present.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mtd/nand/omap2.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index f0ed92e..5b8739c 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -149,8 +149,9 @@ static u_char bch4_vector[] = {0x00, 0x6b, 0x31, 0xdd, 0x41, 0xbc, 0x10};
 /* oob info generated runtime depending on ecc algorithm and layout selected */
 static struct nand_ecclayout omap_oobinfo;
 
+static struct nand_hw_control omap_hw_controller;
+
 struct omap_nand_info {
-	struct nand_hw_control		controller;
 	struct omap_nand_platform_data	*pdata;
 	struct mtd_info			mtd;
 	struct nand_chip		nand;
@@ -1649,9 +1650,6 @@ static int omap_nand_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, info);
 
-	spin_lock_init(&info->controller.lock);
-	init_waitqueue_head(&info->controller.wq);
-
 	info->pdev		= pdev;
 	info->gpmc_cs		= pdata->cs;
 	info->reg		= pdata->reg;
@@ -1672,7 +1670,13 @@ static int omap_nand_probe(struct platform_device *pdev)
 
 	info->phys_base = res->start;
 
-	nand_chip->controller = &info->controller;
+	/*
+	 * There is only one NAND controller (ECC generator) that needs to be
+	 * shared among multiple devices. The NAND base driver takes care of
+	 * serializing access to this single controller when multiple NAND
+	 * devices are present.
+	 */
+	nand_chip->hwcontrol = omap_hw_controller;
 
 	nand_chip->IO_ADDR_W = nand_chip->IO_ADDR_R;
 	nand_chip->cmd_ctrl  = omap_hwcontrol;
-- 
1.8.3.2

