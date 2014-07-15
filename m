Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934056AbaGOVjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:39:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55007 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964826AbaGOVjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:39:00 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 143/198] drm/i915: Avoid div-by-zero when pixel_multiplier is zero
Date: Tue, 15 Jul 2014 14:30:13 -0700
Message-Id: <1405459868-15089-144-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>

commit 2b85886a5457f5c5dbcd32edbd4e6bba0f4e8678 upstream.

On certain platforms pixel_multiplier is read out in
.get_pipe_config(), but it also gets used to calculate the
pixel clock in intel_sdvo_get_config(). If the pipe is disable
but some SDVO outputs are active, we may end up dividing by zero
in intel_sdvo_get_config().

To avoid the problem simply check for zero pixel_multiplier and skip
the division. Another attempt at fixing this involved populating
pixel_multiplier to 1 even for disabled pipes, but that triggered a
WARN because SDVO_CMD_GET_CLOCK_RATE_MULT command failed and thus
encoder_pixel_multiplier was left at zero and didn't match
pipe_config->pixel_multiplier.

The "divide by pixel_multiplier" operation got introduced here:
 commit 18442d08786472c63a0a80c27f92b033dffc26de
 Author: Ville SyrjÃ¤lÃ¤ <ville.syrjala@linux.intel.com>
 Date:   Fri Sep 13 16:00:08 2013 +0300

    drm/i915: Fix port_clock and adjusted_mode.clock readout all over

and it has caused a regression on certain machines since they would
hit the div-by-zero during resume.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=76520
Tested-by: Tim Richardson <tim@tim-richardson.net>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_sdvo.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index a583e8f..9528239 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1364,7 +1364,9 @@ static void intel_sdvo_get_config(struct intel_encoder *encoder,
 			 >> SDVO_PORT_MULTIPLY_SHIFT) + 1;
 	}
 
-	dotclock = pipe_config->port_clock / pipe_config->pixel_multiplier;
+	dotclock = pipe_config->port_clock;
+	if (pipe_config->pixel_multiplier)
+		dotclock /= pipe_config->pixel_multiplier;
 
 	if (HAS_PCH_SPLIT(dev))
 		ironlake_check_encoder_dotclock(pipe_config, dotclock);
-- 
1.9.1

