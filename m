Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaDAMKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:10:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42248 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaDALQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:49 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Adam Nielsen <a.nielsen@shikadi.net>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 037/144] drm/i915: Reject >165MHz modes w/ DVI monitors
Date: Tue,  1 Apr 2014 12:14:01 +0100
Message-Id: <1396350948-29910-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>

commit 6375b768a9850b6154478993e5fb566fa4614a9c upstream.

Single-link DVI max dotclock is 165MHz. Filter out modes with higher
dotclock when the monitor doesn't support HDMI.

Modes higher than 165 MHz were allowed in

commit 7d148ef51a657fd04036c3ed7803da600dd0d451
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Mon Jul 22 18:02:39 2013 +0200

    drm/i915: fix hdmi portclock limits

Also don't attempt to use 12bpc mode with DVI monitors.

Cc: Adam Nielsen <a.nielsen@shikadi.net>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=75345
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=70331
Tested-by: Ralf Jung <post+kernel@ralfj.de>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_hdmi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_hdmi.c b/drivers/gpu/drm/i915/intel_hdmi.c
index 2fd3fd5..5745277 100644
--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@ -789,7 +789,7 @@ static int hdmi_portclock_limit(struct intel_hdmi *hdmi)
 {
 	struct drm_device *dev = intel_hdmi_to_dev(hdmi);
 
-	if (IS_G4X(dev))
+	if (!hdmi->has_hdmi_sink || IS_G4X(dev))
 		return 165000;
 	else if (IS_HASWELL(dev))
 		return 300000;
@@ -842,8 +842,8 @@ bool intel_hdmi_compute_config(struct intel_encoder *encoder,
 	 * outputs. We also need to check that the higher clock still fits
 	 * within limits.
 	 */
-	if (pipe_config->pipe_bpp > 8*3 && clock_12bpc <= portclock_limit
-	    && HAS_PCH_SPLIT(dev)) {
+	if (pipe_config->pipe_bpp > 8*3 && intel_hdmi->has_hdmi_sink &&
+	    clock_12bpc <= portclock_limit && HAS_PCH_SPLIT(dev)) {
 		DRM_DEBUG_KMS("picking bpc to 12 for HDMI output\n");
 		desired_bpp = 12*3;
 
-- 
1.9.1

