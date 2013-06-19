Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934827Ab3FSOGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 10:06:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49950 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933853Ab3FSOGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 10:06:33 -0400
From: Roger Quadros <rogerq@ti.com>
To: <stern@rowland.harvard.edu>, <tony@atomide.com>
CC: <balbi@ti.com>, <ruslan.bilovol@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 4/6] USB: ehci-omap: Suspend the controller during bus suspend
Date: Wed, 19 Jun 2013 17:05:51 +0300
Message-ID: <1371650753-11452-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371650753-11452-1-git-send-email-rogerq@ti.com>
References: <1371650753-11452-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Runtime suspend the controller during bus suspend and resume it
during bus resume. This will ensure that the USB Host power domain
enters lower power state and does not prevent the SoC from
endering deeper sleep states.

Remote wakeup will come up as an interrupt while the controller
is suspended, so tackle it carefully using a workqueue.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/host/ehci-omap.c |   82 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 16d7150..91f14f1 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -44,6 +44,8 @@
 #include <linux/usb/hcd.h>
 #include <linux/of.h>
 #include <linux/dma-mapping.h>
+#include <linux/workqueue.h>
+#include <linux/spinlock.h>
 
 #include "ehci.h"
 
@@ -69,6 +71,7 @@ static const char hcd_name[] = "ehci-omap";
 struct omap_hcd {
 	struct usb_phy *phy[OMAP3_HS_USB_PORTS]; /* one PHY for each port */
 	int nports;
+	struct work_struct work;
 };
 
 static inline void ehci_write(void __iomem *base, u32 reg, u32 val)
@@ -81,6 +84,76 @@ static inline u32 ehci_read(void __iomem *base, u32 reg)
 	return __raw_readl(base + reg);
 }
 
+static void omap_ehci_work(struct work_struct *work)
+{
+	struct omap_hcd *omap = container_of(work, struct omap_hcd, work);
+	struct ehci_hcd *ehci = container_of((void *) omap,
+						struct ehci_hcd, priv);
+	struct usb_hcd *hcd = ehci_to_hcd(ehci);
+	struct device *dev = hcd->self.controller;
+
+	pm_runtime_get_sync(dev);
+	enable_irq(hcd->irq);
+	/*
+	 * enable_irq() should preempt us with a pending IRQ
+	 * so we can be sure that IRQ handler completes before
+	 * we call pm_runtime_put_sync()
+	 */
+	pm_runtime_put_sync(dev);
+}
+
+static irqreturn_t omap_ehci_irq(struct usb_hcd *hcd)
+{
+	struct omap_hcd *omap = (struct omap_hcd *)hcd_to_ehci(hcd)->priv;
+	struct device *dev = hcd->self.controller;
+	irqreturn_t ret;
+
+	if (pm_runtime_suspended(dev)) {
+		schedule_work(&omap->work);
+		disable_irq_nosync(hcd->irq);
+		ret = IRQ_HANDLED;
+	} else
+		ret = ehci_irq(hcd);
+
+	return ret;
+}
+
+#ifdef CONFIG_PM
+static int omap_ehci_bus_suspend(struct usb_hcd *hcd)
+{
+	struct device *dev;
+	int ret;
+
+	dev = hcd->self.controller;
+	ret = ehci_bus_suspend(hcd);
+	if (ret)
+		return ret;
+
+	ret = pm_runtime_put_sync(dev);
+	if (ret < 0 && !(ret == -EBUSY || ret == -EAGAIN)) {
+		dev_err(dev, "Failed to runtime suspend :%d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int omap_ehci_bus_resume(struct usb_hcd *hcd)
+{
+	struct device *dev;
+	int ret;
+
+	dev = hcd->self.controller;
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0) {
+		dev_err(dev, "Failed to runtime resume :%d\n", ret);
+		return ret;
+	}
+
+	return ehci_bus_resume(hcd);
+}
+#endif /* CONFIG_PM */
+
 /* configure so an HC device and id are always provided */
 /* always called with process context; sleeping is OK */
 
@@ -88,6 +161,11 @@ static struct hc_driver __read_mostly ehci_omap_hc_driver;
 
 static const struct ehci_driver_overrides ehci_omap_overrides __initdata = {
 	.extra_priv_size = sizeof(struct omap_hcd),
+#ifdef CONFIG_PM
+	.bus_suspend = omap_ehci_bus_suspend,
+	.bus_resume = omap_ehci_bus_resume,
+#endif
+	.irq = omap_ehci_irq,
 };
 
 /**
@@ -163,6 +241,7 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 
 	omap = (struct omap_hcd *)hcd_to_ehci(hcd)->priv;
 	omap->nports = pdata->nports;
+	INIT_WORK(&omap->work, omap_ehci_work);
 
 	platform_set_drvdata(pdev, hcd);
 
@@ -257,6 +336,9 @@ static int ehci_hcd_omap_remove(struct platform_device *pdev)
 	struct omap_hcd *omap = (struct omap_hcd *)hcd_to_ehci(hcd)->priv;
 	int i;
 
+	if (pm_runtime_suspended(dev))
+		pm_runtime_get_sync(dev);
+
 	usb_remove_hcd(hcd);
 
 	for (i = 0; i < omap->nports; i++) {
-- 
1.7.4.1

