Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbaAHHPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 02:15:49 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53273 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaAHHPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 02:15:41 -0500
From: Roger Quadros <rogerq@ti.com>
To: <lee.jones@linaro.org>
CC: <sameo@linux.intel.com>, <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <stable@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v2] mfd: omap-usb-tll: Don't hold lock during pm_runtime_get/put_sync()
Date: Wed, 8 Jan 2014 12:45:33 +0530
Message-ID: <1389165333-7573-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pm_runtime_get/put_sync() can sleep so don't hold spinlock while
calling them.

This patch prevents a BUG() during system suspend when
CONFIG_DEBUG_ATOMIC_SLEEP is enabled.

Bug is present in Kernel versions v3.9 onwards.

Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
Tested-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: <stable@vger.kernel.org> # 3.9+
---
 drivers/mfd/omap-usb-tll.c | 36 ++++++++++++------------------------
 1 file changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index 0d946ae1..c409be9 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -333,21 +333,17 @@ int omap_tll_init(struct usbhs_omap_platform_data *pdata)
 	unsigned reg;
 	struct usbtll_omap *tll;
 
-	spin_lock(&tll_lock);
-
-	if (!tll_dev) {
-		spin_unlock(&tll_lock);
+	if (!tll_dev)
 		return -ENODEV;
-	}
 
-	tll = dev_get_drvdata(tll_dev);
+	pm_runtime_get_sync(tll_dev);
 
+	spin_lock(&tll_lock);
+	tll = dev_get_drvdata(tll_dev);
 	needs_tll = false;
 	for (i = 0; i < tll->nch; i++)
 		needs_tll |= omap_usb_mode_needs_tll(pdata->port_mode[i]);
 
-	pm_runtime_get_sync(tll_dev);
-
 	if (needs_tll) {
 		void __iomem *base = tll->base;
 
@@ -398,9 +394,8 @@ int omap_tll_init(struct usbhs_omap_platform_data *pdata)
 		}
 	}
 
-	pm_runtime_put_sync(tll_dev);
-
 	spin_unlock(&tll_lock);
+	pm_runtime_put_sync(tll_dev);
 
 	return 0;
 }
@@ -411,17 +406,14 @@ int omap_tll_enable(struct usbhs_omap_platform_data *pdata)
 	int i;
 	struct usbtll_omap *tll;
 
-	spin_lock(&tll_lock);
-
-	if (!tll_dev) {
-		spin_unlock(&tll_lock);
+	if (!tll_dev)
 		return -ENODEV;
-	}
-
-	tll = dev_get_drvdata(tll_dev);
 
 	pm_runtime_get_sync(tll_dev);
 
+	spin_lock(&tll_lock);
+	tll = dev_get_drvdata(tll_dev);
+
 	for (i = 0; i < tll->nch; i++) {
 		if (omap_usb_mode_needs_tll(pdata->port_mode[i])) {
 			int r;
@@ -448,13 +440,10 @@ int omap_tll_disable(struct usbhs_omap_platform_data *pdata)
 	int i;
 	struct usbtll_omap *tll;
 
-	spin_lock(&tll_lock);
-
-	if (!tll_dev) {
-		spin_unlock(&tll_lock);
+	if (!tll_dev)
 		return -ENODEV;
-	}
 
+	spin_lock(&tll_lock);
 	tll = dev_get_drvdata(tll_dev);
 
 	for (i = 0; i < tll->nch; i++) {
@@ -464,9 +453,8 @@ int omap_tll_disable(struct usbhs_omap_platform_data *pdata)
 		}
 	}
 
-	pm_runtime_put_sync(tll_dev);
-
 	spin_unlock(&tll_lock);
+	pm_runtime_put_sync(tll_dev);
 
 	return 0;
 }
-- 
1.8.3.2

