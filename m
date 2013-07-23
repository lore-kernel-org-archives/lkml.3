Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab3GWCCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:02:25 -0400
Received: from home.keithp.com ([63.227.221.253]:43593 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224Ab3GWCCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:02:19 -0400
From: Keith Packard <keithp@keithp.com>
To: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>
Cc: Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org
Subject: [PATCH 3/5] drm: Advertise async page flip ability through GETCAP ioctl
Date: Mon, 22 Jul 2013 18:50:00 -0700
Message-Id: <1374544202-15496-4-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374544202-15496-1-git-send-email-keithp@keithp.com>
References: <1374544202-15496-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let applications know whether the kernel supports asynchronous page
flipping.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/drm_crtc.c  | 3 +++
 drivers/gpu/drm/drm_ioctl.c | 3 +++
 include/drm/drm_crtc.h      | 3 +++
 include/uapi/drm/drm.h      | 1 +
 4 files changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 989072c..0909af6 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -3514,6 +3514,9 @@ int drm_mode_page_flip_ioctl(struct drm_device *dev,
 	    page_flip->reserved != 0)
 		return -EINVAL;
 
+	if ((page_flip->flags & DRM_MODE_PAGE_FLIP_ASYNC) && !dev->mode_config.async_page_flip)
+		return -EINVAL;
+
 	obj = drm_mode_object_find(dev, page_flip->crtc_id, DRM_MODE_OBJECT_CRTC);
 	if (!obj)
 		return -EINVAL;
diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
index ffd7a7b..7602177 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -303,6 +303,9 @@ int drm_getcap(struct drm_device *dev, void *data, struct drm_file *file_priv)
 	case DRM_CAP_TIMESTAMP_MONOTONIC:
 		req->value = drm_timestamp_monotonic;
 		break;
+	case DRM_CAP_ASYNC_PAGE_FLIP:
+		req->value = dev->mode_config.async_page_flip;
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index 0820ab6..13d215f 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -845,6 +845,9 @@ struct drm_mode_config {
 
 	/* dumb ioctl parameters */
 	uint32_t preferred_depth, prefer_shadow;
+
+	/* whether async page flip is supported or not */
+	bool async_page_flip;
 };
 
 #define obj_to_crtc(x) container_of(x, struct drm_crtc, base)
diff --git a/include/uapi/drm/drm.h b/include/uapi/drm/drm.h
index 238a166..2adfaa5 100644
--- a/include/uapi/drm/drm.h
+++ b/include/uapi/drm/drm.h
@@ -780,6 +780,7 @@ struct drm_event_vblank {
 #define DRM_CAP_DUMB_PREFER_SHADOW 0x4
 #define DRM_CAP_PRIME 0x5
 #define DRM_CAP_TIMESTAMP_MONOTONIC 0x6
+#define DRM_CAP_ASYNC_PAGE_FLIP 0x7
 
 #define DRM_PRIME_CAP_IMPORT 0x1
 #define DRM_PRIME_CAP_EXPORT 0x2
-- 
1.8.3.2

