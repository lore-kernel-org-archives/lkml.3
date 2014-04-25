Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaDYX4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 19:56:43 -0400
Received: from ring0.de ([5.45.105.125]:53222 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbaDYX4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 19:56:39 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv3 4/5] Input: tsc2005: add DT support
Date: Sat, 26 Apr 2014 01:56:18 +0200
Message-Id: <1398470179-20880-5-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398470179-20880-1-git-send-email-sre@kernel.org>
References: <1398470179-20880-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds DT support to the tsc2005 touchscreen
driver.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 drivers/input/touchscreen/tsc2005.c | 96 +++++++++++++++++++++++++++++--------
 1 file changed, 77 insertions(+), 19 deletions(-)

diff --git a/drivers/input/touchscreen/tsc2005.c b/drivers/input/touchscreen/tsc2005.c
index 9daaddd..a83d1be 100644
--- a/drivers/input/touchscreen/tsc2005.c
+++ b/drivers/input/touchscreen/tsc2005.c
@@ -28,6 +28,8 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/pm.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/tsc2005.h>
 
@@ -100,6 +102,11 @@
 					 TSC2005_CFR2_AVG_7)
 
 #define MAX_12BIT			0xfff
+#define TSC2005_DEF_X_FUZZ		4
+#define TSC2005_DEF_Y_FUZZ		8
+#define TSC2005_DEF_P_FUZZ		2
+#define TSC2005_DEF_RESISTOR		280
+
 #define TSC2005_SPI_MAX_SPEED_HZ	10000000
 #define TSC2005_PENUP_TIME_MS		40
 
@@ -143,6 +150,7 @@ struct tsc2005 {
 
 	bool			pen_down;
 
+	int			reset_gpio;
 	void			(*set_reset)(bool enable);
 };
 
@@ -337,6 +345,14 @@ static void tsc2005_stop_scan(struct tsc2005 *ts)
 	tsc2005_cmd(ts, TSC2005_CMD_STOP);
 }
 
