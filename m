Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbaIWW64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:58:56 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:58404 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233AbaIWW6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:58:55 -0400
From: Gernot Vormayr <gvormayr@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-gpio@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gernot Vormayr <gvormayr@gmail.com>
Subject: [PATCH v2 1/1] gpio: Fix ngpio in gpio-xilinx driver
Date: Wed, 24 Sep 2014 00:58:45 +0200
Message-Id: <1411513125-20712-1-git-send-email-gvormayr@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411031032-20649-1-git-send-email-gvormayr@gmail.com>
References: <1411031032-20649-1-git-send-email-gvormayr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If one adds gpio-controller; to the chip in the devicetree, then
initialization fails with 'gpiochip_find_base: cannot find free range',
because ngpio is 0. This patch fixes the bug.

This version includes the suggestions from Linus Walleij.

Tested on ml507 board.

Signed-off-by: Gernot Vormayr <gvormayr@gmail.com>
---
 drivers/gpio/gpio-xilinx.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
index 1248186..c11bc11 100644
--- a/drivers/gpio/gpio-xilinx.c
+++ b/drivers/gpio/gpio-xilinx.c
@@ -197,6 +197,7 @@ static int xgpio_of_probe(struct device_node *np)
 	struct xgpio_instance *chip;
 	int status = 0;
 	const u32 *tree_info;
+	u32 ngpio;
 
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
 	if (!chip)
@@ -211,12 +212,11 @@ static int xgpio_of_probe(struct device_node *np)
 	/* Update GPIO direction shadow register with default value */
 	of_property_read_u32(np, "xlnx,tri-default", &chip->gpio_dir);
 
-	/* By default assume full GPIO controller */
-	chip->mmchip.gc.ngpio = 32;
-
-	/* Check device node and parent device node for device width */
-	of_property_read_u32(np, "xlnx,gpio-width",
-			      (u32 *)&chip->mmchip.gc.ngpio);
+	/* Check device node and parent device node for device width
+	   and assume default width of 32 */
+	if (of_property_read_u32(np, "xlnx,gpio-width", &ngpio))
+		ngpio = 32;
+	chip->mmchip.gc.ngpio = (u16)ngpio;
 
 	spin_lock_init(&chip->gpio_lock);
 
@@ -258,12 +258,11 @@ static int xgpio_of_probe(struct device_node *np)
 		/* Update GPIO direction shadow register with default value */
 		of_property_read_u32(np, "xlnx,tri-default-2", &chip->gpio_dir);
 
-		/* By default assume full GPIO controller */
-		chip->mmchip.gc.ngpio = 32;
-
-		/* Check device node and parent device node for device width */
-		of_property_read_u32(np, "xlnx,gpio2-width",
-				     (u32 *)&chip->mmchip.gc.ngpio);
+		/* Check device node and parent device node for device width
+		   and assume default width of 32 */
+		if (of_property_read_u32(np, "xlnx,gpio2-width", &ngpio))
+			ngpio = 32;
+		chip->mmchip.gc.ngpio = (u16)ngpio;
 
 		spin_lock_init(&chip->gpio_lock);
 
-- 
2.1.0

