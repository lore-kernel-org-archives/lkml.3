Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab3HEWU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:20:29 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:52819 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab3HEWU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:20:27 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        David Airlie <airlied@linux.ie>, Darren Etheridge <detheridge@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] drm/i2c: tda998x: fix EDID reading on TDA19988 devices
Date: Tue,  6 Aug 2013 00:20:11 +0200
Message-Id: <1375741218-10225-2-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375741218-10225-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1375741218-10225-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+kernel@arm.linux.org.uk>

TDA19988 devices need their RAM enabled in order to read EDID
information.  Add support for this.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
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

