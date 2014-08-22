Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbaHVHxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:53:48 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34675 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062AbaHVHxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:53:45 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-54-53f6f7072f09
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
Subject: [PATCH 10/15] drm/exynos/ipp: stop hardware before freeing memory
Date: Fri, 22 Aug 2014 09:52:21 +0200
Message-id: <1408693946-15456-11-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xq7rs378FG7xbxmtxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJWxec8CxoLjXBW7bsxibWC8ydHFyMkhIWAi8en/ZiYIW0ziwr31
	bF2MXBxCAksZJa79bGGEcPqYJG68+QlWxSagKfF38002EFtEQFli1b52dpAiZoGPTBJXlr5h
	BkkIC3hJnLhzkBHEZhFQlXjwsxMszivgIvF34xFGiHVyEiePTWYFsTmB4hcOTgOrERJwlui6
	PY1pAiPvAkaGVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxghgfVlB+PiY1aHGAU4GJV4eBN/
	fw0WYk0sK67MPcQowcGsJMK7ad63YCHelMTKqtSi/Pii0pzU4kOMTBycUg2MC5l31Qh+l3Vd
	tLEg4PfGgGNMC7g3+67JuN5hv3B9YbPQ8oXzJOr7PE+5Lzxn65Tfz6TEO4nl/PJZ7jtDv7+Y
	VvQ018PqkHBPs3jF/KZN/cu/T5T5PPeJbc2tvMhyl7iXGw+q6H48d2filmWFCqdKhFWs+Ms5
	49heRqf3bbe8qcqQy+72clW+EktxRqKhFnNRcSIAbtekPAoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory shouldn't be freed when hardware is still running.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index c72d8d1..6de75aa 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -1283,12 +1283,15 @@ static int ipp_stop_property(struct drm_device *drm_dev,
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
@@ -1304,16 +1307,10 @@ static int ipp_stop_property(struct drm_device *drm_dev,
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

