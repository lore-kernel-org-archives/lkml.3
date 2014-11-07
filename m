Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292AbaKGIcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 03:32:14 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50684 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750962AbaKGIcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 03:32:08 -0500
Message-ID: <545C835D.1050008@arm.com>
Date: Fri, 07 Nov 2014 08:31:25 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>, airlied@linux.ie,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "moinejf@free.fr" <moinejf@free.fr>, liviu Dudau <Liviu.Dudau@arm.com>
Subject: [PATCH v2] drm/i2c: tda998x: Set the CEC I2C address based on the
 slave I2C address.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The I2C address for the TDA9989 and TDA19989 is fixed at 0x34
but the two LSBs of the TDA19988's address are set by two configuration
pins on the chip.  Irrespective of the chip, the associated CEC
peripheral's I2C address is based upon the main I2C address.

This patch avoids any special handling required to support
systems that contain multiple TDA19988 devices on the same
I2C bus.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 drivers/gpu/drm/i2c/tda998x_drv.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index d476279..eeab17a 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1255,6 +1255,7 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
 	struct device_node *np = client->dev.of_node;
 	u32 video;
 	int rev_lo, rev_hi, ret;
+	unsigned short cec_addr;
 
 	priv->vip_cntrl_0 = VIP_CNTRL_0_SWAP_A(2) | VIP_CNTRL_0_SWAP_B(3);
 	priv->vip_cntrl_1 = VIP_CNTRL_1_SWAP_C(0) | VIP_CNTRL_1_SWAP_D(1);
@@ -1262,7 +1263,9 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
 
 	priv->current_page = 0xff;
 	priv->hdmi = client;
-	priv->cec = i2c_new_dummy(client->adapter, 0x34);
+	/* CEC I2C address bound to TDA998x I2C addr by configuration pins */
+	cec_addr = 0x34 + (client->addr & 0x03);
+	priv->cec = i2c_new_dummy(client->adapter, cec_addr);
 	if (!priv->cec)
 		return -ENODEV;
 
-- 
1.7.1

