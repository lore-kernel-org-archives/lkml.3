Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab3G3NFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:05:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41453 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab3G3NFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:05:36 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>
CC: <coelho@ti.com>, <luca@coelho.fi>, <mturquette@linaro.org>,
        <mark.rutland@arm.com>, <balbi@ti.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <nm@ti.com>, <martinez.javier@gmail.com>
Subject: [PATCH v4 3/8] wlcore: remove pwr_in_suspend from platform data
Date: Tue, 30 Jul 2013 16:04:31 +0300
Message-ID: <1375189476-21557-4-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375189476-21557-1-git-send-email-coelho@ti.com>
References: <1375189476-21557-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pwr_in_suspend flag depends on the MMC settings which can be
retrieved from the SDIO subsystem, so it doesn't need to be part of
the platform data structure.  Move it to the platform device data that
is passed from SDIO to wlcore.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c     | 3 +--
 drivers/net/wireless/ti/wlcore/sdio.c     | 2 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h | 1 +
 include/linux/wl12xx.h                    | 1 -
 4 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 11dab9a..e771de0 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5900,7 +5900,6 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 	struct wl1271 *wl = context;
 	struct platform_device *pdev = wl->pdev;
 	struct wlcore_platdev_data *pdev_data = pdev->dev.platform_data;
-	struct wl12xx_platform_data *pdata = pdev_data->pdata;
 
 	int ret;
 
@@ -5947,7 +5946,7 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 	if (!ret) {
 		wl->irq_wake_enabled = true;
 		device_init_wakeup(wl->dev, 1);
-		if (pdata->pwr_in_suspend)
+		if (pdev_data->pwr_in_suspend)
 			wl->hw->wiphy->wowlan = &wlcore_wowlan_support;
 	}
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 29ef249..4c7e8ac 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -260,7 +260,7 @@ static int wl1271_probe(struct sdio_func *func,
 	dev_dbg(glue->dev, "sdio PM caps = 0x%x\n", mmcflags);
 
 	if (mmcflags & MMC_PM_KEEP_POWER)
-		pdev_data->pdata->pwr_in_suspend = true;
+		pdev_data->pwr_in_suspend = true;
 
 	sdio_set_drvdata(func, glue);
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index e5e1464..f2c4227 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -209,6 +209,7 @@ struct wl1271_if_operations {
 struct wlcore_platdev_data {
 	struct wl12xx_platform_data *pdata;
 	struct wl1271_if_operations *if_ops;
+	bool pwr_in_suspend;
 };
 
 #define MAX_NUM_KEYS 14
diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
index 1bfcd19..ab90b1c 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -59,7 +59,6 @@ struct wl12xx_platform_data {
 	int irq;
 	int board_ref_clock;
 	int board_tcxo_clock;
-	bool pwr_in_suspend;
 };
 
 #ifdef CONFIG_WILINK_PLATFORM_DATA
-- 
1.8.3.2

