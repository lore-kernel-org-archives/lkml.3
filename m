Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbaC3XnZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:43:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753426AbaC3XnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:14 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?=" 
	<ville.syrjala@linux.intel.com>,
        "Alexandru DAMIAN" <alexandru.damian@intel.com>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "Bjoern C" <lkml@call-home.ch>,
        "Enrico Tagliavini" <enrico.tagliavini@gmail.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.384774785@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 105/200] drm/i915: Prevent MI_DISPLAY_FLIP straddling
 two cachelines on IVB
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7252,6 +7252,20 @@ static int intel_gen7_queue_flip(struct
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

