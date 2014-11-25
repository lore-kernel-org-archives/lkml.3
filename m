Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaKYARf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 19:17:35 -0500
Received: from mail-pd0-f202.google.com ([209.85.192.202]:43514 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaKYARa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 19:17:30 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, linux-tegra@vger.kernel.org
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: [PATCH V6 01/12] xhci: Set shared HCD's hcd_priv in xhci_gen_setup
Date: Mon, 24 Nov 2014 16:17:13 -0800
Message-Id: <1416874644-12070-2-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1416874644-12070-1-git-send-email-abrestic@chromium.org>
References: <1416874644-12070-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xhci_gen_setup() sets the hcd_priv field for the primary HCD, but not
for the shared HCD, requiring xHCI host-controller drivers to set it
between usb_create_shared_hcd() and usb_add_hcd().  There's no reason
xhci_gen_setup() can't set the shared HCD's hcd_priv as well, so move
that bit out of the host-controller drivers and into xhci_gen_setup().

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
No changes from v5.
New for v5.
Peviously posted here: https://lkml.org/lkml/2014/10/30/726
---
 drivers/usb/host/xhci-pci.c  | 5 -----
 drivers/usb/host/xhci-plat.c | 5 -----
 drivers/usb/host/xhci.c      | 6 +++---
 3 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 9a69b1f..31025e4 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -221,11 +221,6 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		goto dealloc_usb2_hcd;
 	}
 
-	/* Set the xHCI pointer before xhci_pci_setup() (aka hcd_driver.reset)
-	 * is called by usb_add_hcd().
-	 */
-	*((struct xhci_hcd **) xhci->shared_hcd->hcd_priv) = xhci;
-
 	retval = usb_add_hcd(xhci->shared_hcd, dev->irq,
 			IRQF_SHARED);
 	if (retval)
diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 3d78b0c..5bc33bc 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -149,11 +149,6 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	if ((node && of_property_read_bool(node, "usb3-lpm-capable")) ||
 			(pdata && pdata->usb3_lpm_capable))
 		xhci->quirks |= XHCI_LPM_SUPPORT;
-	/*
-	 * Set the xHCI pointer before xhci_plat_setup() (aka hcd_driver.reset)
-	 * is called by usb_add_hcd().
-	 */
-	*((struct xhci_hcd **) xhci->shared_hcd->hcd_priv) = xhci;
 
 	if (HCC_MAX_PSA(xhci->hcc_params) >= 4)
 		xhci->shared_hcd->can_do_streams = 1;
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 2a5d45b..ae05471 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4843,9 +4843,9 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 		 */
 		hcd->has_tt = 1;
 	} else {
-		/* xHCI private pointer was set in xhci_pci_probe for the second
-		 * registered roothub.
-		 */
+		xhci = hcd_to_xhci(hcd->primary_hcd);
+		*((struct xhci_hcd **) hcd->hcd_priv) = xhci;
+
 		return 0;
 	}
 
-- 
2.1.0.rc2.206.gedb03e5

