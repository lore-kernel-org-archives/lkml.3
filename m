Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab3BDOfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 09:35:39 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57329 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3BDOfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 09:35:37 -0500
From: Roger Quadros <rogerq@ti.com>
To: <stern@rowland.harvard.edu>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 09/31] USB: ehci-omap: Use devm_ioremap_resource()
Date: Mon, 4 Feb 2013 16:35:20 +0200
Message-ID: <1359988520-11996-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359372631-8180-1-git-send-email-rogerq@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of devm_ioremap_resource() and correct comment.

CC: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/host/ehci-omap.c |   21 ++++++---------------
 1 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 30fc482..6b088a4 100644
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
-	if (!regs) {
-		dev_err(dev, "UHH EHCI ioremap failed\n");
-		return -ENOMEM;
+	regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(regs)) {
+		dev_err(dev, "Resource request/ioremap failed\n");
+		return PTR_ERR(regs);
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

