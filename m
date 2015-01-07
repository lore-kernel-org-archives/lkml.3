Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbbAGLwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:52:33 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:6517 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbbAGLwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:52:31 -0500
X-Mailbox-Line: From f682ee5ef933fd71d7e9ecaa503dff20304c1d75 Mon Sep 17 00:00:00 2001
Message-Id: <f682ee5ef933fd71d7e9ecaa503dff20304c1d75.1420628786.git.moinejf@free.fr>
In-Reply-To: <cover.1420628786.git.moinejf@free.fr>
References: <cover.1420628786.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Wed, 7 Jan 2015 11:00:50 +0100
Subject: [PATCH v9 2/4] drm/i2c: tda998x: Change drvdata for audio extension
To: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dave Airlie <airlied@gmail.com>, Andrew Jackson <Andrew.Jackson@arm.com>,
        Jyri Sarha <jsarha@ti.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device drvdata is used for component bind, but points to the
encoder/connector structure which is hidden from the slave encoder.
For audio extension, the slave encoder private data must be accessible,
so, this patch changes drvdata to the slave encoder private data and
sets it in case of slave encoder use.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 9d9b072..ce1478d 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1437,6 +1437,8 @@ static int tda998x_encoder_init(struct i2c_client *client,
 	encoder_slave->slave_priv = priv;
 	encoder_slave->slave_funcs = &tda998x_encoder_slave_funcs;
 
+	dev_set_drvdata(&client->dev, priv);
+
 	return 0;
 }
 
@@ -1563,7 +1565,7 @@ static int tda998x_bind(struct device *dev, struct device *master, void *data)
 	if (!priv)
 		return -ENOMEM;
 
-	dev_set_drvdata(dev, priv);
+	dev_set_drvdata(dev, &priv->base);
 
 	priv->base.encoder = &priv->encoder;
 	priv->connector.interlace_allowed = 1;
@@ -1613,7 +1615,9 @@ err_encoder:
 static void tda998x_unbind(struct device *dev, struct device *master,
 			   void *data)
 {
-	struct tda998x_priv2 *priv = dev_get_drvdata(dev);
+	struct tda998x_priv *priv_s = dev_get_drvdata(dev);
+	struct tda998x_priv2 *priv =
+			container_of(priv_s, struct tda998x_priv2, base);
 
 	drm_connector_cleanup(&priv->connector);
 	drm_encoder_cleanup(&priv->encoder);
-- 
2.1.4

