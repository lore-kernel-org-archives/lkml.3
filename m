Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631AbaCQJzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:55:23 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:44604 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210AbaCQJzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:55:18 -0400
X-Mailbox-Line: From b3a3ca75ed3b2acebdbd564361df6c7cc96aacb9 Mon Sep 17 00:00:00 2001
Message-Id: <b3a3ca75ed3b2acebdbd564361df6c7cc96aacb9.1395049204.git.moinejf@free.fr>
In-Reply-To: <cover.1395049204.git.moinejf@free.fr>
References: <cover.1395049204.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Mon, 17 Mar 2014 09:17:32 +0100
Subject: [PATCH RFC 1/5] drm/i2c: tda998x: Move tda998x to a couple
 encoder/connector
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'slave encoder' structure of the tda998x driver asks for glue
between the DRM driver and the encoder/connector structures.

This patch changes the driver to a normal DRM encoder/connector
thanks to the infrastructure for componentised subsystems.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 335 ++++++++++++++++++++------------------
 1 file changed, 180 insertions(+), 155 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 48af5ca..1b5bbc5 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -20,11 +20,12 @@
 #include <linux/hdmi.h>
 #include <linux/module.h>
 #include <linux/irq.h>
+#include <linux/of_platform.h>
+#include <linux/component.h>
 #include <sound/asoundef.h>
 
 #include <drm/drmP.h>
 #include <drm/drm_crtc_helper.h>
-#include <drm/drm_encoder_slave.h>
 #include <drm/drm_edid.h>
 #include <drm/i2c/tda998x.h>
 
@@ -44,10 +45,14 @@ struct tda998x_priv {
 
 	wait_queue_head_t wq_edid;
 	volatile int wq_edid_wait;
-	struct drm_encoder *encoder;
+	struct drm_encoder encoder;
+	struct drm_connector connector;
 };
 
-#define to_tda998x_priv(x)  ((struct tda998x_priv *)to_encoder_slave(x)->slave_priv)
+#define connector_priv(e) \
+		container_of(connector, struct tda998x_priv, connector)
+#define encoder_priv(e) \
+		container_of(encoder, struct tda998x_priv, encoder)
 
 /* The TDA9988 series of devices use a paged register scheme.. to simplify
  * things we encode the page # in upper bits of the register #.  To read/
@@ -559,9 +564,8 @@ static irqreturn_t tda998x_irq_thread(int irq, void *data)
 	if ((flag2 & INT_FLAGS_2_EDID_BLK_RD) && priv->wq_edid_wait) {
 		priv->wq_edid_wait = 0;
 		wake_up(&priv->wq_edid);
-	} else if (cec != 0) {			/* HPD change */
-		if (priv->encoder && priv->encoder->dev)
-			drm_helper_hpd_irq_event(priv->encoder->dev);
+	} else if (cec != 0&& priv->encoder.dev) {	/* HPD change */
+		drm_helper_hpd_irq_event(priv->encoder.dev);
 	}
 	return IRQ_HANDLED;
 }
@@ -731,31 +735,9 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 /* DRM encoder functions */
 
 static void
-tda998x_encoder_set_config(struct drm_encoder *encoder, void *params)
-{
-	struct tda998x_priv *priv = to_tda998x_priv(encoder);
-	struct tda998x_encoder_params *p = params;
-
-	priv->vip_cntrl_0 = VIP_CNTRL_0_SWAP_A(p->swap_a) |
-			    (p->mirr_a ? VIP_CNTRL_0_MIRR_A : 0) |
-			    VIP_CNTRL_0_SWAP_B(p->swap_b) |
-			    (p->mirr_b ? VIP_CNTRL_0_MIRR_B : 0);
-	priv->vip_cntrl_1 = VIP_CNTRL_1_SWAP_C(p->swap_c) |
-			    (p->mirr_c ? VIP_CNTRL_1_MIRR_C : 0) |
-			    VIP_CNTRL_1_SWAP_D(p->swap_d) |
-			    (p->mirr_d ? VIP_CNTRL_1_MIRR_D : 0);
-	priv->vip_cntrl_2 = VIP_CNTRL_2_SWAP_E(p->swap_e) |
-			    (p->mirr_e ? VIP_CNTRL_2_MIRR_E : 0) |
-			    VIP_CNTRL_2_SWAP_F(p->swap_f) |
-			    (p->mirr_f ? VIP_CNTRL_2_MIRR_F : 0);
-
-	priv->params = *p;
-}
-
-static void
 tda998x_encoder_dpms(struct drm_encoder *encoder, int mode)
 {
-	struct tda998x_priv *priv = to_tda998x_priv(encoder);
+	struct tda998x_priv *priv = encoder_priv(encoder);
 
 	/* we only care about on or off: */
 	if (mode != DRM_MODE_DPMS_ON)
@@ -786,18 +768,6 @@ tda998x_encoder_dpms(struct drm_encoder *encoder, int mode)
 	priv->dpms = mode;
 }
 
