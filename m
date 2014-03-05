Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbaCEP1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:27:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40786 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539AbaCEOYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:24:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bjoern C <lkml@call-home.ch>,
        Alexandru DAMIAN <alexandru.damian@intel.com>,
        Enrico Tagliavini <enrico.tagliavini@gmail.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 019/131] drm/i915: Prevent MI_DISPLAY_FLIP straddling two cachelines on IVB
Date: Wed,  5 Mar 2014 14:22:23 +0000
Message-Id: <1394029455-23128-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 0e3f213..5df9798 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7477,6 +7477,20 @@ static int intel_gen7_queue_flip(struct drm_device *dev,
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
1.9.0

