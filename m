Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbaJIVig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:38:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59188 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757373AbaJIVIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Bartlett <ajb@elrepo.org>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 035/163] drm/i915: Wait for vblank before enabling the TV encoder
Date: Thu,  9 Oct 2014 14:01:00 -0700
Message-Id: <1412888588-26755-36-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>

commit 7a98948f3b536ca9a077e84966ddc0e9f53726df upstream.

The vblank waits in intel_tv_detect_type() are timing out for some
reason. This is a regression caused removing seemingly useless vblank
waits from the modeset seqeuence in:

 commit 56ef52cad5e37fca89638e4bad598a994ecc3d9f
 Author: Ville Syrjälä <ville.syrjala@linux.intel.com>
 Date:   Thu May 8 19:23:15 2014 +0300

    drm/i915: Kill vblank waits after pipe enable on gmch platforms

So it turns out they weren't all entirely useless. Apparently the pipe
has to go through one full frame before we enable the TV port. Add a
vblank wait to intel_enable_tv() to make sure that happens.

Another approach was attempted by placing the vblank wait just after
enabling the port. The theory behind that attempt was that we need to
let the port stay enabled for one full frame before disabling it again
during load detection. But that didn't work, and we definitely must
have the vblank wait before enabling the port.

Cc: Alan Bartlett <ajb@elrepo.org>
Tested-by: Alan Bartlett <ajb@elrepo.org>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=79311
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_tv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
index 99faac5..5e1d30e 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -854,6 +854,10 @@ intel_enable_tv(struct intel_encoder *encoder)
 	struct drm_device *dev = encoder->base.dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
+	/* Prevents vblank waits from timing out in intel_tv_detect_type() */
+	intel_wait_for_vblank(encoder->base.dev,
+			      to_intel_crtc(encoder->base.crtc)->pipe);
+
 	I915_WRITE(TV_CTL, I915_READ(TV_CTL) | TV_ENC_ENABLE);
 }
 
-- 
1.9.1

