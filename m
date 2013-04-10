Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937261Ab3DJKi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:38:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:57085 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711Ab3DJKep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:34:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,445,1363158000"; 
   d="scan'208";a="315911800"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        ben-linux@fluff.org, Jean Delvare <khali@linux-fr.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 5/7] i2c-designware: enable/disable the controller properly
Date: Wed, 10 Apr 2013 13:36:40 +0300
Message-Id: <1365590202-1623-5-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365590202-1623-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1365590202-1623-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The correct way to disable or enable the controller is to wait until the
DW_IC_ENABLE_STATUS register bit matches the bit we program into DW_IC_ENABLE
register. This procedure is described in the DesignWare I2C databook.

By doing this we can be sure that the controller is in correct state once
the function returns.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
Changes to v1:
	- Added comment about why we sleep 25us after each iteration.
	- } while (timeout--); instead of } while (timeout-- > 0);

 drivers/i2c/busses/i2c-designware-core.c |   34 ++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 94fd818..5cc4ebf 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -68,6 +68,7 @@
 #define DW_IC_TXFLR		0x74
 #define DW_IC_RXFLR		0x78
 #define DW_IC_TX_ABRT_SOURCE	0x80
+#define DW_IC_ENABLE_STATUS	0x9c
 #define DW_IC_COMP_PARAM_1	0xf4
 #define DW_IC_COMP_TYPE		0xfc
 #define DW_IC_COMP_TYPE_VALUE	0x44570140
@@ -248,6 +249,27 @@ static u32 i2c_dw_scl_lcnt(u32 ic_clk, u32 tLOW, u32 tf, int offset)
 	return ((ic_clk * (tLOW + tf) + 5000) / 10000) - 1 + offset;
 }
 
+static void __i2c_dw_enable(struct dw_i2c_dev *dev, bool enable)
+{
+	int timeout = 100;
+
+	do {
+		dw_writel(dev, enable, DW_IC_ENABLE);
+		if ((dw_readl(dev, DW_IC_ENABLE_STATUS) & 1) == enable)
+			return;
+
+		/*
+		 * Wait 10 times the signaling period of the highest I2C
+		 * transfer supported by the driver (for 400KHz this is
+		 * 25us) as described in the DesignWare I2C databook.
+		 */
+		usleep_range(25, 250);
+	} while (timeout--);
+
+	dev_warn(dev->dev, "timeout in %sabling adapter\n",
+		 enable ? "en" : "dis");
+}
+
 /**
  * i2c_dw_init() - initialize the designware i2c master hardware
  * @dev: device private data
@@ -278,7 +300,7 @@ int i2c_dw_init(struct dw_i2c_dev *dev)
 	}
 
 	/* Disable the adapter */
-	dw_writel(dev, 0, DW_IC_ENABLE);
+	__i2c_dw_enable(dev, false);
 
 	/* set standard and fast speed deviders for high/low periods */
 
@@ -345,7 +367,7 @@ static void i2c_dw_xfer_init(struct dw_i2c_dev *dev)
 	u32 ic_con;
 
 	/* Disable the adapter */
-	dw_writel(dev, 0, DW_IC_ENABLE);
+	__i2c_dw_enable(dev, false);
 
 	/* set the slave (target) address */
 	dw_writel(dev, msgs[dev->msg_write_idx].addr, DW_IC_TAR);
@@ -359,7 +381,7 @@ static void i2c_dw_xfer_init(struct dw_i2c_dev *dev)
 	dw_writel(dev, ic_con, DW_IC_CON);
 
 	/* Enable the adapter */
-	dw_writel(dev, 1, DW_IC_ENABLE);
+	__i2c_dw_enable(dev, true);
 
 	/* Enable interrupts */
 	dw_writel(dev, DW_IC_INTR_DEFAULT_MASK, DW_IC_INTR_MASK);
@@ -565,7 +587,7 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 	/* no error */
 	if (likely(!dev->cmd_err)) {
 		/* Disable the adapter */
-		dw_writel(dev, 0, DW_IC_ENABLE);
+		__i2c_dw_enable(dev, false);
 		ret = num;
 		goto done;
 	}
@@ -700,7 +722,7 @@ EXPORT_SYMBOL_GPL(i2c_dw_isr);
 void i2c_dw_enable(struct dw_i2c_dev *dev)
 {
        /* Enable the adapter */
-	dw_writel(dev, 1, DW_IC_ENABLE);
+	__i2c_dw_enable(dev, true);
 }
 EXPORT_SYMBOL_GPL(i2c_dw_enable);
 
@@ -713,7 +735,7 @@ EXPORT_SYMBOL_GPL(i2c_dw_is_enabled);
 void i2c_dw_disable(struct dw_i2c_dev *dev)
 {
 	/* Disable controller */
-	dw_writel(dev, 0, DW_IC_ENABLE);
+	__i2c_dw_enable(dev, false);
 
 	/* Disable all interupts */
 	dw_writel(dev, 0, DW_IC_INTR_MASK);
-- 
1.7.10.4

