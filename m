Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbaIRJEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 05:04:09 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:43229 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbaIRJEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 05:04:07 -0400
From: Gernot Vormayr <gvormayr@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-gpio@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gernot Vormayr <gvormayr@gmail.com>
Subject: [PATCH 1/1] gpio: Fix ngpio in gpio-xilinx driver
Date: Thu, 18 Sep 2014 11:03:52 +0200
Message-Id: <1411031032-20649-1-git-send-email-gvormayr@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If one adds 'gpio-controller;' to the chip in the devicetree, then
initialization fails with 'gpiochip_find_base: cannot find free range',
because ngpio is 0. This patch fixes the bug.

Tested on ml507 board.

Signed-off-by: Gernot Vormayr <gvormayr@gmail.com>
---
 drivers/gpio/gpio-xilinx.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
index 1248186..4606ad2 100644
--- a/drivers/gpio/gpio-xilinx.c
+++ b/drivers/gpio/gpio-xilinx.c
@@ -197,6 +197,7 @@ static int xgpio_of_probe(struct device_node *np)
 	struct xgpio_instance *chip;
 	int status = 0;
 	const u32 *tree_info;
+	u32 ngpio;
 
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
 	if (!chip)
@@ -215,8 +216,9 @@ static int xgpio_of_probe(struct device_node *np)
 	chip->mmchip.gc.ngpio = 32;
 
 	/* Check device node and parent device node for device width */
-	of_property_read_u32(np, "xlnx,gpio-width",
-			      (u32 *)&chip->mmchip.gc.ngpio);
+	status = of_property_read_u32(np, "xlnx,gpio-width", &ngpio);
+	if (status == 0)
+		chip->mmchip.gc.ngpio = (u16)ngpio;
 
 	spin_lock_init(&chip->gpio_lock);
 
@@ -262,8 +264,9 @@ static int xgpio_of_probe(struct device_node *np)
 		chip->mmchip.gc.ngpio = 32;
 
 		/* Check device node and parent device node for device width */
-		of_property_read_u32(np, "xlnx,gpio2-width",
-				     (u32 *)&chip->mmchip.gc.ngpio);
+		status = of_property_read_u32(np, "xlnx,gpio2-width", &ngpio);
+		if (status == 0)
+			chip->mmchip.gc.ngpio = (u16)ngpio;
 
 		spin_lock_init(&chip->gpio_lock);
 
-- 
2.1.0

