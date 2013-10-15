Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833Ab3JOOPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:15:07 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:55619 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab3JOOPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:15:03 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH v3 2/2] hwrng: msm: Add PRNG support for MSM SoC's
Date: Tue, 15 Oct 2013 17:11:18 +0300
Message-Id: <1381846278-9529-3-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381846278-9529-1-git-send-email-svarbanov@mm-sol.com>
References: <1381846278-9529-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a driver for hardware random number generator present
on Qualcomm MSM SoC's.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 drivers/char/hw_random/Kconfig   |  12 +++
 drivers/char/hw_random/Makefile  |   1 +
 drivers/char/hw_random/msm-rng.c | 197 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 210 insertions(+)
 create mode 100644 drivers/char/hw_random/msm-rng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 0aa9d91daef5..bc67099ea24d 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -314,3 +314,15 @@ config HW_RANDOM_TPM
 	  module will be called tpm-rng.
 
 	  If unsure, say Y.
+
+config HW_RANDOM_MSM
+	tristate "Qualcomm MSM Random Number Generator support"
+	depends on HW_RANDOM && ARCH_MSM
+	---help---
+	  This driver provides kernel-side support for the Random Number
+	  Generator hardware found on Qualcomm MSM SoCs.
+
+	  To compile this driver as a module, choose M here. the
+	  module will be called msm-rng.
+
+	  If unsure, say Y.
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index bed467c9300e..441a0a7705a2 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -27,3 +27,4 @@ obj-$(CONFIG_HW_RANDOM_PSERIES) += pseries-rng.o
 obj-$(CONFIG_HW_RANDOM_EXYNOS)	+= exynos-rng.o
 obj-$(CONFIG_HW_RANDOM_TPM) += tpm-rng.o
 obj-$(CONFIG_HW_RANDOM_BCM2835) += bcm2835-rng.o
