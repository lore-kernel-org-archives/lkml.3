Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbaKNWmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 17:42:53 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44465 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbaKNWmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 17:42:52 -0500
From: Hai Li <hali@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Hai Li <hali@codeaurora.org>
Subject: [PATCH 1/2] drm/msm: Register irq handler for each sub-system in mdss
Date: Fri, 14 Nov 2014 17:42:34 -0500
Message-Id: <1416004955-28749-1-git-send-email-hali@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the sub-systems in mdss share the same irq. This change provides
the sub-systems with the interfaces to register/unregister their own
irq handlers.

With this change, struct mdp5_kms does not have to keep the hdmi or
edp context.

Signed-off-by: Hai Li <hali@codeaurora.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi.c         |  12 +++-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_irq.c | 107 ++++++++++++++++++++++++++++++--
 drivers/gpu/drm/msm/msm_drv.h           |  19 +++++-
 3 files changed, 130 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index 9d00dcb..aaf5e2b 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -39,7 +39,7 @@ void hdmi_set_mode(struct hdmi *hdmi, bool power_on)
 			power_on ? "Enable" : "Disable", ctrl);
 }
 
-irqreturn_t hdmi_irq(int irq, void *dev_id)
+static irqreturn_t hdmi_irq(int irq, void *dev_id)
 {
 	struct hdmi *hdmi = dev_id;
 
@@ -59,6 +59,9 @@ void hdmi_destroy(struct kref *kref)
 	struct hdmi *hdmi = container_of(kref, struct hdmi, refcount);
 	struct hdmi_phy *phy = hdmi->phy;
 
+	if (hdmi->config->shared_irq)
+		msm_shared_irq_unregister(MSM_SUBSYS_HDMI);
+
 	if (phy)
 		phy->funcs->destroy(phy);
 
@@ -221,6 +224,13 @@ struct hdmi *hdmi_init(struct drm_device *dev, struct drm_encoder *encoder)
 					hdmi->irq, ret);
 			goto fail;
 		}
+	} else {
+		ret = msm_shared_irq_register(MSM_SUBSYS_HDMI, hdmi_irq, hdmi);
+		if (ret < 0) {
+			dev_err(dev->dev, "failed to register shared IRQ: %d\n",
+					ret);
+			goto fail;
+		}
 	}
 
 	encoder->bridge = hdmi->bridge;
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_irq.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_irq.c
index f2b985b..2973c1c 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_irq.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_irq.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright (c) 2014, The Linux Foundation. All rights reserved.
  * Copyright (C) 2013 Red Hat
  * Author: Rob Clark <robdclark@gmail.com>
  *
@@ -19,6 +20,75 @@
 #include "msm_drv.h"
 #include "mdp5_kms.h"
 
