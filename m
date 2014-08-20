Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaHTOaB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 10:30:01 -0400
Received: from mail.abilis.ch ([195.70.19.74]:21414 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbaHTO36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 10:29:58 -0400
From: Romain Baeriswyl <Romain.Baeriswyl@abilis.com>
To: Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Romain Baeriswyl <Romain.Baeriswyl@abilis.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, atull@opensource.altera.com,
        baruch@tkos.co.il, grant.likely@linaro.org, robh+dt@kernel.org,
        skuribay@pobox.com, alan@linux.intel.com, devicetree@vger.kernel.org,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Cc: Romain Baeriswyl <Romain.Baeriswyl@abilis.com>,
        Romain Baeriswyl <romainba@abilis.com>
Subject: [PATCH] i2c designware add support of I2C standard mode
Date: Wed, 20 Aug 2014 16:29:08 +0200
Message-Id: <1408544948-22339-1-git-send-email-romainba@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20140820124231.GD21734@leverpostej>
References: <20140820124231.GD21734@leverpostej>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Romain Baeriswyl <Romain.Baeriswyl@abilis.com>

Some legacy devices support ony I2C standard mode at 100kHz.
This patch allows to select the standard mode through the DTS
with the use of the existing clock-frequency parameter.

When clock-frequency parameter is not set, the fast mode is selected.
Only when the parameter is set at 100000, the standard mode is selected.

Signed-off-by: Romain Baeriswyl <romainba@abilis.com>
Reviewed-by: Christian Ruppert <christian.ruppert@abilis.com>
---
 drivers/i2c/busses/i2c-designware-platdrv.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 402ec39..b543fe1 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -122,6 +122,7 @@ static int dw_i2c_probe(struct platform_device *pdev)
 	struct i2c_adapter *adap;
 	struct resource *mem;
 	int irq, r;
+	u32 clk_freq;
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
@@ -151,6 +152,9 @@ static int dw_i2c_probe(struct platform_device *pdev)
 		return PTR_ERR(dev->clk);
 	clk_prepare_enable(dev->clk);
 
+	/* fast mode by default because of legacy reasons */
+	clk_freq = 400000;
+
 	if (pdev->dev.of_node) {
 		u32 ht = 0;
 		u32 ic_clk = dev->get_clk_rate_khz(dev);
@@ -166,6 +170,17 @@ static int dw_i2c_probe(struct platform_device *pdev)
 		of_property_read_u32(pdev->dev.of_node,
 				     "i2c-scl-falling-time-ns",
 				     &dev->scl_falling_time);
+
+		of_property_read_u32(pdev->dev.of_node, "clock-frequency",
+				     &clk_freq);
+
+		/* Only standard mode at 100kHz and fast mode at 400kHz
+		 * are supported.
+		 */
+		if (clk_freq != 100000 && clk_freq != 400000) {
+			dev_err(&pdev->dev, "Only 100kHz and 400kHz supported");
+			return -EINVAL;
+		}
 	}
 
 	dev->functionality =
@@ -175,8 +190,12 @@ static int dw_i2c_probe(struct platform_device *pdev)
 		I2C_FUNC_SMBUS_BYTE_DATA |
 		I2C_FUNC_SMBUS_WORD_DATA |
 		I2C_FUNC_SMBUS_I2C_BLOCK;
-	dev->master_cfg =  DW_IC_CON_MASTER | DW_IC_CON_SLAVE_DISABLE |
-		DW_IC_CON_RESTART_EN | DW_IC_CON_SPEED_FAST;
+	if (clk_freq == 100000)
+		dev->master_cfg =  DW_IC_CON_MASTER | DW_IC_CON_SLAVE_DISABLE |
+			DW_IC_CON_RESTART_EN | DW_IC_CON_SPEED_STD;
+	else
+		dev->master_cfg =  DW_IC_CON_MASTER | DW_IC_CON_SLAVE_DISABLE |
+			DW_IC_CON_RESTART_EN | DW_IC_CON_SPEED_FAST;
 
 	/* Try first if we can configure the device from ACPI */
 	r = dw_i2c_acpi_configure(pdev);
-- 
1.7.1

