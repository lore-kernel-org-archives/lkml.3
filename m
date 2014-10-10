Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbaJJMca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 08:32:30 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36238 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbaJJMcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 08:32:24 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-6b-5437d1d5b6e0
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
Subject: [PATCH 4/4] drm/exynos: correct connector->dpms field before resuming
Date: Fri, 10 Oct 2014 14:31:56 +0200
Message-id: <1412944316-27737-5-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1412944316-27737-1-git-send-email-a.hajda@samsung.com>
References: <1412944316-27737-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xq7pXL5qHGPRe1rG4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2CO4rJJSc3JLEst0rdL4Mp4+GsyW8EJjorTK9cyNTAuYu9i5OSQEDCRaJ1zjA3CFpO4cG89
	kM3FISSwlFGip/0EC4TTxySx5/4/RpAqNgFNib+bb4J1iAgoS6za184OUsQs8JFJ4srSN8wg
	CWEBP4nlM6eDFbEIqEosm7qbCcTmFXCWmDZ1FdQ6OYmTxyazgticAi4Sv29dALI5gLY5Szy/
	pDyBkXcBI8MqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJCw+rKDcfExq0OMAhyMSjy8F2TM
	Q4RYE8uKK3MPMUpwMCuJ8M7fCxTiTUmsrEotyo8vKs1JLT7EyMTBKdXAWJe/786xpMyraeei
	+BbLfRFLf8ezwfSduOXPDWXu11wvCmh8WHRNMeWa7+vVYhWzYtJsHgl/XL/PVml/w/vm642+
	ojue/pVbfPZN+6Eu56K3l6uuLusSdMoU/pfjsvrltzUz3a896lwRoTVPSmrSictV2+0Ou12q
	uv3uf42vq/PMBYmXDCufmCixFGckGmoxFxUnAgBjp2CYCQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During system suspend after connector switch off its dpms field
is set to connector previous dpms state. To properly resume dpms field
should be set to its actual state (off) before resuming to previous dpms state.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_drv.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
index ce6c14c..fe250e4 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
@@ -194,8 +194,12 @@ static int exynos_drm_resume(struct drm_device *dev)
 
 	drm_modeset_lock_all(dev);
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
-		if (connector->funcs->dpms)
-			connector->funcs->dpms(connector, connector->dpms);
+		if (connector->funcs->dpms) {
+			int dpms = connector->dpms;
+
+			connector->dpms = DRM_MODE_DPMS_OFF;
+			connector->funcs->dpms(connector, dpms);
+		}
 	}
 	drm_modeset_unlock_all(dev);
 
-- 
1.9.1

