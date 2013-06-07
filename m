Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab3FGPmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:42:40 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:50104 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479Ab3FGPmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:42:31 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>, linux-kernel@vger.kernel.org,
        Zbigniew Bodek <zbb@semihalf.com>, Piotr Ziecik <kosmo@semihalf.com>
Subject: [PATCH 1/2] i2c-mv64xxx: Add I2C Transaction Generator support
Date: Fri,  7 Jun 2013 17:42:22 +0200
Message-Id: <1370619743-15245-2-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370619743-15245-1-git-send-email-gregory.clement@free-electrons.com>
References: <1370619743-15245-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zbigniew Bodek <zbb@semihalf.com>

The I2C Transaction Generator offloads CPU from managing I2C
transfer step by step.

This feature is currently only available on Armada XP, so usage of
this mechanism is activated through device tree.

[gregory.clement@free-electrons.com: Rewrite some part to be applied
on the the code modified by Russell King's fixes]
[gregory.clement@free-electrons.com: Merge and split the commits to
push them to the accurate maintainer i2c and of]]
[gregory.clement@free-electrons.com: Reword the commit log]

Signed-off-by: Piotr Ziecik <kosmo@semihalf.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/i2c/busses/i2c-mv64xxx.c | 143 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 139 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index 6356439..5376dc3 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -24,7 +24,7 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 
-/* Register defines */
+/* Register defines (I2C port) */
 #define	MV64XXX_I2C_REG_SLAVE_ADDR			0x00
 #define	MV64XXX_I2C_REG_DATA				0x04
 #define	MV64XXX_I2C_REG_CONTROL				0x08
@@ -59,6 +59,29 @@
 #define	MV64XXX_I2C_STATUS_MAST_RD_ADDR_2_NO_ACK	0xe8
 #define	MV64XXX_I2C_STATUS_NO_STATUS			0xf8
 
+/* Register defines (I2C bridge) */
+#define	MV64XXX_I2C_REG_TX_DATA_LO			0xC0
+#define	MV64XXX_I2C_REG_TX_DATA_HI			0xC4
+#define	MV64XXX_I2C_REG_RX_DATA_LO			0xC8
+#define	MV64XXX_I2C_REG_RX_DATA_HI			0xCC
+#define	MV64XXX_I2C_REG_BRIDGE_CONTROL			0xD0
+#define	MV64XXX_I2C_REG_BRIDGE_STATUS			0xD4
+#define	MV64XXX_I2C_REG_BRIDGE_INTR_CAUSE		0xD8
+#define	MV64XXX_I2C_REG_BRIDGE_INTR_MASK		0xDC
+#define	MV64XXX_I2C_REG_BRIDGE_TIMING			0xE0
+
+/* Bridge Control values */
+#define	MV64XXX_I2C_BRIDGE_CONTROL_WR			0x00000001
+#define	MV64XXX_I2C_BRIDGE_CONTROL_RD			0x00000002
+#define	MV64XXX_I2C_BRIDGE_CONTROL_ADDR_SHIFT		2
+#define	MV64XXX_I2C_BRIDGE_CONTROL_ADDR_EXT		0x00001000
+#define	MV64XXX_I2C_BRIDGE_CONTROL_TX_SIZE_SHIFT	13
+#define	MV64XXX_I2C_BRIDGE_CONTROL_RX_SIZE_SHIFT	16
+#define	MV64XXX_I2C_BRIDGE_CONTROL_ENABLE		0x00080000
+
+/* Bridge Status values */
+#define	MV64XXX_I2C_BRIDGE_STATUS_ERROR			0x00000001
+
 /* Driver states */
 enum {
 	MV64XXX_I2C_STATE_INVALID,
@@ -110,6 +133,7 @@ struct mv64xxx_i2c_data {
 	spinlock_t		lock;
 	struct i2c_msg		*msg;
 	struct i2c_adapter	adapter;
+	int			bridge_enabled;
 };
 
 static void
@@ -157,6 +181,16 @@ mv64xxx_i2c_hw_init(struct mv64xxx_i2c_data *drv_data)
 	writel(0, drv_data->reg_base + MV64XXX_I2C_REG_EXT_SLAVE_ADDR);
 	writel(MV64XXX_I2C_REG_CONTROL_TWSIEN | MV64XXX_I2C_REG_CONTROL_STOP,
 		drv_data->reg_base + MV64XXX_I2C_REG_CONTROL);
+
+	if (drv_data->bridge_enabled) {
+		writel(0, drv_data->reg_base + MV64XXX_I2C_REG_BRIDGE_CONTROL);
+		writel(0, drv_data->reg_base + MV64XXX_I2C_REG_BRIDGE_TIMING);
+		writel(0, drv_data->reg_base +
+			MV64XXX_I2C_REG_BRIDGE_INTR_CAUSE);
+		writel(0, drv_data->reg_base +
+			MV64XXX_I2C_REG_BRIDGE_INTR_MASK);
+	}
+
 	drv_data->state = MV64XXX_I2C_STATE_IDLE;
 }
 
