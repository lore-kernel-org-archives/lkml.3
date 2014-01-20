Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbaATRLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 12:11:42 -0500
Received: from mail.abilis.ch ([195.70.19.74]:17243 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077AbaATRLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 12:11:15 -0500
X-Greylist: delayed 1423 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jan 2014 12:11:14 EST
From: Romain Baeriswyl <Romain.Baeriswyl@abilis.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Chiau Ee Chew <chiau.ee.chew@intel.com>,
        Shinya Kuribayashi <skuribay@pobox.com>,
        Jean Delvare <khali@linux-fr.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        romainba@abilis.com
Subject: [PATCH v2 2/2] i2c designware add support of I2C standard mode
Date: Mon, 20 Jan 2014 17:45:38 +0100
Message-Id: <1390236338-21407-1-git-send-email-romainba@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20140116193345.GB4127@katana>
References: <20140116193345.GB4127@katana>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some legacy devices support ony I2C standard mode at 100kHz.
This patch allows to select the standard mode through the DTS
with the use of the existing clock-frequency parameter.

When clock-frequency parameter is not set, the fast mode is selected.
Only when the parameter is set at 100000, the standard mode is selected.

Signed-off-by: Romain Baeriswyl <romainba@abilis.com>
Reviewed-by: Christian Ruppert <christian.ruppert@abilis.com>
---
 drivers/i2c/busses/i2c-designware-platdrv.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index fc24399..ae0a256 100644
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
 
+	/* fast mode by default */
+	clk_freq = 400000;
+
 	if (pdev->dev.of_node) {
 		u32 ht = 0;
 		u32 ic_clk = dev->get_clk_rate_khz(dev);
@@ -166,6 +170,15 @@ static int dw_i2c_probe(struct platform_device *pdev)
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
+		if (clk_freq != 100000 && clk_freq != 400000)
+			return -EINVAL;
 	}
 
 	dev->functionality =
@@ -175,8 +188,12 @@ static int dw_i2c_probe(struct platform_device *pdev)
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