-static void
-tda998x_encoder_save(struct drm_encoder *encoder)
-{
-	DBG("");
-}
-
-static void
-tda998x_encoder_restore(struct drm_encoder *encoder)
-{
-	DBG("");
-}
-
 static bool
 tda998x_encoder_mode_fixup(struct drm_encoder *encoder,
 			  const struct drm_display_mode *mode,
@@ -806,11 +776,14 @@ tda998x_encoder_mode_fixup(struct drm_encoder *encoder,
 	return true;
 }
 
-static int
-tda998x_encoder_mode_valid(struct drm_encoder *encoder,
-			  struct drm_display_mode *mode)
+static void tda998x_encoder_prepare(struct drm_encoder *encoder)
 {
-	return MODE_OK;
+	tda998x_encoder_dpms(encoder, DRM_MODE_DPMS_OFF);
+}
+
+static void tda998x_encoder_commit(struct drm_encoder *encoder)
+{
+	tda998x_encoder_dpms(encoder, DRM_MODE_DPMS_ON);
 }
 
 static void
@@ -818,7 +791,7 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 			struct drm_display_mode *mode,
 			struct drm_display_mode *adjusted_mode)
 {
-	struct tda998x_priv *priv = to_tda998x_priv(encoder);
+	struct tda998x_priv *priv = encoder_priv(encoder);
 	uint16_t ref_pix, ref_line, n_pix, n_line;
 	uint16_t hs_pix_s, hs_pix_e;
 	uint16_t vs1_pix_s, vs1_pix_e, vs1_line_s, vs1_line_e;
@@ -1006,10 +979,9 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 }
 
 static enum drm_connector_status
