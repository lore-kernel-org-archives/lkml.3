Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaEZITC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 04:19:02 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:29493 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaEZIS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 04:18:56 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-88-5382f8db74f2
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
Subject: [PATCH 6/9] drm/exynos: ipp: rearrange c_node->mem_lock using routines
Date: Mon, 26 May 2014 10:17:20 +0200
Message-id: <1401092243-25568-7-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401092243-25568-1-git-send-email-a.hajda@samsung.com>
References: <1401092243-25568-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xa7q3fzQFGxxco2Jx5et7NotJ9yew
	WLy4d5HF4mzTG3aLy7vmsFnMOL+PyWLtkbvsFjMmv2Sz2LtzMqMDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJVx+tF+1oJDbhW/nn1jbmCcadHFyMkhIWAicezdGxYIW0ziwr31
	bF2MXBxCAksZJTb/ncME4fQxSZxesY0JpIpNQFPi7+abbCC2iICyxN+JqxhBipgFPjJJtHz/
	wA6SEBbwl1j05x4riM0ioCrx6EwvmM0r4CyxYtMaZoh1chInj00Gi3MKuEi8/rgSaAEH0DZn
	id/f+Scw8i5gZFjFKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERJWX3YwLj5mdYhRgINRiYf3
	RFBTsBBrYllxZe4hRgkOZiUR3uYPQCHelMTKqtSi/Pii0pzU4kOMTBycUg2MvVdeSDKYMk4I
	Ki7PYJ0jrJz0lbVQfoLDeU69N4usf35V+l2Z9vm0yfeJD+t7Y1SufLRb0CjQxKtwVerVj7je
	7S/flt/hO9kqpnV36cI2W4Ery/LndxvKH5K/c3rSAxPvuvfBf6yDihKvplU8NZFaqRk083XW
	LGPZWKvyiCaW4BsXXVIX/7ujxFKckWioxVxUnAgAQZ737wkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: YoungJun Cho <yj44.cho@samsung.com>

The c_node->mem_list[] should be protected with
c_node->mem_lock.

Signed-off-by: YoungJun Cho <yj44.cho@samsung.com>
Acked-by: Seong-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Tested-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 86 ++++++++++++++++++---------------
 1 file changed, 48 insertions(+), 38 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index f1c51b4..4b5afd3 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -584,8 +584,6 @@ static int ipp_check_mem_list(struct drm_exynos_ipp_cmd_node *c_node)
 	struct list_head *head;
 	int ret, i, count[EXYNOS_DRM_OPS_MAX] = { 0, };
 
-	mutex_lock(&c_node->mem_lock);
-
 	for_each_ipp_ops(i) {
 		/* source/destination memory list */
 		head = &c_node->mem_list[i];
@@ -614,8 +612,6 @@ static int ipp_check_mem_list(struct drm_exynos_ipp_cmd_node *c_node)
 		ret = max(count[EXYNOS_DRM_OPS_SRC],
 			count[EXYNOS_DRM_OPS_DST]);
 
-	mutex_unlock(&c_node->mem_lock);
-
 	return ret;
 }
 
@@ -658,16 +654,13 @@ static int ipp_set_mem_node(struct exynos_drm_ippdrv *ippdrv,
 		return -EFAULT;
 	}
 
-	mutex_lock(&c_node->mem_lock);
-
 	DRM_DEBUG_KMS("ops_id[%d]\n", m_node->ops_id);
 
 	/* get operations callback */
 	ops = ippdrv->ops[m_node->ops_id];
 	if (!ops) {
 		DRM_ERROR("not support ops.\n");
-		ret = -EFAULT;
-		goto err_unlock;
+		return -EFAULT;
 	}
 
 	/* set address and enable irq */
@@ -676,12 +669,10 @@ static int ipp_set_mem_node(struct exynos_drm_ippdrv *ippdrv,
 			m_node->buf_id, IPP_BUF_ENQUEUE);
 		if (ret) {
 			DRM_ERROR("failed to set addr.\n");
-			goto err_unlock;
+			return ret;
 		}
 	}
 
-err_unlock:
-	mutex_unlock(&c_node->mem_lock);
 	return ret;
 }
 
@@ -696,11 +687,9 @@ static struct drm_exynos_ipp_mem_node
 	void *addr;
 	int i;
 
-	mutex_lock(&c_node->mem_lock);
-
 	m_node = kzalloc(sizeof(*m_node), GFP_KERNEL);
 	if (!m_node)
-		goto err_unlock;
+		return ERR_PTR(-ENOMEM);
 
 	/* clear base address for error handling */
 	memset(&buf_info, 0x0, sizeof(buf_info));
