Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab3KYOQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:16:08 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58994 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754313Ab3KYNxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:42 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Pavel Roskin" <proski@gnu.org>, "Dave Airlie" <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.408981322@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 75/87] drm: Pad drm_mode_get_connector to 64-bit boundary
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/uapi/drm/drm_mode.h | 2 ++
 1 file changed, 2 insertions(+)

--- a/include/drm/drm_mode.h
+++ b/include/drm/drm_mode.h
@@ -184,6 +184,8 @@ struct drm_mode_get_connector {
 	__u32 connection;
 	__u32 mm_width, mm_height; /**< HxW in millimeters */
 	__u32 subpixel;
+
+	__u32 pad;
 };
 
 #define DRM_MODE_PROP_PENDING	(1<<0)

