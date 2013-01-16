Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab3APOon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:44:43 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45199 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972Ab3APOok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:44:40 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>
CC: <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <rogerq@ti.com>
Subject: [PATCH v6 07/22] mfd: omap-usb-tll: Fix error message
Date: Wed, 16 Jan 2013 16:43:38 +0200
Message-ID: <1358347433-329-8-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358347433-329-1-git-send-email-rogerq@ti.com>
References: <1358347433-329-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

omap_enable/disable_tll() can fail if TLL device is not
initialized. It could be due to multiple reasons and not only
due to missing platform data.

Also make local variables static and use 'struct device *'
instead of 'struct platform_device *' for global reference.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-tll.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index b9f372d..8628313 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -109,8 +109,8 @@ struct usbtll_omap {
 
 /*-------------------------------------------------------------------------*/
 
-const char usbtll_driver_name[] = USBTLL_DRIVER_NAME;
-struct platform_device	*tll_pdev;
+static const char usbtll_driver_name[] = USBTLL_DRIVER_NAME;
+static struct device	*tll_dev;
 
 /*-------------------------------------------------------------------------*/
 
@@ -337,7 +337,8 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 
 	spin_unlock_irqrestore(&tll->lock, flags);
 	pm_runtime_put_sync(dev);
-	tll_pdev = pdev;
+	/* only after this can omap_tll_enable/disable work */
+	tll_dev = dev;
 
 	return 0;
 
@@ -359,6 +360,8 @@ static int usbtll_omap_remove(struct platform_device *pdev)
 	struct usbtll_omap *tll = platform_get_drvdata(pdev);
 	int i;
 
+	tll_dev = NULL;
+
 	for (i = 0; i < tll->nch; i++)
 		clk_put(tll->ch_clk[i]);
 
@@ -438,21 +441,21 @@ static struct platform_driver usbtll_omap_driver = {
 
 int omap_tll_enable(void)
 {
-	if (!tll_pdev) {
-		pr_err("missing omap usbhs tll platform_data\n");
+	if (!tll_dev) {
+		pr_err("%s: OMAP USB TLL not initialized\n", __func__);
 		return  -ENODEV;
 	}
-	return pm_runtime_get_sync(&tll_pdev->dev);
+	return pm_runtime_get_sync(tll_dev);
 }
 EXPORT_SYMBOL_GPL(omap_tll_enable);
 
 int omap_tll_disable(void)
 {
-	if (!tll_pdev) {
-		pr_err("missing omap usbhs tll platform_data\n");
+	if (!tll_dev) {
+		pr_err("%s: OMAP USB TLL not initialized\n", __func__);
 		return  -ENODEV;
 	}
-	return pm_runtime_put_sync(&tll_pdev->dev);
+	return pm_runtime_put_sync(tll_dev);
 }
 EXPORT_SYMBOL_GPL(omap_tll_disable);
 
-- 
1.7.4.1

