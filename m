Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaIBLMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:12:55 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:38409 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbaIBLMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:12:52 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        kishon@ti.com, balbi@ti.com, stern@rowland.harvard.edu,
        kgene.kim@samsung.com, heikki.krogerus@linux.intel.com,
        mathias.nyman@intel.com, sergei.shtylyov@cogentembedded.com,
        jg1.han@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v6 3/4] usb: hcd: Calibrate PHY post hcd reset
Date: Tue,  2 Sep 2014 16:42:17 +0530
Message-Id: <1409656338-20337-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409656338-20337-1-git-send-email-gautam.vivek@samsung.com>
References: <1409656338-20337-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some quirky PHYs may require to be calibrated post the
hcd initialization.
The USB 3.0 DRD PHY on Exynos5420/5800 systems, coming along
with Synopsys's DWC3 controller, is one such PHY which needs
to be calibrated post xhci's reset at initialization time and
at resume time, to get the controller work at SuperSpeed.
So facilitating the HCDs to calibrate the PHY.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/core/hcd.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index c4ed66c..6e01d09 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2202,6 +2202,7 @@ int hcd_bus_resume(struct usb_device *rhdev, pm_message_t msg)
 	struct usb_hcd	*hcd = container_of(rhdev->bus, struct usb_hcd, self);
 	int		status;
 	int		old_state = hcd->state;
+	int		ret;
 
 	dev_dbg(&rhdev->dev, "usb %sresume\n",
 			(PMSG_IS_AUTO(msg) ? "auto-" : ""));
@@ -2216,6 +2217,15 @@ int hcd_bus_resume(struct usb_device *rhdev, pm_message_t msg)
 
 	hcd->state = HC_STATE_RESUMING;
 	status = hcd->driver->bus_resume(hcd);
+
+	/* calibrate the phy here */
+	ret = phy_calibrate(hcd->gen_phy);
+	if (ret < 0 && ret != -ENOTSUPP) {
+		dev_err(hcd->self.controller,
+			"failed to calibrate USB PHY\n");
+		return ret;
+	}
+
 	clear_bit(HCD_FLAG_WAKEUP_PENDING, &hcd->flags);
 	if (status == 0) {
 		struct usb_device *udev;
@@ -2738,6 +2748,14 @@ int usb_add_hcd(struct usb_hcd *hcd,
 	}
 	hcd->rh_pollable = 1;
 
+	/* calibrate the phy here */
+	retval = phy_calibrate(hcd->gen_phy);
+	if (retval < 0 && retval != -ENOTSUPP) {
+		dev_err(hcd->self.controller,
+			"failed to calibrate USB PHY\n");
+		return retval;
+	}
+
 	/* NOTE: root hub and controller capabilities may not be the same */
 	if (device_can_wakeup(hcd->self.controller)
 			&& device_can_wakeup(&hcd->self.root_hub->dev))
-- 
1.7.10.4

