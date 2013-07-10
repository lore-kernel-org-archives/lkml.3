Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab3GJQX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 12:23:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56936 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755033Ab3GJQX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 12:23:56 -0400
From: Roger Quadros <rogerq@ti.com>
To: <stern@rowland.harvard.edu>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <sergei.shtylyov@cogentembedded.com>, <khilman@linaro.org>,
        <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH 6/6] USB: ehci-omap: Implement suspend/resume
Date: Wed, 10 Jul 2013 19:23:25 +0300
Message-ID: <1373473405-27589-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1373473081-27181-1-git-send-email-rogerq@ti.com>
References: <1373473081-27181-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call ehci_suspend/resume() during runtime suspend/resume
as well as system suspend/resume.

Use a flag "bound" to indicate that the HCD structures are valid.
This is only true between usb_add_hcd() and usb_remove_hcd() calls.

The flag can be used by omap_ehci_runtime_suspend/resume() handlers
to avoid calling ehci_suspend/resume() when we are no longer bound
to the HCD e.g. during probe() and remove();

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/host/ehci-omap.c |   64 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 9bd7dfe..6d1fde97 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -69,6 +69,7 @@ static const char hcd_name[] = "ehci-omap";
 struct omap_hcd {
 	struct usb_phy *phy[OMAP3_HS_USB_PORTS]; /* one PHY for each port */
 	int nports;
+	bool bound;	/* HCD structures are valid */
 };
 
 static inline void ehci_write(void __iomem *base, u32 reg, u32 val)
@@ -159,6 +160,7 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 	hcd->regs = regs;
+	hcd->has_wakeup_irq = true;
 	hcd_to_ehci(hcd)->caps = regs;
 
 	omap = (struct omap_hcd *)hcd_to_ehci(hcd)->priv;
@@ -216,6 +218,8 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 		goto err_pm_runtime;
 	}
 
+	omap->bound = true;
+
 	/*
 	 * Bring PHYs out of reset for non PHY modes.
 	 * Even though HSIC mode is a PHY-less mode, the reset
@@ -232,6 +236,8 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 		usb_phy_set_suspend(omap->phy[i], 0);
 	}
 
+	pm_runtime_put_sync(dev);
+
 	return 0;
 
 err_pm_runtime:
@@ -264,7 +270,9 @@ static int ehci_hcd_omap_remove(struct platform_device *pdev)
 	struct omap_hcd *omap = (struct omap_hcd *)hcd_to_ehci(hcd)->priv;
 	int i;
 
+	pm_runtime_get_sync(dev);
 	usb_remove_hcd(hcd);
+	omap->bound = false;
 
 	for (i = 0; i < omap->nports; i++) {
 		if (omap->phy[i])
@@ -293,15 +301,67 @@ static const struct of_device_id omap_ehci_dt_ids[] = {
 
 MODULE_DEVICE_TABLE(of, omap_ehci_dt_ids);
 
+static int omap_ehci_suspend(struct device *dev)
+{
+	struct usb_hcd *hcd = dev_get_drvdata(dev);
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	return ehci_suspend(hcd, true);
+}
+
+static int omap_ehci_resume(struct device *dev)
+{
+	struct usb_hcd *hcd = dev_get_drvdata(dev);
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	return ehci_resume(hcd, false);
+}
+
+static int omap_ehci_runtime_suspend(struct device *dev)
+{
+	struct usb_hcd *hcd = dev_get_drvdata(dev);
+	struct omap_hcd *omap = (struct omap_hcd *)hcd_to_ehci(hcd)->priv;
+	bool do_wakeup = device_may_wakeup(dev);
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	if (omap->bound)
+		ehci_suspend(hcd, do_wakeup);
+
+	return 0;
+}
+
+static int omap_ehci_runtime_resume(struct device *dev)
+{
+	struct usb_hcd *hcd = dev_get_drvdata(dev);
+	struct omap_hcd *omap = (struct omap_hcd *)hcd_to_ehci(hcd)->priv;
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	if (omap->bound)
+		ehci_resume(hcd, false);
+
+	return 0;
+}
+
+
+static const struct dev_pm_ops omap_ehci_pm_ops = {
+	.suspend = omap_ehci_suspend,
+	.resume = omap_ehci_resume,
+	.runtime_suspend = omap_ehci_runtime_suspend,
+	.runtime_resume = omap_ehci_runtime_resume,
+};
+
 static struct platform_driver ehci_hcd_omap_driver = {
 	.probe			= ehci_hcd_omap_probe,
 	.remove			= ehci_hcd_omap_remove,
 	.shutdown		= ehci_hcd_omap_shutdown,
-	/*.suspend		= ehci_hcd_omap_suspend, */
-	/*.resume		= ehci_hcd_omap_resume, */
 	.driver = {
 		.name		= hcd_name,
 		.of_match_table = omap_ehci_dt_ids,
+		.pm		= &omap_ehci_pm_ops,
 	}
 };
 
-- 
1.7.4.1

