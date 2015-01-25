Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbbAYIPS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 03:15:18 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:44664 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbbAYIPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 03:15:10 -0500
From: Sneeker Yeh <sneeker.yeh@gmail.com>
X-Google-Original-From: Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>, Huang Rui <ray.huang@amd.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc: Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Subject: [PATCH v3 2/5] xhci: Platform: Set Synopsis device disconnection quirk based on platform data
Date: Sun, 25 Jan 2015 16:13:25 +0800
Message-Id: <1422173608-24355-3-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422173608-24355-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
References: <1422173608-24355-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an xhci platform has Synopsis device disconnection errata then enable
XHCI_DISCONNECT_QUIRK quirk flag.

Signed-off-by: Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
---
 drivers/usb/host/xhci-plat.c     |    3 +++
 include/linux/usb/xhci_pdriver.h |    4 ++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 08d402b..40beb95 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -147,6 +147,9 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	if ((node && of_property_read_bool(node, "usb3-lpm-capable")) ||
 			(pdata && pdata->usb3_lpm_capable))
 		xhci->quirks |= XHCI_LPM_SUPPORT;
+
+	if (pdata && pdata->delay_portcsc_clear)
+		xhci->quirks |= XHCI_DISCONNECT_QUIRK;
 	/*
 	 * Set the xHCI pointer before xhci_plat_setup() (aka hcd_driver.reset)
 	 * is called by usb_add_hcd().
diff --git a/include/linux/usb/xhci_pdriver.h b/include/linux/usb/xhci_pdriver.h
index 376654b..a37a3a5 100644
--- a/include/linux/usb/xhci_pdriver.h
+++ b/include/linux/usb/xhci_pdriver.h
@@ -18,10 +18,14 @@
  *
  * @usb3_lpm_capable:	determines if this xhci platform supports USB3
  *			LPM capability
+ * @delay_portcsc_clear:	determines if Synopsis USB3 core has errata in
+ *				"DWC_USB3_SUSPEND_ON_DISCONNECT_EN=1" hardware
+ *				configuration.
  *
  */
 struct usb_xhci_pdata {
 	unsigned	usb3_lpm_capable:1;
+	unsigned	delay_portcsc_clear:1;
 };
 
 #endif /* __USB_CORE_XHCI_PDRIVER_H */
-- 
1.7.9.5

