Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbaAILLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:11:22 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:35217 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbaAILLI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:11:08 -0500
Date: Thu, 9 Jan 2014 12:04:12 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v2 13/28] drm/i2c: tda998x: use irq for connection status
 and EDID read
Message-ID: <20140109120412.7697d23c@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the optional treatment of the tda998x IRQ.

The interrupt function is used to know the display connection status
without polling and to speedup reading the EDID.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c            | 116 +++++++++++++++++++--
 .../devicetree/bindings/drm/i2c/tda998x.txt  |   3 +++
 2 file changed, 108 insertions(+), 11 deletions(-)

diff --git a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
index f07339e1..83d7880 100644
--- a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
+++ b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
@@ -4,6 +4,7 @@ Required properties;
   - compatible: must be "nxp,tda998x"
 
 Optional properties:
+  - interrupts: interrupt number for HDMI exchanges - default: by polling
   - video-ports: 24 bits value - default: <0x230145>
 
 Example:
@@ -11,6 +12,8 @@ Example:
 	tda998x: hdmi-encoder {
 		compatible = "nxp,tda998x";
 		reg = <0x70>;
+		interrupt-parent = <&gpio0>;
+		interrupts = <27 2>;		/* falling edge */
 		pinctrl-0 = <&pmx_camera>;
 		pinctrl-names = "default";
 	};
diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index b87802f..2187d63 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -19,6 +19,7 @@
 
 #include <linux/hdmi.h>
 #include <linux/module.h>
+#include <linux/of_irq.h>
 
 #include <drm/drmP.h>
 #include <drm/drm_crtc_helper.h>
@@ -44,6 +45,11 @@ struct tda998x_priv {
 	u8 audio_type;		/* audio type */
 	u8 audio_frame[6];
 	u32 audio_port;
+
+	int int_irq;
+	wait_queue_head_t wq_edid;
+	volatile int wq_edid_wait;
+	struct drm_encoder *encoder;
 };
 
 #define to_tda998x_priv(x)  ((struct tda998x_priv *)to_encoder_slave(x)->slave_priv)
