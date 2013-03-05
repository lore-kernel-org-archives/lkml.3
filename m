Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab3CEOWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 09:22:50 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33029 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580Ab3CEOWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 09:22:36 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <s-guiriec@ti.com>, <gg@slimlogic.co.uk>, <sameo@linux.intel.com>,
        <broonie@opensource.wolfsonmicro.com>, <ldewangan@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH 2/4] usb: dwc3: dwc3-omap: return -EPROBE_DEFER if probe has not yet executed
Date: Tue, 5 Mar 2013 19:51:58 +0530
Message-ID: <1362493320-13913-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362493320-13913-1-git-send-email-kishon@ti.com>
References: <1362493320-13913-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

return -EPROBE_DEFER from dwc3_omap_mailbox in dwc3-omap.c, if the probe of
dwc3-omap has not yet been executed or failed.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/dwc3/dwc3-omap.c  |    7 +++++--
 include/linux/usb/dwc3-omap.h |    6 +++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 19c6e72..9428f4e 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -138,11 +138,14 @@ static inline void dwc3_omap_writel(void __iomem *base, u32 offset, u32 value)
 	writel(value, base + offset);
 }
 
-void dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
+int dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
 {
 	u32			val;
 	struct dwc3_omap	*omap = _omap;
 
+	if (!omap)
+		return -EPROBE_DEFER;
+
 	switch (status) {
 	case OMAP_DWC3_ID_GROUND:
 		dev_dbg(omap->dev, "ID GND\n");
@@ -185,7 +188,7 @@ void dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
 		dev_dbg(omap->dev, "ID float\n");
 	}
 
-	return;
+	return IRQ_HANDLED;
 }
 EXPORT_SYMBOL_GPL(dwc3_omap_mailbox);
 
diff --git a/include/linux/usb/dwc3-omap.h b/include/linux/usb/dwc3-omap.h
index 51eae14..5615f4d 100644
--- a/include/linux/usb/dwc3-omap.h
+++ b/include/linux/usb/dwc3-omap.h
@@ -19,11 +19,11 @@ enum omap_dwc3_vbus_id_status {
 };
 
 #if (defined(CONFIG_USB_DWC3) || defined(CONFIG_USB_DWC3_MODULE))
-extern void dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status);
+extern int dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status);
 #else
-static inline void dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
+static inline int dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
 {
-	return;
+	return -ENODEV;
 }
 #endif
 
-- 
1.7.10.4

