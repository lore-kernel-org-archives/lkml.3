Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaEBMsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 08:48:01 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:53155 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaEBMr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 08:47:57 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        t.figa@samsung.com, k.debski@samsung.com, jg1.han@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v3 1/4] usb: ohci-exynos: Use struct device instead of platform_device
Date: Fri,  2 May 2014 18:17:32 +0530
Message-Id: <1399034855-9686-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399034855-9686-1-git-send-email-gautam.vivek@samsung.com>
References: <1399034855-9686-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change to use struct device instead of struct platform_device
for some static functions.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Jingoo Han <jg1.han@samsung.com>
---

Changes from v2:
 - none

 drivers/usb/host/ohci-exynos.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index 9cf80cb..05f00e3 100644
--- a/drivers/usb/host/ohci-exynos.c
+++ b/drivers/usb/host/ohci-exynos.c
@@ -39,18 +39,18 @@ struct exynos_ohci_hcd {
 	struct usb_otg *otg;
 };
 
-static void exynos_ohci_phy_enable(struct platform_device *pdev)
+static void exynos_ohci_phy_enable(struct device *dev)
 {
-	struct usb_hcd *hcd = platform_get_drvdata(pdev);
+	struct usb_hcd *hcd = dev_get_drvdata(dev);
 	struct exynos_ohci_hcd *exynos_ohci = to_exynos_ohci(hcd);
 
 	if (exynos_ohci->phy)
 		usb_phy_init(exynos_ohci->phy);
 }
 
-static void exynos_ohci_phy_disable(struct platform_device *pdev)
+static void exynos_ohci_phy_disable(struct device *dev)
 {
-	struct usb_hcd *hcd = platform_get_drvdata(pdev);
+	struct usb_hcd *hcd = dev_get_drvdata(dev);
 	struct exynos_ohci_hcd *exynos_ohci = to_exynos_ohci(hcd);
 
 	if (exynos_ohci->phy)
@@ -139,7 +139,7 @@ skip_phy:
 
 	platform_set_drvdata(pdev, hcd);
 
-	exynos_ohci_phy_enable(pdev);
+	exynos_ohci_phy_enable(&pdev->dev);
 
 	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (err) {
@@ -150,7 +150,7 @@ skip_phy:
 	return 0;
 
 fail_add_hcd:
-	exynos_ohci_phy_disable(pdev);
+	exynos_ohci_phy_disable(&pdev->dev);
 fail_io:
 	clk_disable_unprepare(exynos_ohci->clk);
 fail_clk:
@@ -168,7 +168,7 @@ static int exynos_ohci_remove(struct platform_device *pdev)
 	if (exynos_ohci->otg)
 		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
 
-	exynos_ohci_phy_disable(pdev);
+	exynos_ohci_phy_disable(&pdev->dev);
 
 	clk_disable_unprepare(exynos_ohci->clk);
 
@@ -190,7 +190,6 @@ static int exynos_ohci_suspend(struct device *dev)
 {
 	struct usb_hcd *hcd = dev_get_drvdata(dev);
 	struct exynos_ohci_hcd *exynos_ohci = to_exynos_ohci(hcd);
-	struct platform_device *pdev = to_platform_device(dev);
 	bool do_wakeup = device_may_wakeup(dev);
 	int rc = ohci_suspend(hcd, do_wakeup);
 
@@ -200,7 +199,7 @@ static int exynos_ohci_suspend(struct device *dev)
 	if (exynos_ohci->otg)
 		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
 
-	exynos_ohci_phy_disable(pdev);
+	exynos_ohci_phy_disable(dev);
 
 	clk_disable_unprepare(exynos_ohci->clk);
 
@@ -211,14 +210,13 @@ static int exynos_ohci_resume(struct device *dev)
 {
 	struct usb_hcd *hcd			= dev_get_drvdata(dev);
 	struct exynos_ohci_hcd *exynos_ohci	= to_exynos_ohci(hcd);
-	struct platform_device *pdev		= to_platform_device(dev);
 
 	clk_prepare_enable(exynos_ohci->clk);
 
 	if (exynos_ohci->otg)
 		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
 
-	exynos_ohci_phy_enable(pdev);
+	exynos_ohci_phy_enable(dev);
 
 	ohci_resume(hcd, false);
 
-- 
1.7.10.4

