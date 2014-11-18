Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaKRRv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:51:26 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36077 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaKRRuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:50:07 -0500
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH 2/3] drm/msm/mdp5: introduce mdp5_cfg module
Date: Tue, 18 Nov 2014 12:49:48 -0500
Message-Id: <1416332989-685-3-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1416332989-685-1-git-send-email-sviau@codeaurora.org>
References: <1416332989-685-1-git-send-email-sviau@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hardware configuration modification from a version to another
is quite consequent. Introducing a configuration module
(mdp5_cfg) may make things more clear and easier to access when a
new hardware version comes up.

Signed-off-by: Stephane Viau <sviau@codeaurora.org>
---
 drivers/gpu/drm/msm/Makefile            |   1 +
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c | 215 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.h |  88 +++++++++++++
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c | 211 ++++++-------------------------
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h |  39 +-----
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.c |   9 +-
 6 files changed, 354 insertions(+), 209 deletions(-)
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c
 create mode 100644 drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.h

diff --git a/drivers/gpu/drm/msm/Makefile b/drivers/gpu/drm/msm/Makefile
index 6283dcb..51045b0 100644
--- a/drivers/gpu/drm/msm/Makefile
+++ b/drivers/gpu/drm/msm/Makefile
@@ -24,6 +24,7 @@ msm-y := \
 	mdp/mdp4/mdp4_irq.o \
 	mdp/mdp4/mdp4_kms.o \
 	mdp/mdp4/mdp4_plane.o \
