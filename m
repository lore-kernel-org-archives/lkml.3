Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455AbaIWSne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 14:43:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:53934 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbaIWSnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 14:43:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,581,1406617200"; 
   d="scan'208";a="577730097"
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
        chiau.ee.chew@intel.com, christian.ruppert@abilis.com,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: [PATCH V2] i2c-designware: Add Intel Baytrail PMIC I2C bus support
Date: Tue, 23 Sep 2014 11:40:26 -0700
Message-Id: <1411497626-7984-1-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410543367-6565-1-git-send-email-david.e.box@linux.intel.com>
References: <1410543367-6565-1-git-send-email-david.e.box@linux.intel.com>
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

V2:	Moved semaphore detection out of dw platform driver
	Replaced function pointers with defined acquire/release functions in dw
		core. This helps elliminate the ifdefery in the dw platform driver.
	Use new has_hw_lock flag to check if the lock exists on a given bus.
	Use new pm_runtime_disabled flag to conditionally turnoff runtime pm
		in the dw platform driver.

 drivers/i2c/busses/Kconfig                  |  16 +++
 drivers/i2c/busses/Makefile                 |   1 +
 drivers/i2c/busses/i2c-baytrail-sem.c       | 157 ++++++++++++++++++++++++++++
 drivers/i2c/busses/i2c-designware-core.c    |   7 ++
 drivers/i2c/busses/i2c-designware-core.h    |  19 ++++
 drivers/i2c/busses/i2c-designware-platdrv.c |  18 +++-
 6 files changed, 213 insertions(+), 5 deletions(-)
 create mode 100644 drivers/i2c/busses/i2c-baytrail-sem.c

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 2ac87fa..036f16f 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -441,6 +441,22 @@ config I2C_DESIGNWARE_PCI
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-designware-pci.
 
+config I2C_BAYTRAIL_SEM
+	tristate "Intel Baytrail I2C semaphore support"
+	depends on I2C_DESIGNWARE_PLATFORM
+	select I2C_DESIGNWARE_CORE
+	select IOSF_MBI
+	help
+	  This driver enables host access to the PMIC I2C bus on select Intel
+	  BayTrail platforms using the X-Powers AXP288 PMIC. This driver is
+	  required for host access to the PMIC on these platforms. You should
+	  probably say Y if you have a BayTrail system, unless you know it uses
+	  a different PMIC. Otherwises critical PMIC functions, like charging,
+	  may not operate.
+
+	  This driver should be built as a m if I2C_DESIGNWARE_PLATFORM=m,
+	  and as y if I2C_DESIGNWARE_PLATFORM=y.
+
 config I2C_EFM32
 	tristate "EFM32 I2C controller"
 	depends on ARCH_EFM32 || COMPILE_TEST
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 49bf07e..6f143b4 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_I2C_DESIGNWARE_PLATFORM)	+= i2c-designware-platform.o
 i2c-designware-platform-objs := i2c-designware-platdrv.o
 obj-$(CONFIG_I2C_DESIGNWARE_PCI)	+= i2c-designware-pci.o
 i2c-designware-pci-objs := i2c-designware-pcidrv.o
+obj-$(CONFIG_I2C_BAYTRAIL_SEM)	+= i2c-baytrail-sem.o
 obj-$(CONFIG_I2C_EFM32)		+= i2c-efm32.o
 obj-$(CONFIG_I2C_EG20T)		+= i2c-eg20t.o
 obj-$(CONFIG_I2C_EXYNOS5)	+= i2c-exynos5.o
