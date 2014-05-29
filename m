Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934298AbaE2NvC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:51:02 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59539 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933641AbaE2Nte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 057/103] drm/i915/tv: fix gen4 composite s-video tv-out
Date: Thu, 29 May 2014 15:48:42 +0200
Message-Id: <007f639ee9166b2ecd7357dd7773e1d855e74c2e.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e1f23f3dd817f53f622e486913ac662add46eeed upstream.

This is *not* bisected, but the likely regression is

commit c35614380d5c956bfda20eab2755b2f5a7d6f1e7
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Tue Nov 24 09:48:48 2009 +0800

    drm/i915: Don't set up the TV port if it isn't in the BIOS table.

The commit does not check for all TV device types that might be present
in the VBT, disabling TV out for the missing ones. Add composite
S-video.

Reported-and-tested-by: Matthew Khouzam <matthew.khouzam@gmail.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=73362
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/i915/intel_tv.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
index dd6f84bf6c22..a1e980938fef 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1530,9 +1530,14 @@ static int tv_is_present_in_vbt(struct drm_device *dev)
 		/*
 		 * If the device type is not TV, continue.
 		 */
-		if (p_child->device_type != DEVICE_TYPE_INT_TV &&
-			p_child->device_type != DEVICE_TYPE_TV)
+		switch (p_child->device_type) {
+		case DEVICE_TYPE_INT_TV:
+		case DEVICE_TYPE_TV:
+		case DEVICE_TYPE_TV_SVIDEO_COMPOSITE:
+			break;
+		default:
 			continue;
+		}
 		/* Only when the addin_offset is non-zero, it is regarded
 		 * as present.
 		 */
-- 
1.9.3

