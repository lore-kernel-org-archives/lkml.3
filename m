Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab3GBO5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 10:57:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46270 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab3GBO4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 10:56:54 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>
CC: <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <coelho@ti.com>
Subject: [PATCH v2 9/9] wlcore/wl12xx: check if we got correct clock data from DT
Date: Tue, 2 Jul 2013 17:55:48 +0300
Message-ID: <1372776948-24840-10-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372776948-24840-1-git-send-email-coelho@ti.com>
References: <1372776948-24840-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fref and the tcxo clocks settings are optional in some platforms.
WiLink8 doesn't need either, so we don't check the values.  WiLink 6
only needs the fref clock, so we check that it is valid or return with
an error.  WiLink7 needs both clocks, if either is not available we
return with an error.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c |   20 +++++++++++++++++---
 drivers/net/wireless/ti/wlcore/sdio.c |    4 ----
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 903dcb3..72d13e4 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -927,6 +927,11 @@ static int wl128x_boot_clk(struct wl1271 *wl, int *selected_clock)
 	u16 sys_clk_cfg;
 	int ret;
 
+	if ((priv->ref_clock < 0) || (priv->tcxo_clock < 0)) {
+		wl1271_error("Missing fref and/or tcxo clock settings\n");
+		return -EINVAL;
+	}
+
 	/* For XTAL-only modes, FREF will be used after switching from TCXO */
 	if (priv->ref_clock == WL12XX_REFCLOCK_26_XTAL ||
 	    priv->ref_clock == WL12XX_REFCLOCK_38_XTAL) {
@@ -976,6 +981,11 @@ static int wl127x_boot_clk(struct wl1271 *wl)
 	u32 clk;
 	int ret;
 
+	if (priv->ref_clock < 0) {
+		wl1271_error("Missing fref clock settings\n");
+		return -EINVAL;
+	}
+
 	if (WL127X_PG_GET_MAJOR(wl->hw_pg_ver) < 3)
 		wl->quirks |= WLCORE_QUIRK_END_OF_TRANSACTION;
 
@@ -1757,7 +1767,7 @@ static int wl12xx_setup(struct wl1271 *wl)
 	wlcore_set_ht_cap(wl, IEEE80211_BAND_5GHZ, &wl12xx_ht_cap);
 	wl12xx_conf_init(wl);
 
-	if (!fref_param) {
+	if (!fref_param && (pdata->ref_clock_freq > 0)) {
 		priv->ref_clock = wl12xx_get_clock_idx(wl12xx_refclock_table,
 						       pdata->ref_clock_freq,
 						       pdata->ref_clock_xtal);
@@ -1768,6 +1778,8 @@ static int wl12xx_setup(struct wl1271 *wl)
 
 			return priv->ref_clock;
 		}
+	} else if (!fref_param) {
+		priv->ref_clock = -EINVAL;
 	} else {
 		if (!strcmp(fref_param, "19.2"))
 			priv->ref_clock = WL12XX_REFCLOCK_19;
@@ -1785,7 +1797,7 @@ static int wl12xx_setup(struct wl1271 *wl)
 			wl1271_error("Invalid fref parameter %s", fref_param);
 	}
 
-	if (!tcxo_param) {
+	if (!fref_param && (pdata->tcxo_clock_freq > 0)) {
 		priv->tcxo_clock = wl12xx_get_clock_idx(wl12xx_tcxoclock_table,
 							pdata->tcxo_clock_freq,
 							pdata->tcxo_clock_xtal);
@@ -1796,7 +1808,9 @@ static int wl12xx_setup(struct wl1271 *wl)
 
 			return priv->tcxo_clock;
 		}
-	} else {
+	} else if (!fref_param) {
+		priv->tcxo_clock = -EINVAL;
+	}else {
 		if (!strcmp(tcxo_param, "19.2"))
 			priv->tcxo_clock = WL12XX_TCXOCLOCK_19_2;
 		else if (!strcmp(tcxo_param, "26"))
diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 60fce49..c76eb66 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -252,20 +252,16 @@ static struct wl12xx_platform_data *wlcore_get_pdata_from_of(struct device *dev)
 	for_each_matching_node(clock_node, wlcore_sdio_of_clk_match_table)
 		of_fixed_clk_setup(clock_node);
 
-	/* TODO: make sure we have this when needed (ie. for WL6 and WL7) */
 	glue->refclock = of_clk_get_by_name(np, "refclock");
 	if (IS_ERR(glue->refclock)) {
-		dev_err(dev, "couldn't find refclock on the device tree\n");
 		glue->refclock = NULL;
 	} else {
 		clk_prepare_enable(glue->refclock);
 		pdata->ref_clock_freq = clk_get_rate(glue->refclock);
 	}
 
-	/* TODO: make sure we have this when needed (ie. for WL7) */
 	glue->tcxoclock = of_clk_get_by_name(np, "tcxoclock");
 	if (IS_ERR(glue->tcxoclock)) {
-		dev_err(dev, "couldn't find tcxoclock on the device tree\n");
 		glue->tcxoclock = NULL;
 	} else {
 		clk_prepare_enable(glue->tcxoclock);
-- 
1.7.10.4

