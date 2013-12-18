Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab3LRKCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:02:04 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41947 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab3LRKB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:01:59 -0500
From: Roger Quadros <rogerq@ti.com>
To: <lee.jones@linaro.org>, <sameo@linux.intel.com>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>, <stable@vger.kernel.org>
Subject: [PATCH] mfd: omap-usb-tll: Don't hold lock during pm_runtime_get/put_sync()
Date: Wed, 18 Dec 2013 15:31:49 +0530
Message-ID: <1387360909-10624-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pm_runtime_get/put_sync() can sleep so don't hold spinlock while
calling them.

This patch prevents a BUG() when CONFIG_DEBUG_ATOMIC_SLEEP is enabled.
Bug is present in Kernel versions v3.9 onwards.

Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
Tested-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: <stable@vger.kernel.org> # 3.9+
---
 drivers/mfd/omap-usb-tll.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index 0d946ae1..248004c 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -346,7 +346,9 @@ int omap_tll_init(struct usbhs_omap_platform_data *pdata)
 	for (i = 0; i < tll->nch; i++)
 		needs_tll |= omap_usb_mode_needs_tll(pdata->port_mode[i]);
 
+	spin_unlock(&tll_lock);
 	pm_runtime_get_sync(tll_dev);
+	spin_lock(&tll_lock);
 
 	if (needs_tll) {
 		void __iomem *base = tll->base;
@@ -398,9 +400,8 @@ int omap_tll_init(struct usbhs_omap_platform_data *pdata)
 		}
 	}
 
-	pm_runtime_put_sync(tll_dev);
-
 	spin_unlock(&tll_lock);
+	pm_runtime_put_sync(tll_dev);
 
 	return 0;
 }
@@ -420,7 +421,9 @@ int omap_tll_enable(struct usbhs_omap_platform_data *pdata)
 
 	tll = dev_get_drvdata(tll_dev);
 
+	spin_unlock(&tll_lock);
 	pm_runtime_get_sync(tll_dev);
+	spin_lock(&tll_lock);
 
 	for (i = 0; i < tll->nch; i++) {
 		if (omap_usb_mode_needs_tll(pdata->port_mode[i])) {
@@ -438,7 +441,6 @@ int omap_tll_enable(struct usbhs_omap_platform_data *pdata)
 	}
 
 	spin_unlock(&tll_lock);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(omap_tll_enable);
@@ -464,9 +466,8 @@ int omap_tll_disable(struct usbhs_omap_platform_data *pdata)
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

