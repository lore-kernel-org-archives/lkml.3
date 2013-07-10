Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab3GJQBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 12:01:31 -0400
Received: from sauhun.de ([89.238.76.85]:44321 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457Ab3GJP73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:59:29 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Huang Shijie <b32955@freescale.com>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        linux-mtd@lists.infradead.org
Subject: [PATCH 06/12] drivers/mtd/nand/gpmi-nand: don't use devm_pinctrl_get_select_default() in probe
Date: Wed, 10 Jul 2013 16:57:41 +0100
Message-Id: <1373471889-18107-6-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
References: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
we can rely on device core for setting the default pins. Compile tested only.

Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
index 25ecfa1..fd49464 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@ -26,7 +26,6 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/mtd/partitions.h>
-#include <linux/pinctrl/consumer.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_mtd.h>
@@ -516,7 +515,6 @@ err_clock:
 
 static int acquire_resources(struct gpmi_nand_data *this)
 {
-	struct pinctrl *pinctrl;
 	int ret;
 
 	ret = acquire_register_block(this, GPMI_NAND_GPMI_REGS_ADDR_RES_NAME);
@@ -535,19 +533,12 @@ static int acquire_resources(struct gpmi_nand_data *this)
 	if (ret)
 		goto exit_dma_channels;
 
-	pinctrl = devm_pinctrl_get_select_default(&this->pdev->dev);
-	if (IS_ERR(pinctrl)) {
-		ret = PTR_ERR(pinctrl);
-		goto exit_pin;
-	}
-
 	ret = gpmi_get_clks(this);
 	if (ret)
 		goto exit_clock;
 	return 0;
 
 exit_clock:
-exit_pin:
 	release_dma_channels(this);
 exit_dma_channels:
 	release_bch_irq(this);
-- 
1.7.10.4

