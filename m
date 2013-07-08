Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab3GHLnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 07:43:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:40947 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab3GHLnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 07:43:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1020,1363158000"; 
   d="scan'208";a="361982704"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] i2c-designware: make *CNT values configurable
Date: Mon,  8 Jul 2013 14:45:26 +0300
Message-Id: <1373283927-21677-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DesignWare I2C controller has high count (HCNT) and low count (LCNT)
registers for each of the I2C speed modes (standard and fast). These
registers are programmed based on the input clock speed in the driver.

However, that is not always the most accurate way. For example on Intel
BayTrail we have 100MHz input clock and calculated *CNT values result as
measured by one of our team:

 Standard mode: 100.25kHz
 Fast mode    : 315.41kHZ

The fast mode speed is over 20% lower than what is expected. It might be
that there are things like strenght of the pull-up resistors, bus
capacitance etc. that are very platform specific and have an effect on the
clock signal.

With this patch we let the platform code to specify more accurate, optimal
*CNT values if they are known beforehand.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/i2c/busses/i2c-designware-core.c | 46 +++++++++++++++++++-------------
 drivers/i2c/busses/i2c-designware-core.h | 12 +++++++++
 2 files changed, 40 insertions(+), 18 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index ad46616..f31469e 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -308,29 +308,39 @@ int i2c_dw_init(struct dw_i2c_dev *dev)
 	/* set standard and fast speed deviders for high/low periods */
 
 	/* Standard-mode */
-	hcnt = i2c_dw_scl_hcnt(input_clock_khz,
-				40,	/* tHD;STA = tHIGH = 4.0 us */
-				3,	/* tf = 0.3 us */
-				0,	/* 0: DW default, 1: Ideal */
-				0);	/* No offset */
-	lcnt = i2c_dw_scl_lcnt(input_clock_khz,
-				47,	/* tLOW = 4.7 us */
-				3,	/* tf = 0.3 us */
-				0);	/* No offset */
+	if (dev->ss_hcnt && dev->ss_lcnt) {
+		hcnt = dev->ss_hcnt;
+		lcnt = dev->ss_lcnt;
+	} else {
+		hcnt = i2c_dw_scl_hcnt(input_clock_khz,
+					40,	/* tHD;STA = tHIGH = 4.0 us */
+					3,	/* tf = 0.3 us */
+					0,	/* 0: DW default, 1: Ideal */
+					0);	/* No offset */
+		lcnt = i2c_dw_scl_lcnt(input_clock_khz,
+					47,	/* tLOW = 4.7 us */
+					3,	/* tf = 0.3 us */
+					0);	/* No offset */
+	}
 	dw_writel(dev, hcnt, DW_IC_SS_SCL_HCNT);
 	dw_writel(dev, lcnt, DW_IC_SS_SCL_LCNT);
 	dev_dbg(dev->dev, "Standard-mode HCNT:LCNT = %d:%d\n", hcnt, lcnt);
 
 	/* Fast-mode */
-	hcnt = i2c_dw_scl_hcnt(input_clock_khz,
-				6,	/* tHD;STA = tHIGH = 0.6 us */
-				3,	/* tf = 0.3 us */
-				0,	/* 0: DW default, 1: Ideal */
-				0);	/* No offset */
-	lcnt = i2c_dw_scl_lcnt(input_clock_khz,
-				13,	/* tLOW = 1.3 us */
-				3,	/* tf = 0.3 us */
-				0);	/* No offset */
+	if (dev->fs_hcnt && dev->fs_lcnt) {
+		hcnt = dev->fs_hcnt;
+		lcnt = dev->fs_lcnt;
+	} else {
+		hcnt = i2c_dw_scl_hcnt(input_clock_khz,
+					6,	/* tHD;STA = tHIGH = 0.6 us */
+					3,	/* tf = 0.3 us */
+					0,	/* 0: DW default, 1: Ideal */
+					0);	/* No offset */
+		lcnt = i2c_dw_scl_lcnt(input_clock_khz,
+					13,	/* tLOW = 1.3 us */
+					3,	/* tf = 0.3 us */
+					0);	/* No offset */
+	}
 	dw_writel(dev, hcnt, DW_IC_FS_SCL_HCNT);
 	dw_writel(dev, lcnt, DW_IC_FS_SCL_LCNT);
 	dev_dbg(dev->dev, "Fast-mode HCNT:LCNT = %d:%d\n", hcnt, lcnt);
diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
index 912aa22..e8a7565 100644
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -61,6 +61,14 @@
  * @tx_fifo_depth: depth of the hardware tx fifo
  * @rx_fifo_depth: depth of the hardware rx fifo
  * @rx_outstanding: current master-rx elements in tx fifo
+ * @ss_hcnt: standard speed HCNT value
+ * @ss_lcnt: standard speed LCNT value
+ * @fs_hcnt: fast speed HCNT value
+ * @fs_lcnt: fast speed LCNT value
+ *
+ * HCNT and LCNT parameters can be used if the platform knows more accurate
+ * values than the one computed based only on the input clock frequency.
+ * Leave them to be %0 if not used.
  */
 struct dw_i2c_dev {
 	struct device		*dev;
@@ -91,6 +99,10 @@ struct dw_i2c_dev {
 	unsigned int		rx_fifo_depth;
 	int			rx_outstanding;
 	u32			sda_hold_time;
+	u16			ss_hcnt;
+	u16			ss_lcnt;
+	u16			fs_hcnt;
+	u16			fs_lcnt;
 };
 
 #define ACCESS_SWAP		0x00000001
-- 
1.8.3.2

