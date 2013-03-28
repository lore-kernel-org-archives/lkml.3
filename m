Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab3C1GTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:19:49 -0400
Received: from norkia.v3.sk ([91.210.183.14]:52328 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab3C1GTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:19:47 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: linux-kernel@vger.kernel.org
Cc: Lubomir Rintel <lkundrak@v3.sk>, Dom Cobley <popcornmix@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Stephen Warren <swarren@wwwdotorg.org>, Matt Mackall <mpm@selenic.com>,
        linux-rpi-kernel@lists.infradead.org
Subject: [PATCH v3] hw_random: Add Broadcom BCM2835 RNG driver
Date: Thu, 28 Mar 2013 07:19:38 +0100
Message-Id: <1364451578-5331-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1364135980-27750-1-git-send-email-lkundrak@v3.sk>
References: <1364135980-27750-1-git-send-email-lkundrak@v3.sk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a driver for random number generator present on Broadcom BCM2835 SoC,
used in Raspberry Pi and Roku 2 devices.

Signed-off-by: Dom Cobley <popcornmix@gmail.com>
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Tested-by: Stephen Warren <swarren@wwwdotorg.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: linux-rpi-kernel@lists.infradead.org
---
Changes for v2:
    - Device tree and defconfig changes split out
    - Licence changed from GPLv2+BSD to GPLv2 only
    - Style fixes

Changes for v3:
    - Device tree binding documentation added

 .../devicetree/bindings/rng/brcm,bcm2835.txt       |   13 +++
 drivers/char/hw_random/Kconfig                     |   12 ++
 drivers/char/hw_random/Makefile                    |    1 +
 drivers/char/hw_random/bcm2835-rng.c               |  113 ++++++++++++++++++++
 4 files changed, 139 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm2835.txt
 create mode 100644 drivers/char/hw_random/bcm2835-rng.c

diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt b/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt
new file mode 100644
index 0000000..07ccdaa
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt
@@ -0,0 +1,13 @@
+BCM2835 Random number generator
+
+Required properties:
+
+- compatible : should be "brcm,bcm2835-rng"
+- reg : Specifies base physical address and size of the registers.
+
+Example:
+
+rng {
+        compatible = "brcm,bcm2835-rng";
+        reg = <0x7e104000 0x10>;
+};
diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index c5a0262..2f9dbf7 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -86,6 +86,18 @@ config HW_RANDOM_BCM63XX
 
 	  If unusure, say Y.
 
+config HW_RANDOM_BCM2835
+	tristate "Broadcom BCM2835 Random Number Generator support"
+	depends on HW_RANDOM && ARCH_BCM2835
+	default HW_RANDOM
+	---help---
+	  This driver provides kernel-side support for the Random Number
+	  Generator hardware found on the Broadcom BCM2835 SoCs.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called bcm2835-rng
+
+	  If unsure, say Y.
 
 config HW_RANDOM_GEODE
 	tristate "AMD Geode HW Random Number Generator support"
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 1fd7eec..bed467c 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -26,3 +26,4 @@ obj-$(CONFIG_HW_RANDOM_PPC4XX) += ppc4xx-rng.o
 obj-$(CONFIG_HW_RANDOM_PSERIES) += pseries-rng.o
 obj-$(CONFIG_HW_RANDOM_EXYNOS)	+= exynos-rng.o
 obj-$(CONFIG_HW_RANDOM_TPM) += tpm-rng.o
+obj-$(CONFIG_HW_RANDOM_BCM2835) += bcm2835-rng.o
diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
new file mode 100644
index 0000000..eb7f147
--- /dev/null
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -0,0 +1,113 @@
+/**
+ * Copyright (c) 2010-2012 Broadcom. All rights reserved.
+ * Copyright (c) 2013 Lubomir Rintel
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License ("GPL")
+ * version 2, as published by the Free Software Foundation.
+ */
+
+#include <linux/hw_random.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/printk.h>
+
+#define RNG_CTRL	0x0
+#define RNG_STATUS	0x4
+#define RNG_DATA	0x8
+
+/* enable rng */
+#define RNG_RBGEN	0x1
+
+/* the initial numbers generated are "less random" so will be discarded */
+#define RNG_WARMUP_COUNT 0x40000
+
+static int bcm2835_rng_read(struct hwrng *rng, void *buf, size_t max,
+			       bool wait)
+{
+	void __iomem *rng_base = (void __iomem *)rng->priv;
+
+	while ((__raw_readl(rng_base + RNG_STATUS) >> 24) == 0) {
+		if (!wait)
+			return 0;
+		cpu_relax();
+	}
+
+	*(u32 *)buf = __raw_readl(rng_base + RNG_DATA);
+	return sizeof(u32);
+}
+
+static struct hwrng bcm2835_rng_ops = {
+	.name	= "bcm2835",
+	.read	= bcm2835_rng_read,
+};
+
+static int bcm2835_rng_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	void __iomem *rng_base;
+	int err;
+
+	/* map peripheral */
+	rng_base = of_iomap(np, 0);
+	if (!rng_base) {
+		dev_err(dev, "failed to remap rng regs");
+		return -ENODEV;
+	}
+	bcm2835_rng_ops.priv = (unsigned long)rng_base;
+
+	/* register driver */
+	err = hwrng_register(&bcm2835_rng_ops);
+	if (err) {
+		dev_err(dev, "hwrng registration failed\n");
+		iounmap(rng_base);
+	} else {
+		dev_info(dev, "hwrng registered\n");
+
+		/* set warm-up count & enable */
+		__raw_writel(RNG_WARMUP_COUNT, rng_base + RNG_STATUS);
+		__raw_writel(RNG_RBGEN, rng_base + RNG_CTRL);
+	}
+	return err;
+}
+
+static int bcm2835_rng_remove(struct platform_device *pdev)
+{
+	void __iomem *rng_base = (void __iomem *)bcm2835_rng_ops.priv;
+
+	/* disable rng hardware */
+	__raw_writel(0, rng_base + RNG_CTRL);
+
+	/* unregister driver */
+	hwrng_unregister(&bcm2835_rng_ops);
+	iounmap(rng_base);
+
+	return 0;
+}
+
+static const struct of_device_id bcm2835_rng_of_match[] = {
+	{ .compatible = "brcm,bcm2835-rng", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, bcm2835_rng_of_match);
+
+static struct platform_driver bcm2835_rng_driver = {
+	.driver = {
+		.name = "bcm2835-rng",
+		.owner = THIS_MODULE,
+		.of_match_table = bcm2835_rng_of_match,
+	},
+	.probe		= bcm2835_rng_probe,
+	.remove		= bcm2835_rng_remove,
+};
+module_platform_driver(bcm2835_rng_driver);
+
+MODULE_AUTHOR("Lubomir Rintel <lkundrak@v3.sk>");
+MODULE_DESCRIPTION("BCM2835 Random Number Generator (RNG) driver");
+MODULE_LICENSE("GPLv2");
-- 
1.7.1

