Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbaHVH5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:57:32 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:49131 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaHVHxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:53:30 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-1f-53f6f6f8ecfb
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
Subject: [PATCH 03/15] drm/exynos/ipp: move file reference from memory to
 command node
Date: Fri, 22 Aug 2014 09:52:14 +0200
Message-id: <1408693946-15456-4-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xq7o/vn0LNnixWNPi1rpzrBZXvr5n
	s5h0fwKLxYt7F1kszja9Ybe4vGsOm8WM8/uYLNYeuctuMWPySzYHTo/73ceZPPq2rGL0+LxJ
	LoA5issmJTUnsyy1SN8ugStj7fMJbAXHBSuarh9ka2C8xNfFyMkhIWAi8W3HD1YIW0ziwr31
	bF2MXBxCAksZJS727mWFcPqYJM4fusMGUsUmoCnxd/NNMFtEQFli1b52dpAiZoGPTBJXlr5h
	BkkIC0RInPm7jRHEZhFQldjzcztLFyMHB6+As8Tv24wQ2+QkTh6bDLaZU8BF4sLBaWCtQkAl
	XbenMU1g5F3AyLCKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIySsvuxgXHzM6hCjAAejEg9v
	4u+vwUKsiWXFlbmHGCU4mJVEeDfN+xYsxJuSWFmVWpQfX1Sak1p8iJGJg1OqgTHpUe7RT9dd
	pE49qHX4dLiS48fFlN9eTzYs8Nc69rY6te7asbXiGeEnDnyV3DFvTcOkpgMWRt7Hz767d3zW
	zf0JhiJqPQZeVw6ruH60mWj0Zo43j6fQNOvgKS919Y9detcv/kr5x4LMB/pP3i5c03rjvK2F
	eIb3C+5DLrMU759S2Hc9P3VJe+RWJZbijERDLeai4kQAiFxolwkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Command node should contain file reference to distinguish commands
created by different processes.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 5 ++---
 drivers/gpu/drm/exynos/exynos_drm_ipp.h | 2 ++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 9770966..bbe9968 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -75,7 +75,6 @@ struct drm_exynos_ipp_mem_node {
 	u32	prop_id;
 	u32	buf_id;
 	struct drm_exynos_ipp_buf_info	buf_info;
-	struct drm_file		*filp;
 };
 
 /*
@@ -448,6 +447,7 @@ int exynos_drm_ipp_set_property(struct drm_device *drm_dev, void *data,
 	c_node->dev = dev;
 	c_node->property = *property;
 	c_node->state = IPP_STATE_IDLE;
+	c_node->filp = file;
 
 	c_node->start_work = ipp_create_cmd_work();
 	if (IS_ERR(c_node->start_work)) {
@@ -645,7 +645,6 @@ static struct drm_exynos_ipp_mem_node
 		}
 	}
 
-	m_node->filp = file;
 	mutex_lock(&c_node->mem_lock);
 	list_add_tail(&m_node->list, &c_node->mem_list[qbuf->ops_id]);
 	mutex_unlock(&c_node->mem_lock);
@@ -677,7 +676,7 @@ static int ipp_put_mem_node(struct drm_device *drm_dev,
 		unsigned long handle = m_node->buf_info.handles[i];
 		if (handle)
 			exynos_drm_gem_put_dma_addr(drm_dev, handle,
-							m_node->filp);
+							c_node->filp);
 	}
 
 	/* delete list in queue */
diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.h b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
index 6f48d62..0311035 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.h
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
@@ -62,6 +62,7 @@ struct drm_exynos_ipp_cmd_work {
  * @stop_work: stop command work structure.
  * @event_work: event work structure.
  * @state: state of command node.
+ * @filp: associated file pointer.
  */
 struct drm_exynos_ipp_cmd_node {
 	struct device		*dev;
@@ -78,6 +79,7 @@ struct drm_exynos_ipp_cmd_node {
 	struct drm_exynos_ipp_cmd_work *stop_work;
 	struct drm_exynos_ipp_event_work *event_work;
 	enum drm_exynos_ipp_state	state;
+	struct drm_file	*filp;
 };
 
 /*
-- 
1.9.1

