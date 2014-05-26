Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaEZISm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 04:18:42 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:29271 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaEZISk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 04:18:40 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-93-5382f8cfcf55
From: Andrzej Hajda <a.hajda@samsung.com>
To: dri-devel@lists.freedesktop.org
Cc: YoungJun Cho <yj44.cho@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 4/9] drm/exynos: ipp: add cmd_lock for cmd_list
Date: Mon, 26 May 2014 10:17:18 +0200
Message-id: <1401092243-25568-5-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401092243-25568-1-git-send-email-a.hajda@samsung.com>
References: <1401092243-25568-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCJMWRmVeSWpSXmKPExsVy+t/xa7rnfzQFG5xYb2px5et7NotJ9yew
	WLy4d5HF4mzTG3aLy7vmsFnMOL+PyWLtkbvsFjMmv2Sz2LtzMqMDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJWx/loHU8Fj9Ypb656xNTAeVOxi5OSQEDCROLxtAxuELSZx4d56
	IJuLQ0hgKaPE72/TWUESQgJ9TBJ9R5RBbDYBTYm/m2+CNYgIKEv8nbiKEaSBWeAjk0TL9w/s
	XYwcHMIC9hInNiaC1LAIqEp03N7MCGLzCjhLNCxoY4ZYJidx8thksPmcAi4Srz+uZAJpFQKq
	+f2dfwIj7wJGhlWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYISH1dQfj0mNWhxgFOBiVeHhf
	5DUFC7EmlhVX5h5ilOBgVhLhbf4AFOJNSaysSi3Kjy8qzUktPsTIxMEp1cDYcGphn/HqHxXX
	Uq/HcCi3iMfoqa+XXNBqtuZS44Sn9twHPI/nzjHdMmOdbXTR6m/WZckb5osUMxyOiotd+KxI
	5PTlEPFTttF/lXLijkode9pmlK9cFOkuLpDUcynOUObsN4GlwlYx17Y9V2/69pT70SsebU+h
	SzOZthfyOvFV7tA9fb4v57ESS3FGoqEWc1FxIgDZVy6CBwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: YoungJun Cho <yj44.cho@samsung.com>

This patch adds cmd_lock for cmd_list synchronization.

Signed-off-by: YoungJun Cho <yj44.cho@samsung.com>
Acked-by: Seong-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Tested-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 20 ++++++++++++++++++--
 drivers/gpu/drm/exynos/exynos_drm_ipp.h |  2 ++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 0d85433..b60ae54 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -284,9 +284,14 @@ static struct exynos_drm_ippdrv *ipp_find_drv_by_handle(u32 prop_id)
 	list_for_each_entry(ippdrv, &exynos_drm_ippdrv_list, drv_list) {
 		DRM_DEBUG_KMS("count[%d]ippdrv[0x%x]\n", count++, (int)ippdrv);
 
-		list_for_each_entry(c_node, &ippdrv->cmd_list, list)
-			if (c_node->property.prop_id == prop_id)
+		mutex_lock(&ippdrv->cmd_lock);
+		list_for_each_entry(c_node, &ippdrv->cmd_list, list) {
+			if (c_node->property.prop_id == prop_id) {
+				mutex_unlock(&ippdrv->cmd_lock);
 				return ippdrv;
+			}
+		}
+		mutex_unlock(&ippdrv->cmd_lock);
 	}
 
 	return ERR_PTR(-ENODEV);
