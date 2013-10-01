Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3JAXlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 19:41:37 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:59533 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab3JAXlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 19:41:18 -0400
From: Sean Paul <seanpaul@chromium.org>
To: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        inki.dae@samsung.com
Cc: airlied@linux.ie, Sean Paul <seanpaul@chromium.org>
Subject: [PATCH 4/5] drm/exynos: Initialize ptn3460 if present
Date: Tue,  1 Oct 2013 19:40:59 -0400
Message-Id: <1380670860-17621-5-git-send-email-seanpaul@chromium.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380670860-17621-1-git-send-email-seanpaul@chromium.org>
References: <1380670860-17621-1-git-send-email-seanpaul@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code to look for the ptn3460 in the device tree file on
exynos initialization. If ptn node is found, the driver will initialize
the ptn3460 driver and skip creating a DP connector (since the bridge
driver will register its own connector).

Signed-off-by: Sean Paul <seanpaul@chromium.org>
---
 drivers/gpu/drm/exynos/exynos_drm_core.c | 44 +++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_core.c b/drivers/gpu/drm/exynos/exynos_drm_core.c
index 1bef6dc..9cf4476 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_core.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_core.c
@@ -12,7 +12,9 @@
  * option) any later version.
  */
 
+#include <linux/of_i2c.h>
 #include <drm/drmP.h>
+#include <drm/bridge/ptn3460.h>
 #include "exynos_drm_drv.h"
 #include "exynos_drm_encoder.h"
 #include "exynos_drm_connector.h"
@@ -20,6 +22,40 @@
 
 static LIST_HEAD(exynos_drm_subdrv_list);
 
+struct bridge_init {
+	struct i2c_client *client;
+	struct device_node *node;
+};
+
+static bool find_bridge(const char *name, struct bridge_init *bridge)
+{
+	bridge->client = NULL;
+	bridge->node = of_find_node_by_name(NULL, name);
+	if (!bridge->node)
+		return false;
+
+	bridge->client = of_find_i2c_device_by_node(bridge->node);
+	if (!bridge->client)
+		return false;
+
+	return true;
+}
+
+/* returns the number of bridges attached */
+static int exynos_drm_attach_lcd_bridge(struct drm_device *dev,
+		struct drm_encoder *encoder)
+{
+	struct bridge_init bridge;
+	int ret;
+
+	if (find_bridge("ptn3460-bridge", &bridge)) {
+		ret = ptn3460_init(dev, encoder, bridge.client, bridge.node);
+		if (!ret)
+			return 1;
+	}
+	return 0;
+}
+
 static int exynos_drm_create_enc_conn(struct drm_device *dev,
 					struct exynos_drm_subdrv *subdrv)
 {
@@ -36,6 +72,13 @@ static int exynos_drm_create_enc_conn(struct drm_device *dev,
 		DRM_ERROR("failed to create encoder\n");
 		return -EFAULT;
 	}
+	subdrv->encoder = encoder;
+
+	if (subdrv->manager->display_ops->type == EXYNOS_DISPLAY_TYPE_LCD) {
+		ret = exynos_drm_attach_lcd_bridge(dev, encoder);
+		if (ret)
+			return 0;
+	}
 
 	/*
 	 * create and initialize a connector for this sub driver and
@@ -48,7 +91,6 @@ static int exynos_drm_create_enc_conn(struct drm_device *dev,
 		goto err_destroy_encoder;
 	}
 
-	subdrv->encoder = encoder;
 	subdrv->connector = connector;
 
 	return 0;
-- 
1.8.4

