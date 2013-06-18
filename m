Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab3FRHQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 03:16:30 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:54045 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750873Ab3FRHQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 03:16:29 -0400
X-Greylist: delayed 11874 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Jun 2013 03:15:52 EDT
From: Chao Xie <chao.xie@marvell.com>
To: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>, <rogerq@ti.com>,
        <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH] USB: initialize or shutdown PHY when add or remove host controller
Date: Tue, 18 Jun 2013 03:15:01 -0400
Message-ID: <1371539701-11441-1-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some controller need software to initialize PHY before add
host controller, and shut down PHY after remove host controller.
Add the generic code for these controllers so they do not need
do it in its own host controller driver.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/usb/core/hcd.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index d53547d..b26196b 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -43,6 +43,7 @@
 
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
+#include <linux/usb/phy.h>
 
 #include "usb.h"
 
@@ -2531,12 +2532,22 @@ int usb_add_hcd(struct usb_hcd *hcd,
 	 */
 	set_bit(HCD_FLAG_RH_RUNNING, &hcd->flags);
 
+	/* Initialize the PHY before other hardware operation. */
+	if (hcd->phy) {
+		retval = usb_phy_init(hcd->phy);
+		if (retval) {
+			dev_err(hcd->self.controller,
+				"can't initialize phy\n");
+			goto err_hcd_driver_setup;
+		}
+	}
+
 	/* "reset" is misnamed; its role is now one-time init. the controller
 	 * should already have been reset (and boot firmware kicked off etc).
 	 */
 	if (hcd->driver->reset && (retval = hcd->driver->reset(hcd)) < 0) {
 		dev_err(hcd->self.controller, "can't setup\n");
-		goto err_hcd_driver_setup;
+		goto err_hcd_driver_init_phy;
 	}
 	hcd->rh_pollable = 1;
 
@@ -2608,6 +2619,9 @@ err_hcd_driver_start:
 	if (usb_hcd_is_primary_hcd(hcd) && hcd->irq > 0)
 		free_irq(irqnum, hcd);
 err_request_irq:
+err_hcd_driver_init_phy:
+	if (hcd->phy)
+		usb_phy_shutdown(hcd->phy);
 err_hcd_driver_setup:
 err_set_rh_speed:
 	usb_put_dev(hcd->self.root_hub);
@@ -2674,6 +2688,9 @@ void usb_remove_hcd(struct usb_hcd *hcd)
 			free_irq(hcd->irq, hcd);
 	}
 
+	if (hcd->phy)
+		usb_phy_shutdown(hcd->phy);
+
 	usb_put_dev(hcd->self.root_hub);
 	usb_deregister_bus(&hcd->self);
 	hcd_buffer_destroy(hcd);
-- 
1.7.4.1