@@ -318,6 +323,7 @@ int exynos_drm_ipp_get_property(struct drm_device *drm_dev, void *data,
 	if (!prop_list->ipp_id) {
 		list_for_each_entry(ippdrv, &exynos_drm_ippdrv_list, drv_list)
 			count++;
+
 		/*
 		 * Supports ippdrv list count for user application.
 		 * First step user application getting ippdrv count.
@@ -379,9 +385,11 @@ static int ipp_find_and_set_property(struct drm_exynos_ipp_property *property)
 	 * when we find this command no using prop_id.
 	 * return property information set in this command node.
 	 */
+	mutex_lock(&ippdrv->cmd_lock);
 	list_for_each_entry(c_node, &ippdrv->cmd_list, list) {
 		if ((c_node->property.prop_id == prop_id) &&
 		    (c_node->state == IPP_STATE_STOP)) {
+			mutex_unlock(&ippdrv->cmd_lock);
 			DRM_DEBUG_KMS("found cmd[%d]ippdrv[0x%x]\n",
 				property->cmd, (int)ippdrv);
 
@@ -389,6 +397,7 @@ static int ipp_find_and_set_property(struct drm_exynos_ipp_property *property)
 			return 0;
 		}
 	}
+	mutex_unlock(&ippdrv->cmd_lock);
 
 	DRM_ERROR("failed to search property.\n");
 
@@ -519,7 +528,9 @@ int exynos_drm_ipp_set_property(struct drm_device *drm_dev, void *data,
 
 	INIT_LIST_HEAD(&c_node->event_list);
 	list_splice_init(&priv->event_list, &c_node->event_list);
+	mutex_lock(&ippdrv->cmd_lock);
 	list_add_tail(&c_node->list, &ippdrv->cmd_list);
+	mutex_unlock(&ippdrv->cmd_lock);
 
 	/* make dedicated state without m2m */
 	if (!ipp_is_m2m_cmd(property->cmd))
@@ -1110,10 +1121,12 @@ int exynos_drm_ipp_cmd_ctrl(struct drm_device *drm_dev, void *data,
 
 		c_node->state = IPP_STATE_STOP;
 		ippdrv->dedicated = false;
+		mutex_lock(&ippdrv->cmd_lock);
 		ipp_clean_cmd_node(c_node);
 
 		if (list_empty(&ippdrv->cmd_list))
 			pm_runtime_put_sync(ippdrv->dev);
+		mutex_unlock(&ippdrv->cmd_lock);
 		break;
 	case IPP_CTRL_PAUSE:
 		cmd_work = c_node->stop_work;
@@ -1688,6 +1701,7 @@ static int ipp_subdrv_probe(struct drm_device *drm_dev, struct device *dev)
 		ippdrv->event_workq = ctx->event_workq;
 		ippdrv->sched_event = ipp_sched_event;
 		INIT_LIST_HEAD(&ippdrv->cmd_list);
+		mutex_init(&ippdrv->cmd_lock);
 
 		if (is_drm_iommu_supported(drm_dev)) {
 			ret = drm_iommu_attach_device(drm_dev, ippdrv->dev);
@@ -1757,6 +1771,7 @@ static void ipp_subdrv_close(struct drm_device *drm_dev, struct device *dev,
 	DRM_DEBUG_KMS("for priv[0x%x]\n", (int)priv);
 
 	list_for_each_entry(ippdrv, &exynos_drm_ippdrv_list, drv_list) {
+		mutex_lock(&ippdrv->cmd_lock);
 		list_for_each_entry_safe(c_node, tc_node,
 			&ippdrv->cmd_list, list) {
 			DRM_DEBUG_KMS("count[%d]ippdrv[0x%x]\n",
@@ -1781,6 +1796,7 @@ static void ipp_subdrv_close(struct drm_device *drm_dev, struct device *dev,
 					pm_runtime_put_sync(ippdrv->dev);
 			}
 		}
+		mutex_unlock(&ippdrv->cmd_lock);
 	}
 
 	kfree(priv);
diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.h b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
index fbb80ac..09cb5a2 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.h
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
@@ -148,6 +148,7 @@ struct exynos_drm_ipp_ops {
  * @event_workq: event work queue.
  * @c_node: current command information.
  * @cmd_list: list head for command information.
+ * @cmd_lock: lock for synchronization of access to cmd_list.
  * @prop_list: property informations of current ipp driver.
  * @check_property: check property about format, size, buffer.
  * @reset: reset ipp block.
@@ -165,6 +166,7 @@ struct exynos_drm_ippdrv {
 	struct workqueue_struct	*event_workq;
 	struct drm_exynos_ipp_cmd_node *c_node;
 	struct list_head	cmd_list;
+	struct mutex	cmd_lock;
 	struct drm_exynos_ipp_prop_list prop_list;
 
 	int (*check_property)(struct device *dev,
-- 
1.9.1

