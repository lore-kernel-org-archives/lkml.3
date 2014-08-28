Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965849AbaH1JLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:11:48 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:15276 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965658AbaH1JIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:08:22 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-d0-53fef183bd47
From: Andrzej Hajda <a.hajda@samsung.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org (open list),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...)
Subject: [PATCH v2 06/17] drm/exynos/ipp: free partially allocated resources on
 error
Date: Thu, 28 Aug 2014 11:07:30 +0200
Message-id: <1409216861-12452-7-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
References: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xy7rNH/8FG3QsV7G4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2CO4rJJSc3JLEst0rdL4Mo4vH4Se8Ee8Yqty08zNzBuFe5i5OSQEDCROL5jMRuELSZx4d56
	IJuLQ0hgKaPE9DV3GSGcPiaJLdMvMoFUsQloSvzdfBOsQ0RAWWLVvnZ2kCJmgY9MEleWvmEG
	SQgLhEvsWvCYpYuRg4NFQFXi4EYNkDCvgLPEk8N3GCG2yUmcPDaZFcTmFHCR2Hj8DTuILQRU
	s/v8Z6YJjLwLGBlWMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoSE1ZcdjIuPWR1iFOBgVOLh
	3VD6L1iINbGsuDL3EKMEB7OSCO/R40Ah3pTEyqrUovz4otKc1OJDjEwcnFINjIIcV+557EgO
	9C64l2hw3LFJ/Ir4+mO2Wz+xpgmsOS16Ie1kj41kzWUD7RTxfeXFT27yafCH/qg9dPMxX3bT
	I5uXm92TCq18ctdHPteVdjt0Ujej63+XoXbzyWMTZUochDfGGeb09yq+va1Vu9I+6unXnnVT
	mmt2tS/JzFxiFGWutDupcpqAEktxRqKhFnNRcSIAK1Bo9QkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of allocation errors some already allocated buffers
were not freed. The patch fixes it.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 67 ++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 35 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 060a198..ab7b74c 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -599,6 +599,35 @@ static int ipp_set_mem_node(struct exynos_drm_ippdrv *ippdrv,
 	return ret;
 }
 
+static int ipp_put_mem_node(struct drm_device *drm_dev,
+		struct drm_exynos_ipp_cmd_node *c_node,
+		struct drm_exynos_ipp_mem_node *m_node)
+{
+	int i;
+
+	DRM_DEBUG_KMS("node[0x%x]\n", (int)m_node);
+
+	if (!m_node) {
+		DRM_ERROR("invalid dequeue node.\n");
+		return -EFAULT;
+	}
+
+	DRM_DEBUG_KMS("ops_id[%d]\n", m_node->ops_id);
+
+	/* put gem buffer */
+	for_each_ipp_planar(i) {
+		unsigned long handle = m_node->buf_info.handles[i];
+		if (handle)
+			exynos_drm_gem_put_dma_addr(drm_dev, handle,
+							c_node->filp);
+	}
+
+	list_del(&m_node->list);
+	kfree(m_node);
+
+	return 0;
+}
+
 static struct drm_exynos_ipp_mem_node
 		*ipp_get_mem_node(struct drm_device *drm_dev,
 		struct drm_file *file,
@@ -619,6 +648,7 @@ static struct drm_exynos_ipp_mem_node
 	m_node->ops_id = qbuf->ops_id;
 	m_node->prop_id = qbuf->prop_id;
 	m_node->buf_id = qbuf->buf_id;
+	INIT_LIST_HEAD(&m_node->list);
 
 	DRM_DEBUG_KMS("m_node[0x%x]ops_id[%d]\n", (int)m_node, qbuf->ops_id);
 	DRM_DEBUG_KMS("prop_id[%d]buf_id[%d]\n", qbuf->prop_id, m_node->buf_id);
@@ -634,7 +664,8 @@ static struct drm_exynos_ipp_mem_node
 					qbuf->handle[i], file);
 			if (IS_ERR(addr)) {
 				DRM_ERROR("failed to get addr.\n");
-				goto err_clear;
+				ipp_put_mem_node(drm_dev, c_node, m_node);
+				return ERR_PTR(-EFAULT);
 			}
 
 			buf_info->handles[i] = qbuf->handle[i];
@@ -649,40 +680,6 @@ static struct drm_exynos_ipp_mem_node
 	mutex_unlock(&c_node->mem_lock);
 
 	return m_node;
-
-err_clear:
-	kfree(m_node);
-	return ERR_PTR(-EFAULT);
-}
-
-static int ipp_put_mem_node(struct drm_device *drm_dev,
-		struct drm_exynos_ipp_cmd_node *c_node,
-		struct drm_exynos_ipp_mem_node *m_node)
-{
-	int i;
-
-	DRM_DEBUG_KMS("node[0x%x]\n", (int)m_node);
-
-	if (!m_node) {
-		DRM_ERROR("invalid dequeue node.\n");
-		return -EFAULT;
-	}
-
-	DRM_DEBUG_KMS("ops_id[%d]\n", m_node->ops_id);
-
-	/* put gem buffer */
-	for_each_ipp_planar(i) {
-		unsigned long handle = m_node->buf_info.handles[i];
-		if (handle)
-			exynos_drm_gem_put_dma_addr(drm_dev, handle,
-							c_node->filp);
-	}
-
-	/* delete list in queue */
-	list_del(&m_node->list);
-	kfree(m_node);
-
-	return 0;
 }
 
 static void ipp_free_event(struct drm_pending_event *event)
-- 
1.9.1