diff --git a/drivers/i2c/busses/i2c-baytrail-sem.c b/drivers/i2c/busses/i2c-baytrail-sem.c
new file mode 100644
index 0000000..389aa23
--- /dev/null
+++ b/drivers/i2c/busses/i2c-baytrail-sem.c
@@ -0,0 +1,157 @@
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
+void baytrail_evaluate_sem(struct dw_i2c_dev *dev)
+{
+	acpi_status status;
+	unsigned long long shared_host = 0;
+	acpi_handle handle;
+
+	if (!dev || !dev->dev) {
+		pr_err("%s:%d: device is NULL\n", __func__, __LINE__);
+		return;
+	}
+
+	handle = ACPI_HANDLE(dev->dev);
+	if (!handle)
+		return;
+
+	status = acpi_evaluate_integer(handle, "_SEM", NULL, &shared_host);
+
+	if (shared_host) {
+		dev_info(dev->dev, "I2C bus managed by PUNIT\n");
+		dev->has_hw_lock = true;
+		dev->pm_runtime_disabled = true;
+	}
+}
+EXPORT_SYMBOL(baytrail_evaluate_sem);
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
+		dev_err(dev, "iosf failed to reset punit semaphore\n");
+		return;
+	}
+
+	data = data & 0xfffffffe;
+	if (iosf_mbi_write(BT_MBI_UNIT_PMC, BT_MBI_BUNIT_WRITE,
+				 PUNIT_SEMAPHORE, data))
+		dev_err(dev, "iosf failed to reset punit semaphore\n");
+}
+
+int baytrail_i2c_acquire(struct dw_i2c_dev *dev)
+{
+	u32 sem = 0;
+	int ret;
+	unsigned long start, end;
+
+	if (!dev || !dev->dev) {
+		pr_err("%s:%d: device is NULL\n", __func__, __LINE__);
+		return -ENOMEM;
+	}
+
+	if (!dev->has_hw_lock)
+		return 0;
+
+	/* host driver writes 0x2 to side band semaphore register */
+	ret = iosf_mbi_write(BT_MBI_UNIT_PMC, BT_MBI_BUNIT_WRITE,
+				 PUNIT_SEMAPHORE, 0x2);
+	if (ret) {
+		dev_err(dev->dev, "iosf failed to request punit semaphore\n");
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
+	if (!dev || !dev->dev) {
+		pr_err("%s:%d: device is NULL\n", __func__, __LINE__);
+		return;
+	}
+
+	if (!dev->has_hw_lock)
+		return;
+
+	reset_semaphore(dev->dev);
+	dev_dbg(dev->dev, "punit semaphore held for %ums\n",
+		jiffies_to_msecs(jiffies - acquired));
+}
+EXPORT_SYMBOL(baytrail_i2c_release);
+
+MODULE_AUTHOR("David E. Box <david.e.box@linux.intel.com>");
+MODULE_DESCRIPTION("Baytrail I2C Semaphore driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 3c20e4b..185401f 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -631,6 +631,12 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 	dev->abort_source = 0;
 	dev->rx_outstanding = 0;
 
+	ret = i2c_dw_acquire_ownership(dev);
+	if (ret) {
+		dev_err(dev->dev, "couldn't acquire ownership of bus\n");
+		goto done;
+	}
+
 	ret = i2c_dw_wait_bus_not_busy(dev);
 	if (ret < 0)
 		goto done;
@@ -676,6 +682,7 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 	ret = -EIO;
 
 done:
+	i2c_dw_release_ownership(dev);
 	pm_runtime_mark_last_busy(dev->dev);
 	pm_runtime_put_autosuspend(dev->dev);
 	mutex_unlock(&dev->lock);
diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
index d66b6cb..13e0809 100644
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -65,6 +65,8 @@
  * @ss_lcnt: standard speed LCNT value
  * @fs_hcnt: fast speed HCNT value
  * @fs_lcnt: fast speed LCNT value
+ * has_hw_lock: true if bus access requires hardware lock
+ * pm_runtime_disabled: true if pm runtime is disabled
  *
  * HCNT and LCNT parameters can be used if the platform knows more accurate
  * values than the one computed based only on the input clock frequency.
@@ -105,6 +107,8 @@ struct dw_i2c_dev {
 	u16			ss_lcnt;
 	u16			fs_hcnt;
 	u16			fs_lcnt;
+	bool			has_hw_lock;
+	bool			pm_runtime_disabled;
 };
 
 #define ACCESS_SWAP		0x00000001
@@ -123,3 +127,18 @@ extern void i2c_dw_disable(struct dw_i2c_dev *dev);
 extern void i2c_dw_clear_int(struct dw_i2c_dev *dev);
 extern void i2c_dw_disable_int(struct dw_i2c_dev *dev);
 extern u32 i2c_dw_read_comp_param(struct dw_i2c_dev *dev);
+
+#if IS_ENABLED(CONFIG_I2C_BAYTRAIL_SEM)
+extern int baytrail_i2c_acquire(struct dw_i2c_dev *dev);
+extern void baytrail_i2c_release(struct dw_i2c_dev *dev);
+extern void baytrail_evaluate_sem(struct dw_i2c_dev *dev);
+#define i2c_dw_acquire_ownership(dev) baytrail_i2c_acquire(dev)
+#define i2c_dw_release_ownership(dev) baytrail_i2c_release(dev)
+#define i2c_dw_eval_lock(dev) baytrail_evaluate_sem(dev)
+
+#else
+static inline int i2c_dw_acquire_ownership(struct dw_i2c_dev *dev) { return 0; }
+static inline void i2c_dw_release_ownership(struct dw_i2c_dev *dev) { }
+static inline void i2c_dw_eval_lock(struct dw_i2c_dev *dev) { }
+
+#endif
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index f9b1dec..036c6ef 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -218,10 +218,16 @@ static int dw_i2c_probe(struct platform_device *pdev)
 		return r;
 	}
 
-	pm_runtime_set_autosuspend_delay(&pdev->dev, 1000);
-	pm_runtime_use_autosuspend(&pdev->dev);
-	pm_runtime_set_active(&pdev->dev);
-	pm_runtime_enable(&pdev->dev);
+	i2c_dw_eval_lock(dev);
+
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
@@ -268,7 +274,9 @@ static int dw_i2c_resume(struct device *dev)
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

