Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396Ab3CVMzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 08:55:40 -0400
Received: from norkia.v3.sk ([91.210.183.14]:35380 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932825Ab3CVMzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 08:55:38 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: linux-kernel@vger.kernel.org
Cc: Lubomir Rintel <lkundrak@v3.sk>, Stephen Warren <swarren@wwwdotorg.org>,
        Matt Mackall <mpm@selenic.com>, linux-rpi-kernel@lists.infradead.org
Subject: [PATCH] hw_random: Add Broadcom BCM2835 RNG Driver
Date: Fri, 22 Mar 2013 13:55:30 +0100
Message-Id: <1363956930-5717-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: linux-rpi-kernel@lists.infradead.org
---
 arch/arm/boot/dts/bcm2835.dtsi       |    5 +
 arch/arm/configs/bcm2835_defconfig   |    3 +-
 drivers/char/hw_random/Kconfig       |   12 +++
 drivers/char/hw_random/Makefile      |    1 +
 drivers/char/hw_random/bcm2835-rng.c |  137 ++++++++++++++++++++++++++++++++++
 5 files changed, 157 insertions(+), 1 deletions(-)
 create mode 100644 drivers/char/hw_random/bcm2835-rng.c

diff --git a/arch/arm/boot/dts/bcm2835.dtsi b/arch/arm/boot/dts/bcm2835.dtsi
index 7e0481e..dc22336 100644
--- a/arch/arm/boot/dts/bcm2835.dtsi
+++ b/arch/arm/boot/dts/bcm2835.dtsi
@@ -34,6 +34,11 @@
 			reg = <0x7e100000 0x28>;
 		};
 
+		rng {
+			compatible = "brcm,bcm2835-rng";
+			reg = <0x7e104000 0x10>;
+		};
+
 		uart@20201000 {
 			compatible = "brcm,bcm2835-pl011", "arm,pl011", "arm,primecell";
 			reg = <0x7e201000 0x1000>;
diff --git a/arch/arm/configs/bcm2835_defconfig b/arch/arm/configs/bcm2835_defconfig
index af472e4..611bda2 100644
--- a/arch/arm/configs/bcm2835_defconfig
+++ b/arch/arm/configs/bcm2835_defconfig
@@ -59,7 +59,8 @@ CONFIG_DEVTMPFS_MOUNT=y
 CONFIG_SERIAL_AMBA_PL011=y
 CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
 CONFIG_TTY_PRINTK=y
-# CONFIG_HW_RANDOM is not set
+CONFIG_HW_RANDOM=y
+CONFIG_HW_RANDOM_BCM2835=y
 CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_BCM2835=y
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
index 0000000..66adc7f
--- /dev/null
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -0,0 +1,137 @@
+/**
+ * Copyright (c) 2010-2012 Broadcom. All rights reserved.
+ * Copyright (c) 2013 Lubomir Rintel
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. The names of the above-listed copyright holders may not be used
+ *    to endorse or promote products derived from this software without
+ *    specific prior written permission.
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2, as published by the Free
+ * Software Foundation.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
+ * IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
+ * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
+ * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
+ * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
+ * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
+ * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
+ * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
+ * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
+ * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
+	while ((__raw_readl(rng_base + RNG_STATUS)>>24) == 0) {
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
+static int bcm2835_rng_probe(struct platform_device *op)
+{
+	struct device *dev = &op->dev;
+	struct device_node *np = dev->of_node;
+	void __iomem *rng_base;
+	int err;
+
+	/* map peripheral */
+	rng_base = of_iomap(np, 0);
+	if (WARN(!rng_base, "failed to remap rng regs"))
+		return -ENODEV;
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
+static int bcm2835_rng_remove(struct platform_device *op)
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
+
+module_platform_driver(bcm2835_rng_driver);
+
+MODULE_AUTHOR("Lubomir Rintel <lkundrak@v3.sk>");
+MODULE_DESCRIPTION("BCM2835 Random Number Generator (RNG) driver");
+MODULE_LICENSE("GPL and additional rights");
-- 
1.7.1

