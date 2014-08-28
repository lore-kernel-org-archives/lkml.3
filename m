Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965681AbaH1JIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:08:24 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56438 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965634AbaH1JIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:08:18 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-b9-53fef17fdac2
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
Subject: [PATCH v2 03/17] drm/exynos/ipp: move file reference from memory to
 command node
Date: Thu, 28 Aug 2014 11:07:27 +0200
Message-id: <1409216861-12452-4-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
References: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xy7r1H/8FG6yaYGhxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJWxtjms4J9gxeVrD1gaGFv4uxg5OSQETCQW79vDDGGLSVy4t56t
	i5GLQ0hgKaPEj33LmCGcPiaJ6W3zWUGq2AQ0Jf5uvskGYosIKEus2tfODlLELPCRSeLK0jdg
	o4QFoiVOrWoAs1kEVCVOtrUzgti8As4Sz3avhFonJ3Hy2GSwoZwCLhIbj79hB7GFgGp2n//M
	NIGRdwEjwypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkLD6soNx8TGrQ4wCHIxKPLwbSv8F
	C7EmlhVX5h5ilOBgVhLhPXocKMSbklhZlVqUH19UmpNafIiRiYNTqoGxtMzFz6x0we9os8Mr
	CrL1vaN51zlPkKn/mZrJmssqneR88d+WuucLos2uCPPF+S+Y8elQ/uZtGdNjVj1jmLr1+6/X
	knwX3ntdSen+WCtS4l//USbf/JrP2z5zD7PKsL3VDzhljJXL3R0Xf1eQL/8c5fBZ5IKI662d
	AmsWqbAcVv9/Idoy6oISS3FGoqEWc1FxIgBnNs95CQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Command node should contain file reference to distinguish commands
created by different processes.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Joonyoung Shim <jy0922.shim@samsung.com>
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

