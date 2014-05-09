Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaEIGOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 02:14:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38290 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbaEIGOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 02:14:19 -0400
From: Takashi Iwai <tiwai@suse.de>
To: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] drm/ast: Fix double lock at PM resume
Date: Fri,  9 May 2014 08:14:14 +0200
Message-Id: <1399616055-13427-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent commit [3ea87855: drm/helper: lock all around force mode
restore] introduced drm_modeset_lock_all() in
drm_helper_resume_force_mode() itself, while ast driver still takes
this lock before calling it.  Remove the caller side lock for avoid a
fatal deadlock.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/gpu/drm/ast/ast_drv.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_drv.c b/drivers/gpu/drm/ast/ast_drv.c
index 5137f15dba19..27e56dda476d 100644
--- a/drivers/gpu/drm/ast/ast_drv.c
+++ b/drivers/gpu/drm/ast/ast_drv.c
@@ -94,9 +94,7 @@ static int ast_drm_thaw(struct drm_device *dev)
 	ast_post_gpu(dev);
 
 	drm_mode_config_reset(dev);
-	drm_modeset_lock_all(dev);
 	drm_helper_resume_force_mode(dev);
-	drm_modeset_unlock_all(dev);
 
 	console_lock();
 	ast_fbdev_set_suspend(dev, 0);
-- 
1.9.2

