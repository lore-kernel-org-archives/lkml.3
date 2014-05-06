Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933958AbaEFFTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 01:19:31 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35193 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaEFFT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 01:19:28 -0400
Date: Mon, 5 May 2014 22:19:22 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Roger Quadros <rogerq@ti.com>
Cc: rydberg@euromail.se, balbi@ti.com, dmurphy@ti.com, mugunthanvnm@ti.com,
        nsekhar@ti.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 2/7] Input: pixcir_i2c_ts: Initialize interrupt mode
 and power mode
Message-ID: <20140506051922.GA2608@core.coreip.homeip.net>
References: <1399280678-23925-1-git-send-email-rogerq@ti.com>
 <1399280678-23925-3-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399280678-23925-3-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Mon, May 05, 2014 at 12:04:33PM +0300, Roger Quadros wrote:
> @@ -192,8 +364,8 @@ static int pixcir_i2c_ts_remove(struct i2c_client *client)
>  
>  	device_init_wakeup(&client->dev, 0);
>  
> -	tsdata->exiting = true;
> -	mb();
> +	if (!tsdata->exiting)
> +		pixcir_stop(tsdata);
>  

I think if we change tsdata->exiting to tsdata->running we won't have to
do it here. Does the version of the patch below work for you?

-- 
Dmitry

Input: pixcir_i2c_ts - initialize interrupt mode and power mode

From: Roger Quadros <rogerq@ti.com>

Introduce helper functions to configure power and interrupt registers.
Default to IDLE mode on probe as device supports auto wakeup to ACVIE mode
on detecting finger touch.

Configure interrupt mode and polarity on start up.  Power down on device
closure or module removal.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Mugunthan V N <mugunthanvnm@ti.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/touchscreen/pixcir_i2c_ts.c |  182 ++++++++++++++++++++++++++++-
 include/linux/input/pixcir_ts.h           |   42 +++++++
 2 files changed, 216 insertions(+), 8 deletions(-)

diff --git a/drivers/input/touchscreen/pixcir_i2c_ts.c b/drivers/input/touchscreen/pixcir_i2c_ts.c
index 724b839..7d39268 100644
--- a/drivers/input/touchscreen/pixcir_i2c_ts.c
+++ b/drivers/input/touchscreen/pixcir_i2c_ts.c
@@ -29,7 +29,7 @@ struct pixcir_i2c_ts_data {
 	struct i2c_client *client;
 	struct input_dev *input;
 	const struct pixcir_ts_platform_data *chip;
-	bool exiting;
+	bool running;
 };
 
 static void pixcir_ts_poscheck(struct pixcir_i2c_ts_data *data)
@@ -88,7 +88,7 @@ static irqreturn_t pixcir_ts_isr(int irq, void *dev_id)
 {
 	struct pixcir_i2c_ts_data *tsdata = dev_id;
 
-	while (!tsdata->exiting) {
+	while (tsdata->running) {
 		pixcir_ts_poscheck(tsdata);
 
 		if (tsdata->chip->attb_read_val())
@@ -100,6 +100,164 @@ static irqreturn_t pixcir_ts_isr(int irq, void *dev_id)
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
+			       enum pixcir_int_mode mode, bool polarity)
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
+	int error;
+
+	/* LEVEL_TOUCH interrupt with active low polarity */
+	error = pixcir_set_int_mode(ts, PIXCIR_INT_LEVEL_TOUCH, 0);
+	if (error) {
+		dev_err(dev, "Failed to set interrupt mode: %d\n", error);
+		return error;
+	}
+
+	ts->running = true;
+	mb();	/* Update status before IRQ can fire */
+
+	/* enable interrupt generation */
+	error = pixcir_int_enable(ts, true);
+	if (error) {
+		dev_err(dev, "Failed to enable interrupt generation: %d\n",
+			error);
+		return error;
+	}
+
+	return 0;
+}
+
+static int pixcir_stop(struct pixcir_i2c_ts_data *ts)
+{
+	int error;
+
+	/* Disable interrupt generation */
+	error = pixcir_int_enable(ts, false);
+	if (error) {
+		dev_err(&ts->client->dev,
+			"Failed to disable interrupt generation: %d\n",
+			error);
+		return error;
+	}
+
+	/* Exit ISR if running, no more report parsing */
+	ts->running = false;
+	mb();	/* update status before we synchronize irq */
+
+	/* Wait till running ISR is complete */
+	synchronize_irq(ts->client->irq);
+
+	return 0;
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
 #ifdef CONFIG_PM_SLEEP
 static int pixcir_i2c_ts_suspend(struct device *dev)
 {
@@ -156,6 +314,8 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
 
 	input->name = client->name;
 	input->id.bustype = BUS_I2C;
+	input->open = pixcir_input_open;
+	input->close = pixcir_input_close;
 
 	__set_bit(EV_KEY, input->evbit);
 	__set_bit(EV_ABS, input->evbit);
@@ -175,11 +335,22 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
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
 
-	i2c_set_clientdata(client, tsdata);
 	device_init_wakeup(&client->dev, 1);
 
 	return 0;
@@ -187,13 +358,8 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
 
 static int pixcir_i2c_ts_remove(struct i2c_client *client)
 {
-	struct pixcir_i2c_ts_data *tsdata = i2c_get_clientdata(client);
-
 	device_init_wakeup(&client->dev, 0);
 
-	tsdata->exiting = true;
-	mb();
-
 	return 0;
 }
 
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