+	mdp/mdp5/mdp5_cfg.o \
 	mdp/mdp5/mdp5_crtc.o \
 	mdp/mdp5/mdp5_encoder.o \
 	mdp/mdp5/mdp5_irq.o \
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c
new file mode 100644
index 0000000..62e77d1
--- /dev/null
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.c
@@ -0,0 +1,215 @@
+/*
+ * Copyright (c) 2014 The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "mdp5_kms.h"
+#include "mdp5_cfg.h"
+
+struct mdp5_cfg_handler {
+	int revision;
+	struct mdp5_cfg config;
+};
+
+/* mdp5_cfg must be exposed (used in mdp5.xml.h) */
+const struct mdp5_cfg_hw *mdp5_cfg = NULL;
+
+const struct mdp5_cfg_hw msm8x74_config = {
+	.name = "msm8x74",
+	.smp = {
+		.mmb_count = 22,
+		.mmb_size = 4096,
+	},
+	.ctl = {
+		.count = 5,
+		.base = { 0x00600, 0x00700, 0x00800, 0x00900, 0x00a00 },
+	},
+	.pipe_vig = {
+		.count = 3,
+		.base = { 0x01200, 0x01600, 0x01a00 },
+	},
+	.pipe_rgb = {
+		.count = 3,
+		.base = { 0x01e00, 0x02200, 0x02600 },
+	},
+	.pipe_dma = {
+		.count = 2,
+		.base = { 0x02a00, 0x02e00 },
+	},
+	.lm = {
+		.count = 5,
+		.base = { 0x03200, 0x03600, 0x03a00, 0x03e00, 0x04200 },
+		.nb_stages = 5,
+	},
+	.dspp = {
+		.count = 3,
+		.base = { 0x04600, 0x04a00, 0x04e00 },
+	},
+	.ad = {
+		.count = 2,
+		.base = { 0x13100, 0x13300 }, /* NOTE: no ad in v1.0 */
+	},
+	.intf = {
+		.count = 4,
+		.base = { 0x12500, 0x12700, 0x12900, 0x12b00 },
+	},
+	.max_clk = 200000000,
+};
+
+const struct mdp5_cfg_hw apq8084_config = {
+	.name = "apq8084",
+	.smp = {
+		.mmb_count = 44,
+		.mmb_size = 8192,
+		.reserved_state[0] = GENMASK(7, 0),	/* first 8 MMBs */
+		.reserved[CID_RGB0] = 2,
+		.reserved[CID_RGB1] = 2,
+		.reserved[CID_RGB2] = 2,
+		.reserved[CID_RGB3] = 2,
+	},
+	.ctl = {
+		.count = 5,
+		.base = { 0x00600, 0x00700, 0x00800, 0x00900, 0x00a00 },
+	},
+	.pipe_vig = {
+		.count = 4,
+		.base = { 0x01200, 0x01600, 0x01a00, 0x01e00 },
+	},
+	.pipe_rgb = {
+		.count = 4,
+		.base = { 0x02200, 0x02600, 0x02a00, 0x02e00 },
+	},
+	.pipe_dma = {
+		.count = 2,
+		.base = { 0x03200, 0x03600 },
+	},
+	.lm = {
+		.count = 6,
+		.base = { 0x03a00, 0x03e00, 0x04200, 0x04600, 0x04a00, 0x04e00 },
+		.nb_stages = 5,
+	},
+	.dspp = {
+		.count = 4,
+		.base = { 0x05200, 0x05600, 0x05a00, 0x05e00 },
+
+	},
+	.ad = {
+		.count = 3,
+		.base = { 0x13500, 0x13700, 0x13900 },
+	},
+	.intf = {
+		.count = 5,
+		.base = { 0x12500, 0x12700, 0x12900, 0x12b00, 0x12d00 },
+	},
+	.max_clk = 320000000,
+};
+
+static const struct mdp5_cfg_handler cfg_handlers[] = {
+	{ .revision = 0, .config = { .hw = &msm8x74_config } },
+	{ .revision = 2, .config = { .hw = &msm8x74_config } },
+	{ .revision = 3, .config = { .hw = &apq8084_config } },
+};
+
+
+static struct mdp5_cfg_platform *mdp5_get_config(struct platform_device *dev);
+
+const struct mdp5_cfg_hw *mdp5_cfg_get_hw_config(void *cfg_hnd)
+{
+	struct mdp5_cfg_handler *cfg_handler = cfg_hnd;
+
+	return cfg_handler->config.hw;
+}
+
+struct mdp5_cfg *mdp5_cfg_get_config(void *cfg_hnd)
+{
+	struct mdp5_cfg_handler *cfg_handler = cfg_hnd;
+
+	return &cfg_handler->config;
+}
+
+int mdp5_cfg_get_hw_rev(void *cfg_hnd)
+{
+	struct mdp5_cfg_handler *cfg_handler = cfg_hnd;
+
+	return cfg_handler->revision;
+}
+
+void mdp5_cfg_destroy(void *cfg_hnd)
+{
+	struct mdp5_cfg_handler *cfg_handler = cfg_hnd;
+
+	kfree(cfg_handler);
+}
+
+void *mdp5_cfg_init(struct mdp5_kms *mdp5_kms,
+		uint32_t major, uint32_t minor)
+{
+	struct drm_device *dev = mdp5_kms->dev;
+	struct platform_device *pdev = dev->platformdev;
+	struct mdp5_cfg_handler *cfg_handler;
+	struct mdp5_cfg_platform *pconfig;
+	int i, ret = 0;
+
+	cfg_handler = kzalloc(sizeof(*cfg_handler), GFP_KERNEL);
+	if (unlikely(!cfg_handler)) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	if (major != 1) {
+		dev_err(dev->dev, "unexpected MDP major version: v%d.%d\n",
+				major, minor);
+		ret = -ENXIO;
+		goto fail;
+	}
+
+	/* only after mdp5_cfg global pointer's init can we access the hw */
+	for (i = 0; i < ARRAY_SIZE(cfg_handlers); i++) {
+		if (cfg_handlers[i].revision != minor)
+			continue;
+		mdp5_cfg = cfg_handlers[i].config.hw;
+
+		break;
+	}
+	if (unlikely(!mdp5_cfg)) {
+		dev_err(dev->dev, "unexpected MDP minor revision: v%d.%d\n",
+				major, minor);
+		ret = -ENXIO;
+		goto fail;
+	}
+
+	cfg_handler->revision = minor;
+	cfg_handler->config.hw = mdp5_cfg;
+
+	pconfig = mdp5_get_config(pdev);
+	memcpy(&cfg_handler->config.platform, pconfig, sizeof(*pconfig));
+
+	DBG("MDP5: %s hw config selected", mdp5_cfg->name);
+
+	return cfg_handler;
+
+fail:
+	if (cfg_handler)
+		mdp5_cfg_destroy(cfg_handler);
+
+	return NULL;
+}
+
+static struct mdp5_cfg_platform *mdp5_get_config(struct platform_device *dev)
+{
+	static struct mdp5_cfg_platform config = {};
+#ifdef CONFIG_OF
+	/* TODO */
+#endif
+	config.iommu = iommu_domain_alloc(&platform_bus_type);
+
+	return &config;
+}
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.h b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.h
new file mode 100644
index 0000000..00c8271
--- /dev/null
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_cfg.h
@@ -0,0 +1,88 @@
+/*
+ * Copyright (c) 2014 The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MDP5_CFG_H__
+#define __MDP5_CFG_H__
+
+#include "msm_drv.h"
+
+/*
+ * mdp5_cfg
+ *
+ * This module configures the dynamic offsets used by mdp5.xml.h
+ * (initialized in mdp5_cfg.c)
+ */
+extern const struct mdp5_cfg_hw *mdp5_cfg;
+
+#define MAX_BASES		8
+#define MAX_SMP_BLOCKS		44
+#define MAX_CLIENTS		32
+
+typedef DECLARE_BITMAP(mdp5_smp_state_t, MAX_SMP_BLOCKS);
+
+#define MDP5_SUB_BLOCK_DEFINITION \
+	int count; \
+	uint32_t base[MAX_BASES]
+
+struct mdp5_sub_block {
+	MDP5_SUB_BLOCK_DEFINITION;
+};
+
+struct mdp5_lm_block {
+	MDP5_SUB_BLOCK_DEFINITION;
+	uint32_t nb_stages;		/* number of stages per blender */
+};
+
+struct mdp5_smp_block {
+	int mmb_count;			/* number of SMP MMBs */
+	int mmb_size;			/* MMB: size in bytes */
+	mdp5_smp_state_t reserved_state;/* SMP MMBs statically allocated */
+	int reserved[MAX_CLIENTS];	/* # of MMBs allocated per client */
+};
+
+struct mdp5_cfg_hw {
+	char  *name;
+
+	struct mdp5_smp_block smp;
+	struct mdp5_sub_block ctl;
+	struct mdp5_sub_block pipe_vig;
+	struct mdp5_sub_block pipe_rgb;
+	struct mdp5_sub_block pipe_dma;
+	struct mdp5_lm_block  lm;
+	struct mdp5_sub_block dspp;
+	struct mdp5_sub_block ad;
+	struct mdp5_sub_block intf;
+
+	uint32_t max_clk;
+};
+
+/* platform config data (ie. from DT, or pdata) */
+struct mdp5_cfg_platform {
+	struct iommu_domain *iommu;
+};
+
+struct mdp5_cfg {
+	const struct mdp5_cfg_hw *hw;
+	struct mdp5_cfg_platform platform;
+};
+
+struct mdp5_kms;
+
+const struct mdp5_cfg_hw *mdp5_cfg_get_hw_config(void *cfg_hnd);
+struct mdp5_cfg *mdp5_cfg_get_config(void *cfg_hnd);
+int mdp5_cfg_get_hw_rev(void *cfg_hnd);
+
+void *mdp5_cfg_init(struct mdp5_kms *mdp5_kms, uint32_t major, uint32_t minor);
+void mdp5_cfg_destroy(void *cfg_hnd);
+
+#endif /* __MDP5_CFG_H__ */
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
index 0d6306d..76bd860 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright (c) 2014, The Linux Foundation. All rights reserved.
  * Copyright (C) 2013 Red Hat
  * Author: Rob Clark <robdclark@gmail.com>
  *
