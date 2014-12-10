Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbaLJPuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:50:39 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58053 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758003AbaLJPtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:49:20 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-b3-54886b7d62ca
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
Subject: [RFC 13/15] drm/exynos/dpi: convert to restrack API
Date: Wed, 10 Dec 2014 16:48:31 +0100
Message-id: <1418226513-14105-14-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
References: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t/xy7q12R0hBlsmyVncWneO1eLAi4Us
	FlMfPmGzmH8EyL3y9T2bxblXj1gsDvzZwWjRvHg9m8Wk+xNYLC487WGz+Halg8liyp/lTBab
	Hl9jtdg8/w+jxeVdc9gsZpzfx2Rx+zKvxdojd9ktnk64yGbRuvcIu8XPXfNYHEQ9Wpp72Dye
	bLrI6LFz1l12j02rOtk87lzbw+axf+4ado/73ceZPDYvqffo27KK0eP4je1MHp83yQVwR3HZ
	pKTmZJalFunbJXBlbLm5mblgnVnFyYWLmRsYj+h2MXJySAiYSNx8v48FwhaTuHBvPVsXIxeH
	kMBSRollOy8wQTh9TBJz76xjB6liE9CU+Lv5JhuILSKgI3G9p5sZpIhZYAO7xLrp+8ASwgI2
	Ei9+zgZrYBFQlVh59zgziM0r4CKxffsXJoh1chInj01mBbE5geJ/n+9lBLGFBJwllmx7zzqB
	kXcBI8MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJDo+LqDcekxq0OMAhyMSjy8OxTbQoRY
	E8uKK3MPMUpwMCuJ8C5M7ggR4k1JrKxKLcqPLyrNSS0+xMjEwSnVwKi9sdMwZvVJx2Xfc+at
	PzLdaMOnxQ/+hkXNfD27JPWRzOJL+ZFnjke2lt1Z2uYo96PLIvbPzF/34o7Wp3X9+lx+7y+f
	5ayG0rsOi7e2cPaeLn974p5DJNPUI/8n6m6bl5XKtXrvstdinGvMojzXarbH8ZRUsf56JOQc
	EecYtTtAX/o/M5tP3yQlluKMREMt5qLiRABqRwaQbAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exynos_dpi implements drm encoder and connector. Currently its probe
was defered if the associated panel was not yet present. It is inefficient
behavior - it could start normally with connector status set to disconnected
and notify drm about status change when panel appears/disapeears.
Unfortunately drm_panel API does not provide such notifications.
restrack solves the issue above.
After converting to restrack driver have following advantages:
- correctly handles removal of resources,
- do not need to defer probing, so as a result the whole drm system
  initialization will not be postponed to late initcall, unless other
  components delays it,
- it starts/stops tracking panel presence only when necessary.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_dpi.c  | 80 +++++++++++++++++++++++---------
 drivers/gpu/drm/exynos/exynos_drm_fimd.c |  7 +++
 2 files changed, 64 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_dpi.c b/drivers/gpu/drm/exynos/exynos_drm_dpi.c
index 91a29e1..75ee578 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dpi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dpi.c
@@ -13,9 +13,9 @@
 #include <drm/drmP.h>
 #include <drm/drm_crtc_helper.h>
 #include <drm/drm_panel.h>
-
 #include <linux/of_graph.h>
 #include <linux/regulator/consumer.h>
+#include <linux/restrack.h>
 
 #include <video/of_videomode.h>
 #include <video/videomode.h>
