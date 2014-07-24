Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934719AbaGXKMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:12:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54846 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934421AbaGXJrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>,
        Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 054/128] usb: musb: ux500: don't propagate the OF node
Date: Thu, 24 Jul 2014 10:45:03 +0100
Message-Id: <1406195177-8656-55-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/musb/ux500.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
index fce71b605936..027a35b003d9 100644
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
1.9.1

