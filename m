Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbbA2H2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 02:28:43 -0500
Received: from fallback8.mail.ru ([94.100.181.110]:59031 "EHLO
	fallback8.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbbA2H2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 02:28:40 -0500
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Jan 2015 02:28:39 EST
From: Andrey Danin <danindrey@mail.ru>
To: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        ac100@lists.launchpad.net
Cc: Andrey Danin <danindrey@mail.ru>, Laxman Dewangan <ldewangan@nvidia.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, Marc Dietrich <marvin24@gmx.de>
Subject: [PATCH 1/3] i2c: tegra: implement slave mode
Date: Thu, 29 Jan 2015 10:20:20 +0300
Message-Id: <1422516022-27161-2-git-send-email-danindrey@mail.ru>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422516022-27161-1-git-send-email-danindrey@mail.ru>
References: <1422516022-27161-1-git-send-email-danindrey@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialization code is based on NVEC driver.

There is a HW bug in AP20 that was also mentioned in kernel sources
for Toshiba AC100.

Signed-off-by: Andrey Danin <danindrey@mail.ru>
---
 drivers/i2c/busses/i2c-tegra.c | 131 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 28b87e6..cfc4e67 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -42,8 +42,15 @@
 #define I2C_SL_CNFG				0x020
 #define I2C_SL_CNFG_NACK			(1<<1)
 #define I2C_SL_CNFG_NEWSL			(1<<2)
+#define I2C_SL_RCVD				0x024
+#define I2C_SL_STATUS				0x028
+#define I2C_SL_ST_IRQ				(1<<3)
+#define I2C_SL_ST_END_TRANS			(1<<4)
+#define I2C_SL_ST_RCVD				(1<<2)
+#define I2C_SL_ST_RNW				(1<<1)
 #define I2C_SL_ADDR1				0x02c
 #define I2C_SL_ADDR2				0x030
+#define I2C_SL_DELAY_COUNT			0x03c
 #define I2C_TX_FIFO				0x050
 #define I2C_RX_FIFO				0x054
 #define I2C_PACKET_TRANSFER_STATUS		0x058
@@ -125,6 +132,8 @@ enum msg_end_type {
  * @clk_divisor_std_fast_mode: Clock divisor in standard/fast mode. It is
  *		applicable if there is no fast clock source i.e. single clock
  *		source.
+ * @slave_read_start_delay: Workaround for AP20 I2C Slave Controller bug. Delay
+ *              before writing data byte into register I2C_SL_RCVD.
  */
 
 struct tegra_i2c_hw_feature {
@@ -133,6 +142,7 @@ struct tegra_i2c_hw_feature {
 	bool has_single_clk_source;
 	int clk_divisor_hs_mode;
 	int clk_divisor_std_fast_mode;
+	int slave_read_start_delay;
 };
 
 /**
@@ -173,6 +183,7 @@ struct tegra_i2c_dev {
 	int msg_read;
 	u32 bus_clk_rate;
 	bool is_suspended;
+	struct i2c_client *slave;
 };
 
 static void dvc_writel(struct tegra_i2c_dev *i2c_dev, u32 val, unsigned long reg)
@@ -398,6 +409,12 @@ static inline int tegra_i2c_clock_enable(struct tegra_i2c_dev *i2c_dev)
 
 static inline void tegra_i2c_clock_disable(struct tegra_i2c_dev *i2c_dev)
 {
+	if (i2c_dev->slave) {
+		dev_warn(i2c_dev->dev,
+			"i2c slave is registered, don't disable a clock\n");
+		return;
+	}
+
 	clk_disable(i2c_dev->div_clk);
 	if (!i2c_dev->hw->has_single_clk_source)
 		clk_disable(i2c_dev->fast_clk);
@@ -459,12 +476,84 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
 	return err;
 }
 
+static inline int is_ready(unsigned long status)
+{
+	return status & I2C_SL_ST_IRQ;
+}
+
+static inline int is_write(unsigned long status)
+{
+	return (status & I2C_SL_ST_RNW) == 0;
+}
+
+static inline int is_read(unsigned long status)
+{
+	return !is_write(status);
+}
+
+static inline int is_trans_start(unsigned long status)
+{
+	return status & I2C_SL_ST_RCVD;
+}
+
+static inline int is_trans_end(unsigned long status)
+{
+	return status & I2C_SL_ST_END_TRANS;
+}
+
+static bool tegra_i2c_slave_isr(int irq, struct tegra_i2c_dev *i2c_dev)
+{
+	unsigned long status;
+	u8 value;
+
+	if (!i2c_dev->slave || !i2c_dev->slave->slave_cb)
+		return false;
+
+	status = i2c_readl(i2c_dev, I2C_SL_STATUS);
+	if (!is_ready(status))
+		return false;
+
+	/* master sent stop */
+	if (is_trans_end(status)) {
+		i2c_slave_event(i2c_dev->slave, I2C_SLAVE_STOP, NULL);
+		if (!is_trans_start(status))
+			return true;
+	}
+
+	/* i2c master sends data to us */
+	if (is_write(status)) {
+		i2c_slave_event(i2c_dev->slave, I2C_SLAVE_REQ_WRITE_START,
+				NULL);
+		value = i2c_readl(i2c_dev, I2C_SL_RCVD);
+		if (is_trans_start(status))
+			i2c_writel(i2c_dev, 0, I2C_SL_RCVD);
+		i2c_slave_event(i2c_dev->slave, I2C_SLAVE_REQ_WRITE_END,
+				&value);
+	}
+
+	/* i2c master reads data from us */
+	if (is_read(status)) {
+		i2c_slave_event(i2c_dev->slave, I2C_SLAVE_REQ_READ_START,
+				&value);
+		if (is_trans_start(status)
+				&& i2c_dev->hw->slave_read_start_delay)
+			udelay(i2c_dev->hw->slave_read_start_delay);
+		i2c_writel(i2c_dev, value, I2C_SL_RCVD);
+		i2c_slave_event(i2c_dev->slave, I2C_SLAVE_REQ_READ_END, NULL);
+	}
+
+	return true;
+}
+
 static irqreturn_t tegra_i2c_isr(int irq, void *dev_id)
 {
 	u32 status;
 	const u32 status_err = I2C_INT_NO_ACK | I2C_INT_ARBITRATION_LOST;
 	struct tegra_i2c_dev *i2c_dev = dev_id;
 
+	if (tegra_i2c_slave_isr(irq, i2c_dev))
+		return IRQ_HANDLED;
+
 	status = i2c_readl(i2c_dev, I2C_INT_STATUS);
 
 	if (status == 0) {
@@ -660,9 +749,48 @@ static u32 tegra_i2c_func(struct i2c_adapter *adap)
 	return ret;
 }
 
+static int tegra_reg_slave(struct i2c_client *slave)
+{
+	struct tegra_i2c_dev *i2c_dev = i2c_get_adapdata(slave->adapter);
+
+	if (i2c_dev->slave)
+		return -EBUSY;
+
+	i2c_dev->slave = slave;
+
+	tegra_i2c_clock_enable(i2c_dev);
+
+	reset_control_assert(i2c_dev->rst);
+	udelay(2);
+	reset_control_deassert(i2c_dev->rst);
+
+	i2c_writel(i2c_dev, I2C_SL_CNFG_NEWSL, I2C_SL_CNFG);
+	i2c_writel(i2c_dev, 0x1E, I2C_SL_DELAY_COUNT);
+
+	i2c_writel(i2c_dev, slave->addr, I2C_SL_ADDR1);
+	i2c_writel(i2c_dev, 0, I2C_SL_ADDR2);
+
+	return 0;
+}
+
+static int tegra_unreg_slave(struct i2c_client *slave)
+{
+	struct tegra_i2c_dev *i2c_dev = i2c_get_adapdata(slave->adapter);
+
+	WARN_ON(!i2c_dev->slave);
+
+	i2c_writel(i2c_dev, 0, I2C_SL_CNFG);
+
+	i2c_dev->slave = NULL;
+
+	return 0;
+}
+
 static const struct i2c_algorithm tegra_i2c_algo = {
 	.master_xfer	= tegra_i2c_xfer,
 	.functionality	= tegra_i2c_func,
+	.reg_slave		= tegra_reg_slave,
+	.unreg_slave	= tegra_unreg_slave,
 };
 
 static const struct tegra_i2c_hw_feature tegra20_i2c_hw = {
@@ -671,6 +799,7 @@ static const struct tegra_i2c_hw_feature tegra20_i2c_hw = {
 	.has_single_clk_source = false,
 	.clk_divisor_hs_mode = 3,
 	.clk_divisor_std_fast_mode = 0,
+	.slave_read_start_delay = 8,
 };
 
 static const struct tegra_i2c_hw_feature tegra30_i2c_hw = {
@@ -679,6 +808,7 @@ static const struct tegra_i2c_hw_feature tegra30_i2c_hw = {
 	.has_single_clk_source = false,
 	.clk_divisor_hs_mode = 3,
 	.clk_divisor_std_fast_mode = 0,
+	.slave_read_start_delay = 0,
 };
 
 static const struct tegra_i2c_hw_feature tegra114_i2c_hw = {
@@ -687,6 +817,7 @@ static const struct tegra_i2c_hw_feature tegra114_i2c_hw = {
 	.has_single_clk_source = true,
 	.clk_divisor_hs_mode = 1,
 	.clk_divisor_std_fast_mode = 0x19,
+	.slave_read_start_delay = 0,
 };
 
 /* Match table for of_platform binding */
-- 
1.9.1