+struct msm_subsys_shared_irq {
+	u32 mask;
+	u32 count;
+
+	/* Filled by sub system */
+	irqreturn_t (*handler)(int irq, void *dev_id);
+	void *data;
+};
+
+static struct msm_subsys_shared_irq msm_shared_irqs[MSM_SUBSYS_COUNT] = {
+	[MSM_SUBSYS_MDP] = {.mask = MDP5_HW_INTR_STATUS_INTR_MDP,
+				.count = 0},
+	[MSM_SUBSYS_DSI_0] = {.mask = MDP5_HW_INTR_STATUS_INTR_DSI0,
+				.count = 0},
+	[MSM_SUBSYS_DSI_1] = {.mask = MDP5_HW_INTR_STATUS_INTR_DSI1,
+				.count = 0},
+	[MSM_SUBSYS_HDMI] = {.mask = MDP5_HW_INTR_STATUS_INTR_HDMI,
+				.count = 0},
+	[MSM_SUBSYS_EDP] = {.mask = MDP5_HW_INTR_STATUS_INTR_EDP,
+				.count = 0},
+};
+
+static irqreturn_t mdp5_irq_mdp(int irq, void *dev_id);
+
+int msm_shared_irq_register(enum msm_sub_system sys_id,
+	irqreturn_t (*handler)(int irq, void *dev_id), void *data)
+{
+	if (sys_id >= MSM_SUBSYS_COUNT) {
+		DRM_ERROR("Invalid sys_id %d", sys_id);
+		return -EINVAL;
+	}
+
+	if (msm_shared_irqs[sys_id].handler != NULL) {
+		DRM_ERROR("sys %d irq already registered", sys_id);
+		return -EBUSY;
+	}
+
+	msm_shared_irqs[sys_id].data = data;
+	msm_shared_irqs[sys_id].handler = handler;
+
+	return 0;
+}
+
+/*
+ * This function should be called after the interrupt
+ * on the sub-system is disabled.
+ */
+int msm_shared_irq_unregister(enum msm_sub_system sys_id)
+{
+	if (sys_id >= MSM_SUBSYS_COUNT) {
+		DRM_ERROR("Invalid sys_id %d", sys_id);
+		return -EINVAL;
+	}
+
+	msm_shared_irqs[sys_id].handler = NULL;
+	msm_shared_irqs[sys_id].data = NULL;
+
+	/*
+	 * Make sure irq_handler and data is invalid.
+	 * Then we only need to wait until the last pending interrupt is done.
+	 */
+	wmb();
+
+	while (msm_shared_irqs[sys_id].count & 0x1)
+		usleep_range(100, 1000);
+
+	return 0;
+}
+
 void mdp5_set_irqmask(struct mdp_kms *mdp_kms, uint32_t irqmask)
 {
 	mdp5_write(to_mdp5_kms(mdp_kms), REG_MDP5_INTR_EN, irqmask);
@@ -47,6 +117,9 @@ int mdp5_irq_postinstall(struct msm_kms *kms)
 			MDP5_IRQ_INTF2_UNDER_RUN |
 			MDP5_IRQ_INTF3_UNDER_RUN;
 
+	/* Register mdp irq to mdss */
+	msm_shared_irq_register(MSM_SUBSYS_MDP, mdp5_irq_mdp, mdp_kms);
+
 	mdp_irq_register(mdp_kms, error_handler);
 
 	return 0;
@@ -56,10 +129,15 @@ void mdp5_irq_uninstall(struct msm_kms *kms)
 {
 	struct mdp5_kms *mdp5_kms = to_mdp5_kms(to_mdp_kms(kms));
 	mdp5_write(mdp5_kms, REG_MDP5_INTR_EN, 0x00000000);
+
+	/* Make sure interrupt is disabled before remove irq. */
+	wmb();
+	msm_shared_irq_unregister(MSM_SUBSYS_MDP);
 }
 
-static void mdp5_irq_mdp(struct mdp_kms *mdp_kms)
+static irqreturn_t mdp5_irq_mdp(int irq, void *dev_id)
 {
+	struct mdp_kms *mdp_kms = (struct mdp_kms *)dev_id;
 	struct mdp5_kms *mdp5_kms = to_mdp5_kms(mdp_kms);
 	struct drm_device *dev = mdp5_kms->dev;
 	struct msm_drm_private *priv = dev->dev_private;
@@ -76,23 +154,40 @@ static void mdp5_irq_mdp(struct mdp_kms *mdp_kms)
 	for (id = 0; id < priv->num_crtcs; id++)
 		if (status & mdp5_crtc_vblank(priv->crtcs[id]))
 			drm_handle_vblank(dev, id);
+
+	return IRQ_HANDLED;
 }
 
 irqreturn_t mdp5_irq(struct msm_kms *kms)
 {
 	struct mdp_kms *mdp_kms = to_mdp_kms(kms);
 	struct mdp5_kms *mdp5_kms = to_mdp5_kms(mdp_kms);
+	struct msm_subsys_shared_irq *irq;
 	uint32_t intr;
+	int i;
 
 	intr = mdp5_read(mdp5_kms, REG_MDP5_HW_INTR_STATUS);
 
 	VERB("intr=%08x", intr);
 
-	if (intr & MDP5_HW_INTR_STATUS_INTR_MDP)
-		mdp5_irq_mdp(mdp_kms);
-
-	if (intr & MDP5_HW_INTR_STATUS_INTR_HDMI)
-		hdmi_irq(0, mdp5_kms->hdmi);
+	for (i = 0; i < MSM_SUBSYS_COUNT; i++) {
+		irq = &msm_shared_irqs[i];
+		if (intr & irq->mask) {
+			irq->count++;
+
+			/*
+			 * These 2 wmb() ensure count is odd number
+			 * during handler is running.
+			 */
+			wmb();
+			if ((irq->handler != NULL) && (irq->data != NULL))
+				irq->handler(0, irq->data);
+
+			/* Make sure count increments after handler is done */
+			wmb();
+			irq->count++;
+		}
+	}
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/gpu/drm/msm/msm_drv.h b/drivers/gpu/drm/msm/msm_drv.h
index 67f9d0a..718ac55 100644
--- a/drivers/gpu/drm/msm/msm_drv.h
+++ b/drivers/gpu/drm/msm/msm_drv.h
@@ -127,6 +127,16 @@ struct msm_drm_private {
 	} vram;
 };
 
+/* For mdp5 only */
+enum msm_sub_system {
+	MSM_SUBSYS_MDP = 0,
+	MSM_SUBSYS_DSI_0,
+	MSM_SUBSYS_DSI_1,
+	MSM_SUBSYS_HDMI,
+	MSM_SUBSYS_EDP,
+	MSM_SUBSYS_COUNT
+};
+
 struct msm_format {
 	uint32_t pixel_format;
 };
@@ -145,6 +155,14 @@ void __msm_fence_worker(struct work_struct *work);
 		(_cb)->func = _func;                         \
 	} while (0)
 
+/*
+ * For mdp5 only, callers should call these 2 functions
+ * only if the irqs are shared with others.
+ */
+int msm_shared_irq_register(enum msm_sub_system sys_id,
+	irqreturn_t (*handler)(int irq, void *dev_id), void *data);
+int msm_shared_irq_unregister(enum msm_sub_system sys_id);
+
 int msm_register_mmu(struct drm_device *dev, struct msm_mmu *mmu);
 
 int msm_wait_fence_interruptable(struct drm_device *dev, uint32_t fence,
@@ -203,7 +221,6 @@ struct drm_fb_helper *msm_fbdev_init(struct drm_device *dev);
 
 struct hdmi;
 struct hdmi *hdmi_init(struct drm_device *dev, struct drm_encoder *encoder);
-irqreturn_t hdmi_irq(int irq, void *dev_id);
 void __init hdmi_register(void);
 void __exit hdmi_unregister(void);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

