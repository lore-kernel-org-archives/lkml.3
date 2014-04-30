Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626AbaD3Mgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:36:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52556 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbaD3Mgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:36:48 -0400
From: Roger Quadros <rogerq@ti.com>
To: <dmitry.torokhov@gmail.com>
CC: <rydberg@euromail.se>, <balbi@ti.com>, <dmurphy@ti.com>,
        <mugunthanvnm@ti.com>, <nsekhar@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v3 2/7] Input: pixcir_i2c_ts: Initialize interrupt mode and power mode
Date: Wed, 30 Apr 2014 15:36:27 +0300
Message-ID: <1398861392-8959-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398861392-8959-1-git-send-email-rogerq@ti.com>
References: <1398861392-8959-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce helper functions to configure power and interrupt
registers. Default to IDLE mode on probe as device supports
auto wakeup to ACVIE mode on detecting finger touch.

Configure interrupt mode and polarity on start up.
Power down on device closure or module removal.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Mugunthan V N <mugunthanvnm@ti.com>
---
 drivers/input/touchscreen/pixcir_i2c_ts.c | 179 +++++++++++++++++++++++++++++-
 include/linux/input/pixcir_ts.h           |  42 +++++++
 2 files changed, 218 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/pixcir_i2c_ts.c b/drivers/input/touchscreen/pixcir_i2c_ts.c
