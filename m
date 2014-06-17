Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192AbaFQOdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:33:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56251 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933032AbaFQOdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:33:04 -0400
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH 1/2] drm/msm: update iommu support
Date: Tue, 17 Jun 2014 10:32:37 -0400
Message-Id: <1403015558-13210-2-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1403015558-13210-1-git-send-email-sviau@codeaurora.org>
References: <[PATCH] drm/msm: update and activate iommu support>
 <1403015558-13210-1-git-send-email-sviau@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Iommu support is slightly modified in order to make sure
that MDP iommu is properly cleaned up if a probe deferral is
requested. Before this change, IOMMU faults would occur if the
probe failed (-EPROBE_DEFER).

Signed-off-by: Stephane Viau <sviau@codeaurora.org>
---
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c | 22 +++++++++++++++++-----
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h |  1 +
 drivers/gpu/drm/msm/msm_gem.c           |  6 ++++++
 drivers/gpu/drm/msm/msm_iommu.c         | 21 +++++++++++++++++++--
 drivers/gpu/drm/msm/msm_mmu.h           |  1 +
 5 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
index ee8446c..47b3eb0 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
@@ -20,6 +20,10 @@
 #include "msm_mmu.h"
 #include "mdp5_kms.h"
 
+static const char *iommu_ports[] = {
+		"mdp_0",
+};
+
 static struct mdp5_platform_config *mdp5_get_config(struct platform_device *dev);
 
 static int mdp5_hw_init(struct msm_kms *kms)
@@ -104,6 +108,12 @@ static void mdp5_preclose(struct msm_kms *kms, struct drm_file *file)
 static void mdp5_destroy(struct msm_kms *kms)
 {
 	struct mdp5_kms *mdp5_kms = to_mdp5_kms(to_mdp_kms(kms));
+	struct msm_mmu *mmu = mdp5_kms->mmu;
+
+	if (mmu) {
+		mmu->funcs->detach(mmu, iommu_ports, ARRAY_SIZE(iommu_ports));
+		mmu->funcs->destroy(mmu);
+	}
 	kfree(mdp5_kms);
 }
 
@@ -216,10 +226,6 @@ fail:
 	return ret;
 }
 
-static const char *iommu_ports[] = {
-		"mdp_0",
-};
-
 static int get_clk(struct platform_device *pdev, struct clk **clkp,
 		const char *name)
 {
@@ -307,17 +313,23 @@ struct msm_kms *mdp5_kms_init(struct drm_device *dev)
 		mmu = msm_iommu_new(dev, config->iommu);
 		if (IS_ERR(mmu)) {
 			ret = PTR_ERR(mmu);
+			dev_err(dev->dev, "failed to init iommu: %d\n", ret);
 			goto fail;
 		}
+
 		ret = mmu->funcs->attach(mmu, iommu_ports,
 				ARRAY_SIZE(iommu_ports));
-		if (ret)
+		if (ret) {
+			dev_err(dev->dev, "failed to attach iommu: %d\n", ret);
+			mmu->funcs->destroy(mmu);
 			goto fail;
+		}
 	} else {
 		dev_info(dev->dev, "no iommu, fallback to phys "
 				"contig buffers for scanout\n");
 		mmu = NULL;
 	}
