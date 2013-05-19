Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab3ESQth (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 12:49:37 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:33402 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab3ESQtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 12:49:35 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Airlie <airlied@linux.ie>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Rob Clark <robdclark@gmail.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [RFC] drm: i2c: add irq handler for tda998x slave encoder
Date: Sun, 19 May 2013 18:49:22 +0200
Message-Id: <1368982162-10126-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an irq handler for HPD to the tda998x slave encoder driver
to trigger HPD change instead of polling. The gpio connected to int
pin of tda998x is passed through platform_data of the i2c client. As
HPD will ultimately cause EDID read and that will raise an
EDID_READ_DONE interrupt, the irq handling is done threaded with a
workqueue to notify drm backend of HPD events.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: David Airlie <airlied@linux.ie>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Daniel Vetter
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org

This patch currently is based on top of Russell King's Dove DRM driver.
I only have DT (plus the patches to get the above running) I post it as
an RFC first. To rebase it on top of v3.10-rc1, I would just have to
create include/drm/i2c/tda998x.h without rmk's initial include.

@Russell: TDA19988 int line on Cubox is on mpp27.

Sebastian
---
 drivers/gpu/drm/i2c/tda998x_drv.c |  134 +++++++++++++++++++++++++++++++++----
 include/drm/i2c/tda998x.h         |    4 ++
 2 files changed, 125 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 8ffb844..d71b9d8 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -16,8 +16,10 @@
  */
 
 
-
+#include <linux/gpio.h>
 #include <linux/module.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
 
 #include <drm/drmP.h>
 #include <drm/drm_crtc_helper.h>
@@ -29,6 +31,7 @@
 
 struct tda998x_priv {
 	struct i2c_client *cec;
+	struct drm_encoder *encoder;
 	uint16_t rev;
 	uint8_t current_page;
 	int dpms;
@@ -37,6 +40,10 @@ struct tda998x_priv {
 	u8 vip_cntrl_1;
 	u8 vip_cntrl_2;
 	struct tda998x_encoder_params params;
+	wait_queue_head_t wq_edid;
+	bool wq_edid_done;
+	struct work_struct work;
+	int irq;
 };
 
 #define to_tda998x_priv(x)  ((struct tda998x_priv *)to_encoder_slave(x)->slave_priv)
@@ -285,14 +292,19 @@ struct tda998x_priv {
 
 /* CEC registers: (not paged)
  */
+#define REG_CEC_INTSTATUS         0xee                /* read */
+# define CEC_INTSTATUS_HDMI       (1 << 1)
+# define CEC_INTSTATUS_CEC        (1 << 0)
 #define REG_CEC_FRO_IM_CLK_CTRL   0xfb                /* read/write */
 # define CEC_FRO_IM_CLK_CTRL_GHOST_DIS (1 << 7)
 # define CEC_FRO_IM_CLK_CTRL_ENA_OTP   (1 << 6)
 # define CEC_FRO_IM_CLK_CTRL_IMCLK_SEL (1 << 1)
 # define CEC_FRO_IM_CLK_CTRL_FRO_DIV   (1 << 0)
+#define REG_CEC_RXSHPDINTENA      0xfc                /* read/write */
+#define REG_CEC_RXSHPDINT         0xfd                /* read */
 #define REG_CEC_RXSHPDLEV         0xfe                /* read */
-# define CEC_RXSHPDLEV_RXSENS     (1 << 0)
-# define CEC_RXSHPDLEV_HPD        (1 << 1)
+# define CEC_RXSHPD_RXSENS        (1 << 0)
+# define CEC_RXSHPD_HPD           (1 << 1)
 
 #define REG_CEC_ENAMODS           0xff                /* read/write */
 # define CEC_ENAMODS_DIS_FRO      (1 << 6)
@@ -666,6 +678,54 @@ tda998x_encoder_set_config(struct drm_encoder *encoder, void *params)
 		tda998x_configure_audio(encoder, p);
 }
 
+static irqreturn_t tda998x_irq_thread(int irq, void *data)
+{
+	struct drm_encoder *encoder = data;
+	struct tda998x_priv *priv;
+	uint8_t sta, cec, hdmi, lev;
+
+	if (!encoder)
+		return IRQ_HANDLED;
+
+	priv = to_tda998x_priv(encoder);
+	if (!priv)
+		return IRQ_HANDLED;
+
+	sta  = cec_read(encoder, REG_CEC_INTSTATUS);
+	cec  = cec_read(encoder, REG_CEC_RXSHPDINT);
+	lev  = cec_read(encoder, REG_CEC_RXSHPDLEV);
+	hdmi = reg_read(encoder, REG_INT_FLAGS_2);
+
+	/* clear all interrupts */
+	cec_write(encoder, REG_CEC_RXSHPDINTENA, 0x00);
+
+	if (sta & CEC_INTSTATUS_HDMI) {
+		/* schedule EDID read on active HPD */
+		if ((cec & CEC_RXSHPD_HPD) && (lev & CEC_RXSHPD_HPD))
+			schedule_work(&priv->work);
+
+		/* wake up thread waiting on EDID read done */
+		if (hdmi & INT_FLAGS_2_EDID_BLK_RD) {
+			priv->wq_edid_done = true;
+			wake_up(&priv->wq_edid);
+		}
+	};
+
+	/* re-enable HPD interrupts */
+	cec_write(encoder, REG_CEC_RXSHPDINTENA, CEC_RXSHPD_HPD);
+
+	return IRQ_HANDLED;
+}
+
+static void tda998x_hpd_worker(struct work_struct *work)
+{
+	struct tda998x_priv *priv =
+		container_of(work, struct tda998x_priv, work);
+
+	if (priv->encoder && priv->encoder->dev)
+		drm_helper_hpd_irq_event(priv->encoder->dev);
+}
+
 static void
 tda998x_encoder_dpms(struct drm_encoder *encoder, int mode)
 {
@@ -878,19 +938,17 @@ tda998x_encoder_detect(struct drm_encoder *encoder,
 		      struct drm_connector *connector)
 {
 	uint8_t val = cec_read(encoder, REG_CEC_RXSHPDLEV);
-	return (val & CEC_RXSHPDLEV_HPD) ? connector_status_connected :
+	return (val & CEC_RXSHPD_HPD) ? connector_status_connected :
 			connector_status_disconnected;
 }
 
 static int
 read_edid_block(struct drm_encoder *encoder, uint8_t *buf, int blk)
 {
+	struct tda998x_priv *priv = to_tda998x_priv(encoder);
 	uint8_t offset, segptr;
 	int ret, i;
 
-	/* enable EDID read irq: */
-	reg_set(encoder, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
-
 	offset = (blk & 1) ? 128 : 0;
 	segptr = blk / 2;
 
@@ -900,17 +958,24 @@ read_edid_block(struct drm_encoder *encoder, uint8_t *buf, int blk)
 	reg_write(encoder, REG_DDC_SEGM, segptr);
 
 	/* enable reading EDID: */
+	priv->wq_edid_done = false;
+	reg_set(encoder, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
 	reg_write(encoder, REG_EDID_CTRL, 0x1);
 
 	/* flag must be cleared by sw: */
 	reg_write(encoder, REG_EDID_CTRL, 0x0);
 
 	/* wait for block read to complete: */
-	for (i = 100; i > 0; i--) {
-		uint8_t val = reg_read(encoder, REG_INT_FLAGS_2);
-		if (val & INT_FLAGS_2_EDID_BLK_RD)
-			break;
-		msleep(1);
+	if (priv->irq < 0) {
+		for (i = 100; i > 0; i--) {
+			uint8_t val = reg_read(encoder, REG_INT_FLAGS_2);
+			if (val & INT_FLAGS_2_EDID_BLK_RD)
+				break;
+			msleep(1);
+		}
+	} else {
+		i = wait_event_timeout(priv->wq_edid, priv->wq_edid_done,
+				       msecs_to_jiffies(100));
 	}
 
 	if (i == 0)
@@ -1014,7 +1079,15 @@ static int
 tda998x_encoder_create_resources(struct drm_encoder *encoder,
 				struct drm_connector *connector)
 {
-	DBG("");
+	struct tda998x_priv *priv = to_tda998x_priv(encoder);
+
+	/* announce polling if no irq is available */
+	if (priv->irq < 0)
+		connector->polled = DRM_CONNECTOR_POLL_CONNECT |
+			DRM_CONNECTOR_POLL_DISCONNECT;
+	else
+		connector->polled = DRM_CONNECTOR_POLL_HPD;
+
 	return 0;
 }
 
@@ -1105,7 +1178,9 @@ tda998x_encoder_init(struct i2c_client *client,
 		    struct drm_encoder_slave *encoder_slave)
 {
 	struct drm_encoder *encoder = &encoder_slave->base;
+	struct tda998x_platform_data *pdata = client->dev.platform_data;
 	struct tda998x_priv *priv;
+	int ret;
 /* debug */
 	device_create_file(&client->dev, &dev_attr_i2c_read);
 	device_create_file(&client->dev, &dev_attr_i2c_write);
@@ -1122,7 +1197,9 @@ tda998x_encoder_init(struct i2c_client *client,
 
 	priv->current_page = 0;
 	priv->cec = i2c_new_dummy(client->adapter, 0x34);
+	priv->irq = -EINVAL;
 	priv->dpms = DRM_MODE_DPMS_OFF;
+	priv->encoder = encoder;
 
 	encoder_slave->slave_priv = priv;
 	encoder_slave->slave_funcs = &tda998x_encoder_funcs;
@@ -1163,6 +1240,37 @@ tda998x_encoder_init(struct i2c_client *client,
 	cec_write(encoder, REG_CEC_FRO_IM_CLK_CTRL,
 			CEC_FRO_IM_CLK_CTRL_GHOST_DIS | CEC_FRO_IM_CLK_CTRL_IMCLK_SEL);
 
+	/* allow no platform_data */
+	if (!pdata)
+		goto no_pdata;
+
+	if (gpio_is_valid(pdata->int_gpio)) {
+		ret = devm_gpio_request_one(&client->dev, pdata->int_gpio,
+					    GPIOF_DIR_IN, "HDMI HPD");
+		if (ret)
+			goto fail;
+
+		priv->irq = gpio_to_irq(pdata->int_gpio);
+		/* init work and waitqueue */
+		INIT_WORK(&priv->work, tda998x_hpd_worker);
+		init_waitqueue_head(&priv->wq_edid);
+		/* clear pending interrupts */
+		reg_read(encoder, REG_INT_FLAGS_0);
+		reg_read(encoder, REG_INT_FLAGS_1);
+		reg_read(encoder, REG_INT_FLAGS_2);
+
+		ret = devm_request_threaded_irq(&client->dev, priv->irq, NULL,
+					tda998x_irq_thread,
+					IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+					"tda998x-int", encoder);
+		if (ret)
+			goto fail;
+
+		/* enable HPD irq */
+		cec_write(encoder, REG_CEC_RXSHPDINTENA, CEC_RXSHPD_HPD);
+	}
+
+no_pdata:
 	return 0;
 
 fail:
diff --git a/include/drm/i2c/tda998x.h b/include/drm/i2c/tda998x.h
index 41f799f..1838703 100644
--- a/include/drm/i2c/tda998x.h
+++ b/include/drm/i2c/tda998x.h
@@ -20,4 +20,8 @@ struct tda998x_encoder_params {
 	int swap_f, mirr_f;
 };
 
+struct tda998x_platform_data {
+	int int_gpio;
+};
+
 #endif
-- 
1.7.10.4

