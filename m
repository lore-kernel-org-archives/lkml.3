Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbaDOIza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:55:30 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:62705 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751107AbaDOIzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:55:22 -0400
Message-ID: <1397552118.1985.16.camel@x220>
Subject: [PATCH] hwrng: remove unbuildable picoxcell TRNG
From: Paul Bolle <pebolle@tiscali.nl>
To: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        Jamie Iles <jamie@jamieiles.com>
Cc: Richard Weinberger <richard@nod.at>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 15 Apr 2014 10:55:18 +0200
In-Reply-To: <1391977683.25855.27.camel@x220>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-7-git-send-email-richard@nod.at>
	 <1391977683.25855.27.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Apr 2014 08:55:19.0201 (UTC) FILETIME=[6D71E110:01CF5888]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver for the "Picochip picoXcell true random number generator" was
added in v2.6.39. Its Kconfig symbol has always depended on
PICOXCELL_PC3X3. But that Kconfig symbol has never been part of the
tree. This means this driver has never been buildable. Let's remove it.
It can be re-added if its dependencies are actually part of the tree.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested only by grepping the tree!

 drivers/char/hw_random/Kconfig         |  12 ---
 drivers/char/hw_random/Makefile        |   1 -
 drivers/char/hw_random/picoxcell-rng.c | 181 ---------------------------------
 3 files changed, 194 deletions(-)
 delete mode 100644 drivers/char/hw_random/picoxcell-rng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 244759bbd7b7..d994c85a923c 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -251,18 +251,6 @@ config HW_RANDOM_NOMADIK
 
 	  If unsure, say Y.
 
-config HW_RANDOM_PICOXCELL
-	tristate "Picochip picoXcell true random number generator support"
-	depends on HW_RANDOM && ARCH_PICOXCELL && PICOXCELL_PC3X3
-	---help---
-	  This driver provides kernel-side support for the Random Number
-	  Generator hardware found on Picochip PC3x3 and later devices.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called picoxcell-rng.
-
-	  If unsure, say Y.
-
 config HW_RANDOM_PPC4XX
 	tristate "PowerPC 4xx generic true random number generator support"
 	depends on HW_RANDOM && PPC && 4xx
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 3ae7755a52e7..199ed283e149 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -22,7 +22,6 @@ obj-$(CONFIG_HW_RANDOM_TX4939) += tx4939-rng.o
 obj-$(CONFIG_HW_RANDOM_MXC_RNGA) += mxc-rnga.o
 obj-$(CONFIG_HW_RANDOM_OCTEON) += octeon-rng.o
 obj-$(CONFIG_HW_RANDOM_NOMADIK) += nomadik-rng.o
-obj-$(CONFIG_HW_RANDOM_PICOXCELL) += picoxcell-rng.o
 obj-$(CONFIG_HW_RANDOM_PPC4XX) += ppc4xx-rng.o
 obj-$(CONFIG_HW_RANDOM_PSERIES) += pseries-rng.o
 obj-$(CONFIG_HW_RANDOM_POWERNV) += powernv-rng.o
