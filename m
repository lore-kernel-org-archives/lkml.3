Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbaHVH4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:56:41 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34664 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054AbaHVHxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:53:40 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-c0-53f6f702c57f
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
Subject: [PATCH 07/15] drm/exynos/ipp: move nodes cleaning to separate function
Date: Fri, 22 Aug 2014 09:52:18 +0200
Message-id: <1408693946-15456-8-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xq7pM378FG7Rd4bK4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2CO4rJJSc3JLEst0rdL4Mq4/mghU8Eeu4rX/+6yNTBONe5i5OCQEDCRuHimsouRE8gUk7hw
	bz1bFyMXh5DAUkaJrU33oJw+JomeyxuYQKrYBDQl/m6+yQZiiwgoS6za184OUsQs8JFJ4srS
	N8wgCWEBf4lH2yaygtgsAqoSB5ZeAmvgFXCWmLj4CCvEOjmJk8cmg9mcAi4SFw5OA+sVAqrp
	uj2NaQIj7wJGhlWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIWH1dQfj0mNWhxgFOBiVeHgj
	v3wNFmJNLCuuzD3EKMHBrCTCu2net2Ah3pTEyqrUovz4otKc1OJDjEwcnFINjDw3/3bFJDl1
	sP3xs949sby14x4X0/lMt/bJr6Km1GzqS67TeLRgsbdyccLkL8qTOX2uLLF0Zgt4yq2mHvpf
	d3W4oefUM+VrBM5M+Ph81QN1R92+CVlLFRqrN3/OZ1qr/03Rj29V5omdaev+SlbdURM85Hc5
	cQ7TDwMbG43L+VPnXz1Y/u/OaiWW4oxEQy3mouJEALd6KiIJAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch introduces ipp_clean_mem_nodes function which replaces
