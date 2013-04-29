Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446Ab3D2OHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 10:07:24 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:49718 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758188Ab3D2OHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 10:07:23 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: mxs: Use set and clear capabilities of the gpio controller
Date: Mon, 29 Apr 2013 16:07:18 +0200
Message-Id: <1367244438-5322-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current driver doesn't use the set and clear registers found on the
mxs gpio controller.

This leads the generic gpio controller to be using some internal value
to avoid looking up the value stored in the registers, making it behave
pretty much like a cache.

This raises some coherency problem when a gpio is not modified by the
gpio controller, while it can easily be fixed by using the set and clear
registers.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/gpio/gpio-mxs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-mxs.c b/drivers/gpio/gpio-mxs.c
index 25000b0..f8e6af2 100644
--- a/drivers/gpio/gpio-mxs.c
+++ b/drivers/gpio/gpio-mxs.c
@@ -326,7 +326,8 @@ static int mxs_gpio_probe(struct platform_device *pdev)
 
 	err = bgpio_init(&port->bgc, &pdev->dev, 4,
 			 port->base + PINCTRL_DIN(port),
-			 port->base + PINCTRL_DOUT(port), NULL,
+			 port->base + PINCTRL_DOUT(port) + MXS_SET,
+			 port->base + PINCTRL_DOUT(port) + MXS_CLR,
 			 port->base + PINCTRL_DOE(port), NULL, 0);
 	if (err)
 		goto out_irqdesc_free;
-- 
1.8.1.2