diff --git a/drivers/char/hw_random/picoxcell-rng.c b/drivers/char/hw_random/picoxcell-rng.c
deleted file mode 100644
index eab5448ad56f..000000000000
--- a/drivers/char/hw_random/picoxcell-rng.c
+++ /dev/null
@@ -1,181 +0,0 @@
-/*
- * Copyright (c) 2010-2011 Picochip Ltd., Jamie Iles
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * All enquiries to support@picochip.com
- */
-#include <linux/clk.h>
-#include <linux/delay.h>
-#include <linux/err.h>
-#include <linux/hw_random.h>
-#include <linux/io.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-
-#define DATA_REG_OFFSET		0x0200
-#define CSR_REG_OFFSET		0x0278
-#define CSR_OUT_EMPTY_MASK	(1 << 24)
-#define CSR_FAULT_MASK		(1 << 1)
-#define TRNG_BLOCK_RESET_MASK	(1 << 0)
-#define TAI_REG_OFFSET		0x0380
-
-/*
- * The maximum amount of time in microseconds to spend waiting for data if the
- * core wants us to wait.  The TRNG should generate 32 bits every 320ns so a
- * timeout of 20us seems reasonable.  The TRNG does builtin tests of the data
- * for randomness so we can't always assume there is data present.
- */
-#define PICO_TRNG_TIMEOUT		20
-
-static void __iomem *rng_base;
-static struct clk *rng_clk;
-static struct device *rng_dev;
-
-static inline u32 picoxcell_trng_read_csr(void)
-{
-	return __raw_readl(rng_base + CSR_REG_OFFSET);
-}
-
-static inline bool picoxcell_trng_is_empty(void)
-{
-	return picoxcell_trng_read_csr() & CSR_OUT_EMPTY_MASK;
-}
-
-/*
- * Take the random number generator out of reset and make sure the interrupts
- * are masked. We shouldn't need to get large amounts of random bytes so just
- * poll the status register. The hardware generates 32 bits every 320ns so we
- * shouldn't have to wait long enough to warrant waiting for an IRQ.
- */
-static void picoxcell_trng_start(void)
-{
-	__raw_writel(0, rng_base + TAI_REG_OFFSET);
-	__raw_writel(0, rng_base + CSR_REG_OFFSET);
-}
-
-static void picoxcell_trng_reset(void)
-{
-	__raw_writel(TRNG_BLOCK_RESET_MASK, rng_base + CSR_REG_OFFSET);
-	__raw_writel(TRNG_BLOCK_RESET_MASK, rng_base + TAI_REG_OFFSET);
-	picoxcell_trng_start();
-}
-
-/*
- * Get some random data from the random number generator. The hw_random core
- * layer provides us with locking.
- */
-static int picoxcell_trng_read(struct hwrng *rng, void *buf, size_t max,
-			       bool wait)
-{
-	int i;
-
-	/* Wait for some data to become available. */
-	for (i = 0; i < PICO_TRNG_TIMEOUT && picoxcell_trng_is_empty(); ++i) {
-		if (!wait)
-			return 0;
-
-		udelay(1);
-	}
-
-	if (picoxcell_trng_read_csr() & CSR_FAULT_MASK) {
-		dev_err(rng_dev, "fault detected, resetting TRNG\n");
-		picoxcell_trng_reset();
-		return -EIO;
-	}
-
-	if (i == PICO_TRNG_TIMEOUT)
-		return 0;
-
-	*(u32 *)buf = __raw_readl(rng_base + DATA_REG_OFFSET);
-	return sizeof(u32);
-}
-
-static struct hwrng picoxcell_trng = {
-	.name		= "picoxcell",
-	.read		= picoxcell_trng_read,
-};
-
-static int picoxcell_trng_probe(struct platform_device *pdev)
-{
-	int ret;
-	struct resource *mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-
-	rng_base = devm_ioremap_resource(&pdev->dev, mem);
-	if (IS_ERR(rng_base))
-		return PTR_ERR(rng_base);
-
-	rng_clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(rng_clk)) {
-		dev_warn(&pdev->dev, "no clk\n");
-		return PTR_ERR(rng_clk);
-	}
-
-	ret = clk_enable(rng_clk);
-	if (ret) {
-		dev_warn(&pdev->dev, "unable to enable clk\n");
-		return ret;
-	}
-
-	picoxcell_trng_start();
-	ret = hwrng_register(&picoxcell_trng);
-	if (ret)
-		goto err_register;
-
-	rng_dev = &pdev->dev;
-	dev_info(&pdev->dev, "pixoxcell random number generator active\n");
-
-	return 0;
-
-err_register:
-	clk_disable(rng_clk);
-	return ret;
-}
-
-static int picoxcell_trng_remove(struct platform_device *pdev)
-{
-	hwrng_unregister(&picoxcell_trng);
-	clk_disable(rng_clk);
-
-	return 0;
-}
-
-#ifdef CONFIG_PM
-static int picoxcell_trng_suspend(struct device *dev)
-{
-	clk_disable(rng_clk);
-
-	return 0;
-}
-
-static int picoxcell_trng_resume(struct device *dev)
-{
-	return clk_enable(rng_clk);
-}
-
-static const struct dev_pm_ops picoxcell_trng_pm_ops = {
-	.suspend	= picoxcell_trng_suspend,
-	.resume		= picoxcell_trng_resume,
-};
-#endif /* CONFIG_PM */
-
-static struct platform_driver picoxcell_trng_driver = {
-	.probe		= picoxcell_trng_probe,
-	.remove		= picoxcell_trng_remove,
-	.driver		= {
-		.name	= "picoxcell-trng",
-		.owner	= THIS_MODULE,
-#ifdef CONFIG_PM
-		.pm	= &picoxcell_trng_pm_ops,
-#endif /* CONFIG_PM */
-	},
-};
-
-module_platform_driver(picoxcell_trng_driver);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jamie Iles");
-MODULE_DESCRIPTION("Picochip picoXcell TRNG driver");
-- 
1.9.0

