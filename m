Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447AbaCYSAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:00:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55654 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbaCYRRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:17:19 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bjoern C <lkml@call-home.ch>,
        Alexandru DAMIAN <alexandru.damian@intel.com>,
        Enrico Tagliavini <enrico.tagliavini@gmail.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 14/81] drm/i915: Prevent MI_DISPLAY_FLIP straddling two cachelines on IVB
Date: Tue, 25 Mar 2014 10:15:27 -0700
Message-Id: <1395767794-5012-15-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>

commit f66fab8e1cd6b3127ba4c5c0d11539fbe1de1e36 upstream.

According to BSpec the entire MI_DISPLAY_FLIP packet must be contained
in a single cacheline. Make sure that happens.

v2: Use intel_ring_begin_cacheline_safe()
v3: Use intel_ring_cacheline_align() (Chris)

Cc: Bjoern C <lkml@call-home.ch>
Cc: Alexandru DAMIAN <alexandru.damian@intel.com>
Cc: Enrico Tagliavini <enrico.tagliavini@gmail.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=74053
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 7330c58..ad2b52e 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7387,6 +7387,20 @@ static int intel_gen7_queue_flip(struct drm_device *dev,
 		goto err_unpin;
 	}
 
+	/*
+	 * BSpec MI_DISPLAY_FLIP for IVB:
+	 * "The full packet must be contained within the same cache line."
+	 *
+	 * Currently the LRI+SRM+MI_DISPLAY_FLIP all fit within the same
+	 * cacheline, if we ever start emitting more commands before
+	 * the MI_DISPLAY_FLIP we may need to first emit everything else,
+	 * then do the cacheline alignment, and finally emit the
+	 * MI_DISPLAY_FLIP.
+	 */
+	ret = intel_ring_cacheline_align(ring);
+	if (ret)
+		goto err_unpin;
+
 	ret = intel_ring_begin(ring, 4);
 	if (ret)
 		goto err_unpin;
-- 
1.8.3.2

