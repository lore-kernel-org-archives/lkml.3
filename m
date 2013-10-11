Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab3JKIBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 04:01:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab3JKIBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:01:34 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: Gerd Hoffmann <kraxel@redhat.com>, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/6] drm: add drm_set_preferred_mode
Date: Fri, 11 Oct 2013 10:01:08 +0200
Message-Id: <1381478473-18159-2-git-send-email-kraxel@redhat.com>
In-Reply-To: <1381478473-18159-1-git-send-email-kraxel@redhat.com>
References: <1381478473-18159-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New helper function to set the preferred video mode.  Can be called
after drm_add_modes_noedid if you don't want the largest supported
video mode be used by default.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/gpu/drm/drm_edid.c | 13 +++++++++++++
 include/drm/drm_crtc.h     |  2 ++
 2 files changed, 15 insertions(+)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 1688ff5..a635034 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -3286,6 +3286,19 @@ int drm_add_modes_noedid(struct drm_connector *connector,
 }
 EXPORT_SYMBOL(drm_add_modes_noedid);
 
+void drm_set_preferred_mode(struct drm_connector *connector,
+			   int hpref, int vpref)
+{
+	struct drm_display_mode *mode;
+
+	list_for_each_entry(mode, &connector->probed_modes, head) {
+		if (drm_mode_width(mode)  == hpref &&
+		    drm_mode_height(mode) == vpref)
+			mode->type |= DRM_MODE_TYPE_PREFERRED;
+	}
+}
+EXPORT_SYMBOL(drm_set_preferred_mode);
+
 /**
  * drm_hdmi_avi_infoframe_from_display_mode() - fill an HDMI AVI infoframe with
  *                                              data from a DRM display mode
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index 24f4995..ec5d737 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -1108,6 +1108,8 @@ extern struct drm_display_mode *drm_gtf_mode_complex(struct drm_device *dev,
 				int GTF_2C, int GTF_K, int GTF_2J);
 extern int drm_add_modes_noedid(struct drm_connector *connector,
 				int hdisplay, int vdisplay);
+extern void drm_set_preferred_mode(struct drm_connector *connector,
+				   int hpref, int vpref);
 
 extern int drm_edid_header_is_valid(const u8 *raw_edid);
 extern bool drm_edid_block_valid(u8 *raw_edid, int block, bool print_bad_edid);
-- 
1.8.3.1

