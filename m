Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbaBZUDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:03:52 -0500
Received: from ring0.de ([5.45.105.125]:53362 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604AbaBZUDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:03:49 -0500
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
Subject: [RFCv4 5/7] mfd: twl4030-madc: Use twl_i2c_read/write_u16 for 16 bit registers
Date: Wed, 26 Feb 2014 21:03:08 +0100
Message-Id: <1393444990-28140-6-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393444990-28140-1-git-send-email-sre@debian.org>
References: <1393374270-20079-1-git-send-email-sre@debian.org>
 <1393444990-28140-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify reading and writing of 16 bit TWL registers in the
driver by using twl_i2c_read_u16 and twl_i2c_write_u16.

Signed-off-by: Sebastian Reichel <sre@debian.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/twl4030-madc.c | 39 ++++++++-------------------------------
 1 file changed, 8 insertions(+), 31 deletions(-)

diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
index c90013e..d918670 100644
--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -206,25 +206,19 @@ const struct twl4030_madc_conversion_method twl4030_conversion_methods[] = {
  */
 static int twl4030_madc_channel_raw_read(struct twl4030_madc_data *madc, u8 reg)
 {
-	u8 msb, lsb;
+	u16 val;
 	int ret;
 	/*
 	 * For each ADC channel, we have MSB and LSB register pair. MSB address
 	 * is always LSB address+1. reg parameter is the address of LSB register
 	 */
-	ret = twl_i2c_read_u8(TWL4030_MODULE_MADC, &msb, reg + 1);
+	ret = twl_i2c_read_u16(TWL4030_MODULE_MADC, &val, reg);
 	if (ret) {
-		dev_err(madc->dev, "unable to read MSB register 0x%X\n",
-			reg + 1);
-		return ret;
-	}
-	ret = twl_i2c_read_u8(TWL4030_MODULE_MADC, &lsb, reg);
-	if (ret) {
-		dev_err(madc->dev, "unable to read LSB register 0x%X\n", reg);
+		dev_err(madc->dev, "unable to read register 0x%X\n", reg);
 		return ret;
 	}
 
-	return (int)(((msb << 8) | lsb) >> 6);
+	return (int)(val >> 6);
 }
 
 /*
@@ -573,7 +567,6 @@ static int twl4030_madc_wait_conversion_ready(struct twl4030_madc_data *madc,
 int twl4030_madc_conversion(struct twl4030_madc_request *req)
 {
 	const struct twl4030_madc_conversion_method *method;
-	u8 ch_msb, ch_lsb;
 	int ret;
 
 	if (!req || !twl4030_madc)
@@ -589,37 +582,21 @@ int twl4030_madc_conversion(struct twl4030_madc_request *req)
 		ret = -EBUSY;
 		goto out;
 	}
-	ch_msb = (req->channels >> 8) & 0xff;
-	ch_lsb = req->channels & 0xff;
 	method = &twl4030_conversion_methods[req->method];
 	/* Select channels to be converted */
-	ret = twl_i2c_write_u8(TWL4030_MODULE_MADC, ch_msb, method->sel + 1);
+	ret = twl_i2c_write_u16(TWL4030_MODULE_MADC, req->channels, method->sel);
 	if (ret) {
 		dev_err(twl4030_madc->dev,
-			"unable to write sel register 0x%X\n", method->sel + 1);
-		goto out;
-	}
-	ret = twl_i2c_write_u8(TWL4030_MODULE_MADC, ch_lsb, method->sel);
-	if (ret) {
-		dev_err(twl4030_madc->dev,
-			"unable to write sel register 0x%X\n", method->sel + 1);
+			"unable to write sel register 0x%X\n", method->sel);
 		goto out;
 	}
 	/* Select averaging for all channels if do_avg is set */
 	if (req->do_avg) {
-		ret = twl_i2c_write_u8(TWL4030_MODULE_MADC,
-				       ch_msb, method->avg + 1);
+		ret = twl_i2c_write_u16(TWL4030_MODULE_MADC, req->channels,
+				       method->avg);
 		if (ret) {
 			dev_err(twl4030_madc->dev,
 				"unable to write avg register 0x%X\n",
-				method->avg + 1);
-			goto out;
-		}
-		ret = twl_i2c_write_u8(TWL4030_MODULE_MADC,
-				       ch_lsb, method->avg);
-		if (ret) {
-			dev_err(twl4030_madc->dev,
-				"unable to write avg reg 0x%X\n",
 				method->avg);
 			goto out;
 		}
-- 
1.8.5.3

