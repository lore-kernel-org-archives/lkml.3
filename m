Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbaE2Ef1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:35:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405AbaE2EfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.14 063/140] drm/i915/tv: fix gen4 composite s-video tv-out
Date: Wed, 28 May 2014 21:33:22 -0700
Message-Id: <20140529043057.592591753@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_tv.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1536,9 +1536,14 @@ static int tv_is_present_in_vbt(struct d
 		/*
 		 * If the device type is not TV, continue.
 		 */
-		if (p_child->old.device_type != DEVICE_TYPE_INT_TV &&
-			p_child->old.device_type != DEVICE_TYPE_TV)
+		switch (p_child->old.device_type) {
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


