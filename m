Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaJAIPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:15:00 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20057 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaJAIOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:14:55 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-0f-542bb7fc304f
From: Andrzej Hajda <a.hajda@samsung.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm/exynos: fix vblank handling during dpms off
Date: Wed, 01 Oct 2014 10:14:47 +0200
Message-id: <1412151287-12845-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <542B9A0E.7020206@samsung.com>
References: <542B9A0E.7020206@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHJMWRmVeSWpSXmKPExsVy+t/xy7p/tmuHGLz4b2Nxa905VovecyeZ
	LK58fc9mMen+BBaLF/cuslj0LrjKZnG26Q27xeVdc9gsZpzfx2QxY/JLNgcuj+3fHrB63O8+
	zuTRt2UVo8fnTXIBLFFcNimpOZllqUX6dglcGcfuX2UruMNZ8X7VDsYGxl6OLkYODgkBE4kP
	W0K7GDmBTDGJC/fWs3UxcnEICSxllJg0qQXK6WOSeHbjGxtIFZuApsTfzTfBbBEBZYlV+9rZ
	QYqYBa4ySaxfe5gNZKqwgIPE+vkOIDUsAqoSr38fYgexeQWcJX68PM8MsU1O4uSxyawg5ZwC
	2hLrvkSChIUEtCT2/9zLPIGRdwEjwypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkDD7soNx
	8TGrQ4wCHIxKPLwKCdohQqyJZcWVuYcYJTiYlUR4J1YAhXhTEiurUovy44tKc1KLDzEycXBK
	NTAqK+39Osf508Gdniw6U2a4HljKuOdRmMPCCUfv7ovzNLN/uPCX8HnDveLz7yS7F8Wf/BOu
	9c296+WvGBPZZ8wMhQJrF8jdm7zk+S3/4rzwKw8UvA9uTtxY7Fev/Wkry2em5gmXdeZlR1QW
	lp39/yBLxOmz2bJPm+yer35xb//WuY2CO9t1i1tVlViKMxINtZiLihMBvRYVuxECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch disables vblanks during dpms off only if pagefilp has
not been finished. It also replaces drm_vblank_off with drm_crtc_vblank_put.
It fixes issue with page_flip ioctl not being able to acquire vblank counter.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
Hi Inki,

This is fix (or just workaround) of the problem you have reported.
Please carefully verify it, as I am not familiar with pageflip code.

Regards
Andrzej
---
 drivers/gpu/drm/exynos/exynos_drm_crtc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_crtc.c b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
index 8e38e9f..57fa94d 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_crtc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
@@ -69,9 +69,10 @@ static void exynos_drm_crtc_dpms(struct drm_crtc *crtc, int mode)
 		/* wait for the completion of page flip. */
 		if (!wait_event_timeout(exynos_crtc->pending_flip_queue,
 				!atomic_read(&exynos_crtc->pending_flip),
-				HZ/20))
+				HZ/20)) {
 			atomic_set(&exynos_crtc->pending_flip, 0);
-		drm_vblank_off(crtc->dev, exynos_crtc->pipe);
+			drm_crtc_vblank_put(crtc);
+		}
 	}
 
 	if (manager->ops->dpms)
-- 
1.9.1

