Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaI3UTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:19:00 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:42945 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaI3USJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:18:09 -0400
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bcousson@baylibre.com, tony@atomide.com, linux@arm.linux.org.uk,
        dmitry.torokhov@gmail.com
Cc: hns@goldelico.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH 1/3] input: tsc2007: Add pre-calibration, flipping and rotation
Date: Tue, 30 Sep 2014 22:17:32 +0200
Message-Id: <1412108254-19234-2-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412108254-19234-1-git-send-email-marek@goldelico.com>
References: <1412108254-19234-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new parameters that allow to address typical hardware
design differences: touch screens may be wired or oriented differently
(portrait or landscape). And usually the active area of the touch is a
little larger than the active area of the LCD. This results in the touch
coordinates that have some significant deviation from LCD coordinates.
Usually this is addressed in user space by a calibration tool (e.g. tslib
or xinput-calibrator) but some systems don't have these tools or require
that the screen is already roughly calibrated (e.g. Replicant) to operate
the device until a better calibration can be done. And, some systems
react very strangely if the touch event stream reports coordinates
outside of the active area.

This makes it necessry to be able to configure:
1. swapping x and y wires (coordinate values)
2. flipping of x (left - right) or y (top - bottom) or even both
3. define an active area so that an uncalibrated screen already
roughly matches the LCD to be useful.
4. clip reported coordinates to the active area.

If none of the new parameters is defined (in DT) or set in a board file,
the driver behaves the same as without this patch.

Author (1&2): H. Nikolaus Schaller <hns@goldelico.com>
Author (3&4): Paul Kocialkowski <contact@paulk.fr>

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 drivers/input/touchscreen/tsc2007.c | 89 +++++++++++++++++++++++++++++++++++--
 include/linux/i2c/tsc2007.h         |  6 +++
 2 files changed, 91 insertions(+), 4 deletions(-)

diff --git a/drivers/input/touchscreen/tsc2007.c b/drivers/input/touchscreen/tsc2007.c
index 1bf9906..cc0cc3c 100644
--- a/drivers/input/touchscreen/tsc2007.c
+++ b/drivers/input/touchscreen/tsc2007.c
@@ -74,6 +74,12 @@ struct tsc2007 {
 
 	u16			model;
 	u16			x_plate_ohms;
+	bool			swap_xy;	/* swap x and y axis */
+	u16			min_x;
+	u16			min_y;
+	u16			min_rt;
+	u16			max_x;
+	u16			max_y;
 	u16			max_rt;
 	unsigned long		poll_period;
 	int			fuzzx;
@@ -193,11 +199,50 @@ static irqreturn_t tsc2007_soft_irq(int irq, void *handle)
 			break;
 		}
 
-		if (rt <= ts->max_rt) {
+		if (rt <= max(ts->min_rt, ts->max_rt)) {
 			dev_dbg(&ts->client->dev,
 				"DOWN point(%4d,%4d), pressure (%4u)\n",
 				tc.x, tc.y, rt);
 
+			if (ts->swap_xy) {
+				/* swap before applying the range limits */
+				u16 h = tc.x;
+
+				tc.x = tc.y;
+				tc.y = h;
+			}
+
+			/* flip and/or clip X */
+			if (ts->max_x < ts->min_x)
+				tc.x = (ts->min_x - tc.x) + ts->max_x;
+
+			if (tc.x > max(ts->min_x, ts->max_x))
+				tc.x = max(ts->min_x, ts->max_x);
+			else if (tc.x < min(ts->min_x, ts->max_x))
+				tc.x = min(ts->min_x, ts->max_x);
+
+			/* flip and/or clip Y */
+			if (ts->max_y < ts->min_y)
+				tc.y = (ts->min_y - tc.y) + ts->max_y;
+
+			if (tc.y > max(ts->min_y, ts->max_y))
+				tc.y = max(ts->min_y, ts->max_y);
+			else if (tc.y < min(ts->min_y, ts->max_y))
+				tc.y = min(ts->min_y, ts->max_y);
+
+			/* clip Z */
+			if (ts->max_rt < ts->min_rt)
+				rt = (ts->min_rt - rt) + ts->max_rt;
+
+			if (rt > max(ts->min_rt, ts->max_rt))
+				rt = max(ts->min_rt, ts->max_rt);
+			else if (rt < min(ts->min_rt, ts->max_rt))
+				rt = min(ts->min_rt, ts->max_rt);
+
+			dev_dbg(&ts->client->dev,
+					"shaped point(%4d,%4d), pressure (%4u)\n",
+					tc.x, tc.y, rt);
+
 			input_report_key(input, BTN_TOUCH, 1);
 			input_report_abs(input, ABS_X, tc.x);
 			input_report_abs(input, ABS_Y, tc.y);
@@ -299,6 +344,24 @@ static int tsc2007_probe_dt(struct i2c_client *client, struct tsc2007 *ts)
 		return -EINVAL;
 	}
 
+	ts->swap_xy = of_property_read_bool(np, "ti,swap-xy");
+
+	if (!of_property_read_u32(np, "ti,min-x", &val32))
+		ts->min_x = val32;
+	if (!of_property_read_u32(np, "ti,max-x", &val32))
+		ts->max_x = val32;
+	else
+		ts->max_x = MAX_12BIT;
+
+	if (!of_property_read_u32(np, "ti,min-y", &val32))
+		ts->min_y = val32;
+	if (!of_property_read_u32(np, "ti,max-y", &val32))
+		ts->max_y = val32;
+	else
+		ts->max_y = MAX_12BIT;
+
+	if (!of_property_read_u32(np, "ti,min-rt", &val32))
+		ts->min_rt = val32;
 	if (!of_property_read_u32(np, "ti,max-rt", &val32))
 		ts->max_rt = val32;
 	else
@@ -325,6 +388,16 @@ static int tsc2007_probe_dt(struct i2c_client *client, struct tsc2007 *ts)
 		return -EINVAL;
 	}
 
