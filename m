Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab3A1LiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:38:20 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49621 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756957Ab3A1LbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:31:08 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <linux@arm.linux.org.uk>, <sameo@linux.intel.com>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 09/30] USB: ehci-omap: Use devm_request_and_ioremap()
Date: Mon, 28 Jan 2013 13:30:10 +0200
Message-ID: <1359372631-8180-10-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359372631-8180-1-git-send-email-rogerq@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of devm_request_and_ioremap() and correct comment.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/host/ehci-omap.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 30fc482..fd2f5450 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -216,23 +216,17 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 
 	res =  platform_get_resource_byname(pdev,
 				IORESOURCE_MEM, "ehci");
-	if (!res) {
-		dev_err(dev, "UHH EHCI get resource failed\n");
-		return -ENODEV;
-	}
-
-	regs = ioremap(res->start, resource_size(res));
+	regs = devm_request_and_ioremap(dev, res);
 	if (!regs) {
-		dev_err(dev, "UHH EHCI ioremap failed\n");
-		return -ENOMEM;
+		dev_err(dev, "Resource request/ioremap failed\n");
+		return -EADDRNOTAVAIL;
 	}
 
 	hcd = usb_create_hcd(&ehci_omap_hc_driver, dev,
 			dev_name(dev));
 	if (!hcd) {
-		dev_err(dev, "failed to create hcd with err %d\n", ret);
-		ret = -ENOMEM;
-		goto err_io;
+		dev_err(dev, "Failed to create HCD\n");
+		return -ENOMEM;
 	}
 
 	hcd->rsrc_start = res->start;
@@ -285,8 +279,6 @@ err_pm_runtime:
 	pm_runtime_put_sync(dev);
 	usb_put_hcd(hcd);
 
-err_io:
-	iounmap(regs);
 	return ret;
 }
 
@@ -306,7 +298,6 @@ static int ehci_hcd_omap_remove(struct platform_device *pdev)
 
 	usb_remove_hcd(hcd);
 	disable_put_regulator(dev->platform_data);
-	iounmap(hcd->regs);
 	usb_put_hcd(hcd);
 
 	pm_runtime_put_sync(dev);
-- 
1.7.4.1

