Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab3GHLPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 07:15:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50896 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab3GHLPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 07:15:04 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <tony@atomide.com>, <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <linux@arm.linux.org.uk>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: [PATCH v2 3/4] usb: musb: omap: use the new API to get PHY reference by label
Date: Mon, 8 Jul 2013 16:44:16 +0530
Message-ID: <1373282057-20181-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1373282057-20181-1-git-send-email-kishon@ti.com>
References: <1373282057-20181-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the devices are created using PLATFORM_DEVID_AUTO,
devm_usb_get_phy_dev and usb_get_phy_dev can't be used reliably
as it relies on the device_names passed in usb_bind_phy. So used the
new API devm_usb_get_phy_by_name to get the PHY reference.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Tested-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 drivers/usb/musb/musb_core.c |    1 +
 drivers/usb/musb/musb_core.h |    1 +
 drivers/usb/musb/omap2430.c  |    2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 29a24ce..5eb6cd7 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1814,6 +1814,7 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 	musb->min_power = plat->min_power;
 	musb->ops = plat->platform_ops;
 	musb->port_mode = plat->mode;
+	musb->phy_name = plat->phy_name;
 
 	/* The musb_platform_init() call:
 	 *   - adjusts musb->mregs
diff --git a/drivers/usb/musb/musb_core.h b/drivers/usb/musb/musb_core.h
index 7d341c3..1f0863b 100644
--- a/drivers/usb/musb/musb_core.h
+++ b/drivers/usb/musb/musb_core.h
@@ -424,6 +424,7 @@ struct musb {
 	unsigned                double_buffer_not_ok:1;
 
 	struct musb_hdrc_config	*config;
+	const char		*phy_name;
 
 #ifdef MUSB_CONFIG_PROC_FS
 	struct proc_dir_entry *proc_entry;
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 6708a3b..5b6113a 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -352,7 +352,7 @@ static int omap2430_musb_init(struct musb *musb)
 		musb->xceiv = devm_usb_get_phy_by_phandle(dev->parent,
 		    "usb-phy", 0);
 	else
-		musb->xceiv = devm_usb_get_phy_dev(dev, 0);
+		musb->xceiv = devm_usb_get_phy_by_name(dev, musb->phy_name);
 
 	if (IS_ERR(musb->xceiv)) {
 		status = PTR_ERR(musb->xceiv);
-- 
1.7.10.4

