Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbaGHAiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:38:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbaGGXyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.14 11/94] usb: musb: ux500: dont propagate the OF node
Date: Mon,  7 Jul 2014 16:57:01 -0700
Message-Id: <20140707235757.108545948@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/ux500.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/musb/ux500.c
+++ b/drivers/usb/musb/ux500.c
@@ -274,7 +274,6 @@ static int ux500_probe(struct platform_d
 	musb->dev.parent		= &pdev->dev;
 	musb->dev.dma_mask		= &pdev->dev.coherent_dma_mask;
 	musb->dev.coherent_dma_mask	= pdev->dev.coherent_dma_mask;
-	musb->dev.of_node		= pdev->dev.of_node;
 
 	glue->dev			= &pdev->dev;
 	glue->musb			= musb;


