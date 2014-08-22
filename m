Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbaHVHzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:55:47 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49667 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283AbaHVHxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:53:47 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-5f-53f6f7083301
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
Subject: [PATCH 11/15] drm/exynos/ipp: remove events during command cleaning
Date: Fri, 22 Aug 2014 09:52:22 +0200
Message-id: <1408693946-15456-12-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xq7oc378FG/xcZGlxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJXxfcIcloI9OhVNz78xNjD+Uuli5OSQEDCRWH/oIxuELSZx4d56
	IJuLQ0hgKaPEtMkvGSGcPiaJ/xtOMYNUsQloSvzdfBOsQ0RAWWLVvnZ2kCJmgY9MEleWvgEr
	EhbwkWh6+o0JxGYRUJW403iFHcTmFXCRONf2hglinZzEyWOTWUFsTqD4hYPTwHqFBJwlum5P
	Y5rAyLuAkWEVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkhgfdnBuPiY1SFGAQ5GJR7exN9f
	g4VYE8uKK3MPMUpwMCuJ8G6a9y1YiDclsbIqtSg/vqg0J7X4ECMTB6dUA6N/y1m/QI6O1aVM
	2XHXD6pdXrzBVmChq0x+0jkn8/YAl1Ktng3eVafWOs3e4XUwgH9vxzupvPzFHm+XfOz9tdvS
	4cCD14JpXKrSq9tYrEOLf5kbvHGQaFv4PDGx59R9p8iMEEXpd4t2bGk/mXbHXn51t/7MmRFF
	d1n/Mmb+Fus6xrBYr4JpshJLcUaioRZzUXEiALuvPxUKAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Events were removed only during stop command, as a result
there were memory leaks if program prematurely exited.
This patch fixes it.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 155 ++++++++++++++++----------------
 1 file changed, 78 insertions(+), 77 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 6de75aa..ec88393 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -601,6 +601,81 @@ static void ipp_clean_mem_nodes(struct drm_device *drm_dev,
 	mutex_unlock(&c_node->mem_lock);
 }
 
