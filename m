Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaB1Kiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 05:38:46 -0500
Received: from smtp04.online.nl ([194.134.41.34]:34820 "EHLO smtp04.online.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbaB1Kio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 05:38:44 -0500
From: mike.looijmans@topic.nl
To: nsekhar@ti.com, khilman@deeprootsystems.com, wsa@the-dreams.de
Cc: davinci-linux-open-source@linux.davincidsp.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mike Looijmans <milo-software@users.sourceforge.net>
Subject: [PATCH] i2c-davinci: Implement a bus recovery that actually works
Date: Fri, 28 Feb 2014 11:32:05 +0100
Message-Id: <1393583525-9555-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
X-Online-Scanned: by Cloudmark authority (on smtp04.online.nl)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Looijmans <milo-software@users.sourceforge.net>

Having a board where the I2C bus locks up occasionally made it clear
that the bus recovery in the i2c-davinci driver will only work on
some boards, because on regular boards, this will only toggle GPIO
lines that aren't muxed to the actual pins.

The I2C controller has the built-in capability to bit-bang its lines.
Use this to implement a generic recovery routine that puts the
controller in GPIO mode and pulse the clk lines until both SDA and
SCL return to a high state.

Because the controller must be held in reset while doing so, the
recovery routine must re-init the controller. Since this was already
being done after each call to i2c_recover_bus, move that call into
the recovery routine as well.

Tested on a custom board with OMAP-L138, and after this change, the
board can recover from chips keeping SDA low.

Note: This is an adapted port from 2.6.37 code, and was only tested
with that kernel.
---
 drivers/i2c/busses/i2c-davinci.c |   83 ++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 39 deletions(-)

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index af0b583..1ee04c4 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -64,6 +64,10 @@
 #define DAVINCI_I2C_IVR_REG	0x28
 #define DAVINCI_I2C_EMDR_REG	0x2c
 #define DAVINCI_I2C_PSC_REG	0x30
+#define DAVINCI_I2C_FUNC_REG	0x48
+#define DAVINCI_I2C_DIR_REG	0x4c
+#define DAVINCI_I2C_DIN_REG	0x50
+#define DAVINCI_I2C_DOUT_REG	0x54
 
 #define DAVINCI_I2C_IVR_AAS	0x07
 #define DAVINCI_I2C_IVR_SCD	0x06
@@ -133,43 +137,6 @@ static inline u16 davinci_i2c_read_reg(struct davinci_i2c_dev *i2c_dev, int reg)
 	return readw_relaxed(i2c_dev->base + reg);
 }
 
-/* Generate a pulse on the i2c clock pin. */
-static void davinci_i2c_clock_pulse(unsigned int scl_pin)
-{
-	u16 i;
-
-	if (scl_pin) {
-		/* Send high and low on the SCL line */
-		for (i = 0; i < 9; i++) {
-			gpio_set_value(scl_pin, 0);
-			udelay(20);
-			gpio_set_value(scl_pin, 1);
-			udelay(20);
-		}
-	}
-}
-
-/* This routine does i2c bus recovery as specified in the
- * i2c protocol Rev. 03 section 3.16 titled "Bus clear"
- */
-static void davinci_i2c_recover_bus(struct davinci_i2c_dev *dev)
-{
-	u32 flag = 0;
-	struct davinci_i2c_platform_data *pdata = dev->pdata;
-
-	dev_err(dev->dev, "initiating i2c bus recovery\n");
-	/* Send NACK to the slave */
-	flag = davinci_i2c_read_reg(dev, DAVINCI_I2C_MDR_REG);
-	flag |=  DAVINCI_I2C_MDR_NACK;
-	/* write the data into mode register */
-	davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, flag);
-	davinci_i2c_clock_pulse(pdata->scl_pin);
-	/* Send STOP */
-	flag = davinci_i2c_read_reg(dev, DAVINCI_I2C_MDR_REG);
-	flag |= DAVINCI_I2C_MDR_STP;
-	davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, flag);
-}
-
 static inline void davinci_i2c_reset_ctrl(struct davinci_i2c_dev *i2c_dev,
 								int val)
 {
@@ -266,6 +233,46 @@ static int i2c_davinci_init(struct davinci_i2c_dev *dev)
 	return 0;
 }
 
+/* This routine does i2c bus recovery as specified in the
+ * i2c protocol Rev. 03 section 3.16 titled "Bus clear"
+ */
+static void i2c_recover_bus(struct davinci_i2c_dev *dev)
+{
+	u32 flag = 0;
+	int i;
+	struct davinci_i2c_platform_data *pdata = dev->dev->platform_data;
+	flag = davinci_i2c_read_reg(dev, DAVINCI_I2C_DIN_REG);
+	if ((flag & 0x01) == 0)
+		dev_err(dev->dev, "SCL stuck at zero.\n");
+	dev_err(dev->dev, "initiating i2c bus recovery\n");
+	/* Disable interrupts */
+	davinci_i2c_write_reg(dev, DAVINCI_I2C_IMR_REG, 0);
+	/* put I2C into reset */
+	davinci_i2c_reset_ctrl(dev, 0);
+	/* Set GPIO mode */
+	davinci_i2c_write_reg(dev, DAVINCI_I2C_FUNC_REG, 0x1);
+	 /* Set scl=1 sda=1 */
+	davinci_i2c_write_reg(dev, DAVINCI_I2C_DOUT_REG, 0x03);
+	/* Set SCL pin as output, SDA as input */
+	davinci_i2c_write_reg(dev, DAVINCI_I2C_DIR_REG, 0x1);
+	/* Send up to 9 clock pulses until SDA is high */
+	for (i = 0; i < 9; ++i) {
+		davinci_i2c_write_reg(dev, DAVINCI_I2C_DOUT_REG, 0x02); /* scl=0 sda=1 */
+		udelay(10);
+		davinci_i2c_write_reg(dev, DAVINCI_I2C_DOUT_REG, 0x03);
+		udelay(10);
+		/* Register DIN reads actual state on line */
+		flag = davinci_i2c_read_reg(dev, DAVINCI_I2C_DIN_REG);
+		if ((flag & 0x3) == 0x3) {
+			dev_info(dev->dev, "SDA and SCL high again (i=%d), resume.\n", i);
+			break;
+		}
+	}
+	/* Resume operation */
+	davinci_i2c_write_reg(dev, DAVINCI_I2C_FUNC_REG, 0x0);
+	i2c_davinci_init(dev);
+}
+
 /*
  * Waiting for bus not busy
  */
@@ -287,7 +294,6 @@ static int i2c_davinci_wait_bus_not_busy(struct davinci_i2c_dev *dev,
 			} else {
 				to_cnt = 0;
 				davinci_i2c_recover_bus(dev);
-				i2c_davinci_init(dev);
 			}
 		}
 		if (allow_sleep)
@@ -377,7 +383,6 @@ i2c_davinci_xfer_msg(struct i2c_adapter *adap, struct i2c_msg *msg, int stop)
 	if (r == 0) {
 		dev_err(dev->dev, "controller timed out\n");
 		davinci_i2c_recover_bus(dev);
-		i2c_davinci_init(dev);
 		dev->buf_len = 0;
 		return -ETIMEDOUT;
 	}
-- 
1.7.9.5