@@ -34,7 +34,6 @@ enum {
 struct exynos_dpi {
 	struct exynos_drm_display display;
 	struct device *dev;
-	struct device_node *panel_node;
 
 	struct drm_panel *panel;
 	struct drm_connector connector;
@@ -42,10 +41,13 @@ struct exynos_dpi {
 
 	struct videomode *vm;
 	int dpms_mode;
+	struct restrack_ctx *rtrack;
 };
 
 #define connector_to_dpi(c) container_of(c, struct exynos_dpi, connector)
 
+struct exynos_drm_display *fimd_dev_to_display(struct device *dev);
+
 static inline struct exynos_dpi *display_to_dpi(struct exynos_drm_display *d)
 {
 	return container_of(d, struct exynos_dpi, display);
@@ -56,14 +58,18 @@ exynos_dpi_detect(struct drm_connector *connector, bool force)
 {
 	struct exynos_dpi *ctx = connector_to_dpi(connector);
 
-	if (ctx->panel && !ctx->panel->connector)
-		drm_panel_attach(ctx->panel, &ctx->connector);
+	if (!ctx->vm && IS_ERR(ctx->panel))
+		return connector_status_disconnected;
 
 	return connector_status_connected;
 }
 
 static void exynos_dpi_connector_destroy(struct drm_connector *connector)
 {
+	struct exynos_dpi *ctx = connector_to_dpi(connector);
+
+	if (!IS_ERR(ctx->rtrack))
+		restrack_unregister(ctx->rtrack);
 	drm_connector_unregister(connector);
 	drm_connector_cleanup(connector);
 }
@@ -94,7 +100,7 @@ static int exynos_dpi_get_modes(struct drm_connector *connector)
 		return 1;
 	}
 
-	if (ctx->panel)
+	if (!IS_ERR(ctx->panel))
 		return ctx->panel->funcs->get_modes(ctx->panel);
 
 	return 0;
@@ -113,6 +119,38 @@ static struct drm_connector_helper_funcs exynos_dpi_connector_helper_funcs = {
 	.best_encoder = exynos_dpi_best_encoder,
 };
 
+static void exynos_dpi_dpms(struct exynos_drm_display *display, int mode);
+
+void exynos_dpi_notifier(struct device *dev, int ret)
+{
+	struct exynos_drm_display *display = fimd_dev_to_display(dev);
+	struct exynos_dpi *ctx = display_to_dpi(display);
+	struct drm_connector *connector = &ctx->connector;
+	struct drm_device *drm_dev = connector->dev;
+	bool poll_enabled = drm_dev->mode_config.poll_enabled;
+
+	mutex_lock(&drm_dev->mode_config.mutex);
+
+	if (ret == 0) {
+		drm_panel_attach(ctx->panel, connector);
+	} else if (ret == -EPROBE_DEFER) {
+		exynos_dpi_dpms(&ctx->display, DRM_MODE_DPMS_OFF);
+		drm_panel_detach(ctx->panel);
+		ctx->panel = ERR_PTR(-EPROBE_DEFER);
+	} else {
+		dev_err(dev, "restrack error %d\n", ret);
+		poll_enabled = false;
+	}
+
+	if (poll_enabled)
+		connector->status = exynos_dpi_detect(connector, true);
+
+	mutex_unlock(&drm_dev->mode_config.mutex);
+
+	if (poll_enabled)
+		drm_kms_helper_hotplug_event(drm_dev);
+}
+
 static int exynos_dpi_create_connector(struct exynos_drm_display *display,
 				       struct drm_encoder *encoder)
 {
@@ -136,12 +174,23 @@ static int exynos_dpi_create_connector(struct exynos_drm_display *display,
 	drm_connector_register(connector);
 	drm_mode_connector_attach_encoder(connector, encoder);
 
+	if (ctx->vm)
+		return 0;
+
+	ctx->rtrack = restrack_register(ctx->dev, exynos_dpi_notifier,
+		drm_panel_restrack_desc(&ctx->panel, NULL, FIMD_PORT_RGB)
+	);
+
+	if (IS_ERR(ctx->rtrack))
+		DRM_ERROR("error installing panel tracker: %ld\n",
+			  PTR_ERR(ctx->rtrack));
+
 	return 0;
 }
 
 static void exynos_dpi_poweron(struct exynos_dpi *ctx)
 {
-	if (ctx->panel) {
+	if (!IS_ERR(ctx->panel)) {
 		drm_panel_prepare(ctx->panel);
 		drm_panel_enable(ctx->panel);
 	}
@@ -149,7 +198,7 @@ static void exynos_dpi_poweron(struct exynos_dpi *ctx)
 
 static void exynos_dpi_poweroff(struct exynos_dpi *ctx)
 {
-	if (ctx->panel) {
+	if (!IS_ERR(ctx->panel)) {
 		drm_panel_disable(ctx->panel);
 		drm_panel_unprepare(ctx->panel);
 	}
@@ -217,10 +266,9 @@ static int exynos_dpi_parse_dt(struct exynos_dpi *ctx)
 		if (ep.port != FIMD_PORT_RGB)
 			continue;
 
-		ctx->panel_node = of_graph_get_remote_port_parent(np);
 		of_node_put(np);
 
-		return ctx->panel_node ? 0 : -EINVAL;
+		return 0;
 	}
 
 	return -EINVAL;
@@ -252,15 +300,6 @@ struct exynos_drm_display *exynos_dpi_probe(struct device *dev)
 		goto err_del_component;
 	}
 
-	if (ctx->panel_node) {
-		ctx->panel = of_drm_find_panel(ctx->panel_node);
-		if (!ctx->panel) {
-			exynos_drm_component_del(dev,
-						EXYNOS_DEVICE_TYPE_CONNECTOR);
-			return ERR_PTR(-EPROBE_DEFER);
-		}
-	}
-
 	return &ctx->display;
 
 err_del_component:
@@ -273,11 +312,6 @@ int exynos_dpi_remove(struct exynos_drm_display *display)
 {
 	struct exynos_dpi *ctx = display_to_dpi(display);
 
-	exynos_dpi_dpms(&ctx->display, DRM_MODE_DPMS_OFF);
-
-	if (ctx->panel)
-		drm_panel_detach(ctx->panel);
-
 	exynos_drm_component_del(ctx->dev, EXYNOS_DEVICE_TYPE_CONNECTOR);
 
 	return 0;
diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index e5810d1..05cf4e2 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -190,6 +190,13 @@ static inline struct fimd_context *mgr_to_fimd(struct exynos_drm_manager *mgr)
 	return container_of(mgr, struct fimd_context, manager);
 }
 
+struct exynos_drm_display *fimd_dev_to_display(struct device *dev)
+{
+	struct fimd_context *ctx = dev_get_drvdata(dev);
+
+	return ctx->display;
+}
+
 static const struct of_device_id fimd_driver_dt_match[] = {
 	{ .compatible = "samsung,s3c6400-fimd",
 	  .data = &s3c64xx_fimd_driver_data },
-- 
1.9.1

