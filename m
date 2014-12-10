Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbaLJPvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:51:06 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56612 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758044AbaLJPtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:49:14 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-a3-54886b7807f9
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-kernel@vger.kernel.org (open list)
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/CLKDEV SUPPORT),
        linux-gpio@vger.kernel.org (open list:GPIO SUBSYSTEM),
        dri-devel@lists.freedesktop.org (open list:DRM PANEL DRIVERS),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        boris.brezillon@free-electrons.com
Subject: [RFC 10/15] drm/exynos/dsi: simplify hotplug code
Date: Wed, 10 Dec 2014 16:48:28 +0100
Message-id: <1418226513-14105-11-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
References: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xy7oV2R0hBl1rRSxurTvHanHgxUIW
	i6kPn7BZzD8C5F75+p7N4tyrRywWB/7sYLRoXryezWLS/QksFhee9rBZfLvSwWQx5c9yJotN
	j6+xWmye/4fR4vKuOWwWM87vY7K4fZnXYu2Ru+wWTydcZLNo3XuE3eLnrnksDqIeLc09bB5P
	Nl1k9Ng56y67x6ZVnWwed67tYfPYP3cNu8f97uNMHpuX1Hv0bVnF6HH8xnYmj8+b5AK4o7hs
	UlJzMstSi/TtErgyjp2/zlpwU6nizjzVBsb/Ml2MHBwSAiYSk/dHdzFyApliEhfurWfrYuTi
	EBJYyigxcWsjM0hCSKCPSWLpazCbTUBT4u/mm2wgtoiAjsT1nm5mkAZmgQ3sEuum7wNLCAtY
	SbQu+8wOYrMIqEqs/v4OLM4r4CJx6eFDVohtchInj00GszmB4n+f72WEWOYssWTbe9YJjLwL
	GBlWMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoTExdcdjEuPWR1iFOBgVOLh3aHYFiLEmlhW
	XJl7iFGCg1lJhHdhckeIEG9KYmVValF+fFFpTmrxIUYmDk6pBsaioqlH5Y4pr+kV7NweNklR
	eP31kORfDGnvAgSeLo8+bmT0IdrP5WXp/tzE2ypSRytv1Cc1e06eJS7oKPPWWO9w2sfJd788
	s90l1+vI/Xhj8F2VKDkBjz+LEpx/20Wel7Zcye11vIzjnGDBPaNZby+u3mzZmi/7fpNN69Lk
	otAdSz8c6OQ/Kq7EUpyRaKjFXFScCAC3RtjxaQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos DSI driver uses DSI bus attach/detach callbacks to implement
