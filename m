Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaKYNQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:16:33 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37207 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbaKYNQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:16:27 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
CC: <peter.chen@freescale.com>, <sojka@merica.cz>, <mathias.nyman@intel.com>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>, <kgene.kim@samsung.com>,
        <ben-linux@fluff.org>, <linux@arm.linux.org.uk>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 12/19] usb: dwc3: gadget: Adapt gadget to drd library
Date: Tue, 25 Nov 2014 18:41:48 +0530
Message-ID: <1416921115-10467-13-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
References: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapt the dwc3 gadget to use drd library functions.
In prepration to support DRD on dwc3.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/dwc3/gadget.c | 128 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 100 insertions(+), 28 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 2c54d45..a75fae5 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -29,6 +29,7 @@
 
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
+#include <linux/usb/drd.h>
 
 #include "debug.h"
 #include "core.h"
@@ -2681,6 +2682,89 @@ static irqreturn_t dwc3_interrupt(int irq, void *_dwc)
 	return ret;
 }
 
+void dwc3_gadget_release(struct device *dev)
+{
+	struct usb_gadget *gadget = container_of(dev, struct usb_gadget, dev);
+	struct dwc3_gadget *dwc_gadget = gadget_to_dwc_gadget(gadget);
+	struct dwc3 *dwc = dwc_gadget->dwc;
+
+	dev_dbg(dev, "releasing '%s'\n", dev_name(dev));
+	dwc3_gadget_free_endpoints(dwc);
+	dma_free_coherent(dwc->dev, DWC3_EP0_BOUNCE_SIZE,
+			  dwc->ep0_bounce, dwc->ep0_bounce_addr);
+	kfree(dwc->setup_buf);
+	dma_free_coherent(dwc->dev, sizeof(*dwc->ep0_trb),
+			  dwc->ep0_trb, dwc->ep0_trb_addr);
+	dma_free_coherent(dwc->dev, sizeof(*dwc->ctrl_req),
+			  dwc->ctrl_req, dwc->ctrl_req_addr);
+	usb_drd_unregister_udc(dwc->dev);
+	kfree(dwc_gadget);
+}
+
+int dwc3_gadget_setup(void *data)
+{
+	struct dwc3 *dwc = data;
+	struct dwc3_gadget *dwc_gadget;
+	struct usb_drd_gadget *drd_gadget;
+	struct usb_drd_setup *gadget_setup;
+	int ret;
+
+	drd_gadget = kzalloc(sizeof(*drd_gadget), GFP_KERNEL);
+	if (!drd_gadget) {
+		ret = -ENOMEM;
+		goto err1;
+	}
+
+	gadget_setup = kzalloc(sizeof(*gadget_setup), GFP_KERNEL);
+	if (!gadget_setup) {
+		ret = -ENOMEM;
+		goto err2;
+	}
+
+	dwc_gadget = kzalloc(sizeof(*dwc_gadget), GFP_KERNEL);
+	if (!dwc_gadget) {
+		ret = -ENOMEM;
+		goto err3;
+	}
+
+	drd_gadget->g_driver = dwc->gadget_driver;
+
+	/*
+	 * Pass the DWC3 specific routines for
+	 * switching roles to the drd library
+	 */
+	gadget_setup->ll_start = NULL;
+	gadget_setup->ll_stop = NULL;
+	gadget_setup->ll_release = dwc3_gadget_release;
+	gadget_setup->data =  (void *)dwc;
+	drd_gadget->gadget_setup = gadget_setup;
+
+	dwc_gadget->gadget.ops			= &dwc3_gadget_ops;
+	dwc_gadget->gadget.max_speed		= USB_SPEED_SUPER;
+	dwc_gadget->gadget.speed		= USB_SPEED_UNKNOWN;
+	dwc_gadget->gadget.sg_supported		= true;
+	dwc_gadget->gadget.name			= "dwc3-gadget";
+	dwc_gadget->dwc				= dwc;
+	drd_gadget->gadget = &dwc_gadget->gadget;
+
+	/*
+	 * Per databook, DWC3 needs buffer size to be aligned to MaxPacketSize
+	 * on ep out.
+	 */
+	dwc_gadget->gadget.quirk_ep_out_aligned_size = true;
+	dwc->dwc_gadget = dwc_gadget;
+	usb_drd_register_udc(dwc->dev, drd_gadget);
+
+	return 0;
+
+err3:
+	kfree(gadget_setup);
+err2:
+	kfree(drd_gadget);
+err1:
+	return ret;
+}
+
 /**
  * dwc3_gadget_init - Initializes gadget related registers
  * @dwc: pointer to our controller context structure
@@ -2690,7 +2774,6 @@ static irqreturn_t dwc3_interrupt(int irq, void *_dwc)
 int dwc3_gadget_init(struct dwc3 *dwc)
 {
 	int					ret;
-	struct dwc3_gadget			*dwc_gadget;
 
 	dwc->ctrl_req = dma_alloc_coherent(dwc->dev, sizeof(*dwc->ctrl_req),
 			&dwc->ctrl_req_addr, GFP_KERNEL);
@@ -2723,24 +2806,9 @@ int dwc3_gadget_init(struct dwc3 *dwc)
 		goto err3;
 	}
 
-	dwc_gadget = kzalloc(sizeof(*dwc_gadget), GFP_KERNEL);
-	if (!dwc_gadget) {
-		ret = -ENOMEM;
+	ret = dwc3_gadget_setup(dwc);
+	if (ret)
 		goto err3;
-	}
-
-	dwc_gadget->gadget.ops			= &dwc3_gadget_ops;
-	dwc_gadget->gadget.max_speed		= USB_SPEED_SUPER;
-	dwc_gadget->gadget.speed		= USB_SPEED_UNKNOWN;
-	dwc_gadget->gadget.sg_supported	= true;
-	dwc_gadget->gadget.name		= "dwc3-gadget";
-	dwc_gadget->dwc = dwc;
-
-	/*
-	 * Per databook, DWC3 needs buffer size to be aligned to MaxPacketSize
-	 * on ep out.
-	 */
-	dwc_gadget->gadget.quirk_ep_out_aligned_size = true;
 
 	/*
 	 * REVISIT: Here we should clear all pending IRQs to be
@@ -2751,7 +2819,8 @@ int dwc3_gadget_init(struct dwc3 *dwc)
 	if (ret)
 		goto err4;
 
-	ret = usb_add_gadget_udc(dwc->dev, &dwc_gadget->gadget);
+	ret = usb_add_gadget_udc_release(dwc->dev, &dwc->dwc_gadget->gadget,
+					 dwc3_gadget_release);
 	if (ret) {
 		dev_err(dwc->dev, "failed to register udc\n");
 		goto err4;
@@ -2760,6 +2829,7 @@ int dwc3_gadget_init(struct dwc3 *dwc)
 	return 0;
 
 err4:
+	usb_drd_unregister_udc(dwc->dev);
 	dwc3_gadget_free_endpoints(dwc);
 	dma_free_coherent(dwc->dev, DWC3_EP0_BOUNCE_SIZE,
 			dwc->ep0_bounce, dwc->ep0_bounce_addr);
@@ -2785,20 +2855,22 @@ void dwc3_gadget_exit(struct dwc3 *dwc)
 {
 	struct dwc3_gadget *dwc_gadget = dwc->dwc_gadget;
 
-	usb_del_gadget_udc(&dwc_gadget->gadget);
+	if (usb_drd_get_state(dwc->dev) & DRD_DEVICE_REGISTERED) {
+		usb_del_gadget_udc(&dwc_gadget->gadget);
 
-	dwc3_gadget_free_endpoints(dwc);
+		dwc3_gadget_free_endpoints(dwc);
 
-	dma_free_coherent(dwc->dev, DWC3_EP0_BOUNCE_SIZE,
-			dwc->ep0_bounce, dwc->ep0_bounce_addr);
+		dma_free_coherent(dwc->dev, DWC3_EP0_BOUNCE_SIZE,
+				  dwc->ep0_bounce, dwc->ep0_bounce_addr);
 
-	kfree(dwc->setup_buf);
+		kfree(dwc->setup_buf);
 
-	dma_free_coherent(dwc->dev, sizeof(*dwc->ep0_trb),
-			dwc->ep0_trb, dwc->ep0_trb_addr);
+		dma_free_coherent(dwc->dev, sizeof(*dwc->ep0_trb),
+				  dwc->ep0_trb, dwc->ep0_trb_addr);
 
-	dma_free_coherent(dwc->dev, sizeof(*dwc->ctrl_req),
-			dwc->ctrl_req, dwc->ctrl_req_addr);
+		dma_free_coherent(dwc->dev, sizeof(*dwc->ctrl_req),
+				  dwc->ctrl_req, dwc->ctrl_req_addr);
+	}
 }
 
 int dwc3_gadget_suspend(struct dwc3 *dwc)
-- 
1.8.3.1

