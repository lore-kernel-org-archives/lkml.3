Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaJCIYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 04:24:49 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49619 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaJCIYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 04:24:41 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-70-542e5d4775c8
From: Andrzej Hajda <a.hajda@samsung.com>
To: dri-devel@lists.freedesktop.org (open list:DRM DRIVERS)
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        David Airlie <airlied@linux.ie>, Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS),
        linux-kernel@vger.kernel.org (open list),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        intel-gfx@lists.freedesktop.org (open list:INTEL DRM DRIVERS...)
Subject: [PATCH RFC 4/4] drm/exynos: correct connector->dpms field before
 resuming
Date: Fri, 03 Oct 2014 10:24:13 +0200
Message-id: <1412324653-30677-5-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1412324653-30677-1-git-send-email-a.hajda@samsung.com>
References: <1412324653-30677-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t/xq7rusXohBuceMVncWneO1aL33Ekm
	i+Vn1jFbXPn6ns1i0v0JLBazJ2wGil1ez2jx4t5FFoveBVfZLM42vWG3uLxrDpvFjPP7mCzW
	HrnLbjFj8ks2Bz6PxXteMnls//aA1WPeyUCP+93HmTz6tqxi9Pi8SS6ALYrLJiU1J7MstUjf
	LoEr49+CPYwFFzkqXv1/yNrAuJq9i5GTQ0LAROLWzYUsELaYxIV769m6GLk4hASWMkpM7NzE
	CuH0MUncXPqBEaSKTUBT4u/mm0BVHBwiAtYS1ybJgtQwC/SySny70swMUiMsECJxp3Ei2AYW
	AVWJKb/Wgdm8As4SLUdus0Fsk5M4eWwyK4jNKeAi8bxnGpgtBFRz88FvtgmMvAsYGVYxiqaW
	JhcUJ6XnGukVJ+YWl+al6yXn525ihATp1x2MS49ZHWIU4GBU4uH9cEM3RIg1say4MvcQowQH
	s5II7+QovRAh3pTEyqrUovz4otKc1OJDjEwcnFINjHvfnWzJNVCrPSp/fsLTfF+T+6p3XISy
	V22a8dDCR9ffpujDFr45b7Qj9ZzKrS24rl0+UihoYJOX5JB2TmXBmUSlSK15AkcPnnnxeLvB
	24C1eR13f8+/7LhdfQ7rJ6MPjn9DhZfqfHDc0MPkqTGH2XCSXXO+ue/X2u+zis+KtjbM/8bE
	ppKqrcRSnJFoqMVcVJwIALlgep8wAgAA
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
index dca20b15..6746c5a 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
@@ -191,8 +191,12 @@ static int exynos_drm_resume(struct drm_device *dev)
 
 	drm_modeset_lock_all(dev);
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
-		if (connector->funcs->dpms)
-			connector->funcs->dpms(connector, connector->dpms);
+		if (connector->funcs->dpms) {
+			int old_dpms = connector->dpms;
+
+			connector->dpms = DRM_MODE_DPMS_OFF;
+			connector->funcs->dpms(connector, old_dpms);
+		}
 	}
 	drm_modeset_unlock_all(dev);
 
-- 
1.9.1

