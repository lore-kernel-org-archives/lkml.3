Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab3AWKnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:43:41 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41926 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab3AWKio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:38:44 -0500
From: Roger Quadros <rogerq@ti.com>
To: <sameo@linux.intel.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <kishon@ti.com>,
        <sshtylyov@mvista.com>, <bjorn@mork.no>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>
Subject: [PATCH v9 04/20] mfd: omap-usb-tll: Use devm_kzalloc/ioremap and clean up error path
Date: Wed, 23 Jan 2013 12:37:56 +0200
Message-ID: <1358937492-8129-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358937492-8129-1-git-send-email-rogerq@ti.com>
References: <1358937492-8129-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ variants of kzalloc() and ioremap(). Simplify the error path.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/omap-usb-tll.c |   38 ++++++++++++--------------------------
 1 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index 9658e18..9a19cc7 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -215,11 +215,10 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 
 	dev_dbg(dev, "starting TI HSUSB TLL Controller\n");
 
-	tll = kzalloc(sizeof(struct usbtll_omap), GFP_KERNEL);
+	tll = devm_kzalloc(dev, sizeof(struct usbtll_omap), GFP_KERNEL);
 	if (!tll) {
 		dev_err(dev, "Memory allocation failed\n");
-		ret = -ENOMEM;
-		goto end;
+		return -ENOMEM;
 	}
 
 	spin_lock_init(&tll->lock);
@@ -230,28 +229,22 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 	if (IS_ERR(tll->usbtll_p1_fck)) {
 		ret = PTR_ERR(tll->usbtll_p1_fck);
 		dev_err(dev, "usbtll_p1_fck failed error:%d\n", ret);
-		goto err_tll;
+		return ret;
 	}
 
 	tll->usbtll_p2_fck = clk_get(dev, "usb_tll_hs_usb_ch1_clk");
 	if (IS_ERR(tll->usbtll_p2_fck)) {
 		ret = PTR_ERR(tll->usbtll_p2_fck);
 		dev_err(dev, "usbtll_p2_fck failed error:%d\n", ret);
-		goto err_usbtll_p1_fck;
+		goto err_p2_fck;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "usb tll get resource failed\n");
-		ret = -ENODEV;
-		goto err_usbtll_p2_fck;
-	}
-
-	base = ioremap(res->start, resource_size(res));
+	base = devm_request_and_ioremap(dev, res);
 	if (!base) {
-		dev_err(dev, "TLL ioremap failed\n");
-		ret = -ENOMEM;
-		goto err_usbtll_p2_fck;
+		ret = -EADDRNOTAVAIL;
+		dev_err(dev, "Resource request/ioremap failed:%d\n", ret);
+		goto err_res;
 	}
 
 	platform_set_drvdata(pdev, tll);
@@ -323,23 +316,17 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 	}
 
 	spin_unlock_irqrestore(&tll->lock, flags);
-	iounmap(base);
 	pm_runtime_put_sync(dev);
 	tll_pdev = pdev;
-	if (!ret)
-		goto end;
-	pm_runtime_disable(dev);
 
-err_usbtll_p2_fck:
+	return 0;
+
+err_res:
 	clk_put(tll->usbtll_p2_fck);
 
-err_usbtll_p1_fck:
+err_p2_fck:
 	clk_put(tll->usbtll_p1_fck);
 
-err_tll:
-	kfree(tll);
-
-end:
 	return ret;
 }
 
@@ -356,7 +343,6 @@ static int usbtll_omap_remove(struct platform_device *pdev)
 	clk_put(tll->usbtll_p2_fck);
 	clk_put(tll->usbtll_p1_fck);
 	pm_runtime_disable(&pdev->dev);
-	kfree(tll);
 	return 0;
 }
 
-- 
1.7.4.1

