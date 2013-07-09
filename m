Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab3GIK67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 06:58:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42760 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab3GIK64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 06:58:56 -0400
From: Roger Quadros <rogerq@ti.com>
To: <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH] USB: host: Use usb_hcd_platform_shutdown() wherever possible
Date: Tue, 9 Jul 2013 13:58:49 +0300
Message-ID: <1373367529-13713-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most HCD drivers are doing the same thing in their ".shutdown" callback
so it makes sense to use the generic usb_hcd_platform_shutdown()
handler there.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/host/ehci-grlib.c     |   11 +----------
 drivers/usb/host/ehci-mxc.c       |   10 +---------
 drivers/usb/host/ehci-omap.c      |   10 +---------
 drivers/usb/host/ehci-ppc-of.c    |   11 +----------
 drivers/usb/host/ehci-s5p.c       |   10 +---------
 drivers/usb/host/ehci-tegra.c     |   10 +---------
 drivers/usb/host/ehci-xilinx-of.c |   17 +----------------
 drivers/usb/host/ohci-omap3.c     |   10 +---------
 8 files changed, 8 insertions(+), 81 deletions(-)

diff --git a/drivers/usb/host/ehci-grlib.c b/drivers/usb/host/ehci-grlib.c
index a77bd8d..83ab51a 100644
--- a/drivers/usb/host/ehci-grlib.c
+++ b/drivers/usb/host/ehci-grlib.c
@@ -167,15 +167,6 @@ static int ehci_hcd_grlib_remove(struct platform_device *op)
 }
 
 
