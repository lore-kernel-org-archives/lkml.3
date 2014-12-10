Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbaLJPtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:49:25 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56612 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758056AbaLJPtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:49:16 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-e4-54886b7bbece
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
Subject: [RFC 12/15] drm/exynos/dpi: use common of_graph functions
Date: Wed, 10 Dec 2014 16:48:30 +0100
Message-id: <1418226513-14105-13-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
References: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t/xy7rV2R0hBhd+cVjcWneO1eLAi4Us
	FlMfPmGzmH8EyL3y9T2bxblXj1gsDvzZwWjRvHg9m8Wk+xNYLC487WGz+Halg8liyp/lTBab
	Hl9jtdg8/w+jxeVdc9gsZpzfx2Rx+zKvxdojd9ktnk64yGbRuvcIu8XPXfNYHEQ9Wpp72Dye
	bLrI6LFz1l12j02rOtk87lzbw+axf+4ado/73ceZPDYvqffo27KK0eP4je1MHp83yQVwR3HZ
	pKTmZJalFunbJXBlXOy/wlpwRa7iyM71zA2M7yW6GDk4JARMJFYc5+ti5AQyxSQu3FvP1sXI
	xSEksJRR4uTcbUwQTh+TRFf7OUaQKjYBTYm/m2+ygdgiAjoS13u6mUGKmAU2sEusm74PLCEs
	4CSx9l4/mM0ioCqx4vYSFhCbV8BFovPcPzaIdXISJ49NZgWxOYHif5/vBVsgJOAssWTbe9YJ
	jLwLGBlWMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoTExpcdjIuPWR1iFOBgVOLhNVdsDRFi
	TSwrrsw9xCjBwawkwrswuSNEiDclsbIqtSg/vqg0J7X4ECMTB6dUA2NTxw6FHN1jLftZFl0w
	2R7t8vrbBNUCpcSvE2YuPPn4/+asqdNv3zG+LyQZHdrZLFjCPv/NRuF5e1X+vs/XLrj1fFO9
	yf1IoeqpbjrXAwScz9l2PVOz2G2sa6LfYnfBSunQgxW1lXY+jDdsDT49vHRn5on4h+V/u9fY
	PttSuPPd3EtTPv0LOX5NiaU4I9FQi7moOBEA9p5gY2sCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch removes private of_graph functions and uses common ones.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_dpi.c | 117 +++++++-------------------------
 1 file changed, 24 insertions(+), 93 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_dpi.c b/drivers/gpu/drm/exynos/exynos_drm_dpi.c
index 37678cf..91a29e1 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dpi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dpi.c
@@ -14,6 +14,7 @@
 #include <drm/drm_crtc_helper.h>
 #include <drm/drm_panel.h>
 
+#include <linux/of_graph.h>
 #include <linux/regulator/consumer.h>
 
 #include <video/of_videomode.h>
@@ -21,6 +22,15 @@
 
 #include "exynos_drm_drv.h"
 
+/* possible of_graph port nodes used by device */
+enum {
+	FIMD_PORT_IN0,
+	FIMD_PORT_IN1,
+	FIMD_PORT_IN2,
+	FIMD_PORT_RGB,
+	FIMD_PORT_WRB,
+};
+
 struct exynos_dpi {
 	struct exynos_drm_display display;
 	struct device *dev;
@@ -171,102 +181,12 @@ static struct exynos_drm_display_ops exynos_dpi_display_ops = {
 	.dpms = exynos_dpi_dpms
 };
 
-/* of_* functions will be removed after merge of of_graph patches */
-static struct device_node *
-of_get_child_by_name_reg(struct device_node *parent, const char *name, u32 reg)
-{
-	struct device_node *np;
-
-	for_each_child_of_node(parent, np) {
-		u32 r;
-
-		if (!np->name || of_node_cmp(np->name, name))
-			continue;
-
-		if (of_property_read_u32(np, "reg", &r) < 0)
-			r = 0;
-
-		if (reg == r)
-			break;
-	}
-
-	return np;
-}
-
-static struct device_node *of_graph_get_port_by_reg(struct device_node *parent,
-						    u32 reg)
-{
-	struct device_node *ports, *port;
-
-	ports = of_get_child_by_name(parent, "ports");
-	if (ports)
-		parent = ports;
-
-	port = of_get_child_by_name_reg(parent, "port", reg);
-
-	of_node_put(ports);
-
-	return port;
-}
-
-static struct device_node *
-of_graph_get_endpoint_by_reg(struct device_node *port, u32 reg)
-{
-	return of_get_child_by_name_reg(port, "endpoint", reg);
-}
-
-static struct device_node *
-of_graph_get_remote_port_parent(const struct device_node *node)
-{
-	struct device_node *np;
-	unsigned int depth;
-
-	np = of_parse_phandle(node, "remote-endpoint", 0);
-
-	/* Walk 3 levels up only if there is 'ports' node. */
-	for (depth = 3; depth && np; depth--) {
-		np = of_get_next_parent(np);
-		if (depth == 2 && of_node_cmp(np->name, "ports"))
-			break;
-	}
-	return np;
-}
-
-enum {
-	FIMD_PORT_IN0,
-	FIMD_PORT_IN1,
-	FIMD_PORT_IN2,
-	FIMD_PORT_RGB,
-	FIMD_PORT_WRB,
-};
-
-static struct device_node *exynos_dpi_of_find_panel_node(struct device *dev)
-{
-	struct device_node *np, *ep;
-
-	np = of_graph_get_port_by_reg(dev->of_node, FIMD_PORT_RGB);
-	if (!np)
-		return NULL;
-
-	ep = of_graph_get_endpoint_by_reg(np, 0);
-	of_node_put(np);
-	if (!ep)
-		return NULL;
-
-	np = of_graph_get_remote_port_parent(ep);
-	of_node_put(ep);
-
-	return np;
-}
-
 static int exynos_dpi_parse_dt(struct exynos_dpi *ctx)
 {
 	struct device *dev = ctx->dev;
 	struct device_node *dn = dev->of_node;
 	struct device_node *np;
 
-	ctx->panel_node = exynos_dpi_of_find_panel_node(dev);
-
 	np = of_get_child_by_name(dn, "display-timings");
 	if (np) {
 		struct videomode *vm;
@@ -289,10 +209,21 @@ static int exynos_dpi_parse_dt(struct exynos_dpi *ctx)
 		return 0;
 	}
 
-	if (!ctx->panel_node)
-		return -EINVAL;
+	np = NULL;
+	while ((np = of_graph_get_next_endpoint(dev->of_node, np))) {
+		struct of_endpoint ep;
 
-	return 0;
+		of_graph_parse_endpoint(np, &ep);
+		if (ep.port != FIMD_PORT_RGB)
+			continue;
+
+		ctx->panel_node = of_graph_get_remote_port_parent(np);
+		of_node_put(np);
+
+		return ctx->panel_node ? 0 : -EINVAL;
+	}
+
+	return -EINVAL;
 }
 
 struct exynos_drm_display *exynos_dpi_probe(struct device *dev)
-- 
1.9.1

