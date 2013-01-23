Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab3AWKjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:39:03 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40492 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657Ab3AWKi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:38:59 -0500
From: Roger Quadros <rogerq@ti.com>
To: <sameo@linux.intel.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <kishon@ti.com>,
        <sshtylyov@mvista.com>, <bjorn@mork.no>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>
Subject: [PATCH v9 09/20] mfd: omap-usb-tll: serialize access to TLL device
Date: Wed, 23 Jan 2013 12:38:01 +0200
Message-ID: <1358937492-8129-10-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358937492-8129-1-git-send-email-rogerq@ti.com>
References: <1358937492-8129-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the unnecessary spin_lock_irqsave/restore() as there is
no interrupt handler for this driver. Instead we serialize access
to tll_dev using a global spinlock.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/omap-usb-tll.c |   53 ++++++++++++++++++++++---------------------
 1 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index eccc65e..55c85c7 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -103,14 +103,13 @@ struct usbtll_omap {
 	int					nch;	/* num. of channels */
 	struct usbhs_omap_platform_data		*pdata;
 	struct clk				**ch_clk;
-	/* secure the register updates */
-	spinlock_t				lock;
 };
 
 /*-------------------------------------------------------------------------*/
 
 static const char usbtll_driver_name[] = USBTLL_DRIVER_NAME;
 static struct device	*tll_dev;
+static DEFINE_SPINLOCK(tll_lock);	/* serialize access to tll_dev */
 
 /*-------------------------------------------------------------------------*/
 
@@ -212,7 +211,6 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 	struct resource				*res;
 	struct usbtll_omap			*tll;
 	unsigned				reg;
-	unsigned long				flags;
 	int					ret = 0;
 	int					i, ver;
 	bool needs_tll;
@@ -230,8 +228,6 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	spin_lock_init(&tll->lock);
-
 	tll->pdata = pdata;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -246,8 +242,6 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	pm_runtime_get_sync(dev);
 
-	spin_lock_irqsave(&tll->lock, flags);
-
 	ver =  usbtll_read(base, OMAP_USBTLL_REVISION);
 	switch (ver) {
 	case OMAP_USBTLL_REV1:
@@ -265,8 +259,6 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 		break;
 	}
 
-	spin_unlock_irqrestore(&tll->lock, flags);
-
 	tll->ch_clk = devm_kzalloc(dev, sizeof(struct clk * [tll->nch]),
 						GFP_KERNEL);
 	if (!tll->ch_clk) {
@@ -286,8 +278,6 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 			dev_dbg(dev, "can't get clock : %s\n", clkname);
 	}
 
-	spin_lock_irqsave(&tll->lock, flags);
-
 	needs_tll = false;
 	for (i = 0; i < tll->nch; i++)
 		needs_tll |= omap_usb_mode_needs_tll(pdata->port_mode[i]);
@@ -332,10 +322,11 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 		}
 	}
 
-	spin_unlock_irqrestore(&tll->lock, flags);
 	pm_runtime_put_sync(dev);
 	/* only after this can omap_tll_enable/disable work */
+	spin_lock(&tll_lock);
 	tll_dev = dev;
+	spin_unlock(&tll_lock);
 
 	return 0;
 
@@ -357,7 +348,9 @@ static int usbtll_omap_remove(struct platform_device *pdev)
 	struct usbtll_omap *tll = platform_get_drvdata(pdev);
 	int i;
 
+	spin_lock(&tll_lock);
 	tll_dev = NULL;
+	spin_unlock(&tll_lock);
 
 	for (i = 0; i < tll->nch; i++)
 		if (!IS_ERR(tll->ch_clk[i]))
@@ -371,13 +364,10 @@ static int usbtll_runtime_resume(struct device *dev)
 {
 	struct usbtll_omap			*tll = dev_get_drvdata(dev);
 	struct usbhs_omap_platform_data		*pdata = tll->pdata;
-	unsigned long				flags;
 	int i;
 
 	dev_dbg(dev, "usbtll_runtime_resume\n");
 
-	spin_lock_irqsave(&tll->lock, flags);
-
 	for (i = 0; i < tll->nch; i++) {
 		if (omap_usb_mode_needs_tll(pdata->port_mode[i])) {
 			int r;
@@ -393,8 +383,6 @@ static int usbtll_runtime_resume(struct device *dev)
 		}
 	}
 
-	spin_unlock_irqrestore(&tll->lock, flags);
-
 	return 0;
 }
 
@@ -402,13 +390,10 @@ static int usbtll_runtime_suspend(struct device *dev)
 {
 	struct usbtll_omap			*tll = dev_get_drvdata(dev);
 	struct usbhs_omap_platform_data		*pdata = tll->pdata;
-	unsigned long				flags;
 	int i;
 
 	dev_dbg(dev, "usbtll_runtime_suspend\n");
 
-	spin_lock_irqsave(&tll->lock, flags);
-
 	for (i = 0; i < tll->nch; i++) {
 		if (omap_usb_mode_needs_tll(pdata->port_mode[i])) {
 			if (!IS_ERR(tll->ch_clk[i]))
@@ -416,8 +401,6 @@ static int usbtll_runtime_suspend(struct device *dev)
 		}
 	}
 
-	spin_unlock_irqrestore(&tll->lock, flags);
-
 	return 0;
 }
 
@@ -439,21 +422,39 @@ static struct platform_driver usbtll_omap_driver = {
 
 int omap_tll_enable(void)
 {
+	int ret;
+
+	spin_lock(&tll_lock);
+
 	if (!tll_dev) {
 		pr_err("%s: OMAP USB TLL not initialized\n", __func__);
-		return  -ENODEV;
+		ret = -ENODEV;
+	} else {
+		ret = pm_runtime_get_sync(tll_dev);
 	}
-	return pm_runtime_get_sync(tll_dev);
+
+	spin_unlock(&tll_lock);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(omap_tll_enable);
 
 int omap_tll_disable(void)
 {
+	int ret;
+
+	spin_lock(&tll_lock);
+
 	if (!tll_dev) {
 		pr_err("%s: OMAP USB TLL not initialized\n", __func__);
-		return  -ENODEV;
+		ret = -ENODEV;
+	} else {
+		ret = pm_runtime_put_sync(tll_dev);
 	}
-	return pm_runtime_put_sync(tll_dev);
+
+	spin_unlock(&tll_lock);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(omap_tll_disable);
 
-- 
1.7.4.1

