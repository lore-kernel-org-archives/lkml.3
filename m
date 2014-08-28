Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965719AbaH1JIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:08:38 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56444 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965692AbaH1JI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:08:27 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-ce-53fef188b444
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
Subject: [PATCH v2 10/17] drm/exynos/ipp: stop hardware before freeing memory
Date: Thu, 28 Aug 2014 11:07:34 +0200
Message-id: <1409216861-12452-11-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
References: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xy7odH/8FG7yZyWpxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJVxZWIbU8E/roqG83PZGxi7ObsYOTkkBEwkJu1qZ4WwxSQu3FvP
	1sXIxSEksJRRouXzBEYIp49JYtX948wgVWwCmhJ/N99kA7FFBJQlVu1rZwcpYhb4yCRxZekb
	sCJhAV+JH1vWsYPYLAKqErcbGplAbF4BF4kzO54xQ6yTkzh5bDLYak6g+Mbjb8DqhQScJXaf
	/8w0gZF3ASPDKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQwPq6g3HpMatDjAIcjEo8vAqn
	/wQLsSaWFVfmHmKU4GBWEuE9evxfsBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGi9ztn1Y0RDf3
	hTO28UxfbLjqa7yA5eZpIS/UyrznmfyL8Dm0cLN/YfC1Wancisw2WacW713iOevoxePG8S0e
	Ue1Khgox2zXOPWDd3Dxb86fHa3PXW3yfTsp9+HbicuBXxmXltxJuL9rwvXmNytUcnfsp3A9z
	xO+ky6bF7b/u01ZZcbpf1bZciaU4I9FQi7moOBEAsOHyqQoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory shouldn't be freed when hardware is still running.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index fff3509..341db52 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -1282,12 +1282,15 @@ static int ipp_stop_property(struct drm_device *drm_dev,
 		struct drm_exynos_ipp_cmd_node *c_node)
 {
 	struct drm_exynos_ipp_property *property = &c_node->property;
-	int ret = 0, i;
+	int i;
 
 	DRM_DEBUG_KMS("prop_id[%d]\n", property->prop_id);
 
 	/* put event */
 	ipp_put_event(c_node, NULL);
+	/* stop operations */
+	if (ippdrv->stop)
+		ippdrv->stop(ippdrv->dev, property->cmd);
 
 	/* check command */
 	switch (property->cmd) {
@@ -1303,16 +1306,10 @@ static int ipp_stop_property(struct drm_device *drm_dev,
 		break;
 	default:
 		DRM_ERROR("invalid operations.\n");
-		ret = -EINVAL;
-		goto err_clear;
+		return -EINVAL;
 	}
 
-err_clear:
-	/* stop operations */
-	if (ippdrv->stop)
-		ippdrv->stop(ippdrv->dev, property->cmd);
-
-	return ret;
+	return 0;
 }
 
 void ipp_sched_cmd(struct work_struct *work)
-- 
1.9.1

