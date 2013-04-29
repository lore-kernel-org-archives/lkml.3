Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab3D2KEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 06:04:31 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35069 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757487Ab3D2KE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 06:04:29 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <kishon@ti.com>, <arnd@arndb.de>, <swarren@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <sylvester.nawrocki@gmail.com>
CC: <rob.herring@calxeda.com>, <rob@landley.net>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <benoit.cousson@linaro.org>, <mchehab@redhat.com>,
        <akpm@linux-foundation.org>, <cesarb@cesarb.net>,
        <davem@davemloft.net>, <rnayak@ti.com>, <shawn.guo@linaro.org>,
        <santosh.shilimkar@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <nsekhar@ti.com>
Subject: [PATCH v6 7/9] usb: musb: omap2430: use the new generic PHY framework
Date: Mon, 29 Apr 2013 15:33:30 +0530
Message-ID: <1367229812-30574-8-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367229812-30574-1-git-send-email-kishon@ti.com>
References: <1367229812-30574-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic PHY framework API to get the PHY. The usb_phy_set_resume
and usb_phy_set_suspend is replaced with power_on/get_sync and
power_off/put_sync to align with the new PHY framework.

musb->xceiv can't be removed as of now because musb core uses xceiv.state and
xceiv.otg. Once there is a separate state machine to handle otg, these can be
moved out of xceiv and then we can start using the generic PHY framework.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/musb/musb_core.c |    1 +
 drivers/usb/musb/musb_core.h |    3 +++
 drivers/usb/musb/omap2430.c  |   29 +++++++++++++++++++++--------
 3 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 37a261a..2162148 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1864,6 +1864,7 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 	musb->board_set_power = plat->set_power;
 	musb->min_power = plat->min_power;
 	musb->ops = plat->platform_ops;
+	musb->phy_dev_name = plat->phy_dev_name;
 
 	/* The musb_platform_init() call:
 	 *   - adjusts musb->mregs
diff --git a/drivers/usb/musb/musb_core.h b/drivers/usb/musb/musb_core.h
index 7fb4819..09ac74c 100644
--- a/drivers/usb/musb/musb_core.h
+++ b/drivers/usb/musb/musb_core.h
@@ -46,6 +46,7 @@
 #include <linux/usb.h>
 #include <linux/usb/otg.h>
 #include <linux/usb/musb.h>
+#include <linux/phy/phy.h>
 
 struct musb;
 struct musb_hw_ep;
@@ -357,6 +358,7 @@ struct musb {
 	u16			int_tx;
 
 	struct usb_phy		*xceiv;
+	struct phy		*phy;
 
 	int nIrq;
 	unsigned		irq_wake:1;
@@ -434,6 +436,7 @@ struct musb {
 	unsigned                double_buffer_not_ok:1;
 
 	struct musb_hdrc_config	*config;
+	const char		*phy_dev_name;
 
 #ifdef MUSB_CONFIG_PROC_FS
 	struct proc_dir_entry *proc_entry;
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 3551f1a..56ffe5f 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -348,14 +348,24 @@ static int omap2430_musb_init(struct musb *musb)
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
+		musb->phy = devm_phy_get(dev, musb->phy_dev_name);
+	}
 
-	if (IS_ERR(musb->xceiv)) {
-		status = PTR_ERR(musb->xceiv);
+	if (IS_ERR(musb->xceiv) || IS_ERR(musb->phy)) {
+		status = PTR_ERR(musb->xceiv) | PTR_ERR(musb->phy);
 
 		if (status == -ENXIO)
 			return status;
@@ -397,9 +407,10 @@ static int omap2430_musb_init(struct musb *musb)
 	if (glue->status != OMAP_MUSB_UNKNOWN)
 		omap_musb_set_mailbox(glue);
 
-	usb_phy_init(musb->xceiv);
+	phy_init(musb->phy);
 
 	pm_runtime_put_noidle(musb->controller);
+	phy_pm_runtime_put(musb->phy);
 	return 0;
 
 err1:
@@ -460,6 +471,7 @@ static int omap2430_musb_exit(struct musb *musb)
 	del_timer_sync(&musb_idle_timer);
 
 	omap2430_low_level_exit(musb);
+	phy_exit(musb->phy);
 
 	return 0;
 }
@@ -618,7 +630,8 @@ static int omap2430_runtime_suspend(struct device *dev)
 				OTG_INTERFSEL);
 
 		omap2430_low_level_exit(musb);
-		usb_phy_set_suspend(musb->xceiv, 1);
+		phy_power_off(musb->phy);
+		phy_pm_runtime_put(musb->phy);
 	}
 
 	return 0;
@@ -633,8 +646,8 @@ static int omap2430_runtime_resume(struct device *dev)
 		omap2430_low_level_init(musb);
 		musb_writel(musb->mregs, OTG_INTERFSEL,
 				musb->context.otg_interfsel);
-
-		usb_phy_set_suspend(musb->xceiv, 0);
+		phy_pm_runtime_get_sync(musb->phy);
+		phy_power_on(musb->phy);
 	}
 
 	return 0;
-- 
1.7.10.4

