Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614AbaLJP5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:57:53 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56581 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757594AbaLJPtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:49:01 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-6d-54886b6abc99
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
Subject: [RFC 03/15] drm/panel: add restrack support
Date: Wed, 10 Dec 2014 16:48:21 +0100
Message-id: <1418226513-14105-4-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
References: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t/xy7pZ2R0hBj+e6VvcWneO1eLAi4Us
	FlMfPmGzmH8EyL3y9T2bxblXj1gsDvzZwWjRvHg9m8Wk+xNYLC487WGz+Halg8liyp/lTBab
	Hl9jtdg8/w+jxeVdc9gsZpzfx2Rx+zKvxdojd9ktnk64yGbRuvcIu8XPXfNYHEQ9Wpp72Dye
	bLrI6LFz1l12j02rOtk87lzbw+axf+4ado/73ceZPDYvqffo27KK0eP4je1MHp83yQVwR3HZ
	pKTmZJalFunbJXBlHO/fzFZwWK2iceEDlgbGBQpdjJwcEgImEtdnTWKBsMUkLtxbz9bFyMUh
	JLCUUeLyn9esEE4fk8SXT21sIFVsApoSfzffBLNFBHQkrvd0M4MUMQtsYJdYN30fWEIYaOzV
	OafAxrIIqEosP/AUzOYVcJY49OknO8Q6OYmTxyazgticAi4Sf5/vZQSxhYBqlmx7zzqBkXcB
	I8MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJDo+LqDcekxq0OMAhyMSjy8OxTbQoRYE8uK
	K3MPMUpwMCuJ8C5M7ggR4k1JrKxKLcqPLyrNSS0+xMjEwSnVwNi3/524/MNzNt9mMMzgts3h
	WnjijACv090ND6Udq02+zZC0/lWe39n32Ka8vqP0ReWTig0Pvft2cHzr3SKc8E3p2MlZcx9n
	yLvEf+tRs9vSFBDBy8Fa+knmXmx0T3hL1Ss+rqduFheM8kuCZs6U2SM3/eO6hy9680773q/T
	+cbTxpZk8OdatxJLcUaioRZzUXEiAM6QgyhsAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds Device Tree restrack support to drm/panel framework.
As panels supports only Device Tree based lookup all panels can be
converted to restrack.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/drm_panel.c | 97 +++++++++++++++++++++++++++++++++++++++++++++
 include/drm/drm_panel.h     |  4 ++
 include/linux/restrack.h    |  2 +
 3 files changed, 103 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel.c b/drivers/gpu/drm/drm_panel.c
index 2ef988e..db04696 100644
--- a/drivers/gpu/drm/drm_panel.c
+++ b/drivers/gpu/drm/drm_panel.c
@@ -22,7 +22,9 @@
  */
 
 #include <linux/err.h>
+#include <linux/of_graph.h>
 #include <linux/module.h>
+#include <linux/restrack.h>
 
 #include <drm/drm_crtc.h>
 #include <drm/drm_panel.h>
@@ -41,6 +43,7 @@ int drm_panel_add(struct drm_panel *panel)
 	mutex_lock(&panel_lock);
 	list_add_tail(&panel->list, &panel_list);
 	mutex_unlock(&panel_lock);
+	restrack_up(RESTRACK_TYPE_DRM_PANEL, panel->dev->of_node, panel);
 
 	return 0;
 }
@@ -48,6 +51,7 @@ EXPORT_SYMBOL(drm_panel_add);
 
 void drm_panel_remove(struct drm_panel *panel)
 {
+	restrack_down(RESTRACK_TYPE_DRM_PANEL, panel->dev->of_node, panel);
 	mutex_lock(&panel_lock);
 	list_del_init(&panel->list);
 	mutex_unlock(&panel_lock);
@@ -93,6 +97,99 @@ struct drm_panel *of_drm_find_panel(struct device_node *np)
 	return NULL;
 }
 EXPORT_SYMBOL(of_drm_find_panel);
