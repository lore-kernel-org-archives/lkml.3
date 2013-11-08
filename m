Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab3KHCYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:24:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34944 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757261Ab3KHCWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:22:13 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 57/91] drm: Pad drm_mode_get_connector to 64-bit boundary
Date: Thu,  7 Nov 2013 18:15:12 -0800
Message-Id: <1383876946-2396-58-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit bc5bd37ce48c66e9192ad2e7231e9678880f6f8e upstream.

Pavel Roskin reported that DRM_IOCTL_MODE_GETCONNECTOR was overwritting
the 4 bytes beyond the end of its structure with a 32-bit userspace
running on a 64-bit kernel. This is due to the padding gcc inserts as
the drm_mode_get_connector struct includes a u64 and its size is not a
natural multiple of u64s.

64-bit kernel:

sizeof(drm_mode_get_connector)=80, alignof=8
sizeof(drm_mode_get_encoder)=20, alignof=4
sizeof(drm_mode_modeinfo)=68, alignof=4

32-bit userspace:

sizeof(drm_mode_get_connector)=76, alignof=4
sizeof(drm_mode_get_encoder)=20, alignof=4
sizeof(drm_mode_modeinfo)=68, alignof=4

Fortuituously we can insert explicit padding to the tail of our
structures without breaking ABI.

Reported-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/uapi/drm/drm_mode.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/drm/drm_mode.h b/include/uapi/drm/drm_mode.h
index 3d6301b..f604a1a 100644
--- a/include/uapi/drm/drm_mode.h
+++ b/include/uapi/drm/drm_mode.h
@@ -223,6 +223,8 @@ struct drm_mode_get_connector {
 	__u32 connection;
 	__u32 mm_width, mm_height; /**< HxW in millimeters */
 	__u32 subpixel;
+
+	__u32 pad;
 };
 
 #define DRM_MODE_PROP_PENDING	(1<<0)
-- 
1.8.1.2

