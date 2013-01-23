Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3AWKjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:39:16 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40503 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab3AWKjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:39:05 -0500
From: Roger Quadros <rogerq@ti.com>
To: <sameo@linux.intel.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <kishon@ti.com>,
        <sshtylyov@mvista.com>, <bjorn@mork.no>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>
Subject: [PATCH v9 14/20] mfd: omap-usb-host: override number of ports from platform data
Date: Wed, 23 Jan 2013 12:38:06 +0200
Message-ID: <1358937492-8129-15-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358937492-8129-1-git-send-email-rogerq@ti.com>
References: <1358937492-8129-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both OMAP4 and 5 exhibit the same revision ID in the REVISION register
but they have different number of ports i.e. 2 and 3 respectively.
So we can't rely on REVISION register for number of ports on OMAP5
and depend on platform data (or device tree) instead.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/omap-usb-host.c            |   34 +++++++++++++++++++------------
 include/linux/platform_data/usb-omap.h |    1 +
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 26319ca..779588b 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -493,19 +493,27 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 	 */
 	pm_runtime_put_sync(dev);
 
-	switch (omap->usbhs_rev) {
-	case OMAP_USBHS_REV1:
-		omap->nports = 3;
-		break;
-	case OMAP_USBHS_REV2:
-		omap->nports = 2;
-		break;
-	default:
-		omap->nports = OMAP3_HS_USB_PORTS;
-		dev_dbg(dev,
-		  "USB HOST Rev : 0x%d not recognized, assuming %d ports\n",
-		   omap->usbhs_rev, omap->nports);
-		break;
+	/*
+	 * If platform data contains nports then use that
+	 * else make out number of ports from USBHS revision
+	 */
+	if (pdata->nports) {
+		omap->nports = pdata->nports;
+	} else {
+		switch (omap->usbhs_rev) {
+		case OMAP_USBHS_REV1:
+			omap->nports = 3;
+			break;
+		case OMAP_USBHS_REV2:
+			omap->nports = 2;
+			break;
+		default:
+			omap->nports = OMAP3_HS_USB_PORTS;
+			dev_dbg(dev,
+			 "USB HOST Rev:0x%d not recognized, assuming %d ports\n",
+			 omap->usbhs_rev, omap->nports);
+			break;
+		}
 	}
 
 	for (i = 0; i < omap->nports; i++)
diff --git a/include/linux/platform_data/usb-omap.h b/include/linux/platform_data/usb-omap.h
index 04c7537..925a4a7 100644
--- a/include/linux/platform_data/usb-omap.h
+++ b/include/linux/platform_data/usb-omap.h
@@ -39,6 +39,7 @@ enum usbhs_omap_port_mode {
 };
 
 struct usbhs_omap_platform_data {
+	int				nports;
 	enum usbhs_omap_port_mode	port_mode[OMAP3_HS_USB_PORTS];
 	int				reset_gpio_port[OMAP3_HS_USB_PORTS];
 	struct regulator		*regulator[OMAP3_HS_USB_PORTS];
-- 
1.7.4.1

