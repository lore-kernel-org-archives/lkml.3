Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab3KYKCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:02:52 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56948 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab3KYKCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:02:45 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <bcousson@baylibre.com>, <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <rob@landley.net>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <kishon@ti.com>, <gregkh@linuxfoundation.org>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>
Subject: [PATCH v3 04/10] usb: dwc3: use quirks to know if a particualr platform doesn't have PHY
Date: Mon, 25 Nov 2013 15:31:24 +0530
Message-ID: <1385373690-12170-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1385373690-12170-1-git-send-email-kishon@ti.com>
References: <1385373690-12170-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There can be systems which does not have an external phy, so get
phy only if no quirks are added that indicates the PHY is not present.
Introduced two quirk flags to indicate the *absence* of usb2 phy and
usb3 phy. Also remove checking if return value is -ENXIO since it's now
changed to always enable usb_phy layer.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/dwc3/Kconfig         |    1 +
 drivers/usb/dwc3/core.c          |   93 ++++++++++++++++++++------------------
 drivers/usb/dwc3/core.h          |   15 ++++++
 drivers/usb/dwc3/platform_data.h |    5 ++
 4 files changed, 69 insertions(+), 45 deletions(-)

diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index 70fc430..8e385b4 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -1,6 +1,7 @@
 config USB_DWC3
 	tristate "DesignWare USB3 DRD Core Support"
 	depends on (USB || USB_GADGET) && HAS_DMA
+	select USB_PHY
 	select USB_XHCI_PLATFORM if USB_SUPPORT && USB_XHCI_HCD
 	help
 	  Say Y or M here if your system has a Dual Role SuperSpeed
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 986674f..f20f4a1 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -32,6 +32,7 @@
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
@@ -351,13 +352,28 @@ static void dwc3_core_exit(struct dwc3 *dwc)
 
 #define DWC3_ALIGN_MASK		(16 - 1)
 
+#ifdef CONFIG_OF
+static const struct of_device_id of_dwc3_match[] = {
+	{
+		.compatible = "snps,dwc3"
+	},
+	{
+		.compatible = "synopsys,dwc3"
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, of_dwc3_match);
+#endif
+
 static int dwc3_probe(struct platform_device *pdev)
 {
 	struct device		*dev = &pdev->dev;
 	struct dwc3_platform_data *pdata = dev_get_platdata(dev);
 	struct device_node	*node = dev->of_node;
+	const struct of_device_id *of_id;
 	struct resource		*res;
 	struct dwc3		*dwc;
+	struct dwc3_data	*dwc_data;
 
 	int			ret = -ENOMEM;
 
@@ -391,16 +407,36 @@ static int dwc3_probe(struct platform_device *pdev)
 	if (node) {
 		dwc->maximum_speed = of_usb_get_maximum_speed(node);
 
-		dwc->usb2_phy = devm_usb_get_phy_by_phandle(dev, "usb-phy", 0);
-		dwc->usb3_phy = devm_usb_get_phy_by_phandle(dev, "usb-phy", 1);
+		of_id = of_match_device(of_match_ptr(of_dwc3_match),
+			&pdev->dev);
+		if (!of_id)
+			return -EINVAL;
+
+		dwc_data = (struct dwc3_data *)of_id->data;
+
+		if (dwc_data)
+			dwc->quirks = dwc_data->quirks;
+
+		if (!(dwc->quirks & DWC3_QUIRK_NO_USB2_PHY))
+			dwc->usb2_phy = devm_usb_get_phy_by_phandle(dev,
+				"usb-phy", 0);
+
+		if (!(dwc->quirks & DWC3_QUIRK_NO_USB3_PHY))
+			dwc->usb3_phy = devm_usb_get_phy_by_phandle(dev,
+				"usb-phy", 1);
 
 		dwc->needs_fifo_resize = of_property_read_bool(node, "tx-fifo-resize");
 		dwc->dr_mode = of_usb_get_dr_mode(node);
 	} else if (pdata) {
 		dwc->maximum_speed = pdata->maximum_speed;
 
-		dwc->usb2_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
-		dwc->usb3_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB3);
+		if (!(pdata->quirks & DWC3_QUIRK_NO_USB2_PHY))
+			dwc->usb2_phy = devm_usb_get_phy(dev,
+				USB_PHY_TYPE_USB2);
+
+		if (!(pdata->quirks & DWC3_QUIRK_NO_USB3_PHY))
+			dwc->usb3_phy = devm_usb_get_phy(dev,
+				USB_PHY_TYPE_USB3);
 
 		dwc->needs_fifo_resize = pdata->tx_fifo_resize;
 		dwc->dr_mode = pdata->dr_mode;
@@ -409,40 +445,20 @@ static int dwc3_probe(struct platform_device *pdev)
 		dwc->usb3_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB3);
 	}
 
