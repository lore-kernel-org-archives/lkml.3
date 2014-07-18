Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965943AbaGRNay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:30:54 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17830 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161114AbaGRNPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:15:38 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Felipe Balbi <balbi@ti.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 068/170] usb: musb: ux500: don't propagate the OF node
Date: Fri, 18 Jul 2014 14:11:13 +0200
Message-Id: <52b2230ba2b957ab4a995f13cd7cd40310610755.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 82363cf2eeafeea6ba88849f5e2febdc8a05943f upstream.

There is a regression in the upcoming v3.16-rc1, that is caused
by a problem that has been around for a while but now finally
hangs the system. The bootcrawl looks like this:

pinctrl-nomadik soc:pinctrl: pin GPIO256_AF28 already
requested by a03e0000.usb_per5; cannot claim for musb-hdrc.0.auto
pinctrl-nomadik soc:pinctrl: pin-256 (musb-hdrc.0.auto) status -22
pinctrl-nomadik soc:pinctrl: could not request pin 256
(GPIO256_AF28) from group usb_a_1  on device pinctrl-nomadik
musb-hdrc musb-hdrc.0.auto: Error applying setting, reverse
things back
HS USB OTG: no transceiver configured
musb-hdrc musb-hdrc.0.auto: musb_init_controller failed
with status -517
platform musb-hdrc.0.auto: Driver musb-hdrc requests
probe deferral
(...)

The ux500 MUSB driver propagates the OF node to the dynamically
created musb-hdrc device, which is incorrect as it makes the OF
core believe there are two devices spun from the very same
DT node, which confuses other parts of the device core, notably
the pin control subsystem, which will try to apply all the pin
control settings also to the HDRC device as it gets
instantiated. (The OMAP2430 for example, does not set the
of_node member.)

Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/musb/ux500.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
index 59256b12f746..8264256271f8 100644
--- a/drivers/usb/musb/ux500.c
+++ b/drivers/usb/musb/ux500.c
@@ -275,7 +275,6 @@ static int ux500_probe(struct platform_device *pdev)
 	musb->dev.parent		= &pdev->dev;
 	musb->dev.dma_mask		= &pdev->dev.coherent_dma_mask;
 	musb->dev.coherent_dma_mask	= pdev->dev.coherent_dma_mask;
-	musb->dev.of_node		= pdev->dev.of_node;
 
 	glue->dev			= &pdev->dev;
 	glue->musb			= musb;
-- 
2.0.0

