Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab3IZK6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 06:58:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:46031 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756306Ab3IZK6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 06:58:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,984,1371106800"; 
   d="scan'208";a="365834004"
From: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Christian Ruppert <christian.ruppert@abilis.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i2c-designware: 10-bit addressing mode enabling if I2C_DYNAMIC_TAR_UPDATE is set.
Date: Fri, 27 Sep 2013 02:57:35 +0800
Message-Id: <1380221855-14150-1-git-send-email-chiau.ee.chew@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Designware I2C spec, if I2C_DYNAMIC_TAR_UPDATE is set to 1,
the 10-bit addressing mode is controlled by IC_10BITADDR_MASTER bit of
IC_TAR register instead of IC_CON register. The IC_10BITADDR_MASTER
in IC_CON register becomes read-only copy. Since I2C_DYNAMIC_TAR_UPDATE
value can't be detected from hardware register, so we will always set the
IC_10BITADDR_MASTER bit in both IC_CON and IC_TAR register whenever 10-bit
addresing mode is requested by user application.

Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/i2c/busses/i2c-designware-core.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index dbecf08..5888fee 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -98,6 +98,8 @@
 
 #define DW_IC_ERR_TX_ABRT	0x1
 
+#define DW_IC_TAR_10BITADDR_MASTER BIT(12)
+
 /*
  * status codes
  */
@@ -388,22 +390,34 @@ static int i2c_dw_wait_bus_not_busy(struct dw_i2c_dev *dev)
 static void i2c_dw_xfer_init(struct dw_i2c_dev *dev)
 {
 	struct i2c_msg *msgs = dev->msgs;
-	u32 ic_con;
+	u32 ic_con, ic_tar = 0;
 
 	/* Disable the adapter */
 	__i2c_dw_enable(dev, false);
 
-	/* set the slave (target) address */
-	dw_writel(dev, msgs[dev->msg_write_idx].addr, DW_IC_TAR);
-
 	/* if the slave address is ten bit address, enable 10BITADDR */
 	ic_con = dw_readl(dev, DW_IC_CON);
-	if (msgs[dev->msg_write_idx].flags & I2C_M_TEN)
+	if (msgs[dev->msg_write_idx].flags & I2C_M_TEN) {
 		ic_con |= DW_IC_CON_10BITADDR_MASTER;
-	else
+		/*
+		 * If I2C_DYNAMIC_TAR_UPDATE is set, the 10-bit addressing
+		 * mode has to be enabled via bit 12 of IC_TAR register.
+		 * We set it always as I2C_DYNAMIC_TAR_UPDATE can't be
+		 * detected from registers.
+		 */
+		ic_tar = DW_IC_TAR_10BITADDR_MASTER;
+	} else {
 		ic_con &= ~DW_IC_CON_10BITADDR_MASTER;
+	}
+
 	dw_writel(dev, ic_con, DW_IC_CON);
 
+	/*
+	 * Set the slave (target) address and enable 10-bit addressing mode
+	 * if applicable.
+	 */
+	dw_writel(dev, msgs[dev->msg_write_idx].addr | ic_tar, DW_IC_TAR);
+
 	/* Enable the adapter */
 	__i2c_dw_enable(dev, true);
 
-- 
1.7.4.4