+	dev_dbg(&client->dev,
+			"min/max_x (%4d,%4d)\n",
+			ts->min_x, ts->max_x);
+	dev_dbg(&client->dev,
+			"min/max_y (%4d,%4d)\n",
+			ts->min_y, ts->max_y);
+	dev_dbg(&client->dev,
+			"min/max_rt (%4d,%4d)\n",
+			ts->min_rt, ts->max_rt);
+
 	ts->gpio = of_get_gpio(np, 0);
 	if (gpio_is_valid(ts->gpio))
 		ts->get_pendown_state = tsc2007_get_pendown_state_gpio;
@@ -349,6 +422,12 @@ static int tsc2007_probe_pdev(struct i2c_client *client, struct tsc2007 *ts,
 {
 	ts->model             = pdata->model;
 	ts->x_plate_ohms      = pdata->x_plate_ohms;
+	ts->swap_xy           = pdata->swap_xy;
+	ts->min_x             = pdata->min_x ? : 0;
+	ts->min_y             = pdata->min_y ? : 0;
+	ts->min_rt            = pdata->min_rt ? : 0;
+	ts->max_x             = pdata->max_x ? : MAX_12BIT;
+	ts->max_y             = pdata->max_y ? : MAX_12BIT;
 	ts->max_rt            = pdata->max_rt ? : MAX_12BIT;
 	ts->poll_period       = pdata->poll_period ? : 1;
 	ts->get_pendown_state = pdata->get_pendown_state;
@@ -422,9 +501,11 @@ static int tsc2007_probe(struct i2c_client *client,
 	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 	input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 
-	input_set_abs_params(input_dev, ABS_X, 0, MAX_12BIT, ts->fuzzx, 0);
-	input_set_abs_params(input_dev, ABS_Y, 0, MAX_12BIT, ts->fuzzy, 0);
-	input_set_abs_params(input_dev, ABS_PRESSURE, 0, MAX_12BIT,
+	input_set_abs_params(input_dev, ABS_X, min(ts->min_x, ts->max_x),
+			     max(ts->min_x, ts->max_x), ts->fuzzx, 0);
+	input_set_abs_params(input_dev, ABS_Y, min(ts->min_y, ts->max_y),
+			     max(ts->min_y, ts->max_y), ts->fuzzy, 0);
+	input_set_abs_params(input_dev, ABS_PRESSURE, ts->min_rt, ts->max_rt,
 			     ts->fuzzz, 0);
 
 	if (pdata) {
diff --git a/include/linux/i2c/tsc2007.h b/include/linux/i2c/tsc2007.h
index 4f35b6a..5ce7b79 100644
--- a/include/linux/i2c/tsc2007.h
+++ b/include/linux/i2c/tsc2007.h
@@ -6,6 +6,12 @@
 struct tsc2007_platform_data {
 	u16	model;				/* 2007. */
 	u16	x_plate_ohms;	/* must be non-zero value */
+	bool	swap_xy;	/* swap x and y axis */
+	u16	min_x;	/* min and max values to reported to user space */
+	u16	min_y;
+	u16	min_rt;
+	u16	max_x;
+	u16	max_y;
 	u16	max_rt; /* max. resistance above which samples are ignored */
 	unsigned long poll_period; /* time (in ms) between samples */
 	int	fuzzx; /* fuzz factor for X, Y and pressure axes */
-- 
1.9.3