@@ -734,15 +723,14 @@ static struct drm_exynos_ipp_mem_node
 
 	m_node->filp = file;
 	m_node->buf_info = buf_info;
+	mutex_lock(&c_node->mem_lock);
 	list_add_tail(&m_node->list, &c_node->mem_list[qbuf->ops_id]);
-
 	mutex_unlock(&c_node->mem_lock);
+
 	return m_node;
 
 err_clear:
 	kfree(m_node);
-err_unlock:
-	mutex_unlock(&c_node->mem_lock);
 	return ERR_PTR(-EFAULT);
 }
 
@@ -759,13 +747,6 @@ static int ipp_put_mem_node(struct drm_device *drm_dev,
 		return -EFAULT;
 	}
 
-	if (list_empty(&m_node->list)) {
-		DRM_ERROR("empty memory node.\n");
-		return -ENOMEM;
-	}
-
-	mutex_lock(&c_node->mem_lock);
-
 	DRM_DEBUG_KMS("ops_id[%d]\n", m_node->ops_id);
 
 	/* put gem buffer */
@@ -780,8 +761,6 @@ static int ipp_put_mem_node(struct drm_device *drm_dev,
 	list_del(&m_node->list);
 	kfree(m_node);
 
-	mutex_unlock(&c_node->mem_lock);
-
 	return 0;
 }
 
@@ -894,7 +873,9 @@ static int ipp_queue_buf_with_run(struct device *dev,
 		return 0;
 	}
 
+	mutex_lock(&c_node->mem_lock);
 	if (!ipp_check_mem_list(c_node)) {
+		mutex_unlock(&c_node->mem_lock);
 		DRM_DEBUG_KMS("empty memory.\n");
 		return 0;
 	}
@@ -911,10 +892,12 @@ static int ipp_queue_buf_with_run(struct device *dev,
 	} else {
 		ret = ipp_set_mem_node(ippdrv, c_node, m_node);
 		if (ret) {
+			mutex_unlock(&c_node->mem_lock);
 			DRM_ERROR("failed to set m node.\n");
 			return ret;
 		}
 	}
+	mutex_unlock(&c_node->mem_lock);
 
 	return 0;
 }