+static void tsc2005_set_reset(struct tsc2005 *ts, bool enable)
+{
+	if (ts->reset_gpio >= 0)
+		gpio_set_value(ts->reset_gpio, enable);
+	else if (ts->set_reset)
+		ts->set_reset(enable);
+}
+
 /* must be called with ts->mutex held */
 static void __tsc2005_disable(struct tsc2005 *ts)
 {
@@ -355,7 +371,7 @@ static void __tsc2005_enable(struct tsc2005 *ts)
 {
 	tsc2005_start_scan(ts);
 
-	if (ts->esd_timeout && ts->set_reset) {
+	if (ts->esd_timeout && (ts->set_reset || ts->reset_gpio)) {
 		ts->last_valid_interrupt = jiffies;
 		schedule_delayed_work(&ts->esd_work,
 				round_jiffies_relative(
@@ -414,9 +430,9 @@ static ssize_t tsc2005_selftest_show(struct device *dev,
 	}
 
 	/* hardware reset */
-	ts->set_reset(false);
+	tsc2005_set_reset(ts, false);
 	usleep_range(100, 500); /* only 10us required */
-	ts->set_reset(true);
+	tsc2005_set_reset(ts, true);
 
 	if (!success)
 		goto out;
@@ -459,7 +475,7 @@ static umode_t tsc2005_attr_is_visible(struct kobject *kobj,
 	umode_t mode = attr->mode;
 
 	if (attr == &dev_attr_selftest.attr) {
-		if (!ts->set_reset)
+		if (!ts->set_reset && !ts->reset_gpio)
 			mode = 0;
 	}
 
@@ -509,9 +525,9 @@ static void tsc2005_esd_work(struct work_struct *work)
 
 	tsc2005_update_pen_state(ts, 0, 0, 0);
 
-	ts->set_reset(false);
+	tsc2005_set_reset(ts, false);
 	usleep_range(100, 500); /* only 10us required */
-	ts->set_reset(true);
+	tsc2005_set_reset(ts, true);
 
 	enable_irq(ts->spi->irq);
 	tsc2005_start_scan(ts);
@@ -572,29 +588,47 @@ static void tsc2005_setup_spi_xfer(struct tsc2005 *ts)
 static int tsc2005_probe(struct spi_device *spi)
 {
 	const struct tsc2005_platform_data *pdata = dev_get_platdata(&spi->dev);
+	struct device_node *np = spi->dev.of_node;
+
 	struct tsc2005 *ts;
 	struct input_dev *input_dev;
-	unsigned int max_x, max_y, max_p;
-	unsigned int fudge_x, fudge_y, fudge_p;
+	unsigned int max_x = MAX_12BIT;
+	unsigned int max_y = MAX_12BIT;
+	unsigned int max_p = MAX_12BIT;
+	unsigned int fudge_x = TSC2005_DEF_X_FUZZ;
+	unsigned int fudge_y = TSC2005_DEF_Y_FUZZ;
+	unsigned int fudge_p = TSC2005_DEF_P_FUZZ;
+	unsigned int x_plate_ohm = TSC2005_DEF_RESISTOR;
+	unsigned int esd_timeout;
 	int error;
 
-	if (!pdata) {
+	if (!np && !pdata) {
 		dev_err(&spi->dev, "no platform data\n");
 		return -ENODEV;
 	}
 
-	fudge_x	= pdata->ts_x_fudge	   ? : 4;
-	fudge_y	= pdata->ts_y_fudge	   ? : 8;
-	fudge_p	= pdata->ts_pressure_fudge ? : 2;
-	max_x	= pdata->ts_x_max	   ? : MAX_12BIT;
-	max_y	= pdata->ts_y_max	   ? : MAX_12BIT;
-	max_p	= pdata->ts_pressure_max   ? : MAX_12BIT;
-
 	if (spi->irq <= 0) {
 		dev_err(&spi->dev, "no irq\n");
 		return -ENODEV;
 	}
 
+	if (pdata) {
+		fudge_x	= pdata->ts_x_fudge;
+		fudge_y	= pdata->ts_y_fudge;
+		fudge_p	= pdata->ts_pressure_fudge;
+		max_x	= pdata->ts_x_max;
+		max_y	= pdata->ts_y_max;
+		max_p	= pdata->ts_pressure_max;
+		x_plate_ohm = pdata->ts_x_plate_ohm;
+		esd_timeout = pdata->esd_timeout_ms;
+	} else {
+		x_plate_ohm = TSC2005_DEF_RESISTOR;
+		of_property_read_u32(np, "ti,x-plate-ohms", &x_plate_ohm);
+		esd_timeout = 0;
+		of_property_read_u32(np, "ti,esd-recovery-timeout-ms",
+								&esd_timeout);
+	}
+
 	spi->mode = SPI_MODE_0;
 	spi->bits_per_word = 8;
 	if (!spi->max_speed_hz)
@@ -612,9 +646,30 @@ static int tsc2005_probe(struct spi_device *spi)
 	ts->spi = spi;
 	ts->idev = input_dev;
 
-	ts->x_plate_ohm	= pdata->ts_x_plate_ohm	? : 280;
-	ts->esd_timeout	= pdata->esd_timeout_ms;
-	ts->set_reset	= pdata->set_reset;
+	ts->x_plate_ohm = x_plate_ohm;
+	ts->esd_timeout	= esd_timeout;
+
+	if (np) {
+		ts->reset_gpio = of_get_named_gpio(np, "reset-gpios", 0);
+		if (ts->reset_gpio == -EPROBE_DEFER)
+			return ts->reset_gpio;
+		if (ts->reset_gpio < 0) {
+			dev_err(&spi->dev, "error acquiring reset gpio: %d\n",
+				ts->reset_gpio);
+			return ts->reset_gpio;
+		}
+
+		error = devm_gpio_request_one(&spi->dev, ts->reset_gpio, 0,
+					      "reset-gpios");
+		if (error) {
+			dev_err(&spi->dev, "error requesting reset gpio: %d\n",
+				error);
+			return error;
+		}
+	} else {
+		ts->reset_gpio = -1;
+		ts->set_reset = pdata->set_reset;
+	}
 
 	mutex_init(&ts->mutex);
 
@@ -639,6 +694,9 @@ static int tsc2005_probe(struct spi_device *spi)
 	input_set_abs_params(input_dev, ABS_Y, 0, max_y, fudge_y, 0);
 	input_set_abs_params(input_dev, ABS_PRESSURE, 0, max_p, fudge_p, 0);
 
+	if (np)
+		input_parse_touchscreen_of_params(input_dev);
+
 	input_dev->open = tsc2005_open;
 	input_dev->close = tsc2005_close;
 
-- 
1.9.2

