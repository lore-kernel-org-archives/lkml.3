Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab3BOW6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 17:58:04 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:62220 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab3BOW6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:58:01 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Anton Vorontsov <cbou@mail.ru>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 1/2] mfd: twl4030-madc: Add support for raw value in twl4030_madc_conversion
Date: Fri, 15 Feb 2013 23:56:49 +0100
Message-Id: <1360969010-8571-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver twl4030-madc has hardcoded channel types (10 - battery current,
1 - battery temperature) and also conversation data in variable
twl4030_divider_ratios. These hardcoded channels are incorrect for
Nokia RX-51 board (where is channel 0 - battery temperature).

For Nokia RX-51 there is rx51_battery power_supply driver which reporting
battery information via twl4030_madc_conversion. But this driver needs
raw values (not converted via some hardcoded functions). So this patch
adding new parameter "raw" to struct twl4030_madc_request which tell
twl4030-madc driver to not convert values, but rather return raw.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/mfd/twl4030-madc.c       |   14 ++++++++++----
 include/linux/i2c/twl4030-madc.h |    2 ++
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
index 88ff9dc..79d5d57 100644
--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -211,12 +211,14 @@ static int twl4030battery_current(int raw_volt)
  * @reg_base - Base address of the first channel
  * @Channels - 16 bit bitmap. If the bit is set, channel value is read
  * @buf - The channel values are stored here. if read fails error
+ * @raw - Return raw values without conversion
  * value is stored
  * Returns the number of successfully read channels.
  */
 static int twl4030_madc_read_channels(struct twl4030_madc_data *madc,
 				      u8 reg_base, unsigned
-						long channels, int *buf)
+				      long channels, int *buf,
+				      bool raw)
 {
 	int count = 0, count_req = 0, i;
 	u8 reg;
@@ -230,6 +232,10 @@ static int twl4030_madc_read_channels(struct twl4030_madc_data *madc,
 			count_req++;
 			continue;
 		}
+		if (raw) {
+			count++;
+			continue;
+		}
 		switch (i) {
 		case 10:
 			buf[i] = twl4030battery_current(buf[i]);
@@ -371,7 +377,7 @@ static irqreturn_t twl4030_madc_threaded_irq_handler(int irq, void *_madc)
 		method = &twl4030_conversion_methods[r->method];
 		/* Read results */
 		len = twl4030_madc_read_channels(madc, method->rbase,
-						 r->channels, r->rbuf);
+						 r->channels, r->rbuf, r->raw);
 		/* Return results to caller */
 		if (r->func_cb != NULL) {
 			r->func_cb(len, r->channels, r->rbuf);
@@ -397,7 +403,7 @@ err_i2c:
 		method = &twl4030_conversion_methods[r->method];
 		/* Read results */
 		len = twl4030_madc_read_channels(madc, method->rbase,
-						 r->channels, r->rbuf);
+						 r->channels, r->rbuf, r->raw);
 		/* Return results to caller */
 		if (r->func_cb != NULL) {
 			r->func_cb(len, r->channels, r->rbuf);
@@ -585,7 +591,7 @@ int twl4030_madc_conversion(struct twl4030_madc_request *req)
 		goto out;
 	}
 	ret = twl4030_madc_read_channels(twl4030_madc, method->rbase,
-					 req->channels, req->rbuf);
+					 req->channels, req->rbuf, req->raw);
 	twl4030_madc->requests[req->method].active = 0;
 
 out:
diff --git a/include/linux/i2c/twl4030-madc.h b/include/linux/i2c/twl4030-madc.h
index 530e11b..01f5951 100644
--- a/include/linux/i2c/twl4030-madc.h
+++ b/include/linux/i2c/twl4030-madc.h
@@ -39,6 +39,7 @@ struct twl4030_madc_conversion_method {
  * @do_avgP:	sample the input channel for 4 consecutive cycles
  * @method:	RT, SW1, SW2
  * @type:	Polling or interrupt based method
+ * @raw:	Return raw value, do not convert it
  */
 
 struct twl4030_madc_request {
@@ -48,6 +49,7 @@ struct twl4030_madc_request {
 	u16 type;
 	bool active;
 	bool result_pending;
+	bool raw;
 	int rbuf[TWL4030_MADC_MAX_CHANNELS];
 	void (*func_cb)(int len, int channels, int *buf);
 };
-- 
1.7.10.4

