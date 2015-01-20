Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbbATTnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:43:53 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:22836 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594AbbATTnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:43:51 -0500
X-Mailbox-Line: From ca8037eca1cbbec18d3917e9268735a88d6ff935 Mon Sep 17 00:00:00 2001
Message-Id: <ca8037eca1cbbec18d3917e9268735a88d6ff935.1421782533.git.moinejf@free.fr>
In-Reply-To: <cover.1421782532.git.moinejf@free.fr>
References: <cover.1421782532.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Tue, 20 Jan 2015 12:16:46 +0100
Subject: [PATCH v10 5/9] drm/i2c: tda998x: Change drvdata for audio extension
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
index cf245ce..b35f35f 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1465,6 +1465,8 @@ static int tda998x_encoder_init(struct i2c_client *client,
 	encoder_slave->slave_priv = priv;
 	encoder_slave->slave_funcs = &tda998x_encoder_slave_funcs;
 
+	dev_set_drvdata(&client->dev, priv);
+
 	return 0;
 }
 
@@ -1591,7 +1593,7 @@ static int tda998x_bind(struct device *dev, struct device *master, void *data)
 	if (!priv)
 		return -ENOMEM;
 
-	dev_set_drvdata(dev, priv);
+	dev_set_drvdata(dev, &priv->base);
 
 	priv->base.encoder = &priv->encoder;
 	priv->connector.interlace_allowed = 1;
@@ -1641,7 +1643,9 @@ err_encoder:
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

