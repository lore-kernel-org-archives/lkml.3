Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbbAOJQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 04:16:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:21789 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbbAOJQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 04:16:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,402,1418112000"; 
   d="scan'208";a="670290671"
From: "David E. Box" <david.e.box@linux.intel.com>
To: wsa@the-dreams.de
Cc: jdelvare@suse.de, arnd@arndb.de, maxime.ripard@free-electrons.com,
        dianders@chromium.org, david.e.box@linux.intel.com,
        u.kleine-koenig@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com,
        boris.brezillon@free-electrons.com, maxime.coquelin@st.com,
        andrew@lunn.ch, sjg@chromium.org, markus.mayer@linaro.org,
        ch.naveen@samsung.com, jacob.jun.pan@linux.intel.com,
        max.schwarz@online.de, mika.westerberg@linux.intel.com,
        skuribay@pobox.com, Romain.Baeriswyl@abilis.com, wenkai.du@intel.com,
        christian.ruppert@abilis.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: [PATCH V4 2/2] i2c-designware: Add Intel Baytrail PMIC I2C bus support
Date: Thu, 15 Jan 2015 01:12:17 -0800
Message-Id: <1421313137-1613-3-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421313137-1613-1-git-send-email-david.e.box@linux.intel.com>
References: <1421313137-1613-1-git-send-email-david.e.box@linux.intel.com>
In-Reply-To: <1417478973-25522-1-git-send-email-david.e.box@linux.intel.com>
References: <1417478973-25522-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements an I2C bus sharing mechanism between the host and platform
hardware on select Intel BayTrail SoC platforms using the X-Powers AXP288 PMIC.

On these platforms access to the PMIC must be shared with platform hardware. The
hardware unit assumes full control of the I2C bus and the host must request
access through a special semaphore. Hardware control of the bus also makes it
necessary to disable runtime pm to avoid interfering with hardware transactions.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
---
 drivers/i2c/busses/Kconfig                   |  11 ++
 drivers/i2c/busses/Makefile                  |   1 +
 drivers/i2c/busses/i2c-designware-baytrail.c | 160 +++++++++++++++++++++++++++
 drivers/i2c/busses/i2c-designware-core.h     |   6 +
 drivers/i2c/busses/i2c-designware-platdrv.c  |  20 +++-
 5 files changed, 193 insertions(+), 5 deletions(-)
 create mode 100644 drivers/i2c/busses/i2c-designware-baytrail.c

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 917c358..9a83c46 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -464,6 +464,17 @@ config I2C_DESIGNWARE_PCI
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-designware-pci.
 
+config I2C_DESIGNWARE_BAYTRAIL
+	bool "Intel Baytrail I2C semaphore support"
+	depends on I2C_DESIGNWARE_PLATFORM
+	select IOSF_MBI
+	help
+	  This driver enables managed host access to the PMIC I2C bus on select
+	  Intel BayTrail platforms using the X-Powers AXP288 PMIC. It allows
+	  the host to request uninterrupted access to the PMIC's I2C bus from
+	  the platform firmware controlling it. You should say Y if running on
+	  a BayTrail system using the AXP288.
+
 config I2C_EFM32
 	tristate "EFM32 I2C controller"
 	depends on ARCH_EFM32 || COMPILE_TEST
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 78d56c5..15b2965 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_I2C_DAVINCI)	+= i2c-davinci.o
 obj-$(CONFIG_I2C_DESIGNWARE_CORE)	+= i2c-designware-core.o
 obj-$(CONFIG_I2C_DESIGNWARE_PLATFORM)	+= i2c-designware-platform.o
 i2c-designware-platform-objs := i2c-designware-platdrv.o
+i2c-designware-platform-$(CONFIG_I2C_DESIGNWARE_BAYTRAIL) += i2c-designware-baytrail.o
 obj-$(CONFIG_I2C_DESIGNWARE_PCI)	+= i2c-designware-pci.o
 i2c-designware-pci-objs := i2c-designware-pcidrv.o
 obj-$(CONFIG_I2C_EFM32)		+= i2c-efm32.o
