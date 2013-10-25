Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab3JYOQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 10:16:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53832 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab3JYOQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 10:16:18 -0400
Date: Fri, 25 Oct 2013 16:15:28 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 4/5] usb: ehci-s5p: Change to use phy provided by the generic
 phy framework
In-reply-to: <1382710529-12082-1-git-send-email-k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        Kamil Debski <k.debski@samsung.com>
Message-id: <1382710529-12082-5-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-AuditID: cbfee61b-b7fd56d000001fc6-82-526a7d3183ae
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t9jQV3D2qwgg13LRSzmHznHatF25SC7
	xY/XF9gsLjztYbM42/SG3WLazv+sFpd3zWGzmHF+H5PFomWtzBZrj9xltzjbf5vN4vCbdlaL
	9TNeszjweuycdZfdo2/LKkaP4ze2M3l83iQXwBLFZZOSmpNZllqkb5fAlfHtzyzGgkvSFXNf
	vGNrYPwu1sXIySEhYCJx/9BqdghbTOLCvfVsXYxcHEIC0xklXm/+wAjhdDBJTDu4lLmLkYOD
	TUBTYtU9D5AGEYGZjBKbF5uC2MwCZxklWm77gtjCArES64/3MoLYLAKqEld+bwZbwCvgInGl
	8zw7yBgJAQWJOZNsQExOAVeJ2fcKQCqEgCoez1/HNoGRdwEjwypG0dSC5ILipPRcI73ixNzi
	0rx0veT83E2M4BB8Jr2DcVWDxSFGAQ5GJR7ehBmZQUKsiWXFlbmHGCU4mJVEeHvKs4KEeFMS
	K6tSi/Lji0pzUosPMUpzsCiJ8x5stQ4UEkhPLEnNTk0tSC2CyTJxcEo1MPp1nz4rc9EyLfrk
	uikHtswxX8HGJO7fe/tS55F/3k4XLUycM/rLklPfSv3Ya9bkvLSa722uRdLk8sC1j6NjrjH6
	fGS5JHAl3kdQzu6gzPrX2fNXbLyusvAMr9qKOClFlcebDM9U28w5+i7A5r/q3G3VHhorzvk6
	fE9+VuJzI0JId+ov71MfqpRYijMSDbWYi4oTAZnrPEE9AgAA
References: <1382710529-12082-1-git-send-email-k.debski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the phy provider used from the old usb phy specific to a new one
using the generic phy framework.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/host/ehci-s5p.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 7cc26e6..76606ff 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_gpio.h>
+#include <linux/phy/phy.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/usb-ehci-s5p.h>
 #include <linux/usb/phy.h>
@@ -45,7 +46,7 @@ static struct hc_driver __read_mostly s5p_ehci_hc_driver;
 
 struct s5p_ehci_hcd {
 	struct clk *clk;
-	struct usb_phy *phy;
+	struct phy *phy;
 	struct usb_otg *otg;
 	struct s5p_ehci_platdata *pdata;
 };
@@ -77,10 +78,11 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 {
 	struct s5p_ehci_platdata *pdata = pdev->dev.platform_data;
 	struct s5p_ehci_hcd *s5p_ehci;
+	struct phy *phy;
 	struct usb_hcd *hcd;
 	struct ehci_hcd *ehci;
 	struct resource *res;
-	struct usb_phy *phy;
+	const char *phy_name;
 	int irq;
 	int err;
 
@@ -103,14 +105,14 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 	s5p_ehci = to_s5p_ehci(hcd);
-
+	phy_name = of_get_property(pdev->dev.of_node, "phy-names", NULL);
+	phy =  devm_phy_get(&pdev->dev, phy_name);
 	if (of_device_is_compatible(pdev->dev.of_node,
 					"samsung,exynos5440-ehci")) {
 		s5p_ehci->pdata = &empty_platdata;
 		goto skip_phy;
 	}
 
-	phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
 	if (IS_ERR(phy)) {
 		/* Fallback to pdata */
 		if (!pdata) {
@@ -122,7 +124,6 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 		}
 	} else {
 		s5p_ehci->phy = phy;
-		s5p_ehci->otg = phy->otg;
 	}
 
 skip_phy:
@@ -166,7 +167,7 @@ skip_phy:
 		s5p_ehci->otg->set_host(s5p_ehci->otg, &hcd->self);
 
 	if (s5p_ehci->phy)
-		usb_phy_init(s5p_ehci->phy);
+		phy_power_on(s5p_ehci->phy);
 	else if (s5p_ehci->pdata->phy_init)
 		s5p_ehci->pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
 
@@ -188,7 +189,7 @@ skip_phy:
 
 fail_add_hcd:
 	if (s5p_ehci->phy)
-		usb_phy_shutdown(s5p_ehci->phy);
+		phy_power_off(s5p_ehci->phy);
 	else if (s5p_ehci->pdata->phy_exit)
 		s5p_ehci->pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
 fail_io:
@@ -209,7 +210,7 @@ static int s5p_ehci_remove(struct platform_device *pdev)
 		s5p_ehci->otg->set_host(s5p_ehci->otg, &hcd->self);
 
 	if (s5p_ehci->phy)
-		usb_phy_shutdown(s5p_ehci->phy);
+		phy_power_off(s5p_ehci->phy);
 	else if (s5p_ehci->pdata->phy_exit)
 		s5p_ehci->pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
 
@@ -244,7 +245,7 @@ static int s5p_ehci_suspend(struct device *dev)
 		s5p_ehci->otg->set_host(s5p_ehci->otg, &hcd->self);
 
 	if (s5p_ehci->phy)
-		usb_phy_shutdown(s5p_ehci->phy);
+		phy_power_off(s5p_ehci->phy);
 	else if (s5p_ehci->pdata->phy_exit)
 		s5p_ehci->pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
 
@@ -265,7 +266,7 @@ static int s5p_ehci_resume(struct device *dev)
 		s5p_ehci->otg->set_host(s5p_ehci->otg, &hcd->self);
 
 	if (s5p_ehci->phy)
-		usb_phy_init(s5p_ehci->phy);
+		phy_power_on(s5p_ehci->phy);
 	else if (s5p_ehci->pdata->phy_init)
 		s5p_ehci->pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
 
-- 
1.7.9.5

