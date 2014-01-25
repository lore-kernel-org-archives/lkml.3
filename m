Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbaAYRPv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 12:15:51 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:45524 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbaAYRPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 12:15:49 -0500
Date: Sat, 25 Jan 2014 18:14:38 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v4 15/24] drm/i2c: tda998x: use irq for connection status
 and EDID read
Message-ID: <20140125181438.1353afc7@armhf>
In-Reply-To: <cover.1390646891.git.moinejf@free.fr>
References: <cover.1390646891.git.moinejf@free.fr>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the optional treatment of the tda998x IRQ.

The interrupt function is used to know the display connection status
without polling and to speedup reading the EDID.

The IRQ number is defined in the i2c client either by platform data or
in the DT.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 102 ++++++++++++++++++++++++++++++++++----
 1 file changed, 93 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 967f9ce..5a67b6f 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -39,6 +39,10 @@ struct tda998x_priv {
 	u8 vip_cntrl_1;
 	u8 vip_cntrl_2;
 	struct tda998x_encoder_params params;
+
+	wait_queue_head_t wq_edid;
+	volatile int wq_edid_wait;
+	struct drm_encoder *encoder;
 };
 
 #define to_tda998x_priv(x)  ((struct tda998x_priv *)to_encoder_slave(x)->slave_priv)
@@ -305,11 +309,16 @@ struct tda998x_priv {
 
 /* CEC registers: (not paged)
  */
+#define REG_CEC_INTSTATUS	  0xee		      /* read */
+# define CEC_INTSTATUS_CEC	  (1 << 0)
+# define CEC_INTSTATUS_HDMI	  (1 << 1)
 #define REG_CEC_FRO_IM_CLK_CTRL   0xfb                /* read/write */
 # define CEC_FRO_IM_CLK_CTRL_GHOST_DIS (1 << 7)
 # define CEC_FRO_IM_CLK_CTRL_ENA_OTP   (1 << 6)
 # define CEC_FRO_IM_CLK_CTRL_IMCLK_SEL (1 << 1)
 # define CEC_FRO_IM_CLK_CTRL_FRO_DIV   (1 << 0)
+#define REG_CEC_RXSHPDINTENA	  0xfc		      /* read/write */
+#define REG_CEC_RXSHPDINT	  0xfd		      /* read */
 #define REG_CEC_RXSHPDLEV         0xfe                /* read */
 # define CEC_RXSHPDLEV_RXSENS     (1 << 0)
 # define CEC_RXSHPDLEV_HPD        (1 << 1)
@@ -523,6 +532,35 @@ tda998x_reset(struct tda998x_priv *priv)
 	reg_write(priv, REG_MUX_VP_VIP_OUT, 0x24);
 }
 