diff --git a/drivers/i2c/busses/i2c-designware-baytrail.c b/drivers/i2c/busses/i2c-designware-baytrail.c
new file mode 100644
index 0000000..5f1ff4c
--- /dev/null
+++ b/drivers/i2c/busses/i2c-designware-baytrail.c
@@ -0,0 +1,160 @@
+/*
+ * Intel BayTrail PMIC I2C bus semaphore implementaion
+ * Copyright (c) 2014, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/acpi.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <asm/iosf_mbi.h>
+#include "i2c-designware-core.h"
+
+#define SEMAPHORE_TIMEOUT	100
+#define PUNIT_SEMAPHORE		0x7
+
+static unsigned long acquired;
+
+static int get_sem(struct device *dev, u32 *sem)
+{
+	u32 reg_val;
+	int ret;
+
+	ret = iosf_mbi_read(BT_MBI_UNIT_PMC, BT_MBI_BUNIT_READ, PUNIT_SEMAPHORE,
+			    &reg_val);
+	if (ret) {
+		dev_err(dev, "iosf failed to read punit semaphore\n");
+		return ret;
+	}
+
+	*sem = reg_val & 0x1;
+
+	return 0;
+}
+
+static void reset_semaphore(struct device *dev)
+{
+	u32 data;
+
+	if (iosf_mbi_read(BT_MBI_UNIT_PMC, BT_MBI_BUNIT_READ,
+				PUNIT_SEMAPHORE, &data)) {
+		dev_err(dev, "iosf failed to reset punit semaphore during read\n");
+		return;
+	}
+
+	data = data & 0xfffffffe;
+	if (iosf_mbi_write(BT_MBI_UNIT_PMC, BT_MBI_BUNIT_WRITE,
+				 PUNIT_SEMAPHORE, data))
+		dev_err(dev, "iosf failed to reset punit semaphore during write\n");
+}
+
+int baytrail_i2c_acquire(struct dw_i2c_dev *dev)
+{
+	u32 sem = 0;
+	int ret;
+	unsigned long start, end;
+
+	if (!dev || !dev->dev)
+		return -ENODEV;
+
+	if (!dev->acquire_lock)
+		return 0;
+
+	/* host driver writes 0x2 to side band semaphore register */
+	ret = iosf_mbi_write(BT_MBI_UNIT_PMC, BT_MBI_BUNIT_WRITE,
+				 PUNIT_SEMAPHORE, 0x2);
+	if (ret) {
+		dev_err(dev->dev, "iosf punit semaphore request failed\n");
+		return ret;
+	}
+
+	/* host driver waits for bit 0 to be set in semaphore register */
+	start = jiffies;
+	end = start + msecs_to_jiffies(SEMAPHORE_TIMEOUT);
+	while (!time_after(jiffies, end)) {
+		ret = get_sem(dev->dev, &sem);
+		if (!ret && sem) {
+			acquired = jiffies;
+			dev_dbg(dev->dev, "punit semaphore acquired after %ums\n",
+				jiffies_to_msecs(jiffies - start));
+			return 0;
+		}
+
+		usleep_range(1000, 2000);
+	}
+
+	dev_err(dev->dev, "punit semaphore timed out, resetting\n");
+	reset_semaphore(dev->dev);
+
+	ret = iosf_mbi_read(BT_MBI_UNIT_PMC, BT_MBI_BUNIT_READ,
+		PUNIT_SEMAPHORE, &sem);
+	if (!ret)
+		dev_err(dev->dev, "iosf failed to read punit semaphore\n");
+	else
+		dev_err(dev->dev, "PUNIT SEM: %d\n", sem);
+
+	WARN_ON(1);
+
+	return -ETIMEDOUT;
+}
+EXPORT_SYMBOL(baytrail_i2c_acquire);
+
+void baytrail_i2c_release(struct dw_i2c_dev *dev)
+{
+	if (!dev || !dev->dev)
+		return;
+
+	if (!dev->acquire_lock)
+		return;
+
+	reset_semaphore(dev->dev);
+	dev_dbg(dev->dev, "punit semaphore held for %ums\n",
+		jiffies_to_msecs(jiffies - acquired));
+}
+EXPORT_SYMBOL(baytrail_i2c_release);
+
+int i2c_dw_eval_lock_support(struct dw_i2c_dev *dev)
+{
+	acpi_status status;
+	unsigned long long shared_host = 0;
+	acpi_handle handle;
+
+	if (!dev || !dev->dev)
+		return 0;
+
+	handle = ACPI_HANDLE(dev->dev);
+	if (!handle)
+		return 0;
+
+	status = acpi_evaluate_integer(handle, "_SEM", NULL, &shared_host);
+
+	if (ACPI_FAILURE(status))
+		return 0;
+
+	if (shared_host) {
+		dev_info(dev->dev, "I2C bus managed by PUNIT\n");
+		dev->acquire_lock = baytrail_i2c_acquire;
+		dev->release_lock = baytrail_i2c_release;
+		dev->pm_runtime_disabled = true;
+	}
+
+	if (!iosf_mbi_available())
+		return -EPROBE_DEFER;
+
+	return 0;
+}
+EXPORT_SYMBOL(i2c_dw_eval_lock_support);
+
+MODULE_AUTHOR("David E. Box <david.e.box@linux.intel.com>");
+MODULE_DESCRIPTION("Baytrail I2C Semaphore driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
index a472c91..92ceb65 100644
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -129,3 +129,9 @@ extern void i2c_dw_disable(struct dw_i2c_dev *dev);
 extern void i2c_dw_clear_int(struct dw_i2c_dev *dev);
 extern void i2c_dw_disable_int(struct dw_i2c_dev *dev);
 extern u32 i2c_dw_read_comp_param(struct dw_i2c_dev *dev);
+
+#if IS_ENABLED(CONFIG_I2C_DESIGNWARE_BAYTRAIL)
+extern int i2c_dw_eval_lock_support(struct dw_i2c_dev *dev);
+#else
+static inline int i2c_dw_eval_lock_support(struct dw_i2c_dev *dev) { return 0; }
+#endif
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index a743115..ac32414 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -199,6 +199,10 @@ static int dw_i2c_probe(struct platform_device *pdev)
 			clk_freq = pdata->i2c_scl_freq;
 	}
 