@@ -926,12 +909,14 @@ static void ipp_clean_queue_buf(struct drm_device *drm_dev,
 	struct drm_exynos_ipp_mem_node *m_node, *tm_node;
 
 	/* delete list */
+	mutex_lock(&c_node->mem_lock);
 	list_for_each_entry_safe(m_node, tm_node,
 		&c_node->mem_list[qbuf->ops_id], list) {
 		if (m_node->buf_id == qbuf->buf_id &&
 		    m_node->ops_id == qbuf->ops_id)
 			ipp_put_mem_node(drm_dev, c_node, m_node);
 	}
+	mutex_unlock(&c_node->mem_lock);
 }
 
 int exynos_drm_ipp_queue_buf(struct drm_device *drm_dev, void *data,
@@ -1267,9 +1252,11 @@ static int ipp_start_property(struct exynos_drm_ippdrv *ippdrv,
 	/* store command info in ippdrv */
 	ippdrv->c_node = c_node;
 
+	mutex_lock(&c_node->mem_lock);
 	if (!ipp_check_mem_list(c_node)) {
 		DRM_DEBUG_KMS("empty memory.\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_unlock;
 	}
 
 	/* set current property in ippdrv */
@@ -1277,7 +1264,7 @@ static int ipp_start_property(struct exynos_drm_ippdrv *ippdrv,
 	if (ret) {
 		DRM_ERROR("failed to set property.\n");
 		ippdrv->c_node = NULL;
-		return ret;
+		goto err_unlock;
 	}
 
 	/* check command */
@@ -1292,7 +1279,7 @@ static int ipp_start_property(struct exynos_drm_ippdrv *ippdrv,
 			if (!m_node) {
 				DRM_ERROR("failed to get node.\n");
 				ret = -EFAULT;
-				return ret;
+				goto err_unlock;
 			}
 
 			DRM_DEBUG_KMS("m_node[0x%x]\n", (int)m_node);
@@ -1300,7 +1287,7 @@ static int ipp_start_property(struct exynos_drm_ippdrv *ippdrv,
 			ret = ipp_set_mem_node(ippdrv, c_node, m_node);
 			if (ret) {
 				DRM_ERROR("failed to set m node.\n");
-				return ret;
+				goto err_unlock;
 			}
 		}
 		break;
@@ -1312,7 +1299,7 @@ static int ipp_start_property(struct exynos_drm_ippdrv *ippdrv,
 			ret = ipp_set_mem_node(ippdrv, c_node, m_node);
 			if (ret) {
 				DRM_ERROR("failed to set m node.\n");
-				return ret;
+				goto err_unlock;
 			}
 		}
 		break;
@@ -1324,14 +1311,16 @@ static int ipp_start_property(struct exynos_drm_ippdrv *ippdrv,
 			ret = ipp_set_mem_node(ippdrv, c_node, m_node);
 			if (ret) {
 				DRM_ERROR("failed to set m node.\n");
-				return ret;
+				goto err_unlock;
 			}
 		}
 		break;
 	default:
 		DRM_ERROR("invalid operations.\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_unlock;
 	}
+	mutex_unlock(&c_node->mem_lock);
 
 	DRM_DEBUG_KMS("cmd[%d]\n", property->cmd);
 
@@ -1340,11 +1329,17 @@ static int ipp_start_property(struct exynos_drm_ippdrv *ippdrv,
 		ret = ippdrv->start(ippdrv->dev, property->cmd);
 		if (ret) {
 			DRM_ERROR("failed to start ops.\n");
+			ippdrv->c_node = NULL;
 			return ret;
 		}
 	}
 
 	return 0;
+
+err_unlock:
+	mutex_unlock(&c_node->mem_lock);
+	ippdrv->c_node = NULL;
+	return ret;
 }
 
 static int ipp_stop_property(struct drm_device *drm_dev,
@@ -1361,6 +1356,8 @@ static int ipp_stop_property(struct drm_device *drm_dev,
 	/* put event */
 	ipp_put_event(c_node, NULL);
 
+	mutex_lock(&c_node->mem_lock);
+
 	/* check command */
 	switch (property->cmd) {
 	case IPP_CMD_M2M:
@@ -1410,6 +1407,8 @@ static int ipp_stop_property(struct drm_device *drm_dev,
 	}
 
 err_clear:
+	mutex_unlock(&c_node->mem_lock);
+
 	/* stop operations */
 	if (ippdrv->stop)
 		ippdrv->stop(ippdrv->dev, property->cmd);
@@ -1521,9 +1520,11 @@ static int ipp_send_event(struct exynos_drm_ippdrv *ippdrv,
 		return 0;
 	}
 
+	mutex_lock(&c_node->mem_lock);
 	if (!ipp_check_mem_list(c_node)) {
 		DRM_DEBUG_KMS("empty memory.\n");
-		return 0;
+		ret = 0;
+		goto err_mem_unlock;
 	}
 
 	/* check command */
@@ -1537,7 +1538,8 @@ static int ipp_send_event(struct exynos_drm_ippdrv *ippdrv,
 				struct drm_exynos_ipp_mem_node, list);
 			if (!m_node) {
 				DRM_ERROR("empty memory node.\n");
-				return -ENOMEM;
+				ret = -ENOMEM;
+				goto err_mem_unlock;
 			}
 
 			tbuf_id[i] = m_node->buf_id;
@@ -1559,7 +1561,8 @@ static int ipp_send_event(struct exynos_drm_ippdrv *ippdrv,
 		m_node = ipp_find_mem_node(c_node, &qbuf);
 		if (!m_node) {
 			DRM_ERROR("empty memory node.\n");
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto err_mem_unlock;
 		}
 
 		tbuf_id[EXYNOS_DRM_OPS_DST] = m_node->buf_id;
@@ -1576,7 +1579,8 @@ static int ipp_send_event(struct exynos_drm_ippdrv *ippdrv,
 			struct drm_exynos_ipp_mem_node, list);
 		if (!m_node) {
 			DRM_ERROR("empty memory node.\n");
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto err_mem_unlock;
 		}
 
 		tbuf_id[EXYNOS_DRM_OPS_SRC] = m_node->buf_id;
@@ -1587,8 +1591,10 @@ static int ipp_send_event(struct exynos_drm_ippdrv *ippdrv,
 		break;
 	default:
 		DRM_ERROR("invalid operations.\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_mem_unlock;
 	}
+	mutex_unlock(&c_node->mem_lock);
 
 	if (tbuf_id[EXYNOS_DRM_OPS_DST] != buf_id[EXYNOS_DRM_OPS_DST])
 		DRM_ERROR("failed to match buf_id[%d %d]prop_id[%d]\n",
@@ -1627,6 +1633,10 @@ static int ipp_send_event(struct exynos_drm_ippdrv *ippdrv,
 		property->cmd, property->prop_id, tbuf_id[EXYNOS_DRM_OPS_DST]);
 
 	return 0;
+
+err_mem_unlock:
+	mutex_unlock(&c_node->mem_lock);
+	return ret;
 }
 
 void ipp_sched_event(struct work_struct *work)
-- 
1.9.1

