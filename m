Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab3LEXJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:09:51 -0500
Received: from ring0.de ([91.143.88.219]:39512 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab3LEXJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:09:45 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        devicetree@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sebastian Reichel <sre@debian.org>
Subject: [PATCH 1/2] Input: tsc2005: add DT support
Date: Fri,  6 Dec 2013 00:09:38 +0100
Message-Id: <1386284979-9680-2-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1386284979-9680-1-git-send-email-sre@debian.org>
References: <1386284979-9680-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds DT support to the tsc2005 touchscreen
driver.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 drivers/input/touchscreen/tsc2005.c | 95 ++++++++++++++++++++++++++++++-------
 1 file changed, 78 insertions(+), 17 deletions(-)

diff --git a/drivers/input/touchscreen/tsc2005.c b/drivers/input/touchscreen/tsc2005.c
index 7a6ff52..b50986b 100644
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
@@ -572,29 +588,53 @@ static void tsc2005_setup_spi_xfer(struct tsc2005 *ts)
 static int tsc2005_probe(struct spi_device *spi)
 {
 	const struct tsc2005_platform_data *pdata = spi->dev.platform_data;
+	struct device_node *np = spi->dev.of_node;
 	struct tsc2005 *ts;
 	struct input_dev *input_dev;
 	unsigned int max_x, max_y, max_p;
 	unsigned int fudge_x, fudge_y, fudge_p;
+	unsigned int esd_timeout, x_plate_ohm;
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
+		fudge_x	= pdata->ts_x_fudge	    ? : TSC2005_DEF_X_FUZZ;
+		fudge_y	= pdata->ts_y_fudge	    ? : TSC2005_DEF_Y_FUZZ;
+		fudge_p	= pdata->ts_pressure_fudge  ? : TSC2005_DEF_P_FUZZ;
+		max_x	= pdata->ts_x_max	    ? : MAX_12BIT;
+		max_y	= pdata->ts_y_max	    ? : MAX_12BIT;
+		max_p	= pdata->ts_pressure_max    ? : MAX_12BIT;
+		x_plate_ohm = pdata->ts_x_plate_ohm ? : TSC2005_DEF_RESISTOR;
+		esd_timeout = pdata->esd_timeout_ms;
+	} else {
+		fudge_x = TSC2005_DEF_X_FUZZ;
+		of_property_read_u32(np, "ti,fuzz-x", &fudge_x);
+		fudge_y = TSC2005_DEF_Y_FUZZ;
+		of_property_read_u32(np, "ti,fuzz-y", &fudge_y);
+		fudge_p = TSC2005_DEF_P_FUZZ;
+		of_property_read_u32(np, "ti,fuzz-pressure", &fudge_p);
+		max_x = MAX_12BIT;
+		of_property_read_u32(np, "ti,max-x", &max_x);
+		max_y = MAX_12BIT;
+		of_property_read_u32(np, "ti,max-y", &max_y);
+		max_p = MAX_12BIT;
+		of_property_read_u32(np, "ti,max-pressure", &max_p);
+		x_plate_ohm = TSC2005_DEF_RESISTOR;
+		of_property_read_u32(np, "ti,x-plate-resistance", &x_plate_ohm);
+		esd_timeout = 0;
+		of_property_read_u32(np, "ti,esd-recovery-timeout-ms",
+								&esd_timeout);
+	}
+
 	spi->mode = SPI_MODE_0;
 	spi->bits_per_word = 8;
 	if (!spi->max_speed_hz)
@@ -612,9 +652,30 @@ static int tsc2005_probe(struct spi_device *spi)
 	ts->spi = spi;
 	ts->idev = input_dev;
 
-	ts->x_plate_ohm	= pdata->ts_x_plate_ohm	? : 280;
-	ts->esd_timeout	= pdata->esd_timeout_ms;
-	ts->set_reset	= pdata->set_reset;
+	ts->x_plate_ohm = x_plate_ohm;
+	ts->esd_timeout	= esd_timeout;
+
+	if (np) {
+		ts->reset_gpio = of_get_named_gpio(np, "reset-gpio", 0);
+		if (ts->reset_gpio == -EPROBE_DEFER)
+			return ts->reset_gpio;
+		if (ts->reset_gpio < 0) {
+			dev_err(&spi->dev, "error acquiring reset gpio: %d\n",
+				ts->reset_gpio);
+			return ts->reset_gpio;
+		}
+
+		error = devm_gpio_request_one(&spi->dev, ts->reset_gpio, 0,
+					      "reset-gpio");
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
 
-- 
1.8.4.3