+	r = i2c_dw_eval_lock_support(dev);
+	if (r)
+		return r;
+
 	dev->functionality =
 		I2C_FUNC_I2C |
 		I2C_FUNC_10BIT_ADDR |
@@ -261,10 +265,14 @@ static int dw_i2c_probe(struct platform_device *pdev)
 		return r;
 	}
 
-	pm_runtime_set_autosuspend_delay(&pdev->dev, 1000);
-	pm_runtime_use_autosuspend(&pdev->dev);
-	pm_runtime_set_active(&pdev->dev);
-	pm_runtime_enable(&pdev->dev);
+	if (dev->pm_runtime_disabled) {
+		pm_runtime_forbid(&pdev->dev);
+	} else {
+		pm_runtime_set_autosuspend_delay(&pdev->dev, 1000);
+		pm_runtime_use_autosuspend(&pdev->dev);
+		pm_runtime_set_active(&pdev->dev);
+		pm_runtime_enable(&pdev->dev);
+	}
 
 	return 0;
 }
@@ -314,7 +322,9 @@ static int dw_i2c_resume(struct device *dev)
 	struct dw_i2c_dev *i_dev = platform_get_drvdata(pdev);
 
 	clk_prepare_enable(i_dev->clk);
-	i2c_dw_init(i_dev);
+
+	if (!i_dev->pm_runtime_disabled)
+		i2c_dw_init(i_dev);
 
 	return 0;
 }
-- 
1.9.1

