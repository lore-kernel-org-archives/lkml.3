Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab3DYNqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:46:50 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33666 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042Ab3DYNqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:46:49 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Russell King <rmk@arm.linux.org.uk>, J Keerthy <j-keerthy@ti.com>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: [PATCH 1/1] staging: ti-soc-thermal: remove usage of IS_ERR_OR_NULL
Date: Thu, 25 Apr 2013 09:46:16 -0400
Message-ID: <1366897576-20423-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the driver to avoid the usage of IS_ERR_OR_NULL()
macro. This macro can lead to dangerous results, like returning
success (0) during a failure scenario (NULL pointer handling).

For this reason this patch is changing the driver after
revisiting the code. These are the cases:
i. For cases in which IS_ERR_OR_NULL() is used for checking
return values of functions that returns either PTR_ERR()
or a valid pointer, it has been translated to IS_ERR() check only.
ii. For cases that a NULL check is still needed, it has been
translated to if (!ptr || IS_ERR(ptr)).

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: J Keerthy <j-keerthy@ti.com>
Cc: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/ti-soc-thermal/ti-bandgap.c        |  8 ++++----
 drivers/staging/ti-soc-thermal/ti-thermal-common.c | 15 ++++++++-------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/ti-soc-thermal/ti-bandgap.c b/drivers/staging/ti-soc-thermal/ti-bandgap.c
index f20c1cf..5027833 100644
--- a/drivers/staging/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/staging/ti-soc-thermal/ti-bandgap.c
@@ -469,7 +469,7 @@ static inline int ti_bandgap_validate(struct ti_bandgap *bgp, int id)
 {
 	int ret = 0;
 
-	if (IS_ERR_OR_NULL(bgp)) {
+	if (!bgp || IS_ERR(bgp)) {
 		pr_err("%s: invalid bandgap pointer\n", __func__);
 		ret = -EINVAL;
 		goto exit;
@@ -1191,7 +1191,7 @@ int ti_bandgap_probe(struct platform_device *pdev)
 	int clk_rate, ret = 0, i;
 
 	bgp = ti_bandgap_build(pdev);
-	if (IS_ERR_OR_NULL(bgp)) {
+	if (IS_ERR(bgp)) {
 		dev_err(&pdev->dev, "failed to fetch platform data\n");
 		return PTR_ERR(bgp);
 	}
@@ -1207,14 +1207,14 @@ int ti_bandgap_probe(struct platform_device *pdev)
 	}
 
 	bgp->fclock = clk_get(NULL, bgp->conf->fclock_name);
-	ret = IS_ERR_OR_NULL(bgp->fclock);
+	ret = IS_ERR(bgp->fclock);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to request fclock reference\n");
 		goto free_irqs;
 	}
 
 	bgp->div_clk = clk_get(NULL,  bgp->conf->div_ck_name);
-	ret = IS_ERR_OR_NULL(bgp->div_clk);
+	ret = IS_ERR(bgp->div_clk);
 	if (ret) {
 		dev_err(&pdev->dev,
 			"failed to request div_ts_ck clock ref\n");
diff --git a/drivers/staging/ti-soc-thermal/ti-thermal-common.c b/drivers/staging/ti-soc-thermal/ti-thermal-common.c
index 8e67ebf..4c5f55c37 100644
--- a/drivers/staging/ti-soc-thermal/ti-thermal-common.c
+++ b/drivers/staging/ti-soc-thermal/ti-thermal-common.c
@@ -101,7 +101,7 @@ static inline int ti_thermal_get_temp(struct thermal_zone_device *thermal,
 
 	pcb_tz = data->pcb_tz;
 	/* In case pcb zone is available, use the extrapolation rule with it */
-	if (!IS_ERR_OR_NULL(pcb_tz)) {
+	if (!IS_ERR(pcb_tz)) {
 		ret = thermal_zone_get_temp(pcb_tz, &pcb_temp);
 		if (!ret) {
 			tmp -= pcb_temp; /* got a valid PCB temp */
@@ -124,7 +124,7 @@ static int ti_thermal_bind(struct thermal_zone_device *thermal,
 	struct ti_thermal_data *data = thermal->devdata;
 	int id;
 
-	if (IS_ERR_OR_NULL(data))
+	if (!data || IS_ERR(data))
 		return -ENODEV;
 
 	/* check if this is the cooling device we registered */
@@ -146,7 +146,7 @@ static int ti_thermal_unbind(struct thermal_zone_device *thermal,
 {
 	struct ti_thermal_data *data = thermal->devdata;
 
-	if (IS_ERR_OR_NULL(data))
+	if (!data || IS_ERR(data))
 		return -ENODEV;
 
 	/* check if this is the cooling device we registered */
@@ -282,6 +282,7 @@ static struct ti_thermal_data
 	data->sensor_id = id;
 	data->bgp = bgp;
 	data->mode = THERMAL_DEVICE_ENABLED;
+	/* pcb_tz will be either valid or PTR_ERR() */
 	data->pcb_tz = thermal_zone_get_zone_by_name("pcb");
 	INIT_WORK(&data->thermal_wq, ti_thermal_work);
 
@@ -295,7 +296,7 @@ int ti_thermal_expose_sensor(struct ti_bandgap *bgp, int id,
 
 	data = ti_bandgap_get_sensor_data(bgp, id);
 
-	if (IS_ERR_OR_NULL(data))
+	if (!data || IS_ERR(data))
 		data = ti_thermal_build_data(bgp, id);
 
 	if (!data)
@@ -306,7 +307,7 @@ int ti_thermal_expose_sensor(struct ti_bandgap *bgp, int id,
 				OMAP_TRIP_NUMBER, 0, data, &ti_thermal_ops,
 				NULL, FAST_TEMP_MONITORING_RATE,
 				FAST_TEMP_MONITORING_RATE);
-	if (IS_ERR_OR_NULL(data->ti_thermal)) {
+	if (IS_ERR(data->ti_thermal)) {
 		dev_err(bgp->dev, "thermal zone device is NULL\n");
 		return PTR_ERR(data->ti_thermal);
 	}
@@ -343,7 +344,7 @@ int ti_thermal_register_cpu_cooling(struct ti_bandgap *bgp, int id)
 	struct ti_thermal_data *data;
 
 	data = ti_bandgap_get_sensor_data(bgp, id);
-	if (IS_ERR_OR_NULL(data))
+	if (!data || IS_ERR(data))
 		data = ti_thermal_build_data(bgp, id);
 
 	if (!data)
@@ -356,7 +357,7 @@ int ti_thermal_register_cpu_cooling(struct ti_bandgap *bgp, int id)
 
 	/* Register cooling device */
 	data->cool_dev = cpufreq_cooling_register(cpu_present_mask);
-	if (IS_ERR_OR_NULL(data->cool_dev)) {
+	if (IS_ERR(data->cool_dev)) {
 		dev_err(bgp->dev,
 			"Failed to register cpufreq cooling device\n");
 		return PTR_ERR(data->cool_dev);
-- 
1.8.2.1.342.gfa7285d

