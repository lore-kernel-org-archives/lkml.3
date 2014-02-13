Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbaBMIda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 03:33:30 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:45253 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbaBMId3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 03:33:29 -0500
X-Mailbox-Line: From 6e9c26a067d3ee253ab78d316181cfa44535e041 Mon Sep 17 00:00:00 2001
From: Jean-Francois Moine <moinejf@free.fr>
Date: Thu, 13 Feb 2014 09:13:34 +0100
Subject: [PATCH] drm/i2c: tda998x: fix memory leak in case of i2c error
To: Dave Airlie <airlied@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>
Message-Id: <20140213083316.38D7D822BD@smtp6-g21.free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the creation of the second i2c client was failing, the private
buffer was not freed.

This bug was introduced by the commit 6ae668cc19e8
'drm/i2c: tda998x: check the CEC device creation'

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index fa18cf3..faa77f5 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1151,8 +1151,10 @@ tda998x_encoder_init(struct i2c_client *client,
 
 	priv->current_page = 0xff;
 	priv->cec = i2c_new_dummy(client->adapter, 0x34);
-	if (!priv->cec)
+	if (!priv->cec) {
+		kfree(priv);
 		return -ENODEV;
+	}
 	priv->dpms = DRM_MODE_DPMS_OFF;
 
 	encoder_slave->slave_priv = priv;
-- 
1.9.0.rc3

