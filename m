Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab3CLKpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:45:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41828 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab3CLKpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:45:10 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <stern@rowland.harvard.edu>, <balbi@ti.com>, <b-cousson@ti.com>,
        <mark.rutland@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <rogerq@ti.com>
Subject: [PATCH 02/12] USB: ehci-omap: Use devm_ioremap_resource()
Date: Tue, 12 Mar 2013 12:44:40 +0200
Message-ID: <1363085090-24676-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363085090-24676-1-git-send-email-rogerq@ti.com>
References: <1363085090-24676-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of devm_ioremap_resource() and correct comment.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ehci-omap.c |   21 +++++----------------
 1 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index fa66757..70e8e6f 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -216,23 +216,15 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 
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
-	}
+	regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(regs))
+		return PTR_ERR(regs);
 
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
@@ -285,8 +277,6 @@ err_pm_runtime:
 	pm_runtime_put_sync(dev);
 	usb_put_hcd(hcd);
 
-err_io:
-	iounmap(regs);
 	return ret;
 }
 
@@ -306,7 +296,6 @@ static int ehci_hcd_omap_remove(struct platform_device *pdev)
 
 	usb_remove_hcd(hcd);
 	disable_put_regulator(dev->platform_data);
-	iounmap(hcd->regs);
 	usb_put_hcd(hcd);
 
 	pm_runtime_put_sync(dev);
-- 
1.7.4.1