+	mdp5_kms->mmu = mmu;
 
 	mdp5_kms->id = msm_register_mmu(dev, mmu);
 	if (mdp5_kms->id < 0) {
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
index c8b1a25..6e981b6 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
@@ -33,6 +33,7 @@ struct mdp5_kms {
 
 	/* mapper-id used to request GEM buffer mapped for scanout: */
 	int id;
+	struct msm_mmu *mmu;
 
 	/* for tracking smp allocation amongst pipes: */
 	mdp5_smp_state_t smp_state;
diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
index bb8026d..690d7e7 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -278,6 +278,7 @@ int msm_gem_get_iova_locked(struct drm_gem_object *obj, int id,
 		uint32_t *iova)
 {
 	struct msm_gem_object *msm_obj = to_msm_bo(obj);
+	struct drm_device *dev = obj->dev;
 	int ret = 0;
 
 	if (!msm_obj->domain[id].iova) {
@@ -285,6 +286,11 @@ int msm_gem_get_iova_locked(struct drm_gem_object *obj, int id,
 		struct msm_mmu *mmu = priv->mmus[id];
 		struct page **pages = get_pages(obj);
 
+		if (!mmu) {
+			dev_err(dev->dev, "null MMU pointer\n");
+			return -EINVAL;
+		}
+
 		if (IS_ERR(pages))
 			return PTR_ERR(pages);
 
diff --git a/drivers/gpu/drm/msm/msm_iommu.c b/drivers/gpu/drm/msm/msm_iommu.c
index 92b7459..198b2fe 100644
--- a/drivers/gpu/drm/msm/msm_iommu.c
+++ b/drivers/gpu/drm/msm/msm_iommu.c
@@ -28,7 +28,7 @@ static int msm_fault_handler(struct iommu_domain *iommu, struct device *dev,
 		unsigned long iova, int flags, void *arg)
 {
 	DBG("*** fault: iova=%08lx, flags=%d", iova, flags);
-	return 0;
+	return -ENOSYS;
 }
 
 static int msm_iommu_attach(struct msm_mmu *mmu, const char **names, int cnt)
@@ -40,8 +40,10 @@ static int msm_iommu_attach(struct msm_mmu *mmu, const char **names, int cnt)
 	for (i = 0; i < cnt; i++) {
 		struct device *msm_iommu_get_ctx(const char *ctx_name);
 		struct device *ctx = msm_iommu_get_ctx(names[i]);
-		if (IS_ERR_OR_NULL(ctx))
+		if (IS_ERR_OR_NULL(ctx)) {
+			dev_warn(dev->dev, "couldn't get %s context", names[i]);
 			continue;
+		}
 		ret = iommu_attach_device(iommu->domain, ctx);
 		if (ret) {
 			dev_warn(dev->dev, "could not attach iommu to %s", names[i]);
@@ -52,6 +54,20 @@ static int msm_iommu_attach(struct msm_mmu *mmu, const char **names, int cnt)
 	return 0;
 }
 
+static void msm_iommu_detach(struct msm_mmu *mmu, const char **names, int cnt)
+{
+	struct msm_iommu *iommu = to_msm_iommu(mmu);
+	int i;
+
+	for (i = 0; i < cnt; i++) {
+		struct device *msm_iommu_get_ctx(const char *ctx_name);
+		struct device *ctx = msm_iommu_get_ctx(names[i]);
+		if (IS_ERR_OR_NULL(ctx))
+			continue;
+		iommu_detach_device(iommu->domain, ctx);
+	}
+}
+
 static int msm_iommu_map(struct msm_mmu *mmu, uint32_t iova,
 		struct sg_table *sgt, unsigned len, int prot)
 {
@@ -127,6 +143,7 @@ static void msm_iommu_destroy(struct msm_mmu *mmu)
 
 static const struct msm_mmu_funcs funcs = {
 		.attach = msm_iommu_attach,
+		.detach = msm_iommu_detach,
 		.map = msm_iommu_map,
 		.unmap = msm_iommu_unmap,
 		.destroy = msm_iommu_destroy,
diff --git a/drivers/gpu/drm/msm/msm_mmu.h b/drivers/gpu/drm/msm/msm_mmu.h
index 0303244..21da6d1 100644
--- a/drivers/gpu/drm/msm/msm_mmu.h
+++ b/drivers/gpu/drm/msm/msm_mmu.h
@@ -22,6 +22,7 @@
 
 struct msm_mmu_funcs {
 	int (*attach)(struct msm_mmu *mmu, const char **names, int cnt);
+	void (*detach)(struct msm_mmu *mmu, const char **names, int cnt);
 	int (*map)(struct msm_mmu *mmu, uint32_t iova, struct sg_table *sgt,
 			unsigned len, int prot);
 	int (*unmap)(struct msm_mmu *mmu, uint32_t iova, struct sg_table *sgt,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

