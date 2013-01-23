Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab3AWQZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:25:36 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:63513 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab3AWQZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:25:24 -0500
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fbdev-devel@lists.sourceforge.net,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 2/2] drm/i915: fixup per-crtc locking in intel_release_load_detect_pipe
Date: Wed, 23 Jan 2013 17:25:09 +0100
Message-Id: <1358958309-5342-3-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358958309-5342-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1358958309-5342-1-git-send-email-daniel.vetter@ffwll.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the early return cases missed the mutex unlocking. Hilarity
ensued.

This regression has been introduced in

commit 7b24056be6db7ce907baffdd4cf142ab774ea60c
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed Dec 12 00:35:33 2012 +0100

    drm: don't hold crtc mutexes for connector ->detect callbacks

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=59750
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/intel_display.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 26df9e3..ece4afd 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6522,6 +6522,7 @@ void intel_release_load_detect_pipe(struct drm_connector *connector,
 			drm_framebuffer_unreference(old->release_fb);
 		}
 
+		mutex_unlock(&crtc->mutex);
 		return;
 	}
 
-- 
1.7.10.4

