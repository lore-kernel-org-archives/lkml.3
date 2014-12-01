Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbaLAPey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 10:34:54 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46618 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbaLAPev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 10:34:51 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Wolfram Sang <wsa@the-dreams.de>, Sekhar Nori <nsekhar@ti.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: <linux-i2c@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v3 4/5] i2c: davinci: use bus recovery infrastructure
Date: Mon, 1 Dec 2014 17:34:06 +0200
Message-ID: <1417448047-15236-5-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417448047-15236-1-git-send-email-grygorii.strashko@ti.com>
References: <1417448047-15236-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts Davinci I2C driver to use I2C bus recovery
infrastructure, introduced by commit 5f9296ba21b3 ("i2c: Add
bus recovery infrastructure").

The i2c_bus_recovery_info is configured for Davinci I2C adapter
only in case scl_pin is provided in platform data.

As the controller must be held in reset while doing so, the
recovery routine must re-init the controller. Since this was already
being done after each call to i2c_recover_bus, move those calls into
the recovery_prepare/unprepare routines and as well.

CC: Sekhar Nori <nsekhar@ti.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>
CC: Santosh Shilimkar <ssantosh@kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/i2c/busses/i2c-davinci.c | 77 +++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 41 deletions(-)

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 17e1203..00aed63 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -133,43 +133,6 @@ static inline u16 davinci_i2c_read_reg(struct davinci_i2c_dev *i2c_dev, int reg)
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
@@ -267,6 +230,34 @@ static int i2c_davinci_init(struct davinci_i2c_dev *dev)
 }
 
 /*
+ * This routine does i2c bus recovery by using i2c_generic_gpio_recovery
+ * which is provided by I2C Bus recovery infrastructure.
+ */
+static void davinci_i2c_prepare_recovery(struct i2c_adapter *adap)
+{
+	struct davinci_i2c_dev *dev = i2c_get_adapdata(adap);
+
+	/* Disable interrupts */
+	davinci_i2c_write_reg(dev, DAVINCI_I2C_IMR_REG, 0);
+
+	/* put I2C into reset */
+	davinci_i2c_reset_ctrl(dev, 0);
+}
+
+static void davinci_i2c_unprepare_recovery(struct i2c_adapter *adap)
+{
+	struct davinci_i2c_dev *dev = i2c_get_adapdata(adap);
+
+	i2c_davinci_init(dev);
+}
+
+static struct i2c_bus_recovery_info davinci_i2c_gpio_recovery_info = {
+	.recover_bus = i2c_generic_gpio_recovery,
+	.prepare_recovery = davinci_i2c_prepare_recovery,
+	.unprepare_recovery = davinci_i2c_unprepare_recovery,
+};
+
+/*
  * Waiting for bus not busy
  */
 static int i2c_davinci_wait_bus_not_busy(struct davinci_i2c_dev *dev,
@@ -286,8 +277,7 @@ static int i2c_davinci_wait_bus_not_busy(struct davinci_i2c_dev *dev,
 				return -ETIMEDOUT;
 			} else {
 				to_cnt = 0;
-				davinci_i2c_recover_bus(dev);
-				i2c_davinci_init(dev);
+				i2c_recover_bus(&dev->adapter);
 			}
 		}
 		if (allow_sleep)
@@ -376,8 +366,7 @@ i2c_davinci_xfer_msg(struct i2c_adapter *adap, struct i2c_msg *msg, int stop)
 						      dev->adapter.timeout);
 	if (r == 0) {
 		dev_err(dev->dev, "controller timed out\n");
-		davinci_i2c_recover_bus(dev);
-		i2c_davinci_init(dev);
+		i2c_recover_bus(adap);
 		dev->buf_len = 0;
 		return -ETIMEDOUT;
 	}
@@ -721,6 +710,12 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 	adap->timeout = DAVINCI_I2C_TIMEOUT;
 	adap->dev.of_node = pdev->dev.of_node;
 
+	if (dev->pdata->scl_pin) {
+		adap->bus_recovery_info = &davinci_i2c_gpio_recovery_info;
+		adap->bus_recovery_info->scl_gpio = dev->pdata->scl_pin;
+		adap->bus_recovery_info->sda_gpio = dev->pdata->sda_pin;
+	}
+
 	adap->nr = pdev->id;
 	r = i2c_add_numbered_adapter(adap);
 	if (r) {
-- 
1.9.1