+obj-$(CONFIG_HW_RANDOM_MSM) += msm-rng.o
diff --git a/drivers/char/hw_random/msm-rng.c b/drivers/char/hw_random/msm-rng.c
new file mode 100644
index 000000000000..148521e51dc6
--- /dev/null
+++ b/drivers/char/hw_random/msm-rng.c
@@ -0,0 +1,197 @@
+/*
+ * Copyright (c) 2011-2013, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/hw_random.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+
+/* Device specific register offsets */
+#define PRNG_DATA_OUT		0x0000
+#define PRNG_STATUS		0x0004
+#define PRNG_LFSR_CFG		0x0100
+#define PRNG_CONFIG		0x0104
+
+/* Device specific register masks and config values */
+#define PRNG_LFSR_CFG_MASK	0x0000ffff
+#define PRNG_LFSR_CFG_CLOCKS	0x0000dddd
+#define PRNG_CONFIG_HW_ENABLE	BIT(1)
+#define PRNG_STATUS_DATA_AVAIL	BIT(0)
+
+#define MAX_HW_FIFO_DEPTH	16
+#define MAX_HW_FIFO_SIZE	(MAX_HW_FIFO_DEPTH * 4)
+#define WORD_SZ			4
+
+struct msm_rng {
+	void __iomem *base;
+	struct clk *clk;
+	struct hwrng hwrng;
+};
+
+#define to_msm_rng(p)	container_of(p, struct msm_rng, hwrng)
+
+static int msm_rng_enable(struct hwrng *hwrng, int enable)
+{
+	struct msm_rng *rng = to_msm_rng(hwrng);
+	u32 val;
+	int ret;
+
+	ret = clk_prepare_enable(rng->clk);
+	if (ret)
+		return ret;
+
+	if (enable) {
+		/* Enable PRNG only if it is not already enabled */
+		val = readl_relaxed(rng->base + PRNG_CONFIG);
+		if (val & PRNG_CONFIG_HW_ENABLE)
+			goto already_enabled;
+
+		val = readl_relaxed(rng->base + PRNG_LFSR_CFG);
+		val &= ~PRNG_LFSR_CFG_MASK;
+		val |= PRNG_LFSR_CFG_CLOCKS;
+		writel(val, rng->base + PRNG_LFSR_CFG);
+
+		val = readl_relaxed(rng->base + PRNG_CONFIG);
+		val |= PRNG_CONFIG_HW_ENABLE;
+		writel(val, rng->base + PRNG_CONFIG);
+	} else {
+		val = readl_relaxed(rng->base + PRNG_CONFIG);
+		val &= ~PRNG_CONFIG_HW_ENABLE;
+		writel(val, rng->base + PRNG_CONFIG);
+	}
+
+already_enabled:
+	clk_disable_unprepare(rng->clk);
+	return 0;
+}
+
+static int msm_rng_read(struct hwrng *hwrng, void *data, size_t max, bool wait)
+{
+	struct msm_rng *rng = to_msm_rng(hwrng);
+	size_t currsize = 0;
+	u32 *retdata = data;
+	size_t maxsize;
+	int ret;
+	u32 val;
+
+	/* calculate max size bytes to transfer back to caller */
+	maxsize = min_t(size_t, MAX_HW_FIFO_SIZE, max);
+
+	/* no room for word data */
+	if (maxsize < WORD_SZ)
+		return 0;
+
+	ret = clk_prepare_enable(rng->clk);
+	if (ret)
+		return ret;
+
+	/* read random data from hardware */
+	do {
+		val = readl_relaxed(rng->base + PRNG_STATUS);
+		if (!(val & PRNG_STATUS_DATA_AVAIL))
+			break;
+
+		val = readl_relaxed(rng->base + PRNG_DATA_OUT);
+		if (!val)
+			break;
+
+		*retdata++ = val;
+		currsize += WORD_SZ;
+
+		/* make sure we stay on 32bit boundary */
+		if ((maxsize - currsize) < WORD_SZ)
+			break;
+	} while (currsize < maxsize);
+
+	clk_disable_unprepare(rng->clk);
+
+	return currsize;
+}
+
+static int msm_rng_init(struct hwrng *hwrng)
+{
+	return msm_rng_enable(hwrng, 1);
+}
+
+static void msm_rng_cleanup(struct hwrng *hwrng)
+{
+	msm_rng_enable(hwrng, 0);
+}
+
+static int msm_rng_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	struct msm_rng *rng;
+	int ret;
+
+	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
+	if (!rng)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, rng);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	rng->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(rng->base))
+		return PTR_ERR(rng->base);
+
+	rng->clk = devm_clk_get(&pdev->dev, "core");
+	if (IS_ERR(rng->clk))
+		return PTR_ERR(rng->clk);
+
+	rng->hwrng.name = KBUILD_MODNAME,
+	rng->hwrng.init = msm_rng_init,
+	rng->hwrng.cleanup = msm_rng_cleanup,
+	rng->hwrng.read = msm_rng_read,
+
+	ret = hwrng_register(&rng->hwrng);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register hwrng\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int msm_rng_remove(struct platform_device *pdev)
+{
+	struct msm_rng *rng = platform_get_drvdata(pdev);
+
+	hwrng_unregister(&rng->hwrng);
+	return 0;
+}
+
+static const struct of_device_id msm_rng_of_match[] = {
+	{ .compatible = "qcom,prng", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, msm_rng_of_match);
+
+static struct platform_driver msm_rng_driver = {
+	.probe = msm_rng_probe,
+	.remove = msm_rng_remove,
+	.driver = {
+		.name = KBUILD_MODNAME,
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(msm_rng_of_match),
+	}
+};
+module_platform_driver(msm_rng_driver);
+
+MODULE_ALIAS("platform:" KBUILD_MODNAME);
+MODULE_AUTHOR("The Linux Foundation");
+MODULE_DESCRIPTION("Qualcomm MSM random number generator driver");
+MODULE_LICENSE("GPL v2");
-- 
1.8.3.1

