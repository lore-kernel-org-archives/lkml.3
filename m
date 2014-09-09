Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbaIINSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:18:32 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20764 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaIINRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:17:07 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-ad-540efdd2cd0d
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
Subject: [PATCH 5/9] drm/exynos/crtc: fix framebuffer reference sequence
Date: Tue, 09 Sep 2014 15:16:09 +0200
Message-id: <1410268573-2297-6-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
References: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t/xK7qX/vKFGOw7wGNxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJXx4e5VxoI/EhU9uy+wNTDeEO1i5OSQEDCReNdyhRXCFpO4cG89
	WxcjF4eQwFJGie/nPrGDJIQE+pgkVq2KArHZBDQl/m6+yQZiiwgoS6za184O0sAs8JFJ4srS
	N8wgCWEBD4lXR1aBNbMIqEo0/zgFtoFXwEniyptzzBDb5CROHpsMFOfg4BRwlnj7LwBil5PE
	grff2Ccw8i5gZFjFKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERJUX3YwLj5mdYhRgINRiYe3
	IYMvRIg1say4MvcQowQHs5IIr/ULoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZG+7MO391l7wlX
	vAuYdoE1+KHEjtnd92IYMzefDnu9bUXy37p85gn77QUTOScYb72bscpDPFlKqqXRJni7v/2P
	noVxW5uYvjV4iTYIXjS9b7LxznlDkSRxwTd9L9g4jtx//n5DoMD/a77TTB5OnfNjwsXa2RIr
	1/6Lt77aJ/LuQ4hP97GcdZJnlViKMxINtZiLihMBcXezuQgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding reference to framebuffer should be accompanied with removing
reference to old framebuffer assigned to the plane.
This patch removes following warning:

[   95.038017] WARNING: CPU: 1 PID: 3067 at drivers/gpu/drm/drm_crtc.c:5115 drm_mode_config_cleanup+0x258/0x268()
[   95.048086] Modules linked in:
[   95.051430] CPU: 1 PID: 3067 Comm: bash Tainted: G        W      3.16.0-11355-g7a6eca5-dirty #3015
[   95.060058] [<c0013e90>] (unwind_backtrace) from [<c0011128>] (show_stack+0x10/0x14)
[   95.067766] [<c0011128>] (show_stack) from [<c04a5dc4>] (dump_stack+0x70/0xbc)
[   95.074953] [<c04a5dc4>] (dump_stack) from [<c0021784>] (warn_slowpath_common+0x64/0x88)
[   95.083005] [<c0021784>] (warn_slowpath_common) from [<c00217c4>] (warn_slowpath_null+0x1c/0x24)
[   95.091780] [<c00217c4>] (warn_slowpath_null) from [<c0275fa0>] (drm_mode_config_cleanup+0x258/0x268)
[   95.100983] [<c0275fa0>] (drm_mode_config_cleanup) from [<c0281724>] (exynos_drm_unload+0x38/0x50)
[   95.109915] [<c0281724>] (exynos_drm_unload) from [<c026e248>] (drm_dev_unregister+0x24/0x98)
[   95.118414] [<c026e248>] (drm_dev_unregister) from [<c026ecb0>] (drm_put_dev+0x28/0x64)
[   95.126412] [<c026ecb0>] (drm_put_dev) from [<c02947c4>] (take_down_master+0x24/0x44)
[   95.134218] [<c02947c4>] (take_down_master) from [<c0294870>] (component_del+0x8c/0xc8)
[   95.142201] [<c0294870>] (component_del) from [<c0286c10>] (exynos_dsi_remove+0x18/0x2c)
[   95.150294] [<c0286c10>] (exynos_dsi_remove) from [<c0299e04>] (platform_drv_remove+0x18/0x1c)
[   95.158872] [<c0299e04>] (platform_drv_remove) from [<c02987a4>] (__device_release_driver+0x70/0xc4)
[   95.167981] [<c02987a4>] (__device_release_driver) from [<c0298818>] (device_release_driver+0x20/0x2c)
[   95.177268] [<c0298818>] (device_release_driver) from [<c02979d0>] (unbind_store+0x5c/0x94)
[   95.185597] [<c02979d0>] (unbind_store) from [<c0297278>] (drv_attr_store+0x20/0x2c)
[   95.193323] [<c0297278>] (drv_attr_store) from [<c012aa90>] (sysfs_kf_write+0x4c/0x50)
[   95.201224] [<c012aa90>] (sysfs_kf_write) from [<c0129e94>] (kernfs_fop_write+0xc4/0x184)
[   95.209393] [<c0129e94>] (kernfs_fop_write) from [<c00d03ec>] (vfs_write+0xa0/0x1a8)
[   95.217111] [<c00d03ec>] (vfs_write) from [<c00d07f8>] (SyS_write+0x40/0x8c)
[   95.224146] [<c00d07f8>] (SyS_write) from [<c000e660>] (ret_fast_syscall+0x0/0x48)

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_crtc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_crtc.c b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
index b68e58f..bde19f4 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_crtc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
@@ -145,10 +145,16 @@ exynos_drm_crtc_mode_set(struct drm_crtc *crtc, struct drm_display_mode *mode,
 	if (ret)
 		return ret;
 
+	/* we need to unreference current fb after replacing it with new one */
+	old_fb = plane->fb;
+
 	plane->crtc = crtc;
 	plane->fb = crtc->primary->fb;
 	drm_framebuffer_reference(plane->fb);
 
+	if (old_fb)
+		drm_framebuffer_unreference(old_fb);
+
 	return 0;
 }
 
-- 
1.9.1

