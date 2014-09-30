Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaI3KFC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:05:02 -0400
Received: from mga03.intel.com ([134.134.136.65]:64213 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbaI3KE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:04:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,625,1406617200"; 
   d="scan'208";a="610784152"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Carl Peng <carlpeng008@gmail.com>, Huang Rui <ray.huang@amd.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Romain Baeriswyl <Romain.Baeriswyl@abilis.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 2/3] i2c: designware: Rework probe() to get clock a bit later
Date: Tue, 30 Sep 2014 13:04:54 +0300
Message-Id: <1412071495-15323-3-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412071495-15323-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1412071495-15323-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to be able to create missing clock for AMD (and in future possibly
others) we move getting clock for the device a bit later. Also make ACPI/DT
configuration in the same place depending on from where the device was
enumerated from.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/i2c/busses/i2c-designware-platdrv.c | 38 ++++++++++++++---------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 353adc4dc583..e59c63ae4d41 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -81,9 +81,6 @@ static int dw_i2c_acpi_configure(struct platform_device *pdev)
 {
 	struct dw_i2c_dev *dev = platform_get_drvdata(pdev);
 
-	if (!ACPI_HANDLE(&pdev->dev))
-		return -ENODEV;
-
 	dev->adapter.nr = -1;
 	dev->tx_fifo_depth = 32;
 	dev->rx_fifo_depth = 32;
@@ -123,7 +120,7 @@ static int dw_i2c_probe(struct platform_device *pdev)
 	struct resource *mem;
 	struct dw_i2c_platform_data *pdata;
 	int irq, r;
-	u32 clk_freq;
+	u32 clk_freq, ht = 0;
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
@@ -146,24 +143,14 @@ static int dw_i2c_probe(struct platform_device *pdev)
 	dev->irq = irq;
 	platform_set_drvdata(pdev, dev);
 
-	dev->clk = devm_clk_get(&pdev->dev, NULL);
-	dev->get_clk_rate_khz = i2c_dw_get_clk_rate_khz;
-
-	if (IS_ERR(dev->clk))
-		return PTR_ERR(dev->clk);
-	clk_prepare_enable(dev->clk);
-
 	/* fast mode by default because of legacy reasons */
 	clk_freq = 400000;
 
-	if (pdev->dev.of_node) {
-		u32 ht = 0;
-		u32 ic_clk = dev->get_clk_rate_khz(dev);
-
+	if (ACPI_COMPANION(&pdev->dev)) {
+		dw_i2c_acpi_configure(pdev);
+	} else if (pdev->dev.of_node) {
 		of_property_read_u32(pdev->dev.of_node,
 					"i2c-sda-hold-time-ns", &ht);
-		dev->sda_hold_time = div_u64((u64)ic_clk * ht + 500000,
-					     1000000);
 
 		of_property_read_u32(pdev->dev.of_node,
 				     "i2c-sda-falling-time-ns",
@@ -202,9 +189,20 @@ static int dw_i2c_probe(struct platform_device *pdev)
 		dev->master_cfg =  DW_IC_CON_MASTER | DW_IC_CON_SLAVE_DISABLE |
 			DW_IC_CON_RESTART_EN | DW_IC_CON_SPEED_FAST;
 
-	/* Try first if we can configure the device from ACPI */
-	r = dw_i2c_acpi_configure(pdev);
-	if (r) {
+	dev->clk = devm_clk_get(&pdev->dev, NULL);
+	dev->get_clk_rate_khz = i2c_dw_get_clk_rate_khz;
+	if (IS_ERR(dev->clk))
+		return PTR_ERR(dev->clk);
+	clk_prepare_enable(dev->clk);
+
+	if (!dev->sda_hold_time && ht) {
+		u32 ic_clk = dev->get_clk_rate_khz(dev);
+
+		dev->sda_hold_time = div_u64((u64)ic_clk * ht + 500000,
+					     1000000);
+	}
+
+	if (!dev->tx_fifo_depth) {
 		u32 param1 = i2c_dw_read_comp_param(dev);
 
 		dev->tx_fifo_depth = ((param1 >> 16) & 0xff) + 1;
-- 
2.1.0

