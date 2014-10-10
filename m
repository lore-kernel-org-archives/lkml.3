Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbaJJMcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 08:32:24 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:50999 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaJJMcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 08:32:19 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-50-5437d1d0492e
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
Subject: [PATCH 1/4] drm/exynos: propagate plane initialization errors
Date: Fri, 10 Oct 2014 14:31:53 +0200
Message-id: <1412944316-27737-2-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1412944316-27737-1-git-send-email-a.hajda@samsung.com>
References: <1412944316-27737-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t/xq7oXLpqHGEz+Lmdxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJWxZbNZQRN7Rf+uKywNjK9Yuxg5OSQETCS+THrGBGGLSVy4t56t
	i5GLQ0hgKaPE5yPzmSCcPiaJG90/mEGq2AQ0Jf5uvskGYosIKEus2tfODlLELPCRSeLK0jdg
	RcICbhILXh0Ds1kEVCU2P9nBDmLzCjhLXLr5kRlinZzEyWOTwc7gFHCR+H3rApDNAbTNWeL5
	JeUJjLwLGBlWMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoQE1ZcdjIuPWR1iFOBgVOLhvSBj
	HiLEmlhWXJl7iFGCg1lJhHf+XqAQb0piZVVqUX58UWlOavEhRiYOTqkGRgaD+zKlOXWpQW+u
	v2aXKOB0e2/eq+zEKS24p2f+h3p59zhjtnucp9o2ddjtfWZ8SP4BP+/+5Ysqbz4r4vS3Lfjj
	xOd9aotlx5QFXvr+zKm9FhNO6jnuYju8K0Ku6bxOw1TtV/8azqX2B11ovJ3C1rRDTihhWy7X
	g9KzXoeVdq79vtrdf2O6EktxRqKhFnNRcSIAcBGxvggCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of error during plane initialization load callback
incorrectly return success, this patch fixes it.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_drv.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
index cf19e60..322e7bf 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
@@ -87,8 +87,11 @@ static int exynos_drm_load(struct drm_device *dev, unsigned long flags)
 
 		plane = exynos_plane_init(dev, possible_crtcs,
 					  DRM_PLANE_TYPE_OVERLAY);
-		if (IS_ERR(plane))
-			goto err_mode_config_cleanup;
+		if (!IS_ERR(plane))
+			continue;
+
+		ret = PTR_ERR(plane);
+		goto err_mode_config_cleanup;
 	}
 
 	/* init kms poll for handling hpd */
-- 
1.9.1

