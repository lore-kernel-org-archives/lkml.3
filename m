Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934650Ab3BNPIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 10:08:23 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44243 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759358Ab3BNPIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 10:08:20 -0500
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <stern@rowland.harvard.edu>, <balbi@ti.com>, <sameo@linux.intel.com>,
        <tony@atomide.com>, <rogerq@ti.com>, <stable@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] USB: ehci-omap: Don't free gpios that we didn't request
Date: Thu, 14 Feb 2013 17:08:08 +0200
Message-ID: <1360854489-9972-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1360854489-9972-1-git-send-email-rogerq@ti.com>
References: <1360854489-9972-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver does not request any gpios so don't free them.
Fixes L3 bus error on multiple modprobe/rmmod of ehci_hcd
with ehci-omap in use.

Without this patch, EHCI will break on repeated insmod/rmmod
of ehci_hcd for all OMAP2+ platforms that use EHCI and
set 'phy_reset = true' in usbhs_omap_board_data.
i.e.

board-3430sdp.c:	.phy_reset  = true,
board-3630sdp.c:	.phy_reset  = true,
board-am3517crane.c:	.phy_reset  = true,
board-am3517evm.c:	.phy_reset  = true,
board-cm-t3517.c:	.phy_reset  = true,
board-cm-t35.c:	.phy_reset  = true,
board-devkit8000.c:	.phy_reset  = true,
board-igep0020.c:	.phy_reset = true,
board-igep0020.c:	.phy_reset = true,
board-omap3beagle.c:	.phy_reset  = true,
board-omap3evm.c:	.phy_reset  = true,
board-omap3pandora.c:	.phy_reset  = true,
board-omap3stalker.c:	.phy_reset = true,
board-omap3touchbook.c:	.phy_reset  = true,
board-omap4panda.c:	.phy_reset  = false,
board-overo.c:	.phy_reset  = true,
board-zoom.c:	.phy_reset		= true,

CC: Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: stable@vger.kernel.org

Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ehci-omap.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index ac17a7c..e9d9b09 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -288,7 +288,6 @@ static int ehci_hcd_omap_remove(struct platform_device *pdev)
 {
 	struct device *dev				= &pdev->dev;
 	struct usb_hcd *hcd				= dev_get_drvdata(dev);
-	struct ehci_hcd_omap_platform_data *pdata	= dev->platform_data;
 
 	usb_remove_hcd(hcd);
 	disable_put_regulator(dev->platform_data);
@@ -298,13 +297,6 @@ static int ehci_hcd_omap_remove(struct platform_device *pdev)
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
 
-	if (pdata->phy_reset) {
-		if (gpio_is_valid(pdata->reset_gpio_port[0]))
-			gpio_free(pdata->reset_gpio_port[0]);
-
-		if (gpio_is_valid(pdata->reset_gpio_port[1]))
-			gpio_free(pdata->reset_gpio_port[1]);
-	}
 	return 0;
 }
 
-- 
1.7.4.1

