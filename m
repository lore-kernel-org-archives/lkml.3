Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab3B1Or6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:47:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42107 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517Ab3B1Orx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:47:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roger Quadros <rogerq@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 051/139] USB: ehci-omap: Don't free gpios that we didn't request
Date: Thu, 28 Feb 2013 14:43:21 +0000
Message-Id: <1362062689-2567-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@ti.com>

commit 428525f97153505e83983460a8d08a3210aa6b8a upstream.

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

Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/ehci-omap.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 4a54418..30f8b24 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -289,7 +289,6 @@ static int ehci_hcd_omap_remove(struct platform_device *pdev)
 {
 	struct device *dev				= &pdev->dev;
 	struct usb_hcd *hcd				= dev_get_drvdata(dev);
-	struct ehci_hcd_omap_platform_data *pdata	= dev->platform_data;
 
 	usb_remove_hcd(hcd);
 	disable_put_regulator(dev->platform_data);
@@ -299,13 +298,6 @@ static int ehci_hcd_omap_remove(struct platform_device *pdev)
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
1.8.1.2