@@ -24,158 +25,10 @@ static const char *iommu_ports[] = {
 		"mdp_0",
 };
 
-static struct mdp5_platform_config *mdp5_get_config(struct platform_device *dev);
-
-const struct mdp5_config *mdp5_cfg;
-
-static const struct mdp5_config msm8x74_config = {
-	.name = "msm8x74",
-	.smp = {
-		.mmb_count = 22,
-		.mmb_size = 4096,
-	},
-	.ctl = {
-		.count = 5,
-		.base = { 0x00600, 0x00700, 0x00800, 0x00900, 0x00a00 },
-	},
-	.pipe_vig = {
-		.count = 3,
-		.base = { 0x01200, 0x01600, 0x01a00 },
-	},
-	.pipe_rgb = {
-		.count = 3,
-		.base = { 0x01e00, 0x02200, 0x02600 },
-	},
-	.pipe_dma = {
-		.count = 2,
-		.base = { 0x02a00, 0x02e00 },
-	},
-	.lm = {
-		.count = 5,
-		.base = { 0x03200, 0x03600, 0x03a00, 0x03e00, 0x04200 },
-	},
-	.dspp = {
-		.count = 3,
-		.base = { 0x04600, 0x04a00, 0x04e00 },
-	},
-	.ad = {
-		.count = 2,
-		.base = { 0x13100, 0x13300 }, /* NOTE: no ad in v1.0 */
-	},
-	.intf = {
-		.count = 4,
-		.base = { 0x12500, 0x12700, 0x12900, 0x12b00 },
-	},
-	.max_clk = 200000000,
-};
-
-static const struct mdp5_config apq8084_config = {
-	.name = "apq8084",
-	.smp = {
-		.mmb_count = 44,
-		.mmb_size = 8192,
-		.reserved_state[0] = GENMASK(7, 0),	/* first 8 MMBs */
-		.reserved[CID_RGB0] = 2,
-		.reserved[CID_RGB1] = 2,
-		.reserved[CID_RGB2] = 2,
-		.reserved[CID_RGB3] = 2,
-	},
-	.ctl = {
-		.count = 5,
-		.base = { 0x00600, 0x00700, 0x00800, 0x00900, 0x00a00 },
-	},
-	.pipe_vig = {
-		.count = 4,
-		.base = { 0x01200, 0x01600, 0x01a00, 0x01e00 },
-	},
-	.pipe_rgb = {
-		.count = 4,
-		.base = { 0x02200, 0x02600, 0x02a00, 0x02e00 },
-	},
-	.pipe_dma = {
-		.count = 2,
-		.base = { 0x03200, 0x03600 },
-	},
-	.lm = {
-		.count = 6,
-		.base = { 0x03a00, 0x03e00, 0x04200, 0x04600, 0x04a00, 0x04e00 },
-	},
-	.dspp = {
-		.count = 4,
-		.base = { 0x05200, 0x05600, 0x05a00, 0x05e00 },
-
-	},
-	.ad = {
-		.count = 3,
-		.base = { 0x13500, 0x13700, 0x13900 },
-	},
-	.intf = {
-		.count = 5,
-		.base = { 0x12500, 0x12700, 0x12900, 0x12b00, 0x12d00 },
-	},
-	.max_clk = 320000000,
-};
-
-struct mdp5_config_entry {
-	int revision;
-	const struct mdp5_config *config;
-};
-
-static const struct mdp5_config_entry mdp5_configs[] = {
-	{ .revision = 0, .config = &msm8x74_config },
-	{ .revision = 2, .config = &msm8x74_config },
-	{ .revision = 3, .config = &apq8084_config },
-};
-
-static int mdp5_select_hw_cfg(struct msm_kms *kms)
-{
-	struct mdp5_kms *mdp5_kms = to_mdp5_kms(to_mdp_kms(kms));
-	struct drm_device *dev = mdp5_kms->dev;
-	uint32_t version, major, minor;
-	int i, ret = 0;
-
-	mdp5_enable(mdp5_kms);
-	version = mdp5_read(mdp5_kms, REG_MDP5_MDP_VERSION);
-	mdp5_disable(mdp5_kms);
-
-	major = FIELD(version, MDP5_MDP_VERSION_MAJOR);
-	minor = FIELD(version, MDP5_MDP_VERSION_MINOR);
-
-	DBG("found MDP5 version v%d.%d", major, minor);
-
-	if (major != 1) {
-		dev_err(dev->dev, "unexpected MDP major version: v%d.%d\n",
-				major, minor);
-		ret = -ENXIO;
-		goto out;
-	}
-
-	mdp5_kms->rev = minor;
-
-	/* only after mdp5_cfg global pointer's init can we access the hw */
-	for (i = 0; i < ARRAY_SIZE(mdp5_configs); i++) {
-		if (mdp5_configs[i].revision != minor)
-			continue;
-		mdp5_kms->hw_cfg = mdp5_cfg = mdp5_configs[i].config;
-		break;
-	}
-	if (unlikely(!mdp5_kms->hw_cfg)) {
-		dev_err(dev->dev, "unexpected MDP minor revision: v%d.%d\n",
-				major, minor);
-		ret = -ENXIO;
-		goto out;
-	}
-
-	DBG("MDP5: %s config selected", mdp5_kms->hw_cfg->name);
-
-	return 0;
-out:
-	return ret;
-}
-
 static int mdp5_hw_init(struct msm_kms *kms)
 {
 	struct mdp5_kms *mdp5_kms = to_mdp5_kms(to_mdp_kms(kms));
+	const struct mdp5_cfg_hw *hw_cfg;
 	struct drm_device *dev = mdp5_kms->dev;
 	int i;
 
@@ -207,7 +60,9 @@ static int mdp5_hw_init(struct msm_kms *kms)
 
 	mdp5_write(mdp5_kms, REG_MDP5_DISP_INTF_SEL, 0);
 
-	for (i = 0; i < mdp5_kms->hw_cfg->ctl.count; i++)
+	hw_cfg = mdp5_cfg_get_hw_config(mdp5_kms->cfg_priv);
+
+	for (i = 0; i < hw_cfg->ctl.count; i++)
 		mdp5_write(mdp5_kms, REG_MDP5_CTL_OP(i), 0);
 
 	pm_runtime_put_sync(dev->dev);
@@ -236,6 +91,7 @@ static void mdp5_destroy(struct msm_kms *kms)
 	struct mdp5_kms *mdp5_kms = to_mdp5_kms(to_mdp_kms(kms));
 	struct msm_mmu *mmu = mdp5_kms->mmu;
 	void *smp = mdp5_kms->smp_priv;
+	void *cfg = mdp5_kms->cfg_priv;
 
 	if (mmu) {
 		mmu->funcs->detach(mmu, iommu_ports, ARRAY_SIZE(iommu_ports));
@@ -243,6 +99,8 @@ static void mdp5_destroy(struct msm_kms *kms)
 	}
 	if (smp)
 		mdp5_smp_destroy(smp);
+	if (cfg)
+		mdp5_cfg_destroy(cfg);
 
 	kfree(mdp5_kms);
 }