+/*
+ * only 2 interrupts may occur: screen plug/unplug and EDID read
+ */
+static irqreturn_t tda998x_irq_thread(int irq, void *data)
+{
+	struct tda998x_priv *priv = data;
+	u8 sta, cec, lvl, flag0, flag1, flag2;
+
+	if (!priv)
+		return IRQ_HANDLED;
+	sta = cec_read(priv, REG_CEC_INTSTATUS);
+	cec = cec_read(priv, REG_CEC_RXSHPDINT);
+	lvl = cec_read(priv, REG_CEC_RXSHPDLEV);
+	flag0 = reg_read(priv, REG_INT_FLAGS_0);
+	flag1 = reg_read(priv, REG_INT_FLAGS_1);
+	flag2 = reg_read(priv, REG_INT_FLAGS_2);
+	DRM_DEBUG_DRIVER(
+		"tda irq sta %02x cec %02x lvl %02x f0 %02x f1 %02x f2 %02x\n",
+		sta, cec, lvl, flag0, flag1, flag2);
+	if ((flag2 & INT_FLAGS_2_EDID_BLK_RD) && priv->wq_edid_wait) {
+		priv->wq_edid_wait = 0;
+		wake_up(&priv->wq_edid);
+	} else if (cec != 0) {			/* HPD change */
+		if (priv->encoder && priv->encoder->dev)
+			drm_helper_hpd_irq_event(priv->encoder->dev);
+	}
+	return IRQ_HANDLED;
+}
+
 static uint8_t tda998x_cksum(uint8_t *buf, size_t bytes)
 {
 	uint8_t sum = 0;
@@ -986,23 +1024,36 @@ read_edid_block(struct drm_encoder *encoder, uint8_t *buf, int blk)
 	reg_write(priv, REG_DDC_SEGM, segptr);
 
 	/* enable reading EDID: */
+	priv->wq_edid_wait = 1;
 	reg_write(priv, REG_EDID_CTRL, 0x1);
 
 	/* flag must be cleared by sw: */
 	reg_write(priv, REG_EDID_CTRL, 0x0);
 
 	/* wait for block read to complete: */
-	for (i = 100; i > 0; i--) {
-		ret = reg_read(priv, REG_INT_FLAGS_2);
-		if (ret < 0)
-			return ret;
-		if (ret & INT_FLAGS_2_EDID_BLK_RD)
-			break;
-		msleep(1);
+	if (priv->hdmi->irq) {
+		i = wait_event_timeout(priv->wq_edid,
+					!priv->wq_edid_wait,
+					msecs_to_jiffies(100));
+		if (i < 0) {
+			dev_err(encoder->dev->dev, "read edid wait err %d\n", i);
+			return i;
+		}
+	} else {
+		for (i = 10; i > 0; i--) {
+			msleep(10);
+			ret = reg_read(priv, REG_INT_FLAGS_2);
+			if (ret < 0)
+				return ret;
+			if (ret & INT_FLAGS_2_EDID_BLK_RD)
+				break;
+		}
 	}
 
-	if (i == 0)
+	if (i == 0) {
+		dev_err(encoder->dev->dev, "read edid timeout\n");
 		return -ETIMEDOUT;
+	}
 
 	ret = reg_read_range(priv, REG_EDID_DATA_0, buf, EDID_LENGTH);
 	if (ret != EDID_LENGTH) {
@@ -1100,7 +1151,13 @@ static int
 tda998x_encoder_create_resources(struct drm_encoder *encoder,
 				struct drm_connector *connector)
 {
-	DBG("");
+	struct tda998x_priv *priv = to_tda998x_priv(encoder);
+
+	if (priv->hdmi->irq)
+		connector->polled = DRM_CONNECTOR_POLL_HPD;
+	else
+		connector->polled = DRM_CONNECTOR_POLL_CONNECT |
+			DRM_CONNECTOR_POLL_DISCONNECT;
 	return 0;
 }
 
@@ -1176,6 +1233,7 @@ tda998x_encoder_init(struct i2c_client *client,
 	priv->cec = i2c_new_dummy(client->adapter, 0x34);
 	if (!priv->cec)
 		return -ENODEV;
+	priv->encoder = &encoder_slave->base;
 	priv->dpms = DRM_MODE_DPMS_OFF;
 
 	encoder_slave->slave_priv = priv;
@@ -1229,6 +1287,32 @@ tda998x_encoder_init(struct i2c_client *client,
 	cec_write(priv, REG_CEC_FRO_IM_CLK_CTRL,
 			CEC_FRO_IM_CLK_CTRL_GHOST_DIS | CEC_FRO_IM_CLK_CTRL_IMCLK_SEL);
 
+	/* initialize the optional IRQ */
+	if (client->irq) {
+
+		/* init read EDID waitqueue */
+		init_waitqueue_head(&priv->wq_edid);
+
+		/* clear pending interrupts */
+		reg_read(priv, REG_INT_FLAGS_0);
+		reg_read(priv, REG_INT_FLAGS_1);
+		reg_read(priv, REG_INT_FLAGS_2);
+
+		ret = request_threaded_irq(client->irq, NULL,
+					   tda998x_irq_thread,
+					   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+					   "tda998x", priv);
+		if (ret) {
+			dev_err(&client->dev,
+				"failed to request IRQ#%u: %d\n",
+				client->irq, ret);
+			goto fail;
+		}
+
+		/* enable HPD irq */
+		cec_write(priv, REG_CEC_RXSHPDINTENA, CEC_RXSHPDLEV_HPD);
+	}
+
 	/* enable EDID read irq: */
 	reg_set(priv, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
 
-- 
1.8.5.3

