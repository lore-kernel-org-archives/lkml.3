Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab3H1Ngx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:36:53 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:52229 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab3H1Ngs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:36:48 -0400
From: John Horan <knasher@gmail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Horan <knasher@gmail.com>
Subject: [PATCH] media: dvb-frontends: ts2020: Added in a option for frequency divider value for s600 devices
Date: Wed, 28 Aug 2013 14:37:37 +0100
Message-Id: <1377697057-23676-1-git-send-email-knasher@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the tuner part of the ds3000 driver was split to share code with the m88rs2000 driver, the ts2020 driver used
the frequency divider value from the m88rs2000 driver.  However the ds3000 driver requires a different value, and this
resulted in some frequecies being invisible to the tuner.  This patch adds back in the value needed for the ds3000 driver
and configured as an option in the dw2102 frontend driver.

It may also apply to su3000 devices, which use the same ds3000 driver, but for now it is only applied to the s660 device.

Signed-off-by: John Horan <knasher@gmail.com>
---
 drivers/media/dvb-frontends/ts2020.c |  4 +++-
 drivers/media/dvb-frontends/ts2020.h |  1 +
 drivers/media/usb/dvb-usb/dw2102.c   | 13 ++++++++++---
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index ad7ad85..678f13a 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -31,6 +31,7 @@ struct ts2020_priv {
 	struct i2c_adapter *i2c;
 	u8 clk_out_div;
 	u32 frequency;
+	u32 frequency_div;
 };
 
 static int ts2020_release(struct dvb_frontend *fe)
@@ -193,7 +194,7 @@ static int ts2020_set_params(struct dvb_frontend *fe)
 	u8 lo = 0x01, div4 = 0x0;
 
 	/* Calculate frequency divider */
-	if (frequency < 1060000) {
+	if (frequency < priv->frequency_div) {
 		lo |= 0x10;
 		div4 = 0x1;
 		ndiv = (frequency * 14 * 4) / TS2020_XTAL_FREQ;
@@ -340,6 +341,7 @@ struct dvb_frontend *ts2020_attach(struct dvb_frontend *fe,
 	priv->i2c_address = config->tuner_address;
 	priv->i2c = i2c;
 	priv->clk_out_div = config->clk_out_div;
+	priv->frequency_div = config->frequency_div;
 	fe->tuner_priv = priv;
 
 	/* Wake Up the tuner */
diff --git a/drivers/media/dvb-frontends/ts2020.h b/drivers/media/dvb-frontends/ts2020.h
index 5bcb9a7..b2fe6bb 100644
--- a/drivers/media/dvb-frontends/ts2020.h
+++ b/drivers/media/dvb-frontends/ts2020.h
@@ -28,6 +28,7 @@
 struct ts2020_config {
 	u8 tuner_address;
 	u8 clk_out_div;
+	u32 frequency_div;
 };
 
 #if IS_ENABLED(CONFIG_DVB_TS2020)
diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 6e237b6..6136a2c 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -955,9 +955,10 @@ static struct ds3000_config dw2104_ds3000_config = {
 	.demod_address = 0x68,
 };
 
-static struct ts2020_config dw2104_ts2020_config  = {
+static struct ts2020_config dw2104_ts2020_config = {
 	.tuner_address = 0x60,
 	.clk_out_div = 1,
+	.frequency_div = 1060000,
 };
 
 static struct ds3000_config s660_ds3000_config = {
@@ -966,6 +967,12 @@ static struct ds3000_config s660_ds3000_config = {
 	.set_lock_led = dw210x_led_ctrl,
 };
 
+static struct ts2020_config s660_ts2020_config = {
+	.tuner_address = 0x60,
+	.clk_out_div = 1,
+	.frequency_div = 1146000,
+};
+
 static struct stv0900_config dw2104a_stv0900_config = {
 	.demod_address = 0x6a,
 	.demod_mode = 0,
@@ -1205,7 +1212,7 @@ static int ds3000_frontend_attach(struct dvb_usb_adapter *d)
 	if (d->fe_adap[0].fe == NULL)
 		return -EIO;
 
-	dvb_attach(ts2020_attach, d->fe_adap[0].fe, &dw2104_ts2020_config,
+	dvb_attach(ts2020_attach, d->fe_adap[0].fe, &s660_ts2020_config,
 		&d->dev->i2c_adap);
 
 	st->old_set_voltage = d->fe_adap[0].fe->ops.set_voltage;
@@ -1213,7 +1220,7 @@ static int ds3000_frontend_attach(struct dvb_usb_adapter *d)
 
 	dw210x_op_rw(d->dev->udev, 0x8a, 0, 0, obuf, 2, DW210X_WRITE_MSG);
 
-	info("Attached ds3000+ds2020!\n");
+	info("Attached ds3000+ts2020!\n");
 
 	return 0;
 }
-- 
1.8.4

