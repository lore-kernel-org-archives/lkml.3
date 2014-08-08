Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759816AbaHHWgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:36:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40073 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbaHHUlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>,
        Felipe Balbi <balbi@ti.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 020/259] usb: musb: ux500: don't propagate the OF node
Date: Fri,  8 Aug 2014 13:37:23 -0700
Message-Id: <1407530482-4483-21-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/musb/ux500.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
index 122446b..ebef58d 100644
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

