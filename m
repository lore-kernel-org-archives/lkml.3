Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbaD1Bbw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42892 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752533AbaD1B3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jani Nikula" <jani.nikula@intel.com>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.16385540@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 65/94] drm/i915/tv: fix gen4 composite s-video tv-out
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: s/old\.device_type/device_type/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_tv.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1599,9 +1599,14 @@ static int tv_is_present_in_vbt(struct d
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