index 45bc2d1..670aa6e 100644
--- a/drivers/input/touchscreen/pixcir_i2c_ts.c
+++ b/drivers/input/touchscreen/pixcir_i2c_ts.c
@@ -100,6 +100,168 @@ static irqreturn_t pixcir_ts_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static int pixcir_set_power_mode(struct pixcir_i2c_ts_data *ts,
+				 enum pixcir_power_mode mode)
+{
+	struct device *dev = &ts->client->dev;
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(ts->client, PIXCIR_REG_POWER_MODE);
+	if (ret < 0) {
+		dev_err(dev, "%s: can't read reg 0x%x : %d\n",
+			__func__, PIXCIR_REG_POWER_MODE, ret);
+		return ret;
+	}
+
+	ret &= ~PIXCIR_POWER_MODE_MASK;
+	ret |= mode;
+
+	/* Always AUTO_IDLE */
+	ret |= PIXCIR_POWER_ALLOW_IDLE;
+
+	ret = i2c_smbus_write_byte_data(ts->client, PIXCIR_REG_POWER_MODE, ret);
+	if (ret < 0) {
+		dev_err(dev, "%s: can't write reg 0x%x : %d\n",
+			__func__, PIXCIR_REG_POWER_MODE, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Set the interrupt mode for the device i.e. ATTB line behaviour
+ *
+ * @polarity : 1 for active high, 0 for active low.
+ */
+static int pixcir_set_int_mode(struct pixcir_i2c_ts_data *ts,
+			       enum pixcir_int_mode mode,
+					bool polarity)
+{
+	struct device *dev = &ts->client->dev;
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(ts->client, PIXCIR_REG_INT_MODE);
+	if (ret < 0) {
+		dev_err(dev, "%s: can't read reg 0x%x : %d\n",
+			__func__, PIXCIR_REG_INT_MODE, ret);
+		return ret;
+	}
+
+	ret &= ~PIXCIR_INT_MODE_MASK;
+	ret |= mode;
+
+	if (polarity)
+		ret |= PIXCIR_INT_POL_HIGH;
+	else
+		ret &= ~PIXCIR_INT_POL_HIGH;
+
+	ret = i2c_smbus_write_byte_data(ts->client, PIXCIR_REG_INT_MODE, ret);
+	if (ret < 0) {
+		dev_err(dev, "%s: can't write reg 0x%x : %d\n",
+			__func__, PIXCIR_REG_INT_MODE, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Enable/disable interrupt generation
+ */
+static int pixcir_int_enable(struct pixcir_i2c_ts_data *ts, bool enable)
+{
+	struct device *dev = &ts->client->dev;
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(ts->client, PIXCIR_REG_INT_MODE);
+	if (ret < 0) {
+		dev_err(dev, "%s: can't read reg 0x%x : %d\n",
+			__func__, PIXCIR_REG_INT_MODE, ret);
+		return ret;
+	}
+
+	if (enable)
+		ret |= PIXCIR_INT_ENABLE;
+	else
+		ret &= ~PIXCIR_INT_ENABLE;
+
+	ret = i2c_smbus_write_byte_data(ts->client, PIXCIR_REG_INT_MODE, ret);
+	if (ret < 0) {
+		dev_err(dev, "%s: can't write reg 0x%x : %d\n",
+			__func__, PIXCIR_REG_INT_MODE, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int pixcir_start(struct pixcir_i2c_ts_data *ts)
+{
+	struct device *dev = &ts->client->dev;
+	int ret;
+
+	/* LEVEL_TOUCH interrupt with active low polarity */
+	ret = pixcir_set_int_mode(ts, PIXCIR_INT_LEVEL_TOUCH, 0);
+	if (ret) {
+		dev_err(dev, "Failed to set interrupt mode\n");
+		return ret;
+	}
+
+	ts->exiting = false;
+	mb();	/* Update status before IRQ can fire */
+
+	/* enable interrupt generation */
+	ret = pixcir_int_enable(ts, 1);
+	if (ret) {
+		dev_err(dev, "Failed to enable interrupt generation\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int pixcir_stop(struct pixcir_i2c_ts_data *ts)
+{
+	struct device *dev = &ts->client->dev;
+	int ret;
+
+	/* exit ISR if running, no more report parsing */
+	ts->exiting = true;
+	mb();	/* update status before we synchronize irq */
+
+	/* disable ISR from running again */
+	disable_irq(ts->client->irq);
+
+	/* wait till running ISR complete */
+	synchronize_irq(ts->client->irq);
+
+	/* disable interrupt generation */
+	ret = pixcir_int_enable(ts, 0);
+	if (ret)
+		dev_err(dev, "Failed to disable interrupt generation\n");
+
+	/* restore IRQ */
+	enable_irq(ts->client->irq);
+
+	return ret;
+}
+
+static int pixcir_input_open(struct input_dev *dev)
+{
+	struct pixcir_i2c_ts_data *ts = input_get_drvdata(dev);
+
+	return pixcir_start(ts);
+}
+
+static void pixcir_input_close(struct input_dev *dev)
+{
+	struct pixcir_i2c_ts_data *ts = input_get_drvdata(dev);
+
+	pixcir_stop(ts);
+}
+
+
 #ifdef CONFIG_PM_SLEEP
 static int pixcir_i2c_ts_suspend(struct device *dev)
 {
@@ -157,6 +319,8 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
 	input->name = client->name;
 	input->id.bustype = BUS_I2C;
 	input->dev.parent = &client->dev;
+	input->open = pixcir_input_open;
+	input->close = pixcir_input_close;
 
 	__set_bit(EV_KEY, input->evbit);
 	__set_bit(EV_ABS, input->evbit);
@@ -176,6 +340,18 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
 		return error;
 	}
 
+	/* Always be in IDLE mode to save power, device supports auto wake */
+	error = pixcir_set_power_mode(tsdata, PIXCIR_POWER_IDLE);
+	if (error) {
+		dev_err(dev, "Failed to set IDLE mode\n");
+		return error;
+	}
+
+	/* Stop device till opened */
+	error = pixcir_stop(tsdata);
+	if (error)
+		return error;
+
 	error = input_register_device(input);
 	if (error)
 		return error;
@@ -192,9 +368,6 @@ static int pixcir_i2c_ts_remove(struct i2c_client *client)
 
 	device_init_wakeup(&client->dev, 0);
 
-	tsdata->exiting = true;
-	mb();
-
 	input_unregister_device(tsdata->input);
 
 	return 0;
diff --git a/include/linux/input/pixcir_ts.h b/include/linux/input/pixcir_ts.h
index 7163d91..7942804 100644
--- a/include/linux/input/pixcir_ts.h
+++ b/include/linux/input/pixcir_ts.h
@@ -1,6 +1,48 @@
 #ifndef	_PIXCIR_I2C_TS_H
 #define	_PIXCIR_I2C_TS_H
 
+/*
+ * Register map
+ */
+#define PIXCIR_REG_POWER_MODE	51
+#define PIXCIR_REG_INT_MODE	52
+
+/*
+ * Power modes:
+ * active: max scan speed
+ * idle: lower scan speed with automatic transition to active on touch
+ * halt: datasheet says sleep but this is more like halt as the chip
+ *       clocks are cut and it can only be brought out of this mode
+ *	 using the RESET pin.
+ */
+enum pixcir_power_mode {
+	PIXCIR_POWER_ACTIVE,
+	PIXCIR_POWER_IDLE,
+	PIXCIR_POWER_HALT,
+};
+
+#define PIXCIR_POWER_MODE_MASK	0x03
+#define PIXCIR_POWER_ALLOW_IDLE (1UL << 2)
+
+/*
+ * Interrupt modes:
+ * periodical: interrupt is asserted periodicaly
+ * diff coordinates: interrupt is asserted when coordinates change
+ * level on touch: interrupt level asserted during touch
+ * pulse on touch: interrupt pulse asserted druing touch
+ *
+ */
+enum pixcir_int_mode {
+	PIXCIR_INT_PERIODICAL,
+	PIXCIR_INT_DIFF_COORD,
+	PIXCIR_INT_LEVEL_TOUCH,
+	PIXCIR_INT_PULSE_TOUCH,
+};
+
+#define PIXCIR_INT_MODE_MASK	0x03
+#define PIXCIR_INT_ENABLE	(1UL << 3)
+#define PIXCIR_INT_POL_HIGH	(1UL << 2)
+
 struct pixcir_ts_platform_data {
 	int (*attb_read_val)(void);
 	int x_max;
-- 
1.8.3.2

