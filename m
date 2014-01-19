Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaASS7y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 13:59:54 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:55404 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbaASS7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 13:59:51 -0500
Date: Sun, 19 Jan 2014 19:58:38 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v3 02/24] drm/i2c: tda998x: check more I/O errors
Message-ID: <20140119195838.348f8d6d@armhf>
In-Reply-To: <cover.1390153344.git.moinejf@free.fr>
References: <cover.1390153344.git.moinejf@free.fr>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds more error checking inn I2C I/O functions.
In case of I/O error, this permits to avoid writing in bad controller
pages, a bad chipset detection or looping when getting the EDID.

Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 57 +++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 26dd299..11f0607 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -362,7 +362,7 @@ fail:
 	return 0;
 }
 
-static void
+static int
 set_page(struct tda998x_priv *priv, uint16_t reg)
 {
 	if (REG2PAGE(reg) != priv->current_page) {
@@ -371,11 +371,14 @@ set_page(struct tda998x_priv *priv, uint16_t reg)
 				REG_CURPAGE, REG2PAGE(reg)
 		};
 		int ret = i2c_master_send(client, buf, sizeof(buf));
-		if (ret < 0)
+		if (ret < 0) {
 			dev_err(&client->dev, "Error %d writing to REG_CURPAGE\n", ret);
+			return ret;
+		}
 
 		priv->current_page = REG2PAGE(reg);
 	}
+	return 0;
 }
 
 static int
@@ -385,7 +388,9 @@ reg_read_range(struct tda998x_priv *priv, uint16_t reg, char *buf, int cnt)
 	uint8_t addr = REG2ADDR(reg);
 	int ret;
 
-	set_page(priv, reg);
+	ret = set_page(priv, reg);
+	if (ret < 0)
+		return ret;
 
 	ret = i2c_master_send(client, &addr, sizeof(addr));
 	if (ret < 0)
@@ -412,18 +417,24 @@ reg_write_range(struct tda998x_priv *priv, uint16_t reg, uint8_t *p, int cnt)
 	buf[0] = REG2ADDR(reg);
 	memcpy(&buf[1], p, cnt);
 
-	set_page(priv, reg);
+	ret = set_page(priv, reg);
+	if (ret < 0)
+		return;
 
 	ret = i2c_master_send(client, buf, cnt + 1);
 	if (ret < 0)
 		dev_err(&client->dev, "Error %d writing to 0x%x\n", ret, reg);
 }
 
-static uint8_t
+static int
 reg_read(struct tda998x_priv *priv, uint16_t reg)
 {
 	uint8_t val = 0;
-	reg_read_range(priv, reg, &val, sizeof(val));
+	int ret;
+
+	ret = reg_read_range(priv, reg, &val, sizeof(val));
+	if (ret < 0)
+		return ret;
 	return val;
 }
 
@@ -434,7 +445,9 @@ reg_write(struct tda998x_priv *priv, uint16_t reg, uint8_t val)
 	uint8_t buf[] = {REG2ADDR(reg), val};
 	int ret;
 
-	set_page(priv, reg);
+	ret = set_page(priv, reg);
+	if (ret < 0)
+		return;
 
 	ret = i2c_master_send(client, buf, ARRAY_SIZE(buf));
 	if (ret < 0)
@@ -448,7 +461,9 @@ reg_write16(struct tda998x_priv *priv, uint16_t reg, uint16_t val)
 	uint8_t buf[] = {REG2ADDR(reg), val >> 8, val};
 	int ret;
 
-	set_page(priv, reg);
+	ret = set_page(priv, reg);
+	if (ret < 0)
+		return;
 
 	ret = i2c_master_send(client, buf, ARRAY_SIZE(buf));
 	if (ret < 0)
@@ -458,13 +473,21 @@ reg_write16(struct tda998x_priv *priv, uint16_t reg, uint16_t val)
 static void
 reg_set(struct tda998x_priv *priv, uint16_t reg, uint8_t val)
 {
-	reg_write(priv, reg, reg_read(priv, reg) | val);
+	int old_val;
+
+	old_val = reg_read(priv, reg);
+	if (old_val >= 0)
+		reg_write(priv, reg, old_val | val);
 }
 
 static void
 reg_clear(struct tda998x_priv *priv, uint16_t reg, uint8_t val)
 {
-	reg_write(priv, reg, reg_read(priv, reg) & ~val);
+	int old_val;
+
+	old_val = reg_read(priv, reg);
+	if (old_val >= 0)
+		reg_write(priv, reg, old_val & ~val);
 }
 
 static void
@@ -970,8 +993,10 @@ read_edid_block(struct drm_encoder *encoder, uint8_t *buf, int blk)
 
 	/* wait for block read to complete: */
 	for (i = 100; i > 0; i--) {
-		uint8_t val = reg_read(priv, REG_INT_FLAGS_2);
-		if (val & INT_FLAGS_2_EDID_BLK_RD)
+		ret = reg_read(priv, REG_INT_FLAGS_2);
+		if (ret < 0)
+			return ret;
+		if (ret & INT_FLAGS_2_EDID_BLK_RD)
 			break;
 		msleep(1);
 	}
@@ -1134,6 +1159,7 @@ tda998x_encoder_init(struct i2c_client *client,
 		    struct drm_encoder_slave *encoder_slave)
 {
 	struct tda998x_priv *priv;
+	int ret;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -1158,8 +1184,11 @@ tda998x_encoder_init(struct i2c_client *client,
 	tda998x_reset(priv);
 
 	/* read version: */
-	priv->rev = reg_read(priv, REG_VERSION_LSB) |
-			reg_read(priv, REG_VERSION_MSB) << 8;
+	ret = reg_read(priv, REG_VERSION_LSB) |
+		(reg_read(priv, REG_VERSION_MSB) << 8);
+	if (ret < 0)
+		goto fail;
+	priv->rev = ret;
 
 	/* mask off feature bits: */
 	priv->rev &= ~0x30; /* not-hdcp and not-scalar bit */
-- 
1.8.5.3

