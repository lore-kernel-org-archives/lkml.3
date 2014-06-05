Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaFEEcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:32:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbaFEEWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pavel Roskin <proski@gnu.org>, Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Airlie <airlied@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 3.4 184/214] drm: Pad drm_mode_get_connector to 64-bit boundary
Date: Wed,  4 Jun 2014 21:19:07 -0700
Message-Id: <20140605041704.189869660@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/drm/drm_mode.h |    2 ++
 1 file changed, 2 insertions(+)

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