+static void ipp_free_event(struct drm_pending_event *event)
+{
+	kfree(event);
+}
+
+static int ipp_get_event(struct drm_device *drm_dev,
+		struct drm_file *file,
+		struct drm_exynos_ipp_cmd_node *c_node,
+		struct drm_exynos_ipp_queue_buf *qbuf)
+{
+	struct drm_exynos_ipp_send_event *e;
+	unsigned long flags;
+
+	DRM_DEBUG_KMS("ops_id[%d]buf_id[%d]\n", qbuf->ops_id, qbuf->buf_id);
+
+	e = kzalloc(sizeof(*e), GFP_KERNEL);
+	if (!e) {
+		spin_lock_irqsave(&drm_dev->event_lock, flags);
+		file->event_space += sizeof(e->event);
+		spin_unlock_irqrestore(&drm_dev->event_lock, flags);
+		return -ENOMEM;
+	}
+
+	/* make event */
+	e->event.base.type = DRM_EXYNOS_IPP_EVENT;
+	e->event.base.length = sizeof(e->event);
+	e->event.user_data = qbuf->user_data;
+	e->event.prop_id = qbuf->prop_id;
+	e->event.buf_id[EXYNOS_DRM_OPS_DST] = qbuf->buf_id;
+	e->base.event = &e->event.base;
+	e->base.file_priv = file;
+	e->base.destroy = ipp_free_event;
+	mutex_lock(&c_node->event_lock);
+	list_add_tail(&e->base.link, &c_node->event_list);
+	mutex_unlock(&c_node->event_lock);
+
+	return 0;
+}
+
+static void ipp_put_event(struct drm_exynos_ipp_cmd_node *c_node,
+		struct drm_exynos_ipp_queue_buf *qbuf)
+{
+	struct drm_exynos_ipp_send_event *e, *te;
+	int count = 0;
+
+	mutex_lock(&c_node->event_lock);
+	list_for_each_entry_safe(e, te, &c_node->event_list, base.link) {
+		DRM_DEBUG_KMS("count[%d]e[0x%x]\n", count++, (int)e);
+
+		/*
+		 * qbuf == NULL condition means all event deletion.
+		 * stop operations want to delete all event list.
+		 * another case delete only same buf id.
+		 */
+		if (!qbuf) {
+			/* delete list */
+			list_del(&e->base.link);
+			kfree(e);
+		}
+
+		/* compare buffer id */
+		if (qbuf && (qbuf->buf_id ==
+		    e->event.buf_id[EXYNOS_DRM_OPS_DST])) {
+			/* delete list */
+			list_del(&e->base.link);
+			kfree(e);
+			goto out_unlock;
+		}
+	}
+
+out_unlock:
+	mutex_unlock(&c_node->event_lock);
+	return;
+}
+
 static void ipp_clean_cmd_node(struct ipp_context *ctx,
 				struct drm_exynos_ipp_cmd_node *c_node)
 {
@@ -611,6 +686,9 @@ static void ipp_clean_cmd_node(struct ipp_context *ctx,
 	cancel_work_sync(&c_node->stop_work->work);
 	cancel_work_sync(&c_node->event_work->work);
 
+	/* put event */
+	ipp_put_event(c_node, NULL);
+
 	for_each_ipp_ops(i)
 		ipp_clean_mem_nodes(ctx->subdrv.drm_dev, c_node, i);
 
@@ -707,81 +785,6 @@ static int ipp_set_mem_node(struct exynos_drm_ippdrv *ippdrv,
 	return ret;
 }
 
-static void ipp_free_event(struct drm_pending_event *event)
-{
-	kfree(event);
-}
-
-static int ipp_get_event(struct drm_device *drm_dev,
-		struct drm_file *file,
-		struct drm_exynos_ipp_cmd_node *c_node,
-		struct drm_exynos_ipp_queue_buf *qbuf)
-{
-	struct drm_exynos_ipp_send_event *e;
-	unsigned long flags;
-
-	DRM_DEBUG_KMS("ops_id[%d]buf_id[%d]\n", qbuf->ops_id, qbuf->buf_id);
-
-	e = kzalloc(sizeof(*e), GFP_KERNEL);
-	if (!e) {
-		spin_lock_irqsave(&drm_dev->event_lock, flags);
-		file->event_space += sizeof(e->event);
-		spin_unlock_irqrestore(&drm_dev->event_lock, flags);
-		return -ENOMEM;
-	}
-
-	/* make event */
-	e->event.base.type = DRM_EXYNOS_IPP_EVENT;
-	e->event.base.length = sizeof(e->event);
-	e->event.user_data = qbuf->user_data;
-	e->event.prop_id = qbuf->prop_id;
-	e->event.buf_id[EXYNOS_DRM_OPS_DST] = qbuf->buf_id;
-	e->base.event = &e->event.base;
-	e->base.file_priv = file;
-	e->base.destroy = ipp_free_event;
-	mutex_lock(&c_node->event_lock);
-	list_add_tail(&e->base.link, &c_node->event_list);
-	mutex_unlock(&c_node->event_lock);
-
-	return 0;
-}
-
-static void ipp_put_event(struct drm_exynos_ipp_cmd_node *c_node,
-		struct drm_exynos_ipp_queue_buf *qbuf)
-{
-	struct drm_exynos_ipp_send_event *e, *te;
-	int count = 0;
-
-	mutex_lock(&c_node->event_lock);
-	list_for_each_entry_safe(e, te, &c_node->event_list, base.link) {
-		DRM_DEBUG_KMS("count[%d]e[0x%x]\n", count++, (int)e);
-
-		/*
-		 * qbuf == NULL condition means all event deletion.
-		 * stop operations want to delete all event list.
-		 * another case delete only same buf id.
-		 */
-		if (!qbuf) {
-			/* delete list */
-			list_del(&e->base.link);
-			kfree(e);
-		}
-
-		/* compare buffer id */
-		if (qbuf && (qbuf->buf_id ==
-		    e->event.buf_id[EXYNOS_DRM_OPS_DST])) {
-			/* delete list */
-			list_del(&e->base.link);
-			kfree(e);
-			goto out_unlock;
-		}
-	}
-
-out_unlock:
-	mutex_unlock(&c_node->event_lock);
-	return;
-}
-
 static void ipp_handle_cmd_work(struct device *dev,
 		struct exynos_drm_ippdrv *ippdrv,
 		struct drm_exynos_ipp_cmd_work *cmd_work,
@@ -1287,8 +1290,6 @@ static int ipp_stop_property(struct drm_device *drm_dev,
 
 	DRM_DEBUG_KMS("prop_id[%d]\n", property->prop_id);
 
-	/* put event */
-	ipp_put_event(c_node, NULL);
 	/* stop operations */
 	if (ippdrv->stop)
 		ippdrv->stop(ippdrv->dev, property->cmd);
-- 
1.9.1

