Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032Ab3GCOEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:04:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59845 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932934Ab3GCOEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:04:42 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>
CC: <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <coelho@ti.com>, <nm@ti.com>
Subject: [PATCH v3 7/8] wlcore: sdio: get clocks from device tree
Date: Wed, 3 Jul 2013 17:03:28 +0300
Message-ID: <1372860209-3504-8-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372860209-3504-1-git-send-email-coelho@ti.com>
References: <1372860209-3504-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Read the clock nodes from the device tree and use them to set the
frequency for the refclock and the tcxo clock.

Also, call sdio_set_drvdata() earlier, so the glue is already set in
the driver data when we call wlcore_get_pdata_from_of() and we don't
need to pass it as a parameter.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 drivers/net/wireless/ti/wlcore/sdio.c |   36 +++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 980bf3d..60fce49 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -53,6 +53,7 @@ static bool dump = false;
 struct wl12xx_sdio_glue {
 	struct device *dev;
 	struct platform_device *core;
+	struct clk *refclock, *tcxoclock;
 };
 
 static const struct sdio_device_id wl1271_devices[] = {
@@ -224,6 +225,7 @@ static struct wl12xx_platform_data *wlcore_get_pdata_from_of(struct device *dev)
 	struct wl12xx_platform_data *pdata;
 	struct device_node *np = dev->of_node;
 	struct device_node *clock_node;
+	struct wl12xx_sdio_glue *glue = sdio_get_drvdata(dev_to_sdio_func(dev));
 
 	if (!np) {
 		np = of_find_matching_node(NULL, dev->driver->of_match_table);
@@ -250,6 +252,26 @@ static struct wl12xx_platform_data *wlcore_get_pdata_from_of(struct device *dev)
 	for_each_matching_node(clock_node, wlcore_sdio_of_clk_match_table)
 		of_fixed_clk_setup(clock_node);
 
+	/* TODO: make sure we have this when needed (ie. for WL6 and WL7) */
+	glue->refclock = of_clk_get_by_name(np, "refclock");
+	if (IS_ERR(glue->refclock)) {
+		dev_err(dev, "couldn't find refclock on the device tree\n");
+		glue->refclock = NULL;
+	} else {
+		clk_prepare_enable(glue->refclock);
+		pdata->ref_clock_freq = clk_get_rate(glue->refclock);
+	}
+
+	/* TODO: make sure we have this when needed (ie. for WL7) */
+	glue->tcxoclock = of_clk_get_by_name(np, "tcxoclock");
+	if (IS_ERR(glue->tcxoclock)) {
+		dev_err(dev, "couldn't find tcxoclock on the device tree\n");
+		glue->tcxoclock = NULL;
+	} else {
+		clk_prepare_enable(glue->tcxoclock);
+		pdata->ref_clock_freq = clk_get_rate(glue->tcxoclock);
+	}
+
 	goto out;
 
 out_free:
@@ -294,6 +316,8 @@ static int wl1271_probe(struct sdio_func *func,
 	/* Use block mode for transferring over one block size of data */
 	func->card->quirks |= MMC_QUIRK_BLKSZ_FOR_BYTE_MODE;
 
+	sdio_set_drvdata(func, glue);
+
 	/* The pdata allocated here is freed when the device is freed,
 	 * so we don't need an additional out label to free it in case
 	 * of error further on.
@@ -319,8 +343,6 @@ static int wl1271_probe(struct sdio_func *func,
 	if (mmcflags & MMC_PM_KEEP_POWER)
 		pdev_data->pwr_in_suspend = true;
 
-	sdio_set_drvdata(func, glue);
-
 	/* Tell PM core that we don't need the card to be powered now */
 	pm_runtime_put_noidle(&func->dev);
 
@@ -387,6 +409,16 @@ static void wl1271_remove(struct sdio_func *func)
 {
 	struct wl12xx_sdio_glue *glue = sdio_get_drvdata(func);
 
+	if (glue->refclock) {
+		clk_disable_unprepare(glue->refclock);
+		clk_put(glue->refclock);
+	}
+
+	if (glue->tcxoclock) {
+		clk_disable_unprepare(glue->tcxoclock);
+		clk_put(glue->tcxoclock);
+	}
+
 	/* Undo decrement done above in wl1271_probe */
 	pm_runtime_get_noresume(&func->dev);
 
-- 
1.7.10.4