-	/* default to superspeed if no maximum_speed passed */
-	if (dwc->maximum_speed == USB_SPEED_UNKNOWN)
-		dwc->maximum_speed = USB_SPEED_SUPER;
-
 	if (IS_ERR(dwc->usb2_phy)) {
-		ret = PTR_ERR(dwc->usb2_phy);
-
-		/*
-		 * if -ENXIO is returned, it means PHY layer wasn't
-		 * enabled, so it makes no sense to return -EPROBE_DEFER
-		 * in that case, since no PHY driver will ever probe.
-		 */
-		if (ret == -ENXIO)
-			return ret;
-
-		dev_err(dev, "no usb2 phy configured\n");
-		return -EPROBE_DEFER;
+		dev_err(dev, "usb2 phy not found\n");
+		return PTR_ERR(dwc->usb2_phy);
 	}
 
 	if (IS_ERR(dwc->usb3_phy)) {
-		ret = PTR_ERR(dwc->usb3_phy);
-
-		/*
-		 * if -ENXIO is returned, it means PHY layer wasn't
-		 * enabled, so it makes no sense to return -EPROBE_DEFER
-		 * in that case, since no PHY driver will ever probe.
-		 */
-		if (ret == -ENXIO)
-			return ret;
-
-		dev_err(dev, "no usb3 phy configured\n");
-		return -EPROBE_DEFER;
+		dev_err(dev, "usb3 phy not found\n");
+		return PTR_ERR(dwc->usb3_phy);
 	}
 
+	/* default to superspeed if no maximum_speed passed */
+	if (dwc->maximum_speed == USB_SPEED_UNKNOWN)
+		dwc->maximum_speed = USB_SPEED_SUPER;
+
 	dwc->xhci_resources[0].start = res->start;
 	dwc->xhci_resources[0].end = dwc->xhci_resources[0].start +
 					DWC3_XHCI_REGS_END;
@@ -744,19 +760,6 @@ static const struct dev_pm_ops dwc3_dev_pm_ops = {
 #define DWC3_PM_OPS	NULL
 #endif
 
-#ifdef CONFIG_OF
-static const struct of_device_id of_dwc3_match[] = {
-	{
-		.compatible = "snps,dwc3"
-	},
-	{
-		.compatible = "synopsys,dwc3"
-	},
-	{ },
-};
-MODULE_DEVICE_TABLE(of, of_dwc3_match);
-#endif
-
 static struct platform_driver dwc3_driver = {
 	.probe		= dwc3_probe,
 	.remove		= dwc3_remove,
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index f8af8d4..1e11dd1 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -36,6 +36,10 @@
 #define DWC3_ENDPOINTS_NUM	32
 #define DWC3_XHCI_RESOURCES_NUM	2
 
+/* quirk flags */
+#define DWC3_QUIRK_NO_USB2_PHY	(0x1 << 0)
+#define DWC3_QUIRK_NO_USB3_PHY	(0x1 << 1)
+
 #define DWC3_EVENT_SIZE		4	/* bytes */
 #define DWC3_EVENT_MAX_NUM	64	/* 2 events/endpoint */
 #define DWC3_EVENT_BUFFERS_SIZE	(DWC3_EVENT_SIZE * DWC3_EVENT_MAX_NUM)
@@ -637,6 +641,7 @@ struct dwc3_scratchpad_array {
  * @mem: points to start of memory which is used for this struct.
  * @hwparams: copy of hwparams registers
  * @root: debugfs root folder pointer
+ * @quirks: attributes that are unique to a specific device (like erratas)
  */
 struct dwc3 {
 	struct usb_ctrlrequest	*ctrl_req;
@@ -730,6 +735,8 @@ struct dwc3 {
 
 	u8			test_mode;
 	u8			test_mode_nr;
+
+	u32			quirks;
 };
 
 /* -------------------------------------------------------------------------- */
@@ -856,6 +863,14 @@ union dwc3_event {
 	struct dwc3_event_gevt		gevt;
 };
 
+/**
+ * dwc3_data - dwc3 driver data
+ * @quirks - quirks specific to a device
+ */
+struct dwc3_data {
+	u32	quirks;
+};
+
 /*
  * DWC3 Features to be used as Driver Data
  */
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index 7db34f0..4179980 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -20,8 +20,13 @@
 #include <linux/usb/ch9.h>
 #include <linux/usb/otg.h>
 
+/* quirk flags */
+#define DWC3_QUIRK_NO_USB2_PHY (0x1 << 0)
+#define DWC3_QUIRK_NO_USB3_PHY (0x1 << 1)
+
 struct dwc3_platform_data {
 	enum usb_device_speed maximum_speed;
 	enum usb_dr_mode dr_mode;
 	bool tx_fifo_resize;
+	u32 quirks;
 };
-- 
1.7.10.4

