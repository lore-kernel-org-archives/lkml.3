Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068Ab3HNTqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:46:40 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:59756 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760178Ab3HNTnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:43:40 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        David Airlie <airlied@linux.ie>, Darren Etheridge <detheridge@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/8] drm/i2c: tda998x: ensure VIP output mux is properly set
Date: Wed, 14 Aug 2013 21:43:27 +0200
Message-Id: <1376509413-1462-3-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376509413-1462-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376509413-1462-1-git-send-email-sebastian.hesselbarth@gmail.com>
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
Tested-by: Darren Etheridge <detheridge@ti.com>
Tested-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v1->v2:
- move reg_write to tda998x_reset as last patch was based on an
  old version (Reported by Russell King)

Cc: David Airlie <airlied@linux.ie>
Cc: Darren Etheridge <detheridge@ti.com>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/gpu/drm/i2c/tda998x_drv.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index d71c408..cb9b13a 100644
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
@@ -415,6 +416,9 @@ tda998x_reset(struct drm_encoder *encoder)
 	reg_write(encoder, REG_PLL_SCGR1,    0x5b);
 	reg_write(encoder, REG_PLL_SCGR2,    0x00);
 	reg_write(encoder, REG_PLL_SCG2,     0x10);
+
+	/* Write the default value MUX register */
+	reg_write(encoder, REG_MUX_VP_VIP_OUT, 0x24);
 }
 
 /* DRM encoder functions */
-- 
1.7.10.4

