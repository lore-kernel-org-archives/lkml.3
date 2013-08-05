Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab3HEWUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:20:33 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:44482 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab3HEWU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:20:28 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        David Airlie <airlied@linux.ie>, Darren Etheridge <detheridge@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] drm/i2c: tda998x: ensure VIP output mux is properly set
Date: Tue,  6 Aug 2013 00:20:12 +0200
Message-Id: <1375741218-10225-3-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375741218-10225-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1375741218-10225-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+kernel@arm.linux.org.uk>

When switching between various drivers for this device, it's possible
that some critical registers are left containing values which affect
the device operation.  One such case encountered is the VIP output
mux register.  This defaults to 0x24 on powerup, but other drivers may
set this to 0x12.  This results in incorrect colours.

Fix this by ensuring that the register is always set to the power on
default setting.

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
 drivers/gpu/drm/i2c/tda998x_drv.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index d71c408..4b4db95 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -110,6 +110,7 @@ struct tda998x_priv {
 #define REG_VIP_CNTRL_5           REG(0x00, 0x25)     /* write */
 # define VIP_CNTRL_5_CKCASE       (1 << 0)
 # define VIP_CNTRL_5_SP_CNT(x)    (((x) & 3) << 1)
+#define REG_MUX_VP_VIP_OUT        REG(0x00, 0x27)     /* read/write */
 #define REG_MAT_CONTRL            REG(0x00, 0x80)     /* write */
 # define MAT_CONTRL_MAT_SC(x)     (((x) & 3) << 0)
 # define MAT_CONTRL_MAT_BP        (1 << 2)
@@ -438,6 +439,8 @@ tda998x_encoder_dpms(struct drm_encoder *encoder, int mode)
 
 	switch (mode) {
 	case DRM_MODE_DPMS_ON:
+		/* Write the default value MUX register */
+		reg_write(encoder, REG_MUX_VP_VIP_OUT, 0x24);
 		/* enable audio and video ports */
 		reg_write(encoder, REG_ENA_AP, 0xff);
 		reg_write(encoder, REG_ENA_VP_0, 0xff);
-- 
1.7.10.4

