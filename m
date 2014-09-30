Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaI3KFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:05:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:26466 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbaI3KFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:05:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,625,1406617200"; 
   d="scan'208";a="598695225"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Carl Peng <carlpeng008@gmail.com>, Huang Rui <ray.huang@amd.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Romain Baeriswyl <Romain.Baeriswyl@abilis.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 3/3] i2c: designware: Add support for AMD I2C controller
Date: Tue, 30 Sep 2014 13:04:55 +0300
Message-Id: <1412071495-15323-4-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412071495-15323-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1412071495-15323-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carl Peng <carlpeng008@gmail.com>

Add support for AMD version of the DW I2C host controller. The device is
enumerated from ACPI namespace with ACPI ID AMD0010. Because the core
driver needs an input source clock, and this is not an Intel LPSS device
where clocks are provided through drivers/acpi/acpi_lpss.c, we register the
clock ourselves if the clock rate is given in ->driver_data

Signed-off-by: Carl Peng <carlpeng008@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/i2c/busses/Kconfig                  |  1 +
 drivers/i2c/busses/i2c-designware-platdrv.c | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 2ac87fa3058d..0715a239c87f 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -423,6 +423,7 @@ config I2C_DESIGNWARE_CORE
 config I2C_DESIGNWARE_PLATFORM
 	tristate "Synopsys DesignWare Platform"
 	select I2C_DESIGNWARE_CORE
+	depends on (ACPI && COMMON_CLK) || !ACPI
 	help
 	  If you say yes to this option, support will be included for the
 	  Synopsys DesignWare I2C adapter. Only master mode is supported.
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index e59c63ae4d41..a7431150acf7 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -30,6 +30,7 @@
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/err.h>
@@ -80,6 +81,7 @@ static void dw_i2c_acpi_params(struct platform_device *pdev, char method[],
 static int dw_i2c_acpi_configure(struct platform_device *pdev)
 {
 	struct dw_i2c_dev *dev = platform_get_drvdata(pdev);
+	const struct acpi_device_id *id;
 
 	dev->adapter.nr = -1;
 	dev->tx_fifo_depth = 32;
@@ -93,9 +95,29 @@ static int dw_i2c_acpi_configure(struct platform_device *pdev)
 	dw_i2c_acpi_params(pdev, "FMCN", &dev->fs_hcnt, &dev->fs_lcnt,
 			   &dev->sda_hold_time);
 
+	/*
+	 * Provide a way for Designware I2C host controllers that are not
+	 * based on Intel LPSS to specify their input clock frequency via
+	 * id->driver_data.
+	 */
+	id = acpi_match_device(pdev->dev.driver->acpi_match_table, &pdev->dev);
+	if (id && id->driver_data)
+		clk_register_fixed_rate(&pdev->dev, dev_name(&pdev->dev), NULL,
+					CLK_IS_ROOT, id->driver_data);
+
 	return 0;
 }
 
+static void dw_i2c_acpi_unconfigure(struct platform_device *pdev)
+{
+	struct dw_i2c_dev *dev = platform_get_drvdata(pdev);
+	const struct acpi_device_id *id;
+
+	id = acpi_match_device(pdev->dev.driver->acpi_match_table, &pdev->dev);
+	if (id && id->driver_data)
+		clk_unregister(dev->clk);
+}
+
 static const struct acpi_device_id dw_i2c_acpi_match[] = {
 	{ "INT33C2", 0 },
 	{ "INT33C3", 0 },
@@ -103,6 +125,7 @@ static const struct acpi_device_id dw_i2c_acpi_match[] = {
 	{ "INT3433", 0 },
 	{ "80860F41", 0 },
 	{ "808622C1", 0 },
+	{ "AMD0010", 133 * 1000 * 1000 },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, dw_i2c_acpi_match);
@@ -111,6 +134,7 @@ static inline int dw_i2c_acpi_configure(struct platform_device *pdev)
 {
 	return -ENODEV;
 }
+static inline void dw_i2c_acpi_unconfigure(struct platform_device *pdev) { }
 #endif
 
 static int dw_i2c_probe(struct platform_device *pdev)
@@ -258,6 +282,9 @@ static int dw_i2c_remove(struct platform_device *pdev)
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
+	if (ACPI_COMPANION(&pdev->dev))
+		dw_i2c_acpi_unconfigure(pdev);
+
 	return 0;
 }
 
-- 
2.1.0

