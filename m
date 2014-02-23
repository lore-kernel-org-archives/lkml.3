Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaBWWI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 17:08:29 -0500
Received: from ring0.de ([5.45.105.125]:59323 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbaBWWI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 17:08:26 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Marek Belisko <marek@goldelico.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org,
        Sebastian Reichel <sre@debian.org>
Subject: [RFCv2 3/5] mfd: twl4030-madc: Cleanup driver
Date: Sun, 23 Feb 2014 23:07:49 +0100
Message-Id: <1393193271-16717-4-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393193271-16717-1-git-send-email-sre@debian.org>
References: <20140223220140.GA1258@earth.universe>
 <1393193271-16717-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some style fixes in twl4030-madc driver.

Reported-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 drivers/mfd/twl4030-madc.c | 66 ++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 37 deletions(-)

diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
index 5e67c75..0bc79a7 100644
--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -62,8 +62,8 @@ struct twl4030_madc_data {
 	struct mutex lock;	/* mutex protecting this data structure */
 	struct twl4030_madc_request requests[TWL4030_MADC_NUM_METHODS];
 	bool use_second_irq;
-	int imr;
-	int isr;
+	u8 imr;
+	u8 isr;
 };
 
 static int twl4030_madc_read(struct iio_dev *iio_dev,
@@ -242,13 +242,13 @@ static int twl4030battery_temperature(int raw_volt)
 		REG_BCICTL2);
 	if (ret < 0)
 		return ret;
+
 	curr = ((val & TWL4030_BCI_ITHEN) + 1) * 10;
 	/* Getting and calculating the thermistor resistance in ohms */
 	res = volt * 1000 / curr;
 	/* calculating temperature */
 	for (temp = 58; temp >= 0; temp--) {
 		int actual = therm_tbl[temp];
-
 		if ((actual - res) >= 0)
 			break;
 	}
@@ -270,6 +270,7 @@ static int twl4030battery_current(int raw_volt)
 	else /* slope of 0.88 mV/mA */
 		return (raw_volt * CURR_STEP_SIZE) / CURR_PSR_R2;
 }
