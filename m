Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaFFMMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 08:12:51 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:53805 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaFFMMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 08:12:48 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        gregkh@linuxfoundation.org, kishon@ti.com, mathias.nyman@intel.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgene.kim@samsung.com, jwerner@chromium.org,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 3/4] usb: host: xhci-plat: Caibrate PHY post host reset
Date: Fri,  6 Jun 2014 17:42:14 +0530
Message-Id: <1402056736-12674-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402056736-12674-1-git-send-email-gautam.vivek@samsung.com>
References: <1402056736-12674-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some quirky PHYs may require to be calibrated post the host
controller initialization.
The USB 3.0 DRD PHY on Exynos5420/5800 systems is one such PHY
which needs to calibrated post xhci's reset at initialization
time and at resume time, to get the controller work at SuperSpeed.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/host/xhci-plat.c |   50 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index e7145b5..7be03df 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -32,10 +32,51 @@ static void xhci_plat_quirks(struct device *dev, struct xhci_hcd *xhci)
 	xhci->quirks |= XHCI_PLAT;
 }
 
+static int xhci_plat_calibrate_phy(struct xhci_hcd *xhci)
+{
+	int ret = 0;
+	struct usb_hcd *hcd = xhci_to_hcd(xhci);
+
+	/* calibrate phy if available */
+	if (!IS_ERR(xhci->phy2_gen)) {
+		ret = phy_calibrate(xhci->phy2_gen);
+		if (ret < 0 && ret != -ENOTSUPP) {
+			dev_err(hcd->self.controller,
+				"failed to calibrate USB 2.0 type PHY\n");
+			return ret;
+		}
+	}
+
+	if (!IS_ERR(xhci->phy3_gen)) {
+		ret = phy_calibrate(xhci->phy3_gen);
+		if (ret < 0 && ret != -ENOTSUPP)
+			dev_err(hcd->self.controller,
+				"failed to calibrate USB 3.0 type PHY\n");
+	}
+
+	return ret;
+}
+
 /* called during probe() after chip reset completes */
 static int xhci_plat_setup(struct usb_hcd *hcd)
 {
-	return xhci_gen_setup(hcd, xhci_plat_quirks);
+	struct xhci_hcd	*xhci;
+	int ret;
+
+	ret = xhci_gen_setup(hcd, xhci_plat_quirks);
+	if (ret) {
+		dev_err(hcd->self.controller, "xhci setup failed\n");
+		return ret;
+	}
+
+	if (!usb_hcd_is_primary_hcd(hcd)) {
+		xhci = hcd_to_xhci(hcd);
+		ret = xhci_plat_calibrate_phy(xhci);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static int xhci_plat_start(struct usb_hcd *hcd)
@@ -276,8 +317,13 @@ static int xhci_plat_resume(struct device *dev)
 {
 	struct usb_hcd	*hcd = dev_get_drvdata(dev);
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
+	int ret;
+
+	ret = xhci_resume(xhci, 0);
+	if (ret)
+		return ret;
 
-	return xhci_resume(xhci, 0);
+	return xhci_plat_calibrate_phy(xhci);
 }
 
 static const struct dev_pm_ops xhci_plat_pm_ops = {
-- 
1.7.10.4

