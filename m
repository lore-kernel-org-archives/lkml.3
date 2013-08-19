Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414Ab3HSMH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 08:07:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:25372 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234Ab3HSMH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 08:07:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,913,1367996400"; 
   d="scan'208";a="383046541"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Shinya Kuribayashi <skuribay@pobox.com>, linux-i2c@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 1/2] i2c-designware: make HCNT/LCNT values configurable
Date: Mon, 19 Aug 2013 15:07:53 +0300
Message-Id: <1376914074-31103-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DesignWare I2C controller has high count (HCNT) and low count (LCNT)
registers for each of the I2C speed modes (standard and fast). These
registers are programmed based on the input clock speed in the driver.

The current code calculates these values based on the input clock speed and
tries hard to meet the I2C bus timing requirements. This could result
non-optimal values with regarding to the bus speed. For example on Intel
BayTrail we get bus speed of 315.41kHz which is ~20% slower than we would
expect (400kHz) in fast mode (even though the timing requirements are met).

This patch makes it possible for the platform code to pass more optimal
HCNT/LCNT values to the core driver if they are known beforehand. If these
are not set we use the calculated and more conservative values.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
Changes to the previous version:
 * Updated changelog
 * Reduce indentation as suggested by Shinya Kuribayashi

 drivers/i2c/busses/i2c-designware-core.c | 11 +++++++++++
 drivers/i2c/busses/i2c-designware-core.h | 12 ++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index ad46616..c73eaea 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -317,6 +317,12 @@ int i2c_dw_init(struct dw_i2c_dev *dev)
 				47,	/* tLOW = 4.7 us */
 				3,	/* tf = 0.3 us */
 				0);	/* No offset */
+
+	/* Allow platforms to specify the ideal HCNT and LCNT values */
+	if (dev->ss_hcnt && dev->ss_lcnt) {
+		hcnt = dev->ss_hcnt;
+		lcnt = dev->ss_lcnt;
+	}
 	dw_writel(dev, hcnt, DW_IC_SS_SCL_HCNT);
 	dw_writel(dev, lcnt, DW_IC_SS_SCL_LCNT);
 	dev_dbg(dev->dev, "Standard-mode HCNT:LCNT = %d:%d\n", hcnt, lcnt);
@@ -331,6 +337,11 @@ int i2c_dw_init(struct dw_i2c_dev *dev)
 				13,	/* tLOW = 1.3 us */
 				3,	/* tf = 0.3 us */
 				0);	/* No offset */
+
+	if (dev->fs_hcnt && dev->fs_lcnt) {
+		hcnt = dev->fs_hcnt;
+		lcnt = dev->fs_lcnt;
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
1.8.4.rc2

