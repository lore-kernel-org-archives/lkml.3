Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbaFSBwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 21:52:24 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:51158 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbaFSBwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 21:52:22 -0400
From: Michael Welling <mwelling@ieee.org>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Michael Welling <mwelling@ieee.org>
Subject: [PATCH] drivers:video:fbdev atmel_lcdfb.c power GPIO registration bug
Date: Wed, 18 Jun 2014 20:52:12 -0500
Message-Id: <1403142732-31706-1-git-send-email-mwelling@ieee.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A list that was intended for storing power control GPIOs was never
initialized correctly or filled. Without these lines of added code
the kernel hangs when trying to access an uninitialized list when a
power control GPIO is registered with the device tree.

Signed-off-by: Michael Welling <mwelling@ieee.org>
---
 drivers/video/fbdev/atmel_lcdfb.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/fbdev/atmel_lcdfb.c b/drivers/video/fbdev/atmel_lcdfb.c
index e683b6e..d36e830 100644
--- a/drivers/video/fbdev/atmel_lcdfb.c
+++ b/drivers/video/fbdev/atmel_lcdfb.c
@@ -1057,6 +1057,7 @@ static int atmel_lcdfb_of_init(struct atmel_lcdfb_info *sinfo)
 		goto put_display_node;
 	}
 
+	INIT_LIST_HEAD(&pdata->pwr_gpios);
 	ret = -ENOMEM;
 	for (i = 0; i < of_gpio_named_count(display_np, "atmel,power-control-gpio"); i++) {
 		gpio = of_get_named_gpio_flags(display_np, "atmel,power-control-gpio",
@@ -1082,6 +1083,7 @@ static int atmel_lcdfb_of_init(struct atmel_lcdfb_info *sinfo)
 			dev_err(dev, "set direction output gpio %d failed\n", gpio);
 			goto put_display_node;
 		}
+		list_add(&og->list, &pdata->pwr_gpios);
 	}
 
 	if (is_gpio_power)
-- 
1.7.9.5

