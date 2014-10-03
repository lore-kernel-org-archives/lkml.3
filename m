Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbaJCI0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 04:26:39 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:62932 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaJCIYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 04:24:32 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-4f-542e5d3e2e5c
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
Subject: [PATCH RFC 1/4] drm/i915: set PM callbacks only if modeset is turned
 off
Date: Fri, 03 Oct 2014 10:24:10 +0200
Message-id: <1412324653-30677-2-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1412324653-30677-1-git-send-email-a.hajda@samsung.com>
References: <1412324653-30677-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t/xq7p2sXohBm9/MlvcWneO1aL33Ekm
	i+Vn1jFbXPn6ns1i0v0JLBazJ2wGil1ez2jx4t5FFoveBVfZLM42vWG3uLxrDpvFjPP7mCzW
	HrnLbjFj8ks2Bz6PxXteMnls//aA1WPeyUCP+93HmTz6tqxi9Pi8SS6ALYrLJiU1J7MstUjf
	LoEr4+29RYwFG7gqGn/9ZWpgvMrRxcjJISFgInHx11YmCFtM4sK99WxdjFwcQgJLGSUuLlnP
	BOH0MUmsP3mSHaSKTUBT4u/mm0BVHBwiAtYS1ybJgtQwC/SySny70swMUiMsECwxtaWFBcRm
	EVCVuDx9DytIPa+As8T9XRoQy+QkTh6bzApicwq4SDzvmQZmCwGV3Hzwm20CI+8CRoZVjKKp
	pckFxUnpuYZ6xYm5xaV56XrJ+bmbGCEh+mUH4+JjVocYBTgYlXh4P97QDRFiTSwrrsw9xCjB
	wawkwjs5Si9EiDclsbIqtSg/vqg0J7X4ECMTB6dUA6PPee+lPxiCzj6yk1O3CG4omD5BOviT
	ZGTww7o63SX/3mxj75jPaj7v+h7Gng2HP/RuOfzKYILF4/f5ks3l+fMrLyxrcF7itqzCLv9M
	TeHiN4eqzPlTHU9efD3XP2u2Kefdhu3Bks98fy8IFz/lM3Fn/jXDlcHHJrIvKy47dOASu9zm
	R9NPBTcosRRnJBpqMRcVJwIA/F7Ybi8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently suspend and resume callbacks are called only if driver have
modeset feature disabled.
This patch moves the check directly to i915 driver, it will allow to
remove the check from the core in the future.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/i915/i915_drv.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 3870c73..481f62f 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -1617,10 +1617,6 @@ static struct drm_driver driver = {
 	.postclose = i915_driver_postclose,
 	.set_busid = drm_pci_set_busid,
 
-	/* Used in place of i915_pm_ops for non-DRIVER_MODESET */
-	.suspend = i915_suspend,
-	.resume = i915_resume_legacy,
-
 	.device_is_agp = i915_driver_device_is_agp,
 	.master_create = i915_master_create,
 	.master_destroy = i915_master_destroy,
@@ -1684,6 +1680,8 @@ static int __init i915_init(void)
 
 	if (!(driver.driver_features & DRIVER_MODESET)) {
 		driver.get_vblank_timestamp = NULL;
+		driver.suspend = i915_suspend;
+		driver.resume = i915_resume_legacy;
 #ifndef CONFIG_DRM_I915_UMS
 		/* Silently fail loading to not upset userspace. */
 		DRM_DEBUG_DRIVER("KMS and UMS disabled.\n");
-- 
1.9.1