+
 /*
  * Function to read channel values
  * @madc - pointer to twl4030_madc_data struct
@@ -285,17 +286,14 @@ static int twl4030_madc_read_channels(struct twl4030_madc_data *madc,
 				      long channels, int *buf,
 				      bool raw)
 {
-	int count = 0, count_req = 0, i;
-	u8 reg;
+	int count = 0, i;
 
 	for_each_set_bit(i, &channels, TWL4030_MADC_MAX_CHANNELS) {
-		reg = reg_base + 2 * i;
-		buf[i] = twl4030_madc_channel_raw_read(madc, reg);
+		buf[i] = twl4030_madc_channel_raw_read(madc, reg_base + 2 * i);
 		if (buf[i] < 0) {
-			dev_err(madc->dev,
-				"Unable to read register 0x%X\n", reg);
-			count_req++;
-			continue;
+			dev_err(madc->dev, "Unable to read register 0x%X\n",
+				reg_base + 2 * i);
+			return buf[i];
 		}
 		if (raw) {
 			count++;
@@ -306,7 +304,7 @@ static int twl4030_madc_read_channels(struct twl4030_madc_data *madc,
 			buf[i] = twl4030battery_current(buf[i]);
 			if (buf[i] < 0) {
 				dev_err(madc->dev, "err reading current\n");
-				count_req++;
+				return buf[i];
 			} else {
 				count++;
 				buf[i] = buf[i] - 750;
@@ -316,7 +314,7 @@ static int twl4030_madc_read_channels(struct twl4030_madc_data *madc,
 			buf[i] = twl4030battery_temperature(buf[i]);
 			if (buf[i] < 0) {
 				dev_err(madc->dev, "err reading temperature\n");
-				count_req++;
+				return buf[i];
 			} else {
 				buf[i] -= 3;
 				count++;
@@ -337,8 +335,6 @@ static int twl4030_madc_read_channels(struct twl4030_madc_data *madc,
 				twl4030_divider_ratios[i].numerator);
 		}
 	}
-	if (count_req)
-		dev_err(madc->dev, "%d channel conversion failed\n", count_req);
 
 	return count;
 }
@@ -362,13 +358,13 @@ static int twl4030_madc_enable_irq(struct twl4030_madc_data *madc, u8 id)
 			madc->imr);
 		return ret;
 	}
+
 	val &= ~(1 << id);
 	ret = twl_i2c_write_u8(TWL4030_MODULE_MADC, val, madc->imr);
 	if (ret) {
 		dev_err(madc->dev,
 			"unable to write imr register 0x%X\n", madc->imr);
 		return ret;
-
 	}
 
 	return 0;
@@ -513,21 +509,17 @@ static int twl4030_madc_start_conversion(struct twl4030_madc_data *madc,
 {
 	const struct twl4030_madc_conversion_method *method;
 	int ret = 0;
+
+	if (conv_method != TWL4030_MADC_SW1 && conv_method != TWL4030_MADC_SW2)
+		return -ENOTSUPP;
+
 	method = &twl4030_conversion_methods[conv_method];
-	switch (conv_method) {
-	case TWL4030_MADC_SW1:
-	case TWL4030_MADC_SW2:
-		ret = twl_i2c_write_u8(TWL4030_MODULE_MADC,
-				       TWL4030_MADC_SW_START, method->ctrl);
-		if (ret) {
-			dev_err(madc->dev,
-				"unable to write ctrl register 0x%X\n",
-				method->ctrl);
-			return ret;
-		}
-		break;
-	default:
-		break;
+	ret = twl_i2c_write_u8(TWL4030_MODULE_MADC, TWL4030_MADC_SW_START,
+			       method->ctrl);
+	if (ret) {
+		dev_err(madc->dev, "unable to write ctrl register 0x%X\n",
+			method->ctrl);
+		return ret;
 	}
 
 	return 0;
@@ -625,7 +617,7 @@ int twl4030_madc_conversion(struct twl4030_madc_request *req)
 		if (ret) {
 			dev_err(twl4030_madc->dev,
 				"unable to write sel reg 0x%X\n",
-				method->sel + 1);
+				method->avg);
 			goto out;
 		}
 	}
@@ -666,10 +658,6 @@ out:
 }
 EXPORT_SYMBOL_GPL(twl4030_madc_conversion);
 
-/*
- * Return channel value
- * Or < 0 on failure.
- */
 int twl4030_get_madc_conversion(int channel_no)
 {
 	struct twl4030_madc_request req;
@@ -704,6 +692,7 @@ static int twl4030_madc_set_current_generator(struct twl4030_madc_data *madc,
 					      int chan, int on)
 {
 	int ret;
+	int regmask;
 	u8 regval;
 
 	ret = twl_i2c_read_u8(TWL_MODULE_MAIN_CHARGE,
@@ -713,10 +702,13 @@ static int twl4030_madc_set_current_generator(struct twl4030_madc_data *madc,
 			TWL4030_BCI_BCICTL1);
 		return ret;
 	}
+
+	regmask = (chan == 0) ? TWL4030_BCI_TYPEN : TWL4030_BCI_ITHEN;
 	if (on)
-		regval |= chan ? TWL4030_BCI_ITHEN : TWL4030_BCI_TYPEN;
+		regval |= regmask;
 	else
-		regval &= chan ? ~TWL4030_BCI_ITHEN : ~TWL4030_BCI_TYPEN;
+		regval &= ~regmask;
+
 	ret = twl_i2c_write_u8(TWL_MODULE_MAIN_CHARGE,
 			       regval, TWL4030_BCI_BCICTL1);
 	if (ret) {
-- 
1.8.5.3

