Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640Ab3KIH0F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:26:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453Ab3KIGvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pavel Roskin <proski@gnu.org>, Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org
Subject: [PATCH 3.10 68/74] drm: Pad drm_mode_get_connector to 64-bit boundary
Date: Fri,  8 Nov 2013 22:52:13 -0800
Message-Id: <20131109065118.242570021@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/drm/drm_mode.h |    2 ++
 1 file changed, 2 insertions(+)

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


