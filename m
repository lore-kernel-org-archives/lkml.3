Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbaAYRQZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 12:16:25 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:47722 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbaAYRQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 12:16:23 -0500
Date: Sat, 25 Jan 2014 18:14:38 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v4 14/24] drm/i2c: tda998x: always enable EDID read IRQ
Message-ID: <20140125181438.70217759@armhf>
In-Reply-To: <cover.1390646891.git.moinejf@free.fr>
References: <cover.1390646891.git.moinejf@free.fr>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to enable/disable EDID read IRQ at each EDID block
read. This patch enables the IRQ at init time.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 0231e44..967f9ce 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -977,9 +977,6 @@ read_edid_block(struct drm_encoder *encoder, uint8_t *buf, int blk)
 	uint8_t offset, segptr;
 	int ret, i;
 
-	/* enable EDID read irq: */
-	reg_set(priv, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
-
 	offset = (blk & 1) ? 128 : 0;
 	segptr = blk / 2;
 
@@ -1014,8 +1011,6 @@ read_edid_block(struct drm_encoder *encoder, uint8_t *buf, int blk)
 		return ret;
 	}
 
-	reg_clear(priv, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
-
 	return 0;
 }
 
@@ -1234,6 +1229,9 @@ tda998x_encoder_init(struct i2c_client *client,
 	cec_write(priv, REG_CEC_FRO_IM_CLK_CTRL,
 			CEC_FRO_IM_CLK_CTRL_GHOST_DIS | CEC_FRO_IM_CLK_CTRL_IMCLK_SEL);
 
+	/* enable EDID read irq: */
+	reg_set(priv, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
+
 	if (!np)
 		return 0;		/* non-DT */
 
-- 
1.8.5.3

