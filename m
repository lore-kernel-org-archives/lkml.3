Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbaDXJ5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:57:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46722 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbaDXIyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:54:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 101/182] drm/i915/tv: fix gen4 composite s-video tv-out
Date: Thu, 24 Apr 2014 09:50:26 +0100
Message-Id: <1398329507-5911-102-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

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
[ luis: backported to 3.11:
  - use p_child->device_type instead of p_child->old.device_type ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_tv.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
index d7fe4f8..ab0007d 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1535,9 +1535,14 @@ static int tv_is_present_in_vbt(struct drm_device *dev)
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
1.9.1

