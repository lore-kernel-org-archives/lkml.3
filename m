Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760483Ab3B0AJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:09:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760053Ab3B0AJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:09:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>, Felipe Balbi <balbi@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 79/86] USB: ehci-omap: Dont free gpios that we didnt request
Date: Tue, 26 Feb 2013 16:08:27 -0800
Message-Id: <20130226235921.105248169@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/host/ehci-omap.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -288,7 +288,6 @@ static int ehci_hcd_omap_remove(struct p
 {
 	struct device *dev				= &pdev->dev;
 	struct usb_hcd *hcd				= dev_get_drvdata(dev);
-	struct ehci_hcd_omap_platform_data *pdata	= dev->platform_data;
 
 	usb_remove_hcd(hcd);
 	disable_put_regulator(dev->platform_data);
@@ -297,13 +296,6 @@ static int ehci_hcd_omap_remove(struct p
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
 