@@ -310,11 +316,16 @@ struct tda998x_priv {
 
 /* CEC registers: (not paged)
  */
+#define REG_CEC_INTSTATUS         0xee                /* read */
+# define CEC_INTSTATUS_CEC        (1 << 0)
+# define CEC_INTSTATUS_HDMI       (1 << 1)
 #define REG_CEC_FRO_IM_CLK_CTRL   0xfb                /* read/write */
 # define CEC_FRO_IM_CLK_CTRL_GHOST_DIS (1 << 7)
 # define CEC_FRO_IM_CLK_CTRL_ENA_OTP   (1 << 6)
 # define CEC_FRO_IM_CLK_CTRL_IMCLK_SEL (1 << 1)
 # define CEC_FRO_IM_CLK_CTRL_FRO_DIV   (1 << 0)
+#define REG_CEC_RXSHPDINTENA      0xfc                /* read/write */
+#define REG_CEC_RXSHPDINT         0xfd                /* read */
 #define REG_CEC_RXSHPDLEV         0xfe                /* read */
 # define CEC_RXSHPDLEV_RXSENS     (1 << 0)
 # define CEC_RXSHPDLEV_HPD        (1 << 1)
@@ -520,6 +531,34 @@ tda998x_reset(struct tda998x_priv *priv)
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
+	DRM_DEBUG("tda irq sta %02x cec %02x lvl %02x f0 %02x f1 %02x f2 %02x\n",
+			sta, cec, lvl, flag0, flag1, flag2);
+	if ((flag2 & INT_FLAGS_2_EDID_BLK_RD) && priv->wq_edid_wait) {
+		priv->wq_edid_wait = 0;
+		wake_up(&priv->wq_edid);
+	} else if (cec != 0) {			/* level change */
+		if (priv->encoder && priv->encoder->dev)
+			drm_helper_hpd_irq_event(priv->encoder->dev);
+	}
+	return IRQ_HANDLED;
+}
+
 static uint8_t tda998x_cksum(uint8_t *buf, size_t bytes)
 {
 	uint8_t sum = 0;
@@ -982,7 +1021,8 @@ read_edid_block(struct drm_encoder *encoder, uint8_t *buf, int blk)
 	int ret, i;
 
 	/* enable EDID read irq: */
-	reg_set(priv, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
+	if (blk == 0)
+		reg_set(priv, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
 
 	offset = (blk & 1) ? 128 : 0;
 	segptr = blk / 2;
@@ -999,17 +1039,30 @@ read_edid_block(struct drm_encoder *encoder, uint8_t *buf, int blk)
 	reg_write(priv, REG_EDID_CTRL, 0x0);
 
 	/* wait for block read to complete: */
-	for (i = 100; i > 0; i--) {
-		ret = reg_read(priv, REG_INT_FLAGS_2);
-		if (ret < 0)
-			return ret;
-		if (ret & INT_FLAGS_2_EDID_BLK_RD)
-			break;
-		msleep(1);
+	if (priv->int_irq != NO_IRQ) {
+		priv->wq_edid_wait = 1;
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
@@ -1018,8 +1071,6 @@ read_edid_block(struct drm_encoder *encoder, uint8_t *buf, int blk)
 		return ret;
 	}
 
-	reg_clear(priv, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
-
 	return 0;
 }
 
@@ -1109,7 +1160,14 @@ static int
 tda998x_encoder_create_resources(struct drm_encoder *encoder,
 				struct drm_connector *connector)
 {
+	struct tda998x_priv *priv = to_tda998x_priv(encoder);
+
 	DBG("");
+	if (priv->int_irq != NO_IRQ)
+		connector->polled = DRM_CONNECTOR_POLL_HPD;
+	else
+		connector->polled = DRM_CONNECTOR_POLL_CONNECT |
+			DRM_CONNECTOR_POLL_DISCONNECT;
 	return 0;
 }
 
@@ -1128,6 +1186,8 @@ tda998x_encoder_destroy(struct drm_encoder *encoder)
 {
 	struct tda998x_priv *priv = to_tda998x_priv(encoder);
 	drm_i2c_encoder_destroy(encoder);
+	if (priv->int_irq != NO_IRQ)
+		free_irq(priv->int_irq, priv);
 	if (priv->cec)
 		i2c_unregister_device(priv->cec);
 	kfree(priv);
@@ -1186,6 +1246,7 @@ tda998x_encoder_init(struct i2c_client *client,
 	priv->cec = i2c_new_dummy(client->adapter, 0x34);
 	if (!priv->cec)
 		return -ENODEV;
+	priv->encoder = &encoder_slave->base;
 	priv->dpms = DRM_MODE_DPMS_OFF;
 
 	encoder_slave->slave_priv = priv;
@@ -1250,6 +1311,39 @@ tda998x_encoder_init(struct i2c_client *client,
 		priv->vip_cntrl_2 = video;
 	}
 
+	/* install the optional HDMI connect IRQ */
+	priv->int_irq = irq_of_parse_and_map(np, 0);
+	if (priv->int_irq < 0)
+		priv->int_irq = NO_IRQ;
+	if (priv->int_irq != NO_IRQ) {
+
+		/* init read EDID waitqueue */
+		init_waitqueue_head(&priv->wq_edid);
+/*		priv->wq_edid_wait = 0;	*/
+
+		/* clear pending interrupts */
+		reg_read(priv, REG_INT_FLAGS_0);
+		reg_read(priv, REG_INT_FLAGS_1);
+		reg_read(priv, REG_INT_FLAGS_2);
+
+		ret = request_threaded_irq(priv->int_irq, NULL,
+					   tda998x_irq_thread,
+					   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+					   "tda998x-int", priv);
+		if (ret) {
+			dev_err(&client->dev, "failed to request IRQ#%u: %d\n",
+				priv->int_irq, ret);
+			goto fail;
+		}
+
+		/* enable HPD irq */
+		cec_write(priv, REG_CEC_RXSHPDINTENA,
+				CEC_RXSHPDLEV_HPD | CEC_RXSHPDLEV_RXSENS);
+
+		/* treat the first irq if any */
+		msleep(10);
+	}
+
 	return 0;
 
 fail:
-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
