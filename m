Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaLOOqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:46:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38749 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbaLOO2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 110/168] drm/i915: Ignore SURFLIVE and flip counter when the GPU gets reset
Date: Mon, 15 Dec 2014 14:26:04 +0000
Message-Id: <1418653622-21105-111-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>

commit bdfa7542d40e6251c232a802231b37116bd31b11 upstream.

During a GPU reset we need to get pending page flip cleared out
since the ring contents are gone and flip will never complete
on its own. This used to work until the mmio vs. CS flip race
detection came about. That piece of code is looking for a
specific surface address in the SURFLIVE register, but as
a flip to that address may never happen the check may never
pass. So we should just skip the SURFLIVE and flip counter
checks when the GPU gets reset.

intel_display_handle_reset() tries to effectively complete
the flip anyway by calling .update_primary_plane(). But that
may not satisfy the conditions of the mmio vs. CS race
detection since there's no guarantee that a modeset didn't
sneak in between the GPU reset and intel_display_handle_reset().
Such a modeset will not wait for pending flips due to the ongoing GPU
reset, and then the primary plane updates performed by
intel_display_handle_reset() will already use the new surface
address, and thus the surface address the flip is waiting for
might never appear in SURFLIVE. The result is that the flip
will never complete and attempts to perform further page flips
will fail with -EBUSY.

During the GPU reset intel_crtc_has_pending_flip() will return
false regardless, so the deadlock with a modeset vs. the error
work acquiring crtc->mutex was avoided. And the reset_counter
check in intel_crtc_has_pending_flip() actually made this bug
even less severe since it allowed normal modesets to go through
even though there's a pending flip.

This is a regression introduced by me here:
 commit 75f7f3ec600524c9544cc31695155f1a9ddbe1d9
 Author: Ville Syrjälä <ville.syrjala@linux.intel.com>
 Date:   Tue Apr 15 21:41:34 2014 +0300

    drm/i915: Fix mmio vs. CS flip race on ILK+

Testcase: igt/kms_flip/flip-vs-panning-vs-hang
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 373d652d01fa..6b835b86fbfd 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8925,6 +8925,10 @@ static bool page_flip_finished(struct intel_crtc *crtc)
 	struct drm_device *dev = crtc->base.dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
+	if (i915_reset_in_progress(&dev_priv->gpu_error) ||
+	    crtc->reset_counter != atomic_read(&dev_priv->gpu_error.reset_counter))
+		return true;
+
 	/*
 	 * The relevant registers doen't exist on pre-ctg.
 	 * As the flip done interrupt doesn't trigger for mmio
-- 
2.1.3

