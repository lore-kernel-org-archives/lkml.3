Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab3I0G1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 02:27:41 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38413 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab3I0GZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 02:25:27 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <swarren@wwwdotorg.org>,
        <bcousson@baylibre.com>, <tony@atomide.com>, <kishon@ti.com>,
        <balbi@ti.com>, <s.nawrocki@samsung.com>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <jkosina@suse.cz>, <m.chehab@samsung.com>,
        <cesarb@cesarb.net>, <joe@perches.com>, <davem@davemloft.net>,
        <davidb@codeaurora.org>, <sameo@linux.intel.com>,
        <peter.ujfalusi@ti.com>, <t-kristo@ti.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <akpm@linux-foundation.org>, <balajitk@ti.com>,
        <george.cherian@ti.com>, <nsekhar@ti.com>, <rogerq@ti.com>
Subject: [PATCH v12 6/7] usb: musb: omap2430: use the new generic PHY framework
Date: Fri, 27 Sep 2013 11:53:30 +0530
Message-ID: <1380263012-9687-7-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1380263012-9687-1-git-send-email-kishon@ti.com>
References: <1380263012-9687-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic PHY framework API to get the PHY. The usb_phy_set_resume
and usb_phy_set_suspend is replaced with power_on and
power_off to align with the new PHY framework.

musb->xceiv can't be removed as of now because musb core uses xceiv.state and
xceiv.otg. Once there is a separate state machine to handle otg, these can be
moved out of xceiv and then we can start using the generic PHY framework.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/musb/Kconfig     |    1 +
 drivers/usb/musb/musb_core.h |    2 ++
 drivers/usb/musb/omap2430.c  |   26 ++++++++++++++++++++------
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index c258a97..0440e28 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -75,6 +75,7 @@ config USB_MUSB_TUSB6010
 config USB_MUSB_OMAP2PLUS
 	tristate "OMAP2430 and onwards"
 	depends on ARCH_OMAP2PLUS
+	select GENERIC_PHY
 
 config USB_MUSB_AM35X
 	tristate "AM35x"
diff --git a/drivers/usb/musb/musb_core.h b/drivers/usb/musb/musb_core.h
index 65f3917..d408a99 100644
--- a/drivers/usb/musb/musb_core.h
+++ b/drivers/usb/musb/musb_core.h
@@ -46,6 +46,7 @@
 #include <linux/usb.h>
 #include <linux/usb/otg.h>
 #include <linux/usb/musb.h>
+#include <linux/phy/phy.h>
 
 struct musb;
 struct musb_hw_ep;
@@ -341,6 +342,7 @@ struct musb {
 	u16			int_tx;
 
 	struct usb_phy		*xceiv;
+	struct phy		*phy;
 
 	int nIrq;
 	unsigned		irq_wake:1;
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 59d2245..d0fc4d9 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -348,11 +348,21 @@ static int omap2430_musb_init(struct musb *musb)
 	 * up through ULPI.  TWL4030-family PMICs include one,
 	 * which needs a driver, drivers aren't always needed.
 	 */
-	if (dev->parent->of_node)
+	if (dev->parent->of_node) {
+		musb->phy = devm_phy_get(dev->parent, "usb2-phy");
+
+		/* We can't totally remove musb->xceiv as of now because
+		 * musb core uses xceiv.state and xceiv.otg. Once we have
+		 * a separate state machine to handle otg, these can be moved
+		 * out of xceiv and then we can start using the generic PHY
+		 * framework
+		 */
 		musb->xceiv = devm_usb_get_phy_by_phandle(dev->parent,
 		    "usb-phy", 0);
-	else
+	} else {
 		musb->xceiv = devm_usb_get_phy_dev(dev, 0);
+		musb->phy = devm_phy_get(dev, "usb");
+	}
 
 	if (IS_ERR(musb->xceiv)) {
 		status = PTR_ERR(musb->xceiv);
@@ -364,6 +374,10 @@ static int omap2430_musb_init(struct musb *musb)
 		return -EPROBE_DEFER;
 	}
 
+	if (IS_ERR(musb->phy)) {
+		pr_err("HS USB OTG: no PHY configured\n");
+		return PTR_ERR(musb->phy);
+	}
 	musb->isr = omap2430_musb_interrupt;
 
 	status = pm_runtime_get_sync(dev);
@@ -397,7 +411,7 @@ static int omap2430_musb_init(struct musb *musb)
 	if (glue->status != OMAP_MUSB_UNKNOWN)
 		omap_musb_set_mailbox(glue);
 
-	usb_phy_init(musb->xceiv);
+	phy_init(musb->phy);
 
 	pm_runtime_put_noidle(musb->controller);
 	return 0;
@@ -460,6 +474,7 @@ static int omap2430_musb_exit(struct musb *musb)
 	del_timer_sync(&musb_idle_timer);
 
 	omap2430_low_level_exit(musb);
+	phy_exit(musb->phy);
 
 	return 0;
 }
@@ -638,7 +653,7 @@ static int omap2430_runtime_suspend(struct device *dev)
 				OTG_INTERFSEL);
 
 		omap2430_low_level_exit(musb);
-		usb_phy_set_suspend(musb->xceiv, 1);
+		phy_power_off(musb->phy);
 	}
 
 	return 0;
@@ -653,8 +668,7 @@ static int omap2430_runtime_resume(struct device *dev)
 		omap2430_low_level_init(musb);
 		musb_writel(musb->mregs, OTG_INTERFSEL,
 				musb->context.otg_interfsel);
-
-		usb_phy_set_suspend(musb->xceiv, 0);
+		phy_power_on(musb->phy);
 	}
 
 	return 0;
-- 
1.7.10.4

