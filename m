Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbaDRJnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:43:53 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45898 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752008AbaDRJWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Dave Airlie <airlied@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 18/72] drm: Prefer noninterlace cmdline mode unless explicitly specified
Date: Fri, 18 Apr 2014 11:21:51 +0200
Message-Id: <c9c5b01e83723282d142141cffd7dd41aa36455d.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c683f427bdc43525f61e26609d34e799e7ea4c12 upstream.

Currently drm_pick_cmdline_mode() doesn't care about the interlace
when the given mode line has no "i" suffix.  That is, when there are
multiple entries for the same resolution, an interlace mode might be
picked up just depending on the assigned order, and there is no way to
exclude it.

This patch changes the logic for the mode selection, to prefer the
noninterlace mode unless the interlace mode is explicitly given.
When no matching mode is found, it still tries the interlace mode as
fallback.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/drm_fb_helper.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 3d13ca6e257f..49557c957be8 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -1163,6 +1163,7 @@ static struct drm_display_mode *drm_pick_cmdline_mode(struct drm_fb_helper_conne
 {
 	struct drm_cmdline_mode *cmdline_mode;
 	struct drm_display_mode *mode = NULL;
+	bool prefer_non_interlace;
 
 	cmdline_mode = &fb_helper_conn->cmdline_mode;
 	if (cmdline_mode->specified == false)
@@ -1174,6 +1175,8 @@ static struct drm_display_mode *drm_pick_cmdline_mode(struct drm_fb_helper_conne
 	if (cmdline_mode->rb || cmdline_mode->margins)
 		goto create_mode;
 
+	prefer_non_interlace = !cmdline_mode->interlace;
+ again:
 	list_for_each_entry(mode, &fb_helper_conn->connector->modes, head) {
 		/* check width/height */
 		if (mode->hdisplay != cmdline_mode->xres ||
@@ -1188,10 +1191,18 @@ static struct drm_display_mode *drm_pick_cmdline_mode(struct drm_fb_helper_conne
 		if (cmdline_mode->interlace) {
 			if (!(mode->flags & DRM_MODE_FLAG_INTERLACE))
 				continue;
+		} else if (prefer_non_interlace) {
+			if (mode->flags & DRM_MODE_FLAG_INTERLACE)
+				continue;
 		}
 		return mode;
 	}
 
+	if (prefer_non_interlace) {
+		prefer_non_interlace = false;
+		goto again;
+	}
+
 create_mode:
 	mode = drm_mode_create_from_cmdline_mode(fb_helper_conn->connector->dev,
 						 cmdline_mode);
-- 
1.9.2

