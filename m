Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaEZITx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 04:19:53 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:37365 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbaEZISw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 04:18:52 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-a3-5382f8e0e428
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
Subject: [PATCH 7/9] drm/exynos: ipp: rearrange c_node->event_lock using routine
Date: Mon, 26 May 2014 10:17:21 +0200
Message-id: <1401092243-25568-8-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401092243-25568-1-git-send-email-a.hajda@samsung.com>
References: <1401092243-25568-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCJMWRmVeSWpSXmKPExsVy+t/xa7oPfjQFG5w6pmpx5et7NotJ9yew
	WLy4d5HF4mzTG3aLy7vmsFnMOL+PyWLtkbvsFjMmv2Sz2LtzMqMDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJWx+8p8loK/0hV7nuxnbGC8Lt7FyMEhIWAisfmXWxcjJ5ApJnHh
	3nq2LkYuDiGBpYwS01pPMkE4fUwSLx68YQWpYhPQlPi7+SYbiC0ioCzxd+IqRpAiZoGPTBIt
	3z+wgySEBQIk9n38zARiswioSqz/uJcNZBuvgLPEpWkZENvkJE4emww2k1PAReL1x5VMICVC
	QCW/v/NPYORdwMiwilE0tTS5oDgpPddQrzgxt7g0L10vOT93EyMkpL7sYFx8zOoQowAHoxIP
	74mgpmAh1sSy4srcQ4wSHMxKIrzNH4BCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGLPObHqUYVe/
	iXf5mzU7Pts1pR5uD7tv/6WRQ2/VroTPfRKBN2+d2a/8hefTEgXpJ1NWJbKdcW4Wez/xalcw
	m4hZWnfDgnnzxL+YVs2b1Ha68t9Vpv+zpF503DVkfrrcqHNrQX3Mo/o1X4sLMl/8vHYtSPVT
	ohPHDhdlScHgKuf+yvaTB7aeVVBiKc5INNRiLipOBAAnqruDBwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: YoungJun Cho <yj44.cho@samsung.com>

The c_node->event_list should be protected with
c_node->event_lock.

Signed-off-by: YoungJun Cho <yj44.cho@samsung.com>
Acked-by: Seong-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Tested-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 4b5afd3..603a796 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -796,7 +796,9 @@ static int ipp_get_event(struct drm_device *drm_dev,
 	e->base.event = &e->event.base;
 	e->base.file_priv = file;
 	e->base.destroy = ipp_free_event;
+	mutex_lock(&c_node->event_lock);
 	list_add_tail(&e->base.link, &c_node->event_list);
+	mutex_unlock(&c_node->event_lock);
 
 	return 0;
 }
@@ -807,6 +809,7 @@ static void ipp_put_event(struct drm_exynos_ipp_cmd_node *c_node,
 	struct drm_exynos_ipp_send_event *e, *te;
 	int count = 0;
 
+	mutex_lock(&c_node->event_lock);
 	list_for_each_entry_safe(e, te, &c_node->event_list, base.link) {
 		DRM_DEBUG_KMS("count[%d]e[0x%x]\n", count++, (int)e);
 
@@ -827,9 +830,13 @@ static void ipp_put_event(struct drm_exynos_ipp_cmd_node *c_node,
 			/* delete list */
 			list_del(&e->base.link);
 			kfree(e);
-			return;
+			goto out_unlock;
 		}
 	}
+
+out_unlock:
+	mutex_unlock(&c_node->event_lock);
+	return;
 }
 
 static void ipp_handle_cmd_work(struct device *dev,
@@ -1515,9 +1522,11 @@ static int ipp_send_event(struct exynos_drm_ippdrv *ippdrv,
 		return -EINVAL;
 	}
 
+	mutex_lock(&c_node->event_lock);
 	if (list_empty(&c_node->event_list)) {
 		DRM_DEBUG_KMS("event list is empty.\n");
-		return 0;
+		ret = 0;
+		goto err_event_unlock;
 	}
 
 	mutex_lock(&c_node->mem_lock);
@@ -1609,11 +1618,6 @@ static int ipp_send_event(struct exynos_drm_ippdrv *ippdrv,
 	e = list_first_entry(&c_node->event_list,
 		struct drm_exynos_ipp_send_event, base.link);
 
-	if (!e) {
-		DRM_ERROR("empty event.\n");
-		return -EINVAL;
-	}
-
 	do_gettimeofday(&now);
 	DRM_DEBUG_KMS("tv_sec[%ld]tv_usec[%ld]\n", now.tv_sec, now.tv_usec);
 	e->event.tv_sec = now.tv_sec;
@@ -1628,6 +1632,7 @@ static int ipp_send_event(struct exynos_drm_ippdrv *ippdrv,
 	list_move_tail(&e->base.link, &e->base.file_priv->event_list);
 	wake_up_interruptible(&e->base.file_priv->event_wait);
 	spin_unlock_irqrestore(&drm_dev->event_lock, flags);
+	mutex_unlock(&c_node->event_lock);
 
 	DRM_DEBUG_KMS("done cmd[%d]prop_id[%d]buf_id[%d]\n",
 		property->cmd, property->prop_id, tbuf_id[EXYNOS_DRM_OPS_DST]);
@@ -1636,6 +1641,8 @@ static int ipp_send_event(struct exynos_drm_ippdrv *ippdrv,
 
 err_mem_unlock:
 	mutex_unlock(&c_node->mem_lock);
+err_event_unlock:
+	mutex_unlock(&c_node->event_lock);
 	return ret;
 }
 
@@ -1678,8 +1685,6 @@ void ipp_sched_event(struct work_struct *work)
 		goto err_completion;
 	}
 
-	mutex_lock(&c_node->event_lock);
-
 	ret = ipp_send_event(ippdrv, c_node, event_work->buf_id);
 	if (ret) {
 		DRM_ERROR("failed to send event.\n");
@@ -1689,8 +1694,6 @@ void ipp_sched_event(struct work_struct *work)
 err_completion:
 	if (ipp_is_m2m_cmd(c_node->property.cmd))
 		complete(&c_node->start_complete);
-
-	mutex_unlock(&c_node->event_lock);
 }
 
 static int ipp_subdrv_probe(struct drm_device *drm_dev, struct device *dev)
-- 
1.9.1

