Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab3AUKSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:18:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62780 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab3AUKJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:09:39 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 08/33] gpio: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:01 +0100
Message-Id: <1358762966-20791-9-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:8ILsCZVZA2Soa2gON5OMwTmmNjR2Dqv797X4INOKNsO
 X/Yut6cIzs/mVO5xIor0zfHunzD2Ry0QLSUFExInP90lVVH5OB
 mJEJ50ZNk8yUFkX7cadHZs8xaGClqtWrGNRxUqCS/qgBDMPB5q
 L0cRdvyzcJGTcDRm8H6doHi8REhnF6YOM9ZUkIuDTCL4qwj/is
 bzcjkFWOHWuD6InWNlPahmUZufgZTIlLAVT/XSMNVeugbzuPF0
 n3EGvd8Yu6NGObrsXHNlLvrKrHFrebs7Xrwbiub23ffpaGFJq8
 A6lqouHyfe0C1woUT8IUPSZqNJQMXB4Tt3C2syECSNGhIIjWO+
 6oJL5yUBp2bkJ/AEbWb0Xy5pJX1ab8dQp3nMLEoW8uhH42qY52
 vHSB5fQq9WZDBQdlcIZ4BlJuTYCMejvOosW40toVEzNoCWNWXT
 J7liE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-mvebu.c       | 16 ++++++++--------
 drivers/gpio/gpio-mxs.c         |  9 ++++++---
 drivers/gpio/gpio-spear-spics.c |  8 +++-----
 drivers/gpio/gpio-stp-xway.c    |  9 ++++-----
 drivers/gpio/gpio-tegra.c       |  9 ++++-----
 5 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index 7d9bd94..bf6c7c9 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -33,6 +33,7 @@
  *   interrupts.
  */
 
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/gpio.h>
 #include <linux/irq.h>
@@ -544,11 +545,10 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 	mvchip->chip.of_node = np;
 
 	spin_lock_init(&mvchip->lock);
-	mvchip->membase = devm_request_and_ioremap(&pdev->dev, res);
-	if (! mvchip->membase) {
-		dev_err(&pdev->dev, "Cannot ioremap\n");
+	mvchip->membase = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(mvchip->membase)) {
 		kfree(mvchip->chip.label);
-		return -ENOMEM;
+		return PTR_ERR(mvchip->membase);
 	}
 
 	/* The Armada XP has a second range of registers for the
@@ -561,11 +561,11 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 			return -ENODEV;
 		}
 
-		mvchip->percpu_membase = devm_request_and_ioremap(&pdev->dev, res);
-		if (! mvchip->percpu_membase) {
-			dev_err(&pdev->dev, "Cannot ioremap\n");
+		mvchip->percpu_membase = devm_ioremap_resource(&pdev->dev,
+							       res);
+		if (IS_ERR(mvchip->percpu_membase)) {
 			kfree(mvchip->chip.label);
-			return -ENOMEM;
+			return PTR_ERR(mvchip->percpu_membase);
 		}
 	}
 
diff --git a/drivers/gpio/gpio-mxs.c b/drivers/gpio/gpio-mxs.c
index fa2a63c..45d97c4 100644
--- a/drivers/gpio/gpio-mxs.c
+++ b/drivers/gpio/gpio-mxs.c
@@ -20,6 +20,7 @@
  * MA  02110-1301, USA.
  */
 
+#include <linux/err.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -253,12 +254,14 @@ static int mxs_gpio_probe(struct platform_device *pdev)
 			parent = of_get_parent(np);
 			base = of_iomap(parent, 0);
 			of_node_put(parent);
+			if (!base)
+				return -EADDRNOTAVAIL;
 		} else {
 			iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-			base = devm_request_and_ioremap(&pdev->dev, iores);
+			base = devm_ioremap_resource(&pdev->dev, iores);
+			if (IS_ERR(base))
+				return PTR_ERR(base);
 		}
-		if (!base)
-			return -EADDRNOTAVAIL;
 	}
 	port->base = base;
 
diff --git a/drivers/gpio/gpio-spear-spics.c b/drivers/gpio/gpio-spear-spics.c
index 5f45fc4..7a4bf7c 100644
--- a/drivers/gpio/gpio-spear-spics.c
+++ b/drivers/gpio/gpio-spear-spics.c
@@ -140,11 +140,9 @@ static int spics_gpio_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	spics->base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!spics->base) {
-		dev_err(&pdev->dev, "request and ioremap fail\n");
-		return -ENOMEM;
-	}
+	spics->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(spics->base))
+		return PTR_ERR(spics->base);
 
 	if (of_property_read_u32(np, "st-spics,peripcfg-reg",
 				&spics->perip_cfg))
diff --git a/drivers/gpio/gpio-stp-xway.c b/drivers/gpio/gpio-stp-xway.c
index 85841ee7..c20e051 100644
--- a/drivers/gpio/gpio-stp-xway.c
+++ b/drivers/gpio/gpio-stp-xway.c
@@ -214,11 +214,10 @@ static int xway_stp_probe(struct platform_device *pdev)
 	if (!chip)
 		return -ENOMEM;
 
-	chip->virt = devm_request_and_ioremap(&pdev->dev, res);
-	if (!chip->virt) {
-		dev_err(&pdev->dev, "failed to remap STP memory\n");
-		return -ENOMEM;
-	}
+	chip->virt = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(chip->virt))
+		return PTR_ERR(chip->virt);
+	
 	chip->gc.dev = &pdev->dev;
 	chip->gc.label = "stp-xway";
 	chip->gc.direction_output = xway_stp_dir_out;
diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index 63cb643..414ad91 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -17,6 +17,7 @@
  *
  */
 
+#include <linux/err.h>
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
@@ -450,11 +451,9 @@ static int tegra_gpio_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	regs = devm_request_and_ioremap(&pdev->dev, res);
-	if (!regs) {
-		dev_err(&pdev->dev, "Couldn't ioremap regs\n");
-		return -ENODEV;
-	}
+	regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(regs))
+		return PTR_ERR(regs);
 
 	for (i = 0; i < tegra_gpio_bank_count; i++) {
 		for (j = 0; j < 4; j++) {
-- 
1.8.1.1

