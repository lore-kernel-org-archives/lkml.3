Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbaBUGj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 01:39:56 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:17976 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752514AbaBUGjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 01:39:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhgEALbyBlOl5H4JgWdsb2JhbABZhkm+FIEkDgEBFiYogiYBBSdSEAhJVwcSiAXNPReOZAeEOASYNJVoKA
From: Alistair Popple <alistair@popple.id.au>
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: Alistair Popple <alistair@popple.id.au>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 3/7] IBM Akebono: Add support to the OHCI platform driver for PPC476GTR
Date: Fri, 21 Feb 2014 17:31:29 +1100
Message-Id: <1392964293-13687-4-git-send-email-alistair@popple.id.au>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1392964293-13687-1-git-send-email-alistair@popple.id.au>
References: <1392964293-13687-1-git-send-email-alistair@popple.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IBM Akebono board uses the PPC476GTR SoC which has a OHCI
compliant USB host interface. This patch adds support for it to the
OHCI platform driver.

As we use device tree to pass platform specific data instead of
platform data we remove the check for platform data and instead
provide reasonable defaults if no platform data is present. This is
similar to what is currently done in ehci-platform.c.

Signed-off-by: Alistair Popple <alistair@popple.id.au>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ohci-platform.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/ohci-platform.c b/drivers/usb/host/ohci-platform.c
index f351ff5..e5a5979 100644
--- a/drivers/usb/host/ohci-platform.c
+++ b/drivers/usb/host/ohci-platform.c
@@ -23,6 +23,8 @@
 #include <linux/usb/ohci_pdriver.h>
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
+#include <linux/slab.h>
+#include <linux/of.h>
 
 #include "ohci.h"
 
@@ -55,6 +57,8 @@ static const struct ohci_driver_overrides platform_overrides __initconst = {
 	.reset =	ohci_platform_reset,
 };
 
+static struct usb_ohci_pdata ohci_platform_defaults;
+
 static int ohci_platform_probe(struct platform_device *dev)
 {
 	struct usb_hcd *hcd;
@@ -63,14 +67,16 @@ static int ohci_platform_probe(struct platform_device *dev)
 	int irq;
 	int err = -ENOMEM;
 
-	if (!pdata) {
-		WARN_ON(1);
-		return -ENODEV;
-	}
-
 	if (usb_disabled())
 		return -ENODEV;
 
+	/*
+	 * Platforms using DT don't always provide platform data.
+	 * This should provide reasonable defaults.
+	 */
+	if (!pdata)
+		dev->dev.platform_data = pdata = &ohci_platform_defaults;
+
 	irq = platform_get_irq(dev, 0);
 	if (irq < 0) {
 		dev_err(&dev->dev, "no irq provided");
@@ -178,6 +184,11 @@ static int ohci_platform_resume(struct device *dev)
 #define ohci_platform_resume	NULL
 #endif /* CONFIG_PM */
 
+static const struct of_device_id ohci_of_match[] = {
+	{ .compatible = "usb-ohci", },
+	{},
+};
+
 static const struct platform_device_id ohci_platform_table[] = {
 	{ "ohci-platform", 0 },
 	{ }
@@ -198,6 +209,7 @@ static struct platform_driver ohci_platform_driver = {
 		.owner	= THIS_MODULE,
 		.name	= "ohci-platform",
 		.pm	= &ohci_platform_pm_ops,
+		.of_match_table = ohci_of_match,
 	}
 };
 
-- 
1.7.10.4

