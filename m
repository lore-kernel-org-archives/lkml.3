Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbbA0Mx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:53:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34805 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbbA0MQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:16:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 002/126] drm/i915: Don't call intel_prepare_page_flip() multiple times on gen2-4
Date: Tue, 27 Jan 2015 12:15:07 +0000
Message-Id: <1422361031-19364-3-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>

commit 7d47559ee84b3ac206aa9e675606fafcd7c0b500 upstream.

The flip stall detector kicks in when pending>=INTEL_FLIP_COMPLETE. That
means if we first call intel_prepare_page_flip() but don't call
intel_finish_page_flip(), the next stall check will erroneosly think
the page flip was somehow stuck.

With enough debug spew emitted from the interrupt handler my 830 hangs
when this happens. My theory is that the previous vblank interrupt gets
sufficiently delayed that the handler will see the pending bit set in
IIR, but ISR still has the bit set as well (ie. the flip was processed
by CS but didn't complete yet). In this case the handler will proceed
to call intel_check_page_flip() immediately after
intel_prepare_page_flip(). It then tries to print a backtrace for the
stuck flip WARN, which apparetly results in way too much debug spew
delaying interrupt processing further. That then seems to cause an
endless loop in the interrupt handler, and the machine is dead until
the watchdog kicks in and reboots. At least limiting the number of
iterations of the loop in the interrupt handler also prevented the
hang.

So it seems better to not call intel_prepare_page_flip() without
immediately calling intel_finish_page_flip(). The IIR/ISR trickery
avoids races here so this is a perfectly safe thing to do.

v2: Fix typo in commit message (checkpatch)

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=88381
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=85888
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/i915_irq.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index b54f8563ebbb..085cb5645e66 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -3723,8 +3723,6 @@ static bool i8xx_handle_vblank(struct drm_device *dev,
 	if ((iir & flip_pending) == 0)
 		return false;
 
-	intel_prepare_page_flip(dev, plane);
-
 	/* We detect FlipDone by looking for the change in PendingFlip from '1'
 	 * to '0' on the following vblank, i.e. IIR has the Pendingflip
 	 * asserted following the MI_DISPLAY_FLIP, but ISR is deasserted, hence
@@ -3734,6 +3732,7 @@ static bool i8xx_handle_vblank(struct drm_device *dev,
 	if (I915_READ16(ISR) & flip_pending)
 		return false;
 
+	intel_prepare_page_flip(dev, plane);
 	intel_finish_page_flip(dev, pipe);
 
 	return true;
@@ -3908,8 +3907,6 @@ static bool i915_handle_vblank(struct drm_device *dev,
 	if ((iir & flip_pending) == 0)
 		return false;
 
-	intel_prepare_page_flip(dev, plane);
-
 	/* We detect FlipDone by looking for the change in PendingFlip from '1'
 	 * to '0' on the following vblank, i.e. IIR has the Pendingflip
 	 * asserted following the MI_DISPLAY_FLIP, but ISR is deasserted, hence
@@ -3919,6 +3916,7 @@ static bool i915_handle_vblank(struct drm_device *dev,
 	if (I915_READ(ISR) & flip_pending)
 		return false;
 
+	intel_prepare_page_flip(dev, plane);
 	intel_finish_page_flip(dev, pipe);
 
 	return true;
-- 
2.1.4

