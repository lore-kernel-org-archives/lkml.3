Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567Ab3AQKar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:30:47 -0500
Received: from mga14.intel.com ([143.182.124.37]:41319 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932179Ab3AQKaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:30:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,484,1355126400"; 
   d="scan'208";a="245018591"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Jean Delvare <khali@linux-fr.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        dirk.brandewie@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] i2c-designware: add support for Intel Lynxpoint
Date: Thu, 17 Jan 2013 12:31:07 +0200
Message-Id: <1358418667-4533-5-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358418667-4533-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1358418667-4533-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel Lynxpoint has two I2C controllers. These controllers are enumerated
from ACPI namespace with IDs INT33C2 and INT33C3. Add support for these to
the I2C DesignWare platform driver.

This is based on the work of Dirk Brandewie.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/i2c/busses/i2c-designware-platdrv.c |   49 +++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index d8afc85..d2a33e9 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -40,6 +40,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/io.h>
 #include <linux/slab.h>
+#include <linux/acpi.h>
 #include "i2c-designware-core.h"
 
 static struct i2c_algorithm i2c_dw_algo = {
@@ -51,6 +52,42 @@ static u32 i2c_dw_get_clk_rate_khz(struct dw_i2c_dev *dev)
 	return clk_get_rate(dev->clk)/1000;
 }
 
+#ifdef CONFIG_ACPI
+static int dw_i2c_acpi_configure(struct platform_device *pdev)
+{
+	struct dw_i2c_dev *dev = platform_get_drvdata(pdev);
+	struct acpi_device *adev;
+	int busno, ret;
+
+	if (!ACPI_HANDLE(&pdev->dev))
+		return -ENODEV;
+
+	ret = acpi_bus_get_device(ACPI_HANDLE(&pdev->dev), &adev);
+	if (ret)
+		return -ENODEV;
+
+	dev->adapter.nr = -1;
+	if (adev->pnp.unique_id && !kstrtoint(adev->pnp.unique_id, 0, &busno))
+		dev->adapter.nr = busno;
+
+	dev->tx_fifo_depth = 32;
+	dev->rx_fifo_depth = 32;
+	return 0;
+}
+
+static const struct acpi_device_id dw_i2c_acpi_match[] = {
+	{ "INT33C2", 0 },
+	{ "INT33C3", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(acpi, dw_i2c_acpi_match);
+#else
+static inline int dw_i2c_acpi_configure(struct platform_device *pdev)
+{
+	return -ENODEV;
+}
+#endif
+
 static int dw_i2c_probe(struct platform_device *pdev)
 {
 	struct dw_i2c_dev *dev;
@@ -115,18 +152,22 @@ static int dw_i2c_probe(struct platform_device *pdev)
 		r = -EBUSY;
 		goto err_unuse_clocks;
 	}
-	{
+
+	/* Try first if we can configure the device from ACPI */
+	r = dw_i2c_acpi_configure(pdev);
+	if (r) {
 		u32 param1 = i2c_dw_read_comp_param(dev);
 
 		dev->tx_fifo_depth = ((param1 >> 16) & 0xff) + 1;
 		dev->rx_fifo_depth = ((param1 >> 8)  & 0xff) + 1;
+		dev->adapter.nr = pdev->id;
 	}
 	r = i2c_dw_init(dev);
 	if (r)
 		goto err_iounmap;
 
 	i2c_dw_disable_int(dev);
-	r = request_irq(dev->irq, i2c_dw_isr, IRQF_DISABLED, pdev->name, dev);
+	r = request_irq(dev->irq, i2c_dw_isr, IRQF_SHARED, pdev->name, dev);
 	if (r) {
 		dev_err(&pdev->dev, "failure requesting irq %i\n", dev->irq);
 		goto err_iounmap;
@@ -141,14 +182,15 @@ static int dw_i2c_probe(struct platform_device *pdev)
 	adap->algo = &i2c_dw_algo;
 	adap->dev.parent = &pdev->dev;
 	adap->dev.of_node = pdev->dev.of_node;
+	ACPI_HANDLE_SET(&adap->dev, ACPI_HANDLE(&pdev->dev));
 
-	adap->nr = pdev->id;
 	r = i2c_add_numbered_adapter(adap);
 	if (r) {
 		dev_err(&pdev->dev, "failure adding adapter\n");
 		goto err_free_irq;
 	}
 	of_i2c_register_devices(adap);
+	acpi_i2c_register_devices(adap);
 
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
@@ -243,6 +285,7 @@ static struct platform_driver dw_i2c_driver = {
 		.name	= "i2c_designware",
 		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(dw_i2c_of_match),
+		.acpi_match_table = ACPI_PTR(dw_i2c_acpi_match),
 		.pm	= &dw_i2c_dev_pm_ops,
 	},
 };
-- 
1.7.10.4

