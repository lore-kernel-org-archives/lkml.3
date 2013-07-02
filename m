Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab3GBO4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 10:56:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51877 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab3GBO4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 10:56:32 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>
CC: <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <coelho@ti.com>
Subject: [PATCH v2 3/9] wlcore: remove pwr_in_suspend from platform data
Date: Tue, 2 Jul 2013 17:55:42 +0300
Message-ID: <1372776948-24840-4-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372776948-24840-1-git-send-email-coelho@ti.com>
References: <1372776948-24840-1-git-send-email-coelho@ti.com>
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
---
 drivers/net/wireless/ti/wlcore/main.c     |    2 +-
 drivers/net/wireless/ti/wlcore/sdio.c     |    2 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    1 +
 include/linux/wl12xx.h                    |    1 -
 4 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index e7294b8..d306cd5 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5941,7 +5941,7 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
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
index 04e3096..1e4ed6e 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -60,7 +60,6 @@ struct wl12xx_platform_data {
 	unsigned long irq_flags;
 	int board_ref_clock;
 	int board_tcxo_clock;
-	bool pwr_in_suspend;
 };
 
 #ifdef CONFIG_WILINK_PLATFORM_DATA
-- 
1.7.10.4