@@ -296,10 +154,13 @@ static int modeset_init(struct mdp5_kms *mdp5_kms)
 	struct drm_device *dev = mdp5_kms->dev;
 	struct msm_drm_private *priv = dev->dev_private;
 	struct drm_encoder *encoder;
+	const struct mdp5_cfg_hw *hw_cfg;
 	int i, ret;
 
+	hw_cfg = mdp5_cfg_get_hw_config(mdp5_kms->cfg_priv);
+
 	/* construct CRTCs: */
-	for (i = 0; i < mdp5_kms->hw_cfg->pipe_rgb.count; i++) {
+	for (i = 0; i < hw_cfg->pipe_rgb.count; i++) {
 		struct drm_plane *plane;
 		struct drm_crtc *crtc;
 
@@ -360,6 +221,21 @@ fail:
 	return ret;
 }
 
+static void read_hw_revision(struct mdp5_kms *mdp5_kms,
+		uint32_t *major, uint32_t *minor)
+{
+	uint32_t version;
+
+	mdp5_enable(mdp5_kms);
+	version = mdp5_read(mdp5_kms, REG_MDP5_MDP_VERSION);
+	mdp5_disable(mdp5_kms);
+
+	*major = FIELD(version, MDP5_MDP_VERSION_MAJOR);
+	*minor = FIELD(version, MDP5_MDP_VERSION_MINOR);
+
+	DBG("MDP5 version v%d.%d", *major, *minor);
+}
+
 static int get_clk(struct platform_device *pdev, struct clk **clkp,
 		const char *name)
 {
@@ -376,10 +252,11 @@ static int get_clk(struct platform_device *pdev, struct clk **clkp,
 struct msm_kms *mdp5_kms_init(struct drm_device *dev)
 {
 	struct platform_device *pdev = dev->platformdev;
-	struct mdp5_platform_config *config = mdp5_get_config(pdev);
+	struct mdp5_cfg *config;
 	struct mdp5_kms *mdp5_kms;
 	struct msm_kms *kms = NULL;
 	struct msm_mmu *mmu;
+	uint32_t major, minor;
 	void *priv;
 	int i, ret;
 
@@ -439,14 +316,19 @@ struct msm_kms *mdp5_kms_init(struct drm_device *dev)
 	if (ret)
 		goto fail;
 
-	ret = mdp5_select_hw_cfg(kms);
-	if (ret)
+	read_hw_revision(mdp5_kms, &major, &minor);
+	priv = mdp5_cfg_init(mdp5_kms, major, minor);
+	if (IS_ERR(priv)) {
+		ret = PTR_ERR(priv);
 		goto fail;
+	}
+	mdp5_kms->cfg_priv = priv;
+	config = mdp5_cfg_get_config(mdp5_kms->cfg_priv);
 
 	/* TODO: compute core clock rate at runtime */
-	clk_set_rate(mdp5_kms->src_clk, mdp5_kms->hw_cfg->max_clk);
+	clk_set_rate(mdp5_kms->src_clk, config->hw->max_clk);
 
-	priv = mdp5_smp_init(mdp5_kms->dev, &mdp5_kms->hw_cfg->smp);
+	priv = mdp5_smp_init(mdp5_kms->dev, &config->hw->smp);
 	if (IS_ERR(priv)) {
 		ret = PTR_ERR(priv);
 		goto fail;
@@ -458,13 +340,13 @@ struct msm_kms *mdp5_kms_init(struct drm_device *dev)
 	 * we don't disable):
 	 */
 	mdp5_enable(mdp5_kms);
-	for (i = 0; i < mdp5_kms->hw_cfg->intf.count; i++)
+	for (i = 0; i < config->hw->intf.count; i++)
 		mdp5_write(mdp5_kms, REG_MDP5_INTF_TIMING_ENGINE_EN(i), 0);
 	mdp5_disable(mdp5_kms);
 	mdelay(16);
 
-	if (config->iommu) {
-		mmu = msm_iommu_new(&pdev->dev, config->iommu);
+	if (config->platform.iommu) {
+		mmu = msm_iommu_new(&pdev->dev, config->platform.iommu);
 		if (IS_ERR(mmu)) {
 			ret = PTR_ERR(mmu);
 			dev_err(dev->dev, "failed to init iommu: %d\n", ret);
@@ -505,14 +387,3 @@ fail:
 		mdp5_destroy(kms);
 	return ERR_PTR(ret);
 }
-
-static struct mdp5_platform_config *mdp5_get_config(struct platform_device *dev)
-{
-	static struct mdp5_platform_config config = {};
-#ifdef CONFIG_OF
-	/* TODO */
-#endif
-	config.iommu = iommu_domain_alloc(&platform_bus_type);
-
-	return &config;
-}
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
index 753659b..7616a3b 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
@@ -21,36 +21,7 @@
 #include "msm_drv.h"
 #include "msm_kms.h"
 #include "mdp/mdp_kms.h"
-/* dynamic offsets used by mdp5.xml.h (initialized in mdp5_kms.c) */
-#define MDP5_MAX_BASES		8
-#define MAX_SMP_BLOCKS		44
-#define MAX_CLIENTS		32
-typedef DECLARE_BITMAP(mdp5_smp_state_t, MAX_SMP_BLOCKS);
-struct mdp5_sub_block {
-	int	count;
-	uint32_t base[MDP5_MAX_BASES];
-};
-struct mdp5_smp_block {
-	int mmb_count;			/* number of SMP MMBs */
-	int mmb_size;			/* MMB: size in bytes */
-	mdp5_smp_state_t reserved_state;/* SMP MMBs statically allocated */
-	int reserved[MAX_CLIENTS];	/* # of MMBs reserved per client */
-};
-struct mdp5_config {
-	char  *name;
-	struct mdp5_smp_block smp;
-	struct mdp5_sub_block ctl;
-	struct mdp5_sub_block pipe_vig;
-	struct mdp5_sub_block pipe_rgb;
-	struct mdp5_sub_block pipe_dma;
-	struct mdp5_sub_block lm;
-	struct mdp5_sub_block dspp;
-	struct mdp5_sub_block ad;
-	struct mdp5_sub_block intf;
-
-	uint32_t max_clk;
-};
-extern const struct mdp5_config *mdp5_cfg;
+#include "mdp5_cfg.h"	/* must be included before mdp5.xml.h */
 #include "mdp5.xml.h"
 #include "mdp5_smp.h"
 
@@ -59,8 +30,7 @@ struct mdp5_kms {
 
 	struct drm_device *dev;
 
-	int rev;
-	const struct mdp5_config *hw_cfg;
+	void *cfg_priv;
 
 	/* mapper-id used to request GEM buffer mapped for scanout: */
 	int id;
@@ -84,11 +54,6 @@ struct mdp5_kms {
 };
 #define to_mdp5_kms(x) container_of(x, struct mdp5_kms, base)
 
-/* platform config data (ie. from DT, or pdata) */
-struct mdp5_platform_config {
-	struct iommu_domain *iommu;
-};
-
 static inline void mdp5_write(struct mdp5_kms *mdp5_kms, u32 reg, u32 data)
 {
 	msm_writel(data, mdp5_kms->mmio + reg);
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.c
index e61e1cf..04996ca 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.c
@@ -108,11 +108,15 @@ static int smp_request_block(struct mdp5_smp *smp,
 		enum mdp5_client_id cid, int nblks)
 {
 	struct mdp5_kms *mdp5_kms = get_kms(smp);
+	const struct mdp5_cfg_hw *hw_cfg;
 	struct mdp5_client_smp_state *ps = &smp->client_state[cid];
 	int i, ret, avail, cur_nblks, cnt = smp->blk_cnt;
-	int reserved = mdp5_kms->hw_cfg->smp.reserved[cid];
+	int reserved;
 	unsigned long flags;
 
+	hw_cfg = mdp5_cfg_get_hw_config(mdp5_kms->cfg_priv);
+	reserved = hw_cfg->smp.reserved[cid];
+
 	spin_lock_irqsave(&smp->state_lock, flags);
 
 	nblks -= reserved;
@@ -175,6 +179,7 @@ int mdp5_smp_request(void *handler, enum mdp5_pipe pipe, u32 fmt, u32 width)
 	struct mdp5_smp *smp = handler;
 	struct mdp5_kms *mdp5_kms = get_kms(smp);
 	struct drm_device *dev = mdp5_kms->dev;
+	int rev = mdp5_cfg_get_hw_rev(mdp5_kms->cfg_priv);
 	int i, hsub, nplanes, nlines, nblks, ret;
 
 	nplanes = drm_format_num_planes(fmt);
@@ -192,7 +197,7 @@ int mdp5_smp_request(void *handler, enum mdp5_pipe pipe, u32 fmt, u32 width)
 		n = DIV_ROUND_UP(fetch_stride * nlines, smp->blk_size);
 
 		/* for hw rev v1.00 */
-		if (mdp5_kms->rev == 0)
+		if (rev == 0)
 			n = roundup_pow_of_two(n);
 
 		DBG("%s[%d]: request %d SMP blocks", pipe2name(pipe), i, n);
-- 
Qualcomm Innovation Center, Inc.

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