redundant code. Additionally memory node function definitions
are moved up to increase its visibility.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 231 +++++++++++++++-----------------
 1 file changed, 107 insertions(+), 124 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 728f3b9..22bd551 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -498,6 +498,109 @@ err_clear:
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
+	/* conditionally remove from queue */
+	if (m_node->list.next)
+		list_del(&m_node->list);
+	kfree(m_node);
+
+	return 0;
+}
+
+static struct drm_exynos_ipp_mem_node
+		*ipp_get_mem_node(struct drm_device *drm_dev,
+		struct drm_file *file,
+		struct drm_exynos_ipp_cmd_node *c_node,
+		struct drm_exynos_ipp_queue_buf *qbuf)
+{
+	struct drm_exynos_ipp_mem_node *m_node;
+	struct drm_exynos_ipp_buf_info *buf_info;
+	int i;
+
+	m_node = kzalloc(sizeof(*m_node), GFP_KERNEL);
+	if (!m_node)
+		return ERR_PTR(-ENOMEM);
+
+	buf_info = &m_node->buf_info;
+
+	/* operations, buffer id */
+	m_node->ops_id = qbuf->ops_id;
+	m_node->prop_id = qbuf->prop_id;
+	m_node->buf_id = qbuf->buf_id;
+
+	DRM_DEBUG_KMS("m_node[0x%x]ops_id[%d]\n", (int)m_node, qbuf->ops_id);
+	DRM_DEBUG_KMS("prop_id[%d]buf_id[%d]\n", qbuf->prop_id, m_node->buf_id);
+
+	for_each_ipp_planar(i) {
+		DRM_DEBUG_KMS("i[%d]handle[0x%x]\n", i, qbuf->handle[i]);
+
+		/* get dma address by handle */
+		if (qbuf->handle[i]) {
+			dma_addr_t *addr;
+
+			addr = exynos_drm_gem_get_dma_addr(drm_dev,
+					qbuf->handle[i], file);
+			if (IS_ERR(addr)) {
+				DRM_ERROR("failed to get addr.\n");
+				ipp_put_mem_node(drm_dev, c_node, m_node);
+				return ERR_PTR(-EFAULT);
+			}
+
+			buf_info->handles[i] = qbuf->handle[i];
+			buf_info->base[i] = *addr;
+			DRM_DEBUG_KMS("i[%d]base[0x%x]hd[0x%lx]\n", i,
+				      buf_info->base[i], buf_info->handles[i]);
+		}
+	}
+
+	mutex_lock(&c_node->mem_lock);
+	list_add_tail(&m_node->list, &c_node->mem_list[qbuf->ops_id]);
+	mutex_unlock(&c_node->mem_lock);
+
+	return m_node;
+}
+
+static void ipp_clean_mem_nodes(struct drm_device *drm_dev,
+			       struct drm_exynos_ipp_cmd_node *c_node, int ops)
+{
+	struct drm_exynos_ipp_mem_node *m_node, *tm_node;
+	struct list_head *head = &c_node->mem_list[ops];
+
+	mutex_lock(&c_node->mem_lock);
+
+	list_for_each_entry_safe(m_node, tm_node, head, list) {
+		int ret;
+
+		ret = ipp_put_mem_node(drm_dev, c_node, m_node);
+		if (ret)
+			DRM_ERROR("failed to put m_node.\n");
+	}
+
+	mutex_unlock(&c_node->mem_lock);
+}
+
 static void ipp_clean_cmd_node(struct ipp_context *ctx,
 				struct drm_exynos_ipp_cmd_node *c_node)
 {
@@ -599,90 +702,6 @@ static int ipp_set_mem_node(struct exynos_drm_ippdrv *ippdrv,
 	return ret;
 }
 
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
-	/* conditionally remove from queue */
-	if (m_node->list.next)
-		list_del(&m_node->list);
-	kfree(m_node);
-
-	return 0;
-}
-
-static struct drm_exynos_ipp_mem_node
-		*ipp_get_mem_node(struct drm_device *drm_dev,
-		struct drm_file *file,
-		struct drm_exynos_ipp_cmd_node *c_node,
-		struct drm_exynos_ipp_queue_buf *qbuf)
-{
-	struct drm_exynos_ipp_mem_node *m_node;
-	struct drm_exynos_ipp_buf_info *buf_info;
-	int i;
-
-	m_node = kzalloc(sizeof(*m_node), GFP_KERNEL);
-	if (!m_node)
-		return ERR_PTR(-ENOMEM);
-
-	buf_info = &m_node->buf_info;
-
-	/* operations, buffer id */
-	m_node->ops_id = qbuf->ops_id;
-	m_node->prop_id = qbuf->prop_id;
-	m_node->buf_id = qbuf->buf_id;
-
-	DRM_DEBUG_KMS("m_node[0x%x]ops_id[%d]\n", (int)m_node, qbuf->ops_id);
-	DRM_DEBUG_KMS("prop_id[%d]buf_id[%d]\n", qbuf->prop_id, m_node->buf_id);
-
-	for_each_ipp_planar(i) {
-		DRM_DEBUG_KMS("i[%d]handle[0x%x]\n", i, qbuf->handle[i]);
-
-		/* get dma address by handle */
-		if (qbuf->handle[i]) {
-			dma_addr_t *addr;
-
-			addr = exynos_drm_gem_get_dma_addr(drm_dev,
-					qbuf->handle[i], file);
-			if (IS_ERR(addr)) {
-				DRM_ERROR("failed to get addr.\n");
-				ipp_put_mem_node(drm_dev, c_node, m_node);
-				return ERR_PTR(-EFAULT);
-			}
-
-			buf_info->handles[i] = qbuf->handle[i];
-			buf_info->base[i] = *addr;
-			DRM_DEBUG_KMS("i[%d]base[0x%x]hd[0x%lx]\n", i,
-				      buf_info->base[i], buf_info->handles[i]);
-		}
-	}
-
-	mutex_lock(&c_node->mem_lock);
-	list_add_tail(&m_node->list, &c_node->mem_list[qbuf->ops_id]);
-	mutex_unlock(&c_node->mem_lock);
-
-	return m_node;
-}
-
 static void ipp_free_event(struct drm_pending_event *event)
 {
 	kfree(event);
@@ -1258,9 +1277,7 @@ static int ipp_stop_property(struct drm_device *drm_dev,
 		struct exynos_drm_ippdrv *ippdrv,
 		struct drm_exynos_ipp_cmd_node *c_node)
 {
-	struct drm_exynos_ipp_mem_node *m_node, *tm_node;
 	struct drm_exynos_ipp_property *property = &c_node->property;
-	struct list_head *head;
 	int ret = 0, i;
 
 	DRM_DEBUG_KMS("prop_id[%d]\n", property->prop_id);
@@ -1268,49 +1285,17 @@ static int ipp_stop_property(struct drm_device *drm_dev,
 	/* put event */
 	ipp_put_event(c_node, NULL);
 
-	mutex_lock(&c_node->mem_lock);
-
 	/* check command */
 	switch (property->cmd) {
 	case IPP_CMD_M2M:
-		for_each_ipp_ops(i) {
-			/* source/destination memory list */
-			head = &c_node->mem_list[i];
-
-			list_for_each_entry_safe(m_node, tm_node,
-				head, list) {
-				ret = ipp_put_mem_node(drm_dev, c_node,
-					m_node);
-				if (ret) {
-					DRM_ERROR("failed to put m_node.\n");
-					goto err_clear;
-				}
-			}
-		}
+		for_each_ipp_ops(i)
+			ipp_clean_mem_nodes(drm_dev, c_node, i);
 		break;
 	case IPP_CMD_WB:
-		/* destination memory list */
-		head = &c_node->mem_list[EXYNOS_DRM_OPS_DST];
-
-		list_for_each_entry_safe(m_node, tm_node, head, list) {
-			ret = ipp_put_mem_node(drm_dev, c_node, m_node);
-			if (ret) {
-				DRM_ERROR("failed to put m_node.\n");
-				goto err_clear;
-			}
-		}
+		ipp_clean_mem_nodes(drm_dev, c_node, EXYNOS_DRM_OPS_DST);
 		break;
 	case IPP_CMD_OUTPUT:
-		/* source memory list */
-		head = &c_node->mem_list[EXYNOS_DRM_OPS_SRC];
-
-		list_for_each_entry_safe(m_node, tm_node, head, list) {
-			ret = ipp_put_mem_node(drm_dev, c_node, m_node);
-			if (ret) {
-				DRM_ERROR("failed to put m_node.\n");
-				goto err_clear;
-			}
-		}
+		ipp_clean_mem_nodes(drm_dev, c_node, EXYNOS_DRM_OPS_SRC);
 		break;
 	default:
 		DRM_ERROR("invalid operations.\n");
@@ -1319,8 +1304,6 @@ static int ipp_stop_property(struct drm_device *drm_dev,
 	}
 
 err_clear:
-	mutex_unlock(&c_node->mem_lock);
-
 	/* stop operations */
 	if (ippdrv->stop)
 		ippdrv->stop(ippdrv->dev, property->cmd);
-- 
1.9.1

