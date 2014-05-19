Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbaESIfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:35:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55430 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbaESIen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:34:43 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v2 6/6] usb: dwc3: dwc3-omap: Disable/Enable only wrapper interrupts in prepare/complete
Date: Mon, 19 May 2014 14:02:57 +0530
Message-ID: <1400488377-10605-7-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1400488377-10605-1-git-send-email-george.cherian@ti.com>
References: <1400488377-10605-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dwc3 wrapper driver should not be fiddling with the core interrupts.
Disabling the core interrupts in prepare stops xhci from proper operation.
So remove disable/enable of core interrupts from prepare/complete.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/dwc3/dwc3-omap.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index e4f681a..3f86f29 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -596,7 +596,7 @@ static int dwc3_omap_prepare(struct device *dev)
 {
 	struct dwc3_omap	*omap = dev_get_drvdata(dev);
 
-	dwc3_omap_disable_irqs(omap);
+	dwc3_omap_write_irqmisc_set(omap, 0x00);
 
 	return 0;
 }
@@ -604,8 +604,19 @@ static int dwc3_omap_prepare(struct device *dev)
 static void dwc3_omap_complete(struct device *dev)
 {
 	struct dwc3_omap	*omap = dev_get_drvdata(dev);
+	u32			reg;
 
-	dwc3_omap_enable_irqs(omap);
+	reg = (USBOTGSS_IRQMISC_OEVT |
+			USBOTGSS_IRQMISC_DRVVBUS_RISE |
+			USBOTGSS_IRQMISC_CHRGVBUS_RISE |
+			USBOTGSS_IRQMISC_DISCHRGVBUS_RISE |
+			USBOTGSS_IRQMISC_IDPULLUP_RISE |
+			USBOTGSS_IRQMISC_DRVVBUS_FALL |
+			USBOTGSS_IRQMISC_CHRGVBUS_FALL |
+			USBOTGSS_IRQMISC_DISCHRGVBUS_FALL |
+			USBOTGSS_IRQMISC_IDPULLUP_FALL);
+
+	dwc3_omap_write_irqmisc_set(omap, reg);
 }
 
 static int dwc3_omap_suspend(struct device *dev)
-- 
1.8.3.1

