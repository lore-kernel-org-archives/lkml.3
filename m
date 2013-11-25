Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab3KYN0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:26:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57015 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab3KYNHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:07:34 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 14/78] drm: Pad drm_mode_get_connector to 64-bit boundary
Date: Mon, 25 Nov 2013 13:06:01 +0000
Message-Id: <1385384825-21681-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5:
  - file rename: include/uapi/drm/drm_mode.h -> include/drm/drm_mode.h ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/drm/drm_mode.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/drm/drm_mode.h b/include/drm/drm_mode.h
index 3d6301b..f604a1a 100644
--- a/include/drm/drm_mode.h
+++ b/include/drm/drm_mode.h
@@ -223,6 +223,8 @@ struct drm_mode_get_connector {
 	__u32 connection;
 	__u32 mm_width, mm_height; /**< HxW in millimeters */
 	__u32 subpixel;
+
+	__u32 pad;
 };
 
 #define DRM_MODE_PROP_PENDING	(1<<0)
-- 
1.8.3.2

