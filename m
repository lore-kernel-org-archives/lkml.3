Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaJJMdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 08:33:03 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20588 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaJJMcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 08:32:22 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-54-5437d1d49a8b
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
Subject: [PATCH 3/4] drm/exynos: enable vblank after DPMS on
Date: Fri, 10 Oct 2014 14:31:55 +0200
Message-id: <1412944316-27737-4-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1412944316-27737-1-git-send-email-a.hajda@samsung.com>
References: <1412944316-27737-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t/xq7pXLpqHGJx/wWtxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJXR8qK6YD5nxbKGicwNjE/Zuxg5OSQETCQan01lgbDFJC7cW8/W
	xcjFISSwlFHi68t+Jginj0li0dP1YB1sApoSfzffZAOxRQSUJVbta2cHKWIW+MgkcWXpG2aQ
	hLCAjUTXnX9gNouAqsTqK81MIDavgLPE5mVzWCHWyUmcPDYZzOYUcJH4fesCkM0BtM1Z4vkl
	5QmMvAsYGVYxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihATV1x2MS49ZHWIU4GBU4uG9IGMe
	IsSaWFZcmXuIUYKDWUmEd/5eoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGemkmzuhLvxoZTkdY
	VrzyFV7I0nX9QMHuo+cr+J7k65ib5r+Z7h3Y9th78xzHmVKxXrbqAqLx+S9sVkQ+NcjMqFkr
	Hfv1T/mr7pJHp7PT7d9mbtNcLagSJVD2ocTrlw2P8exLzfsNmENOJx3uYTaXmuzcKH7wsbTg
	rCT3/8Zv6kuvB2q//6fEUpyRaKjFXFScCABe5H5OCAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before DPMS off driver disables vblank.
It should be balanced by vblank enable after DPMS on.
The patch fixes issue with page_flip ioctl not being able
to acquire vblank counter introduced by patch:
drm: Always reject drm_vblank_get() after drm_vblank_off()

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_crtc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_crtc.c b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
index 8e38e9f..45026e6 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_crtc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
@@ -71,13 +71,16 @@ static void exynos_drm_crtc_dpms(struct drm_crtc *crtc, int mode)
 				!atomic_read(&exynos_crtc->pending_flip),
 				HZ/20))
 			atomic_set(&exynos_crtc->pending_flip, 0);
-		drm_vblank_off(crtc->dev, exynos_crtc->pipe);
+		drm_crtc_vblank_off(crtc);
 	}
 
 	if (manager->ops->dpms)
 		manager->ops->dpms(manager, mode);
 
 	exynos_crtc->dpms = mode;
+
+	if (mode == DRM_MODE_DPMS_ON)
+		drm_crtc_vblank_on(crtc);
 }
 
 static void exynos_drm_crtc_prepare(struct drm_crtc *crtc)
-- 
1.9.1