-static void ehci_hcd_grlib_shutdown(struct platform_device *op)
-{
-	struct usb_hcd *hcd = platform_get_drvdata(op);
-
-	if (hcd->driver->shutdown)
-		hcd->driver->shutdown(hcd);
-}
-
-
 static const struct of_device_id ehci_hcd_grlib_of_match[] = {
 	{
 		.name = "GAISLER_EHCI",
@@ -191,7 +182,7 @@ MODULE_DEVICE_TABLE(of, ehci_hcd_grlib_of_match);
 static struct platform_driver ehci_grlib_driver = {
 	.probe		= ehci_hcd_grlib_probe,
 	.remove		= ehci_hcd_grlib_remove,
-	.shutdown	= ehci_hcd_grlib_shutdown,
+	.shutdown	= usb_hcd_platform_shutdown,
 	.driver = {
 		.name = "grlib-ehci",
 		.owner = THIS_MODULE,
diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
index e4c34ac..030b539 100644
--- a/drivers/usb/host/ehci-mxc.c
+++ b/drivers/usb/host/ehci-mxc.c
@@ -197,20 +197,12 @@ static int ehci_mxc_drv_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static void ehci_mxc_drv_shutdown(struct platform_device *pdev)
-{
-	struct usb_hcd *hcd = platform_get_drvdata(pdev);
-
-	if (hcd->driver->shutdown)
-		hcd->driver->shutdown(hcd);
-}
-
 MODULE_ALIAS("platform:mxc-ehci");
 
 static struct platform_driver ehci_mxc_driver = {
 	.probe = ehci_mxc_drv_probe,
 	.remove = ehci_mxc_drv_remove,
-	.shutdown = ehci_mxc_drv_shutdown,
+	.shutdown = usb_hcd_platform_shutdown,
 	.driver = {
 		   .name = "mxc-ehci",
 	},
diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 9bd7dfe..4384d07 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -278,14 +278,6 @@ static int ehci_hcd_omap_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static void ehci_hcd_omap_shutdown(struct platform_device *pdev)
-{
-	struct usb_hcd *hcd = dev_get_drvdata(&pdev->dev);
-
-	if (hcd->driver->shutdown)
-		hcd->driver->shutdown(hcd);
-}
-
 static const struct of_device_id omap_ehci_dt_ids[] = {
 	{ .compatible = "ti,ehci-omap" },
 	{ }
@@ -296,7 +288,7 @@ MODULE_DEVICE_TABLE(of, omap_ehci_dt_ids);
 static struct platform_driver ehci_hcd_omap_driver = {
 	.probe			= ehci_hcd_omap_probe,
 	.remove			= ehci_hcd_omap_remove,
-	.shutdown		= ehci_hcd_omap_shutdown,
+	.shutdown		= usb_hcd_platform_shutdown,
 	/*.suspend		= ehci_hcd_omap_suspend, */
 	/*.resume		= ehci_hcd_omap_resume, */
 	.driver = {
diff --git a/drivers/usb/host/ehci-ppc-of.c b/drivers/usb/host/ehci-ppc-of.c
index 86da09c..932293f 100644
--- a/drivers/usb/host/ehci-ppc-of.c
+++ b/drivers/usb/host/ehci-ppc-of.c
@@ -215,15 +215,6 @@ static int ehci_hcd_ppc_of_remove(struct platform_device *op)
 }
 
 
-static void ehci_hcd_ppc_of_shutdown(struct platform_device *op)
-{
-	struct usb_hcd *hcd = platform_get_drvdata(op);
-
-	if (hcd->driver->shutdown)
-		hcd->driver->shutdown(hcd);
-}
-
-
 static const struct of_device_id ehci_hcd_ppc_of_match[] = {
 	{
 		.compatible = "usb-ehci",
@@ -236,7 +227,7 @@ MODULE_DEVICE_TABLE(of, ehci_hcd_ppc_of_match);
 static struct platform_driver ehci_hcd_ppc_of_driver = {
 	.probe		= ehci_hcd_ppc_of_probe,
 	.remove		= ehci_hcd_ppc_of_remove,
-	.shutdown	= ehci_hcd_ppc_of_shutdown,
+	.shutdown	= usb_hcd_platform_shutdown,
 	.driver = {
 		.name = "ppc-of-ehci",
 		.owner = THIS_MODULE,
diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 7cc26e6..aba645b 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -220,14 +220,6 @@ static int s5p_ehci_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static void s5p_ehci_shutdown(struct platform_device *pdev)
-{
-	struct usb_hcd *hcd = platform_get_drvdata(pdev);
-
-	if (hcd->driver->shutdown)
-		hcd->driver->shutdown(hcd);
-}
-
 #ifdef CONFIG_PM
 static int s5p_ehci_suspend(struct device *dev)
 {
@@ -297,7 +289,7 @@ MODULE_DEVICE_TABLE(of, exynos_ehci_match);
 static struct platform_driver s5p_ehci_driver = {
 	.probe		= s5p_ehci_probe,
 	.remove		= s5p_ehci_remove,
-	.shutdown	= s5p_ehci_shutdown,
+	.shutdown	= usb_hcd_platform_shutdown,
 	.driver = {
 		.name	= "s5p-ehci",
 		.owner	= THIS_MODULE,
diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 6ee7ef7..c8ba888 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -517,14 +517,6 @@ static int tegra_ehci_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static void tegra_ehci_hcd_shutdown(struct platform_device *pdev)
-{
-	struct usb_hcd *hcd = platform_get_drvdata(pdev);
-
-	if (hcd->driver->shutdown)
-		hcd->driver->shutdown(hcd);
-}
-
 static struct of_device_id tegra_ehci_of_match[] = {
 	{ .compatible = "nvidia,tegra20-ehci", },
 	{ },
@@ -533,7 +525,7 @@ static struct of_device_id tegra_ehci_of_match[] = {
 static struct platform_driver tegra_ehci_driver = {
 	.probe		= tegra_ehci_probe,
 	.remove		= tegra_ehci_remove,
-	.shutdown	= tegra_ehci_hcd_shutdown,
+	.shutdown	= usb_hcd_platform_shutdown,
 	.driver		= {
 		.name	= DRV_NAME,
 		.of_match_table = tegra_ehci_of_match,
diff --git a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-xilinx-of.c
index 35c7f90..eba962e 100644
--- a/drivers/usb/host/ehci-xilinx-of.c
+++ b/drivers/usb/host/ehci-xilinx-of.c
@@ -220,21 +220,6 @@ static int ehci_hcd_xilinx_of_remove(struct platform_device *op)
 	return 0;
 }
 
-/**
- * ehci_hcd_xilinx_of_shutdown - shutdown the hcd
- * @op:		pointer to platform_device structure that is to be removed
- *
- * Properly shutdown the hcd, call driver's shutdown routine.
- */
-static void ehci_hcd_xilinx_of_shutdown(struct platform_device *op)
-{
-	struct usb_hcd *hcd = platform_get_drvdata(op);
-
-	if (hcd->driver->shutdown)
-		hcd->driver->shutdown(hcd);
-}
-
-
 static const struct of_device_id ehci_hcd_xilinx_of_match[] = {
 		{.compatible = "xlnx,xps-usb-host-1.00.a",},
 	{},
@@ -244,7 +229,7 @@ MODULE_DEVICE_TABLE(of, ehci_hcd_xilinx_of_match);
 static struct platform_driver ehci_hcd_xilinx_of_driver = {
 	.probe		= ehci_hcd_xilinx_of_probe,
 	.remove		= ehci_hcd_xilinx_of_remove,
-	.shutdown	= ehci_hcd_xilinx_of_shutdown,
+	.shutdown	= usb_hcd_platform_shutdown,
 	.driver = {
 		.name = "xilinx-of-ehci",
 		.owner = THIS_MODULE,
diff --git a/drivers/usb/host/ohci-omap3.c b/drivers/usb/host/ohci-omap3.c
index 8f71357..a09af26 100644
--- a/drivers/usb/host/ohci-omap3.c
+++ b/drivers/usb/host/ohci-omap3.c
@@ -231,14 +231,6 @@ static int ohci_hcd_omap3_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static void ohci_hcd_omap3_shutdown(struct platform_device *pdev)
-{
-	struct usb_hcd *hcd = dev_get_drvdata(&pdev->dev);
-
-	if (hcd->driver->shutdown)
-		hcd->driver->shutdown(hcd);
-}
-
 static const struct of_device_id omap_ohci_dt_ids[] = {
 	{ .compatible = "ti,ohci-omap3" },
 	{ }
@@ -249,7 +241,7 @@ MODULE_DEVICE_TABLE(of, omap_ohci_dt_ids);
 static struct platform_driver ohci_hcd_omap3_driver = {
 	.probe		= ohci_hcd_omap3_probe,
 	.remove		= ohci_hcd_omap3_remove,
-	.shutdown	= ohci_hcd_omap3_shutdown,
+	.shutdown	= usb_hcd_platform_shutdown,
 	.driver		= {
 		.name	= "ohci-omap3",
 		.of_match_table = omap_ohci_dt_ids,
-- 
1.7.4.1

