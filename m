Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab3JBTjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 15:39:35 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:39646 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab3JBTje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 15:39:34 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm: Track the proper DPMS mode of connectors
Date: Wed,  2 Oct 2013 21:37:46 +0200
Message-Id: <1380742666-2438-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When userspace removes the active framebuffer using DRM_IOCTL_MODE_RMFB,
or explicitly disables the CRTC (by calling drmModeSetCrtc(..., NULL)
for example), a NULL framebuffer will be passed to the .set_config()
implementation of a CRTC. The drm_crtc_helper_set_config() helper will
decide to disable a CRTC when that happens.

To do so, it calls drm_crtc_helper_disable(), which in turn will iterate
over all encoders and decouple them from their connectors and finally
call drm_helper_disable_unused_functions() to clean up and call the
.disable() or .dpms() implementation for each encoder. However, at no
point during this sequence does it track the DPMS mode of a connector,
so it will usually remain on after this.

When a connector is enabled again, drm_helper_connector_dpms() will not
notice that the DPMS mode actually changed and won't do anything, which
causes the connector to stay disabled indefinitely.

To prevent this from happening, explicitly set the connector's DPMS mode
to off when the CRTC is disabled. That way it reflects the correct state
and can be enabled again.

This solves an issue observed when terminating an X server running on
the xf86-video-modesetting driver. Without this patch, the connector
would not be enabled properly and the screen would stay dark.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/drm_crtc_helper.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
index 4280e37..7964948 100644
--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -563,6 +563,14 @@ drm_crtc_helper_disable(struct drm_crtc *crtc)
 				continue;
 
 			connector->encoder = NULL;
+
+			/*
+			 * drm_helper_disable_unused_functions() ought to be
+			 * doing this, but since we've decoupled the encoder
+			 * from the connector above, the required connection
+			 * between them is henceforth no longer available.
+			 */
+			connector->dpms = DRM_MODE_DPMS_OFF;
 		}
 	}
 
-- 
1.8.4