-tda998x_encoder_detect(struct drm_encoder *encoder,
-		      struct drm_connector *connector)
+tda998x_connector_detect(struct drm_connector *connector, bool force)
 {
-	struct tda998x_priv *priv = to_tda998x_priv(encoder);
+	struct tda998x_priv *priv = connector_priv(connector);
 	uint8_t val = cec_read(priv, REG_CEC_RXSHPDLEV);
 
 	return (val & CEC_RXSHPDLEV_HPD) ? connector_status_connected :
@@ -1017,9 +989,8 @@ tda998x_encoder_detect(struct drm_encoder *encoder,
 }
 
 static int
-read_edid_block(struct drm_encoder *encoder, uint8_t *buf, int blk)
+read_edid_block(struct tda998x_priv *priv, uint8_t *buf, int blk)
 {
-	struct tda998x_priv *priv = to_tda998x_priv(encoder);
 	uint8_t offset, segptr;
 	int ret, i;
 
@@ -1073,10 +1044,8 @@ read_edid_block(struct drm_encoder *encoder, uint8_t *buf, int blk)
 	return 0;
 }
 
-static uint8_t *
-do_get_edid(struct drm_encoder *encoder)
+static uint8_t *do_get_edid(struct tda998x_priv *priv)
 {
-	struct tda998x_priv *priv = to_tda998x_priv(encoder);
 	int j, valid_extensions = 0;
 	uint8_t *block, *new;
 	bool print_bad_edid = drm_debug & DRM_UT_KMS;
@@ -1088,7 +1057,7 @@ do_get_edid(struct drm_encoder *encoder)
 		reg_clear(priv, REG_TX4, TX4_PD_RAM);
 
 	/* base block fetch */
-	if (read_edid_block(encoder, block, 0))
+	if (read_edid_block(priv, block, 0))
 		goto fail;
 
 	if (!drm_edid_block_valid(block, 0, print_bad_edid))
@@ -1105,7 +1074,7 @@ do_get_edid(struct drm_encoder *encoder)
 
 	for (j = 1; j <= block[0x7e]; j++) {
 		uint8_t *ext_block = block + (valid_extensions + 1) * EDID_LENGTH;
-		if (read_edid_block(encoder, ext_block, j))
+		if (read_edid_block(priv, ext_block, j))
 			goto fail;
 
 		if (!drm_edid_block_valid(ext_block, j, print_bad_edid))
@@ -1137,12 +1106,28 @@ fail:
 	return NULL;
 }
 
+/* DRM connector functions */
+
+static struct drm_encoder *
+tda998x_connector_best_encoder(struct drm_connector *connector)
+{
+	struct tda998x_priv *priv = connector_priv(connector);
+
+	return &priv->encoder;
+}
+
 static int
-tda998x_encoder_get_modes(struct drm_encoder *encoder,
-			 struct drm_connector *connector)
+tda998x_connector_mode_valid(struct drm_connector *connector,
+			  struct drm_display_mode *mode)
+{
+	return MODE_OK;
+}
+
+static int
+tda998x_connector_get_modes(struct drm_connector *connector)
 {
-	struct tda998x_priv *priv = to_tda998x_priv(encoder);
-	struct edid *edid = (struct edid *)do_get_edid(encoder);
+	struct tda998x_priv *priv = connector_priv(connector);
+	struct edid *edid = (struct edid *) do_get_edid(priv);
 	int n = 0;
 
 	if (edid) {
@@ -1156,22 +1141,7 @@ tda998x_encoder_get_modes(struct drm_encoder *encoder,
 }
 
 static int
-tda998x_encoder_create_resources(struct drm_encoder *encoder,
-				struct drm_connector *connector)
-{
-	struct tda998x_priv *priv = to_tda998x_priv(encoder);
-
-	if (priv->hdmi->irq)
-		connector->polled = DRM_CONNECTOR_POLL_HPD;
-	else
-		connector->polled = DRM_CONNECTOR_POLL_CONNECT |
-			DRM_CONNECTOR_POLL_DISCONNECT;
-	return 0;
-}
-
-static int
-tda998x_encoder_set_property(struct drm_encoder *encoder,
-			    struct drm_connector *connector,
+tda998x_connector_set_property(struct drm_connector *connector,
 			    struct drm_property *property,
 			    uint64_t val)
 {
@@ -1179,56 +1149,117 @@ tda998x_encoder_set_property(struct drm_encoder *encoder,
 	return 0;
 }
 
-static void
-tda998x_encoder_destroy(struct drm_encoder *encoder)
+static const struct drm_encoder_helper_funcs encoder_helper_funcs = {
+	.dpms = tda998x_encoder_dpms,
+	.mode_fixup = tda998x_encoder_mode_fixup,
+	.prepare = tda998x_encoder_prepare,
+	.commit = tda998x_encoder_commit,
+	.mode_set = tda998x_encoder_mode_set,
+};
+
+static void tda998x_encoder_destroy(struct drm_encoder *encoder)
 {
-	struct tda998x_priv *priv = to_tda998x_priv(encoder);
-	drm_i2c_encoder_destroy(encoder);
+	drm_encoder_cleanup(encoder);
+}
 
-	/* disable all IRQs and free the IRQ handler */
-	cec_write(priv, REG_CEC_RXSHPDINTENA, 0);
-	reg_clear(priv, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
-	if (priv->hdmi->irq)
-		free_irq(priv->hdmi->irq, priv);
+static const struct drm_encoder_funcs encoder_funcs = {
+	.destroy = tda998x_encoder_destroy,
+};
 
-	if (priv->cec)
-		i2c_unregister_device(priv->cec);
-	kfree(priv);
+static const struct drm_connector_helper_funcs connector_helper_funcs = {
+	.get_modes = tda998x_connector_get_modes,
+	.mode_valid = tda998x_connector_mode_valid,
+	.best_encoder = tda998x_connector_best_encoder,
+};
+
+static void tda998x_connector_destroy(struct drm_connector *connector)
+{
+	if (!connector->dev)
+		return;
+	drm_sysfs_connector_remove(connector);
+	drm_connector_cleanup(connector);
 }
 
-static struct drm_encoder_slave_funcs tda998x_encoder_funcs = {
-	.set_config = tda998x_encoder_set_config,
-	.destroy = tda998x_encoder_destroy,
-	.dpms = tda998x_encoder_dpms,
-	.save = tda998x_encoder_save,
-	.restore = tda998x_encoder_restore,
-	.mode_fixup = tda998x_encoder_mode_fixup,
-	.mode_valid = tda998x_encoder_mode_valid,
-	.mode_set = tda998x_encoder_mode_set,
-	.detect = tda998x_encoder_detect,
-	.get_modes = tda998x_encoder_get_modes,
-	.create_resources = tda998x_encoder_create_resources,
-	.set_property = tda998x_encoder_set_property,
+static const struct drm_connector_funcs connector_funcs = {
+	.detect = tda998x_connector_detect,
+	.set_property = tda998x_connector_set_property,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.dpms = drm_helper_connector_dpms,
+	.destroy = tda998x_connector_destroy,
 };
 
 /* I2C driver functions */
 
-static int
-tda998x_probe(struct i2c_client *client, const struct i2c_device_id *id)
+static int tda_bind(struct device *dev, struct device *master, void *data)
 {
+	struct drm_device *drm = data;
+	struct i2c_client *i2c_client = to_i2c_client(dev);
+	struct tda998x_priv *priv = i2c_get_clientdata(i2c_client);
+	struct drm_connector *connector = &priv->connector;
+	struct drm_encoder *encoder = &priv->encoder;
+	int ret;
+
+	if (!try_module_get(THIS_MODULE)) {
+		dev_err(dev, "cannot get module %s\n", THIS_MODULE->name);
+		return -EINVAL;
+	}
+
+	ret = drm_connector_init(drm, connector,
+				&connector_funcs,
+				DRM_MODE_CONNECTOR_HDMIA);
+	if (ret < 0)
+		return ret;
+	drm_connector_helper_add(connector, &connector_helper_funcs);
+
+	ret = drm_encoder_init(drm, encoder,
+				&encoder_funcs,
+				DRM_MODE_ENCODER_TMDS);
+
+	encoder->possible_crtcs = 1;	// 1 << lcd_num
+
+	if (ret < 0)
+		goto err;
+	drm_encoder_helper_add(encoder, &encoder_helper_funcs);
+
+	ret = drm_mode_connector_attach_encoder(connector, encoder);
+	if (ret < 0)
+		goto err;
+	connector->encoder = encoder;
+
+	drm_sysfs_connector_add(connector);
+
+	drm_helper_connector_dpms(connector, DRM_MODE_DPMS_OFF);
+	ret = drm_object_property_set_value(&connector->base,
+					drm->mode_config.dpms_property,
+					DRM_MODE_DPMS_OFF);
+
+	if (priv->hdmi->irq)
+		connector->polled = DRM_CONNECTOR_POLL_HPD;
+	else
+		connector->polled = DRM_CONNECTOR_POLL_CONNECT |
+			DRM_CONNECTOR_POLL_DISCONNECT;
 	return 0;
+
+err:
+	if (encoder->dev)
+		drm_encoder_cleanup(encoder);
+	if (connector->dev)
+		drm_connector_cleanup(connector);
+	return ret;
 }
 
-static int
-tda998x_remove(struct i2c_client *client)
+static void tda_unbind(struct device *dev, struct device *master, void *data)
 {
-	return 0;
+	module_put(THIS_MODULE);
 }
 
+static const struct component_ops comp_ops = {
+	.bind = tda_bind,
+	.unbind = tda_unbind,
+};
+
 static int
-tda998x_encoder_init(struct i2c_client *client,
-		    struct drm_device *dev,
-		    struct drm_encoder_slave *encoder_slave)
+tda998x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	struct tda998x_priv *priv;
 	struct device_node *np = client->dev.of_node;
@@ -1239,6 +1270,8 @@ tda998x_encoder_init(struct i2c_client *client,
 	if (!priv)
 		return -ENOMEM;
 
+	i2c_set_clientdata(client, priv);
+
 	priv->vip_cntrl_0 = VIP_CNTRL_0_SWAP_A(2) | VIP_CNTRL_0_SWAP_B(3);
 	priv->vip_cntrl_1 = VIP_CNTRL_1_SWAP_C(0) | VIP_CNTRL_1_SWAP_D(1);
 	priv->vip_cntrl_2 = VIP_CNTRL_2_SWAP_E(4) | VIP_CNTRL_2_SWAP_F(5);
@@ -1250,13 +1283,8 @@ tda998x_encoder_init(struct i2c_client *client,
 		kfree(priv);
 		return -ENODEV;
 	}
-
-	priv->encoder = &encoder_slave->base;
 	priv->dpms = DRM_MODE_DPMS_OFF;
 
-	encoder_slave->slave_priv = priv;
-	encoder_slave->slave_funcs = &tda998x_encoder_funcs;
-
 	/* wake up the device: */
 	cec_write(priv, REG_CEC_ENAMODS,
 			CEC_ENAMODS_EN_RXSENS | CEC_ENAMODS_EN_HDMI);
@@ -1340,31 +1368,48 @@ tda998x_encoder_init(struct i2c_client *client,
 	/* enable EDID read irq: */
 	reg_set(priv, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
 
-	if (!np)
-		return 0;		/* non-DT */
+	if (np) {				/* if DT */
 
-	/* get the optional video properties */
-	ret = of_property_read_u32(np, "video-ports", &video);
-	if (ret == 0) {
-		priv->vip_cntrl_0 = video >> 16;
-		priv->vip_cntrl_1 = video >> 8;
-		priv->vip_cntrl_2 = video;
+		/* get the optional video properties */
+		ret = of_property_read_u32(np, "video-ports", &video);
+		if (ret == 0) {
+			priv->vip_cntrl_0 = video >> 16;
+			priv->vip_cntrl_1 = video >> 8;
+			priv->vip_cntrl_2 = video;
+		}
 	}
 
+	/* tda998x video component ready */
+	component_add(&client->dev, &comp_ops);
+
 	return 0;
 
 fail:
-	/* if encoder_init fails, the encoder slave is never registered,
-	 * so cleanup here:
-	 */
 	if (priv->cec)
 		i2c_unregister_device(priv->cec);
 	kfree(priv);
-	encoder_slave->slave_priv = NULL;
-	encoder_slave->slave_funcs = NULL;
 	return -ENXIO;
 }
 
+static int
+tda998x_remove(struct i2c_client *client)
+{
+	struct tda998x_priv *priv = i2c_get_clientdata(client);
+
+	/* disable all IRQs and free the IRQ handler */
+	cec_write(priv, REG_CEC_RXSHPDINTENA, 0);
+	reg_clear(priv, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
+	if (priv->hdmi->irq)
+		free_irq(priv->hdmi->irq, priv);
+
+	component_del(&client->dev, &comp_ops);
+
+	if (priv->cec)
+		i2c_unregister_device(priv->cec);
+	kfree(priv);
+	return 0;
+}
+
 #ifdef CONFIG_OF
 static const struct of_device_id tda998x_dt_ids[] = {
 	{ .compatible = "nxp,tda998x", },
@@ -1379,38 +1424,18 @@ static struct i2c_device_id tda998x_ids[] = {
 };
 MODULE_DEVICE_TABLE(i2c, tda998x_ids);
 
-static struct drm_i2c_encoder_driver tda998x_driver = {
-	.i2c_driver = {
-		.probe = tda998x_probe,
-		.remove = tda998x_remove,
-		.driver = {
-			.name = "tda998x",
-			.of_match_table = of_match_ptr(tda998x_dt_ids),
-		},
-		.id_table = tda998x_ids,
+static struct i2c_driver tda998x_driver = {
+	.probe = tda998x_probe,
+	.remove = tda998x_remove,
+	.driver = {
+		.name = "tda998x",
+		.of_match_table = of_match_ptr(tda998x_dt_ids),
 	},
-	.encoder_init = tda998x_encoder_init,
+	.id_table = tda998x_ids,
 };
 
-/* Module initialization */
-
-static int __init
-tda998x_init(void)
-{
-	DBG("");
-	return drm_i2c_encoder_register(THIS_MODULE, &tda998x_driver);
-}
-
-static void __exit
-tda998x_exit(void)
-{
-	DBG("");
-	drm_i2c_encoder_unregister(&tda998x_driver);
-}
+module_i2c_driver(tda998x_driver);
 
 MODULE_AUTHOR("Rob Clark <robdclark@gmail.com");
 MODULE_DESCRIPTION("NXP Semiconductors TDA998X HDMI Encoder");
 MODULE_LICENSE("GPL");
-
-module_init(tda998x_init);
-module_exit(tda998x_exit);
-- 
1.9.0

