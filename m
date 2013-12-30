Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab3L3QTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 11:19:39 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:61621 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab3L3QTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 11:19:37 -0500
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: tomi.valkeinen@ti.com
Cc: plagnioj@jcrosoft.com, pali.rohar@gmail.com, pavel@ucw.cz,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: [PATCH] ARM: OMAPFB: panel-sony-acx565akm: fix missing mutex unlocks
Date: Mon, 30 Dec 2013 18:17:52 +0200
Message-Id: <1388420272-5132-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
X-Mailer: git-send-email 1.8.4.msysgit.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ivaylo Dimitrov <freemangordon@abv.bg>

Commit c37dd677988ca50bc8bc60ab5ab053720583c168 fixes the unbalanced
unlock in acx565akm_enable but introduces another problem - if
acx565akm_panel_power_on exits early, the mutex is not unlocked. Fix
that by unlocking the mutex on early return. Also add mutex protection in
acx565akm_panel_power_off and remove an unused variable

Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>
---
 .../omap2/displays-new/panel-sony-acx565akm.c      |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/video/omap2/displays-new/panel-sony-acx565akm.c b/drivers/video/omap2/displays-new/panel-sony-acx565akm.c
index d94f35d..a093d3a 100644
--- a/drivers/video/omap2/displays-new/panel-sony-acx565akm.c
+++ b/drivers/video/omap2/displays-new/panel-sony-acx565akm.c
@@ -535,6 +535,7 @@ static int acx565akm_panel_power_on(struct omap_dss_device *dssdev)
 
 	r = in->ops.sdi->enable(in);
 	if (r) {
+		mutex_unlock(&ddata->mutex);
 		pr_err("%s sdi enable failed\n", __func__);
 		return r;
 	}
@@ -546,6 +547,7 @@ static int acx565akm_panel_power_on(struct omap_dss_device *dssdev)
 		gpio_set_value(ddata->reset_gpio, 1);
 
 	if (ddata->enabled) {
+		mutex_unlock(&ddata->mutex);
 		dev_dbg(&ddata->spi->dev, "panel already enabled\n");
 		return 0;
 	}
@@ -578,10 +580,14 @@ static void acx565akm_panel_power_off(struct omap_dss_device *dssdev)
 	struct panel_drv_data *ddata = to_panel_data(dssdev);
 	struct omap_dss_device *in = ddata->in;
 
+	mutex_lock(&ddata->mutex);
+
 	dev_dbg(dssdev->dev, "%s\n", __func__);
 
-	if (!ddata->enabled)
+	if (!ddata->enabled) {
+		mutex_unlock(&ddata->mutex);
 		return;
+	}
 
 	set_display_state(ddata, 0);
 	set_sleep_mode(ddata, 1);
@@ -601,11 +607,13 @@ static void acx565akm_panel_power_off(struct omap_dss_device *dssdev)
 	msleep(100);
 
 	in->ops.sdi->disable(in);
+
+	mutex_unlock(&ddata->mutex);
+
 }
 
 static int acx565akm_enable(struct omap_dss_device *dssdev)
 {
-	struct panel_drv_data *ddata = to_panel_data(dssdev);
 	int r;
 
 	dev_dbg(dssdev->dev, "%s\n", __func__);
-- 
1.5.6.1