+
+struct drm_panel_restrack_desc {
+	struct drm_panel **ptr;
+	const char *name;
+	int port;
+	struct restrack_desc desc;
+};
+
+static int drm_panel_restrack_init(struct device *dev,
+		struct restrack_desc *desc)
+{
+	struct drm_panel_restrack_desc *rd = restrack_desc_to_rd(rd, desc);
+	struct device_node *np;
+
+	if (rd->name) {
+		desc->if_id = of_parse_phandle(dev->of_node, rd->name, 0);
+		goto end;
+	}
+
+	np = NULL;
+	while ((np = of_graph_get_next_endpoint(dev->of_node, np))) {
+		struct of_endpoint ep;
+
+		of_graph_parse_endpoint(np, &ep);
+		if (ep.port != rd->port)
+			continue;
+		desc->if_id = of_graph_get_remote_port_parent(np);
+		of_node_put(np);
+		break;
+	}
+
+end:
+	return desc->if_id ? 0 : -EINVAL;
+}
+
+static void drm_panel_restrack_destroy(struct device *dev,
+		struct restrack_desc *desc)
+{
+	struct drm_panel_restrack_desc *rd = restrack_desc_to_rd(rd, desc);
+
+	of_node_put(desc->if_id);
+	kfree(rd);
+}
+
+static int drm_panel_restrack_ifup(struct device *dev,
+		struct restrack_desc *desc, void *data)
+{
+	struct drm_panel_restrack_desc *rd = restrack_desc_to_rd(rd, desc);
+
+	*rd->ptr = data;
+	return PTR_ERR_OR_ZERO(*rd->ptr);
+}
+
+static void drm_panel_restrack_ifdown(struct device *dev,
+		struct restrack_desc *desc, void *data)
+{
+	struct drm_panel_restrack_desc *rd = restrack_desc_to_rd(rd, desc);
+
+	*rd->ptr = ERR_PTR(-EPROBE_DEFER);
+}
+
+static const struct restrack_ops drm_panel_restrack_ops = {
+	.if_type = RESTRACK_TYPE_DRM_PANEL,
+	.init = drm_panel_restrack_init,
+	.destroy = drm_panel_restrack_destroy,
+	.if_up = drm_panel_restrack_ifup,
+	.if_down = drm_panel_restrack_ifdown,
+};
+
+/**
+ * drm_panel_restrack_desc - drm_panel resource descriptor allocator
+ * @panel: pointer to variable which will be set to drm_panel handle
+ * @prop_name: property name containing phandle to the panel node, it can be
+ *	       NULL if driver uses only of_graph
+ * @port: of_graph port number in case of_graph is used
+ *
+ * The function creates resource description for panel, which shall be used by
+ * *restrack_register functions.
+ */
+struct restrack_desc *drm_panel_restrack_desc(struct drm_panel **panel,
+		const char *prop_name, int port)
+{
+	struct drm_panel_restrack_desc *rd;
+
+	RESTRACK_DESC_ALLOC(rd, drm_panel_restrack_ops, panel, prop_name);
+	if (!rd)
+		return ERR_PTR(-ENOMEM);
+
+	rd->port = port;
+	return &rd->desc;
+}
+EXPORT_SYMBOL_GPL(drm_panel_restrack_desc);
+
 #endif
 
 MODULE_AUTHOR("Thierry Reding <treding@nvidia.com>");
diff --git a/include/drm/drm_panel.h b/include/drm/drm_panel.h
index 1fbcc96..46eb88e 100644
--- a/include/drm/drm_panel.h
+++ b/include/drm/drm_panel.h
@@ -130,6 +130,10 @@ int drm_panel_detach(struct drm_panel *panel);
 
 #ifdef CONFIG_OF
 struct drm_panel *of_drm_find_panel(struct device_node *np);
+
+struct restrack_desc;
+struct restrack_desc *drm_panel_restrack_desc(struct drm_panel **panel,
+		const char *prop_name, int port);
 #else
 static inline struct drm_panel *of_drm_find_panel(struct device_node *np)
 {
diff --git a/include/linux/restrack.h b/include/linux/restrack.h
index 6cf8144f..af5b617 100644
--- a/include/linux/restrack.h
+++ b/include/linux/restrack.h
@@ -3,6 +3,8 @@
 
 #include <linux/track.h>
 
+#define RESTRACK_TYPE_DRM_PANEL 1
+
 struct device;
 struct restrack_ctx;
 struct restrack_desc;
-- 
1.9.1

