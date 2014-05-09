Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaEIGOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 02:14:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbaEIGOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 02:14:19 -0400
From: Takashi Iwai <tiwai@suse.de>
To: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] drm/exynos: Fix double locks at PM resume
Date: Fri,  9 May 2014 08:14:15 +0200
Message-Id: <1399616055-13427-2-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399616055-13427-1-git-send-email-tiwai@suse.de>
References: <1399616055-13427-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent commit [3ea87855: drm/helper: lock all around force mode
restore] introduced drm_modeset_lock_all() in
drm_helper_resume_force_mode() itself, while exynos driver takes this
lock before calling it.  Move the function call outside the lock for
avoiding a deadlock.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/gpu/drm/exynos/exynos_drm_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
index 2d27ba23a6a8..79410b0c4bbf 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
@@ -183,9 +183,9 @@ static int exynos_drm_resume(struct drm_device *dev)
 		if (connector->funcs->dpms)
 			connector->funcs->dpms(connector, connector->dpms);
 	}
+	drm_modeset_unlock_all(dev);
 
 	drm_helper_resume_force_mode(dev);
-	drm_modeset_unlock_all(dev);
 
 	return 0;
 }
-- 
1.9.2

