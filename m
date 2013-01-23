Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab3AWKl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:41:28 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:46624 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657Ab3AWKjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:39:04 -0500
From: Roger Quadros <rogerq@ti.com>
To: <sameo@linux.intel.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <kishon@ti.com>,
        <sshtylyov@mvista.com>, <bjorn@mork.no>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>
Subject: [PATCH v9 12/20] mfd: omap-usb-host: Use devm_kzalloc() and devm_request_and_ioremap()
Date: Wed, 23 Jan 2013 12:38:04 +0200
Message-ID: <1358937492-8129-13-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358937492-8129-1-git-send-email-rogerq@ti.com>
References: <1358937492-8129-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ variants of kzalloc and ioremap. Also clean up error path.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/omap-usb-host.c |   38 +++++++++++---------------------------
 1 files changed, 11 insertions(+), 27 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 061366d..310aaa9 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -461,15 +461,20 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 
 	if (!pdata) {
 		dev_err(dev, "Missing platform data\n");
-		ret = -ENOMEM;
-		goto end_probe;
+		return -ENODEV;
 	}
 
-	omap = kzalloc(sizeof(*omap), GFP_KERNEL);
+	omap = devm_kzalloc(dev, sizeof(*omap), GFP_KERNEL);
 	if (!omap) {
 		dev_err(dev, "Memory allocation failed\n");
-		ret = -ENOMEM;
-		goto end_probe;
+		return -ENOMEM;
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "uhh");
+	omap->uhh_base = devm_request_and_ioremap(dev, res);
+	if (!omap->uhh_base) {
+		dev_err(dev, "Resource request/ioremap failed\n");
+		return -EADDRNOTAVAIL;
 	}
 
 	spin_lock_init(&omap->lock);
@@ -568,20 +573,6 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 				"failed error:%d\n", ret);
 	}
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "uhh");
-	if (!res) {
-		dev_err(dev, "UHH EHCI get resource failed\n");
-		ret = -ENODEV;
-		goto err_init_60m_fclk;
-	}
-
-	omap->uhh_base = ioremap(res->start, resource_size(res));
-	if (!omap->uhh_base) {
-		dev_err(dev, "UHH ioremap failed\n");
-		ret = -ENOMEM;
-		goto err_init_60m_fclk;
-	}
-
 	platform_set_drvdata(pdev, omap);
 
 	omap_usbhs_init(dev);
@@ -591,13 +582,10 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 		goto err_alloc;
 	}
 
-	goto end_probe;
+	return 0;
 
 err_alloc:
 	omap_usbhs_deinit(&pdev->dev);
-	iounmap(omap->uhh_base);
-
-err_init_60m_fclk:
 	clk_put(omap->init_60m_fclk);
 
 err_usbhost_p2_fck:
@@ -621,9 +609,7 @@ err_utmi_p1_fck:
 err_end:
 	clk_put(omap->ehci_logic_fck);
 	pm_runtime_disable(dev);
-	kfree(omap);
 
-end_probe:
 	return ret;
 }
 
@@ -638,7 +624,6 @@ static int usbhs_omap_remove(struct platform_device *pdev)
 	struct usbhs_hcd_omap *omap = platform_get_drvdata(pdev);
 
 	omap_usbhs_deinit(&pdev->dev);
-	iounmap(omap->uhh_base);
 	clk_put(omap->init_60m_fclk);
 	clk_put(omap->usbhost_p2_fck);
 	clk_put(omap->usbhost_p1_fck);
@@ -648,7 +633,6 @@ static int usbhs_omap_remove(struct platform_device *pdev)
 	clk_put(omap->utmi_p1_fck);
 	clk_put(omap->ehci_logic_fck);
 	pm_runtime_disable(&pdev->dev);
-	kfree(omap);
 
 	return 0;
 }
-- 
1.7.4.1

