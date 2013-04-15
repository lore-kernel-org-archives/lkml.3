Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab3DOLuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 07:50:50 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35055 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab3DOLur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 07:50:47 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <stern@rowland.harvard.edu>, <balbi@ti.com>, <holler@ahsoftware.de>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 2/2] USB: ehci-omap: Improve PHY error handling
Date: Mon, 15 Apr 2013 14:50:35 +0300
Message-ID: <1366026636-29198-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366026636-29198-1-git-send-email-rogerq@ti.com>
References: <1366026636-29198-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the USB PHY layer never returns NULL we don't need
to check for that condition.

If we fail to get the PHY device it could be due
to missing USB PHY drivers. Give this hint to the user
in the error message.

CC: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/host/ehci-omap.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 5de3e43..2e34ddd 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -175,13 +175,13 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 			phy = devm_usb_get_phy_by_phandle(dev, "phys", i);
 		else
 			phy = devm_usb_get_phy_dev(dev, i);
-		if (IS_ERR(phy) || !phy) {
+		if (IS_ERR(phy)) {
 			/* Don't bail out if PHY is not absolutely necessary */
 			if (pdata->port_mode[i] != OMAP_EHCI_PORT_MODE_PHY)
 				continue;
 
-			ret = IS_ERR(phy) ? PTR_ERR(phy) : -ENODEV;
-			dev_err(dev, "Can't get PHY device for port %d: %d\n",
+			ret = PTR_ERR(phy);
+			dev_err(dev, "Can't get PHY device for port %d: %d. Is USB_PHY driver enabled?\n",
 					i, ret);
 			goto err_phy;
 		}
-- 
1.7.4.1

