Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205AbaAENOw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 08:14:52 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:49966 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaAENOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 08:14:50 -0500
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: tomi.valkeinen@ti.com
Cc: plagnioj@jcrosoft.com, pali.rohar@gmail.com, pavel@ucw.cz,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: [PATCH v2] ARM: OMAPFB: panel-sony-acx565akm: fix missing mutex unlocks
Date: Sun,  5 Jan 2014 15:13:05 +0200
Message-Id: <1388927585-5640-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
X-Mailer: git-send-email 1.8.4.msysgit.0
In-Reply-To: <52C956E9.2030008@gmail.com>
References: <52C956E9.2030008@gmail.com>
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
 .../omap2/displays-new/panel-sony-acx565akm.c      |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/video/omap2/displays-new/panel-sony-acx565akm.c b/drivers/video/omap2/displays-new/panel-sony-acx565akm.c
index d94f35d..9aef7fa 100644
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
@@ -627,16 +635,12 @@ static int acx565akm_enable(struct omap_dss_device *dssdev)
 
 static void acx565akm_disable(struct omap_dss_device *dssdev)
 {
-	struct panel_drv_data *ddata = to_panel_data(dssdev);
-
 	dev_dbg(dssdev->dev, "%s\n", __func__);
 
 	if (!omapdss_device_is_enabled(dssdev))
 		return;
 
-	mutex_lock(&ddata->mutex);
 	acx565akm_panel_power_off(dssdev);
-	mutex_unlock(&ddata->mutex);
 
 	dssdev->state = OMAP_DSS_DISPLAY_DISABLED;
 }
-- 
1.5.6.1