@@ -368,6 +402,19 @@ mv64xxx_i2c_intr(int irq, void *dev_id)
 	irqreturn_t	rc = IRQ_NONE;
 
 	spin_lock_irqsave(&drv_data->lock, flags);
+
+	if (drv_data->bridge_enabled) {
+		if (readl(drv_data->reg_base +
+				MV64XXX_I2C_REG_BRIDGE_INTR_CAUSE)) {
+			writel(0, drv_data->reg_base +
+				MV64XXX_I2C_REG_BRIDGE_CONTROL);
+			writel(0, drv_data->reg_base +
+				MV64XXX_I2C_REG_BRIDGE_INTR_CAUSE);
+			drv_data->block = 0;
+			wake_up(&drv_data->waitq);
+			rc = IRQ_HANDLED;
+		}
+	}
 	while (readl(drv_data->reg_base + MV64XXX_I2C_REG_CONTROL) &
 						MV64XXX_I2C_REG_CONTROL_IFLG) {
 		status = readl(drv_data->reg_base + MV64XXX_I2C_REG_STATUS);
@@ -446,6 +493,81 @@ mv64xxx_i2c_execute_msg(struct mv64xxx_i2c_data *drv_data, struct i2c_msg *msg,
 	return drv_data->rc;
 }
 
+static int
+mv64xxx_i2c_offload_msg(struct mv64xxx_i2c_data *drv_data, struct i2c_msg *msg)
+{
+	unsigned long data_reg_hi = 0;
+	unsigned long data_reg_lo = 0;
+	unsigned long status_reg;
+	unsigned long ctrl_reg;
+	unsigned long flags;
+	unsigned int i;
+
+	/* Only regular transactions can be offloaded */
+	if ((msg->flags & ~(I2C_M_TEN | I2C_M_RD)) != 0)
+		return 1;
+
+	/* Only 1-8 byte transfers can be offloaded */
+	if (msg->len < 1 || msg->len > 8)
+		return 1;
+
+	/* Build transaction */
+	ctrl_reg = MV64XXX_I2C_BRIDGE_CONTROL_ENABLE |
+		   (msg->addr << MV64XXX_I2C_BRIDGE_CONTROL_ADDR_SHIFT);
+
+	if ((msg->flags & I2C_M_TEN) != 0)
+		ctrl_reg |=  MV64XXX_I2C_BRIDGE_CONTROL_ADDR_EXT;
+
+	if ((msg->flags & I2C_M_RD) == 0) {
+		for (i = 0; i < 4 && i < msg->len; i++)
+			data_reg_lo = data_reg_lo |
+					(msg->buf[i] << ((i & 0x3) * 8));
+
+		for (i = 4; i < 8 && i < msg->len; i++)
+			data_reg_hi = data_reg_hi |
+					(msg->buf[i] << ((i & 0x3) * 8));
+
+		ctrl_reg |= MV64XXX_I2C_BRIDGE_CONTROL_WR |
+		    (msg->len - 1) << MV64XXX_I2C_BRIDGE_CONTROL_TX_SIZE_SHIFT;
+	} else {
+		ctrl_reg |= MV64XXX_I2C_BRIDGE_CONTROL_RD |
+		    (msg->len - 1) << MV64XXX_I2C_BRIDGE_CONTROL_RX_SIZE_SHIFT;
+	}
+
+	/* Execute transaction */
+	spin_lock_irqsave(&drv_data->lock, flags);
+	drv_data->block = 1;
+	writel(data_reg_lo, drv_data->reg_base + MV64XXX_I2C_REG_TX_DATA_LO);
+	writel(data_reg_hi, drv_data->reg_base + MV64XXX_I2C_REG_TX_DATA_HI);
+	writel(ctrl_reg, drv_data->reg_base + MV64XXX_I2C_REG_BRIDGE_CONTROL);
+	spin_unlock_irqrestore(&drv_data->lock, flags);
+
+	mv64xxx_i2c_wait_for_completion(drv_data);
+
+	spin_lock_irqsave(&drv_data->lock, flags);
+	status_reg = readl(drv_data->reg_base + MV64XXX_I2C_REG_BRIDGE_STATUS);
+	data_reg_lo = readl(drv_data->reg_base + MV64XXX_I2C_REG_RX_DATA_LO);
+	data_reg_hi = readl(drv_data->reg_base + MV64XXX_I2C_REG_RX_DATA_HI);
+	spin_unlock_irqrestore(&drv_data->lock, flags);
+
+	if (status_reg & MV64XXX_I2C_BRIDGE_STATUS_ERROR)
+		return -EIO;
+
+	if ((msg->flags & I2C_M_RD) != 0) {
+		for (i = 0; i < 4 && i < msg->len; i++) {
+			msg->buf[i] = data_reg_lo & 0xFF;
+			data_reg_lo >>= 8;
+		}
+
+		for (i = 4; i < 8 && i < msg->len; i++) {
+			msg->buf[i] = data_reg_hi & 0xFF;
+			data_reg_hi >>= 8;
+		}
+	}
+
+	return 0;
+}
+
 /*
  *****************************************************************************
  *
@@ -463,13 +585,15 @@ static int
 mv64xxx_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 {
 	struct mv64xxx_i2c_data *drv_data = i2c_get_adapdata(adap);
-	int rc, ret = num;
+	int rc = 1, ret = num;
 
 	BUG_ON(drv_data->msgs != NULL);
 	drv_data->msgs = msgs;
 	drv_data->num_msgs = num;
-
-	rc = mv64xxx_i2c_execute_msg(drv_data, &msgs[0], num == 1);
+	if (drv_data->bridge_enabled)
+		rc = mv64xxx_i2c_offload_msg(drv_data, &msgs[0]);
+	if (rc > 0)
+		rc = mv64xxx_i2c_execute_msg(drv_data, &msgs[0], num == 1);
 	if (rc < 0)
 		ret = rc;
 
@@ -528,6 +652,7 @@ mv64xxx_of_config(struct mv64xxx_i2c_data *drv_data,
 {
 	u32 bus_freq, tclk;
 	int rc = 0;
+	const char *bridge_status;
 
 	/* CLK is mandatory when using DT to describe the i2c bus. We
 	 * need to know tclk in order to calculate bus clock
@@ -554,6 +679,15 @@ mv64xxx_of_config(struct mv64xxx_i2c_data *drv_data,
 	 * So hard code the value to 1 second.
 	 */
 	drv_data->adapter.timeout = HZ;
+
+	/*
+	 * Acquire information on Transaction Generator support.
+	 */
+	bridge_status = of_get_property(np, "", NULL);
+	if (of_property_read_bool(np, "i2c,i2c-bridge"))
+		drv_data->bridge_enabled = 1;
+	else
+		drv_data->bridge_enabled = 0;
 out:
 	return rc;
 #endif
@@ -607,6 +741,7 @@ mv64xxx_i2c_probe(struct platform_device *pd)
 		drv_data->freq_n = pdata->freq_n;
 		drv_data->irq = platform_get_irq(pd, 0);
 		drv_data->adapter.timeout = msecs_to_jiffies(pdata->timeout);
+		drv_data->bridge_enabled = 0;
 	} else if (pd->dev.of_node) {
 		rc = mv64xxx_of_config(drv_data, pd->dev.of_node);
 		if (rc)
-- 
1.8.1.2