panel hotplug mechanism. The patch moves panel attachment code
from .detect callback to DSI bus callbacks. It makes the code
simpler and more straightforward.
The patch removes also redundant and lock unprotected dpms_off call
from unbind code.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_dsi.c | 61 ++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_dsi.c b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
index 05fe93d..8201d79 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dsi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
@@ -271,7 +271,6 @@ struct exynos_dsi {
 	struct exynos_drm_display display;
 	struct mipi_dsi_host dsi_host;
 	struct drm_connector connector;
-	struct device_node *panel_node;
 	struct drm_panel *panel;
 	struct device *dev;
 
@@ -1154,10 +1153,11 @@ static int exynos_dsi_init(struct exynos_dsi *dsi)
 
 static int exynos_dsi_register_te_irq(struct exynos_dsi *dsi)
 {
+	struct device_node *panel_node = dsi->panel->dev->of_node;
 	int ret;
 	int te_gpio_irq;
 
-	dsi->te_gpio = of_get_named_gpio(dsi->panel_node, "te-gpios", 0);
+	dsi->te_gpio = of_get_named_gpio(panel_node, "te-gpios", 0);
 	if (!gpio_is_valid(dsi->te_gpio)) {
 		dev_err(dsi->dev, "no te-gpios specified\n");
 		ret = dsi->te_gpio;
@@ -1198,11 +1198,25 @@ static int exynos_dsi_host_attach(struct mipi_dsi_host *host,
 				  struct mipi_dsi_device *device)
 {
 	struct exynos_dsi *dsi = host_to_dsi(host);
+	struct drm_device *drm_dev = dsi->connector.dev;
+	bool changed = false;
 
 	dsi->lanes = device->lanes;
 	dsi->format = device->format;
 	dsi->mode_flags = device->mode_flags;
-	dsi->panel_node = device->dev.of_node;
+
+	mutex_lock(&drm_dev->mode_config.mutex);
+
+	dsi->panel = of_drm_find_panel(device->dev.of_node);
+	if (dsi->panel) {
+		drm_panel_attach(dsi->panel, &dsi->connector);
+		if (drm_dev->mode_config.poll_enabled) {
+			dsi->connector.status = connector_status_connected;
+			changed = true;
+		}
+	}
+
+	mutex_unlock(&drm_dev->mode_config.mutex);
 
 	/*
 	 * This is a temporary solution and should be made by more generic way.
@@ -1217,8 +1231,8 @@ static int exynos_dsi_host_attach(struct mipi_dsi_host *host,
 			return ret;
 	}
 
-	if (dsi->connector.dev)
-		drm_helper_hpd_irq_event(dsi->connector.dev);
+	if (changed)
+		drm_kms_helper_hotplug_event(drm_dev);
 
 	return 0;
 }
@@ -1227,13 +1241,29 @@ static int exynos_dsi_host_detach(struct mipi_dsi_host *host,
 				  struct mipi_dsi_device *device)
 {
 	struct exynos_dsi *dsi = host_to_dsi(host);
+	struct drm_device *drm_dev = dsi->connector.dev;
+	struct exynos_drm_display *display = dev_get_drvdata(dsi->dev);
+	bool changed = false;
 
 	exynos_dsi_unregister_te_irq(dsi);
 
-	dsi->panel_node = NULL;
+	mutex_lock(&drm_dev->mode_config.mutex);
+
+	display->ops->dpms(display, DRM_MODE_DPMS_OFF);
+
+	if (dsi->panel) {
+		drm_panel_detach(dsi->panel);
+		dsi->panel = NULL;
+		if (drm_dev->mode_config.poll_enabled) {
+			dsi->connector.status = connector_status_disconnected;
+			changed = true;
+		}
+	}
+
+	mutex_unlock(&drm_dev->mode_config.mutex);
 
-	if (dsi->connector.dev)
-		drm_helper_hpd_irq_event(dsi->connector.dev);
+	if (changed)
+		drm_kms_helper_hotplug_event(drm_dev);
 
 	return 0;
 }
@@ -1430,19 +1460,6 @@ exynos_dsi_detect(struct drm_connector *connector, bool force)
 {
 	struct exynos_dsi *dsi = connector_to_dsi(connector);
 
-	if (!dsi->panel) {
-		dsi->panel = of_drm_find_panel(dsi->panel_node);
-		if (dsi->panel)
-			drm_panel_attach(dsi->panel, &dsi->connector);
-	} else if (!dsi->panel_node) {
-		struct exynos_drm_display *display;
-
-		display = platform_get_drvdata(to_platform_device(dsi->dev));
-		exynos_dsi_dpms(display, DRM_MODE_DPMS_OFF);
-		drm_panel_detach(dsi->panel);
-		dsi->panel = NULL;
-	}
-
 	if (dsi->panel)
 		return connector_status_connected;
 
@@ -1665,8 +1682,6 @@ static void exynos_dsi_unbind(struct device *dev, struct device *master,
 	struct exynos_drm_display *display = dev_get_drvdata(dev);
 	struct exynos_dsi *dsi = display_to_dsi(display);
 
-	exynos_dsi_dpms(display, DRM_MODE_DPMS_OFF);
-
 	mipi_dsi_host_unregister(&dsi->dsi_host);
 }
 
-- 
1.9.1

