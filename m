Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbaJCIZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 04:25:57 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:62932 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaJCIYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 04:24:34 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-55-542e5d3f230c
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
Subject: [PATCH RFC 2/4] drm/core: re-enable suspend/resume callbacks for KMS
 drivers
Date: Fri, 03 Oct 2014 10:24:11 +0200
Message-id: <1412324653-30677-3-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1412324653-30677-1-git-send-email-a.hajda@samsung.com>
References: <1412324653-30677-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t/xq7r2sXohBksmGVrcWneO1aL33Ekm
	i+Vn1jFbXPn6ns1i0v0JLBazJ2wGil1ez2jx4t5FFoveBVfZLM42vWG3uLxrDpvFjPP7mCzW
	HrnLbjFj8ks2Bz6PxXteMnls//aA1WPeyUCP+93HmTz6tqxi9Pi8SS6ALYrLJiU1J7MstUjf
	LoErY/W7o4wFa7grfnzczNTAuJOzi5GTQ0LARKLpwj8WCFtM4sK99WxdjFwcQgJLGSUmL2pm
	h3D6mCSWTVvBBlLFJqAp8XfzTSCbg0NEwFri2iRZkBpmgV5WiW9XmplBaoQFwiXaprxmBLFZ
	BFQlWp/fBOvlFXCWePTtEDvENjmJk8cms4LYnAIuEs97poHZQkA1Nx/8ZpvAyLuAkWEVo2hq
	aXJBcVJ6rqFecWJucWleul5yfu4mRkiQftnBuPiY1SFGAQ5GJR7ejzd0Q4RYE8uKK3MPMUpw
	MCuJ8E6O0gsR4k1JrKxKLcqPLyrNSS0+xMjEwSnVwNhnUtC8uPWd1lLO8KfX5m/zOOllbXlu
	Lr/xnjkPHE31rgdftzpZOHfawUOHTD8teeaZwqZyee2sU+Wzf9qseNlzp+L3Yca5/Ln9xWs8
	KjIFN+08fU/xfZkP1+P+Sa7RPkJFC9bGT+DI1j7/kM9awGfvV5E989917ZuTvb/62D2WdQ7X
	H0kmiSkrsRRnJBpqMRcVJwIAlGW69DACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implementing suspend/resume functionality in componentized drm drivers using
master component PM callbacks is problematic because those callbacks can be
called asynchronously regardless of existence/state of drm device.
The patch re-enables suspend/resume drm driver callbacks in drivers with
modeset feature enabled. These callback can be used to implement suspend/resume
functionality in more convenient way.

The patch should not affect behavior of existing drm drivers.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/drm_sysfs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index cc3d6d6..206afc4 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -45,7 +45,6 @@ static int __drm_class_suspend(struct device *dev, pm_message_t state)
 		struct drm_device *drm_dev = drm_minor->dev;
 
 		if (drm_minor->type == DRM_MINOR_LEGACY &&
-		    !drm_core_check_feature(drm_dev, DRIVER_MODESET) &&
 		    drm_dev->driver->suspend)
 			return drm_dev->driver->suspend(drm_dev, state);
 	}
@@ -86,7 +85,6 @@ static int drm_class_resume(struct device *dev)
 		struct drm_device *drm_dev = drm_minor->dev;
 
 		if (drm_minor->type == DRM_MINOR_LEGACY &&
-		    !drm_core_check_feature(drm_dev, DRIVER_MODESET) &&
 		    drm_dev->driver->resume)
 			return drm_dev->driver->resume(drm_dev);
 	}
-- 
1.9.1

