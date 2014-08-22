Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbaHVHxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:53:40 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49654 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945AbaHVHxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:53:37 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-b9-53f6f6ff9d9a
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
Subject: [PATCH 06/15] drm/exynos/ipp: free partially allocated resources on
 error
Date: Fri, 22 Aug 2014 09:52:17 +0200
Message-id: <1408693946-15456-7-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xq7r/v30LNjgxRc/i1rpzrBZXvr5n
	s5h0fwKLxYt7F1kszja9Ybe4vGsOm8WM8/uYLNYeuctuMWPySzYHTo/73ceZPPq2rGL0+LxJ
	LoA5issmJTUnsyy1SN8ugSujvVGv4I1Ixf/2aYwNjJ2CXYycHBICJhJvnrUwQdhiEhfurWfr
	YuTiEBJYyijx9+QLVginj0liVfdmZpAqNgFNib+bb7KB2CICyhKr9rWzgxQxC3xkkriy9A1Y
	kbBAiMTWxS/YQWwWAVWJj+9egzXwCjhLfNzzhBlinZzEyWOTWUFsTgEXiQsHp4HFhYBqum5P
	Y5rAyLuAkWEVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkhYfd3BuPSY1SFGAQ5GJR7eyC9f
	g4VYE8uKK3MPMUpwMCuJ8G6a9y1YiDclsbIqtSg/vqg0J7X4ECMTB6dUA+MO4wqTj9eY/L58
	OG/vs90gumV70503rE0d96UT33DKPV71nenAfg4vv6VVMhrbtbVni7xM8WrUfbmHR+/x9K5F
	C8Jk5zjbfGyq7Z/ncPfArbAQ86bglw3dLs/qrx7Llrsa4uWX6MGdLH7HR+s504W/byKPvFio
	arH/6AH33Le7MkVzlG4eLVNiKc5INNRiLipOBACZtLw0CQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of allocation errors some already allocated buffers
were not freed. The patch fixes it.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 68 ++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 35 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 060a198..728f3b9 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -599,6 +599,37 @@ static int ipp_set_mem_node(struct exynos_drm_ippdrv *ippdrv,
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
 static struct drm_exynos_ipp_mem_node
 		*ipp_get_mem_node(struct drm_device *drm_dev,
 		struct drm_file *file,
@@ -634,7 +665,8 @@ static struct drm_exynos_ipp_mem_node
 					qbuf->handle[i], file);
 			if (IS_ERR(addr)) {
 				DRM_ERROR("failed to get addr.\n");
-				goto err_clear;
+				ipp_put_mem_node(drm_dev, c_node, m_node);
+				return ERR_PTR(-EFAULT);
 			}
 
 			buf_info->handles[i] = qbuf->handle[i];
@@ -649,40 +681,6 @@ static struct drm_exynos_ipp_mem_node
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

