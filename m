Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaKVTr1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 14:47:27 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:45009 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbaKVTrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 14:47:24 -0500
From: Alexander Kochetkov <al.kochet@gmail.com>
To: linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, al.kochet@gmail.com
Subject: [PATCH v3 2/4] i2c: omap: implement workaround for handling invalid BB-bit values
Date: Sat, 22 Nov 2014 23:47:12 +0400
Message-Id: <1416685634-5864-3-git-send-email-al.kochet@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1416685634-5864-1-git-send-email-al.kochet@gmail.com>
References: <1416518925-20679-1-git-send-email-al.kochet@gmail.com>
 <1416685634-5864-1-git-send-email-al.kochet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a multimaster environment, after IP software reset, BB-bit value doesn't
correspond to the current bus state. It may happen what BB-bit will be 0,
while the bus is busy due to another I2C master activity.

Any transfer started when BB=0 and bus is busy wouldn't be completed by IP
and results in controller timeout. More over, in some cases IP could
interrupt another master's transfer and corrupt data on wire.

The commit implement method allowing to prevent IP from entering into
"controller timeout" state and from "data corruption" state.

The one drawback is the need to wait for 10ms before the first transfer.

Tested on Beagleboard XM C.
Tested on BBB and AM437x Starter Kit by Felipe Balbi.

Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
Tested-by: Felipe Balbi <balbi@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |  103 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index adfac9b..a238a1d 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -54,6 +54,9 @@
 /* timeout for pm runtime autosuspend */
 #define OMAP_I2C_PM_TIMEOUT		1000	/* ms */
 
+/* timeout for making decision on bus free status */
+#define OMAP_I2C_BUS_FREE_TIMEOUT (msecs_to_jiffies(10))
+
 /* For OMAP3 I2C_IV has changed to I2C_WE (wakeup enable) */
 enum {
 	OMAP_I2C_REV_REG = 0,
@@ -206,6 +209,9 @@ struct omap_i2c_dev {
 						 */
 	u32			rev;
 	unsigned		b_hw:1;		/* bad h/w fixes */
+	unsigned		bb_valid:1;	/* true when BB-bit reflects
+						 * the I2C bus state
+						 */
 	unsigned		receiver:1;	/* true when we're in receiver mode */
 	u16			iestate;	/* Saved interrupt register */
 	u16			pscstate;
@@ -332,7 +338,10 @@ static int omap_i2c_reset(struct omap_i2c_dev *dev)
 		/* SYSC register is cleared by the reset; rewrite it */
 		omap_i2c_write_reg(dev, OMAP_I2C_SYSC_REG, sysc);
 
+		/* Schedule I2C-bus monitoring on the next transfer */
+		dev->bb_valid = 0;
 	}
+
 	return 0;
 }
 
@@ -445,6 +454,11 @@ static int omap_i2c_init(struct omap_i2c_dev *dev)
 	dev->scllstate = scll;
 	dev->sclhstate = sclh;
 
+	if (dev->rev < OMAP_I2C_OMAP1_REV_2) {
+		/* Not implemented */
+		dev->bb_valid = 1;
+	}
+
 	__omap_i2c_init(dev);
 
 	return 0;
@@ -469,6 +483,91 @@ static int omap_i2c_wait_for_bb(struct omap_i2c_dev *dev)
 	return 0;
 }
 
+/*
+ * Wait while BB-bit doesn't reflect the I2C bus state
+ *
+ * In a multimaster environment, after IP software reset, BB-bit value doesn't
+ * correspond to the current bus state. It may happen what BB-bit will be 0,
+ * while the bus is busy due to another I2C master activity.
+ * Here are BB-bit values after reset:
+ *     SDA   SCL   BB   NOTES
+ *       0     0    0   1, 2
+ *       1     0    0   1, 2
+ *       0     1    1
+ *       1     1    0   3
+ * Later, if IP detect SDA=0 and SCL=1 (ACK) or SDA 1->0 while SCL=1 (START)
+ * combinations on the bus, it set BB-bit to 1.
+ * If IP detect SDA 0->1 while SCL=1 (STOP) combination on the bus,
+ * it set BB-bit to 0 and BF to 1.
+ * BB and BF bits correctly tracks the bus state while IP is suspended
+ * BB bit became valid on the next FCLK clock after CON_EN bit set
+ *
+ * NOTES:
+ * 1. Any transfer started when BB=0 and bus is busy wouldn't be
+ *    completed by IP and results in controller timeout.
+ * 2. Any transfer started when BB=0 and SCL=0 results in IP
+ *    starting to drive SDA low. In that case IP corrupt data
+ *    on the bus.
+ * 3. Any transfer started in the middle of another master's transfer
+ *    results in unpredictable results and data corruption
+ */
+static int omap_i2c_wait_for_bb_valid(struct omap_i2c_dev *dev)
+{
+	unsigned long bus_free_timeout = 0;
+	unsigned long timeout;
+	int bus_free = 0;
+	u16 stat, systest;
+
+	if (dev->bb_valid)
+		return 0;
+
+	timeout = jiffies + OMAP_I2C_TIMEOUT;
+	while (1) {
+		stat = omap_i2c_read_reg(dev, OMAP_I2C_STAT_REG);
+		/*
+		 * We will see BB or BF event in a case IP had detected any
+		 * activity on the I2C bus. Now IP correctly tracks the bus
+		 * state. BB-bit value is valid.
+		 */
+		if (stat & (OMAP_I2C_STAT_BB | OMAP_I2C_STAT_BF))
+			break;
+
+		/*
+		 * Otherwise, we must look signals on the bus to make
+		 * the right decision.
+		 */
+		systest = omap_i2c_read_reg(dev, OMAP_I2C_SYSTEST_REG);
+		if ((systest & OMAP_I2C_SYSTEST_SCL_I_FUNC) &&
+		    (systest & OMAP_I2C_SYSTEST_SDA_I_FUNC)) {
+			if (!bus_free) {
+				bus_free_timeout = jiffies +
+					OMAP_I2C_BUS_FREE_TIMEOUT;
+				bus_free = 1;
+			}
+
+			/*
+			 * SDA and SCL lines was high for 10 ms without bus
+			 * activity detected. The bus is free. Consider
+			 * BB-bit value is valid.
+			 */
+			if (time_after(jiffies, bus_free_timeout))
+				break;
+		} else {
+			bus_free = 0;
+		}
+
+		if (time_after(jiffies, timeout)) {
+			dev_warn(dev->dev, "timeout waiting for bus ready\n");
+			return -ETIMEDOUT;
+		}
+
+		msleep(1);
+	}
+
+	dev->bb_valid = 1;
+	return 0;
+}
+
 static void omap_i2c_resize_fifo(struct omap_i2c_dev *dev, u8 size, bool is_rx)
 {
 	u16		buf;
@@ -639,6 +738,10 @@ omap_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 	if (r < 0)
 		goto out;
 
+	r = omap_i2c_wait_for_bb_valid(dev);
+	if (r < 0)
+		goto out;
+
 	r = omap_i2c_wait_for_bb(dev);
 	if (r < 0)
 		goto out;
-- 
1.7.9.5

