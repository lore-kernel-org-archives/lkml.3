Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275Ab3HNTnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:43:41 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:64386 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760140Ab3HNTnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:43:40 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Rob Clark <robdclark@gmail.com>, David Airlie <airlied@linux.ie>,
        Darren Etheridge <detheridge@ti.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/8] drm/i2c: tda998x: fix EDID reading on TDA19988 devices
Date: Wed, 14 Aug 2013 21:43:26 +0200
Message-Id: <1376509413-1462-2-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376509413-1462-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376509413-1462-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+kernel@arm.linux.org.uk>

TDA19988 devices need their RAM enabled in order to read EDID
information.  Add support for this.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Rob Clark <robdclark@gmail.com>
Tested-by: Darren Etheridge <detheridge@ti.com>
Tested-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: David Airlie <airlied@linux.ie>
Cc: Darren Etheridge <detheridge@ti.com>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/gpu/drm/i2c/tda998x_drv.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index e68b58a..d71c408 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -229,6 +229,8 @@ struct tda998x_priv {
 
 /* Page 12h: HDCP and OTP */
 #define REG_TX3                   REG(0x12, 0x9a)     /* read/write */
+#define REG_TX4                   REG(0x12, 0x9b)     /* read/write */
+# define TX4_PD_RAM               (1 << 1)
 #define REG_TX33                  REG(0x12, 0xb8)     /* read/write */
 # define TX33_HDMI                (1 << 1)
 
@@ -673,6 +675,7 @@ read_edid_block(struct drm_encoder *encoder, uint8_t *buf, int blk)
 static uint8_t *
 do_get_edid(struct drm_encoder *encoder)
 {
+	struct tda998x_priv *priv = to_tda998x_priv(encoder);
 	int j = 0, valid_extensions = 0;
 	uint8_t *block, *new;
 	bool print_bad_edid = drm_debug & DRM_UT_KMS;
@@ -680,6 +683,9 @@ do_get_edid(struct drm_encoder *encoder)
 	if ((block = kmalloc(EDID_LENGTH, GFP_KERNEL)) == NULL)
 		return NULL;
 
+	if (priv->rev == TDA19988)
+		reg_clear(encoder, REG_TX4, TX4_PD_RAM);
+
 	/* base block fetch */
 	if (read_edid_block(encoder, block, 0))
 		goto fail;
@@ -689,7 +695,7 @@ do_get_edid(struct drm_encoder *encoder)
 
 	/* if there's no extensions, we're done */
 	if (block[0x7e] == 0)
-		return block;
+		goto done;
 
 	new = krealloc(block, (block[0x7e] + 1) * EDID_LENGTH, GFP_KERNEL);
 	if (!new)
@@ -716,9 +722,15 @@ do_get_edid(struct drm_encoder *encoder)
 		block = new;
 	}
 
+done:
+	if (priv->rev == TDA19988)
+		reg_set(encoder, REG_TX4, TX4_PD_RAM);
+
 	return block;
 
 fail:
+	if (priv->rev == TDA19988)
+		reg_set(encoder, REG_TX4, TX4_PD_RAM);
 	dev_warn(encoder->dev->dev, "failed to read EDID\n");
 	kfree(block);
 	return NULL;
-- 
1.7.10.4

