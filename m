Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365Ab3IHDUW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:20:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56095 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755947Ab3IHDSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:48 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Takashi Iwai" <tiwai@suse.de>, "Giacomo Comes" <comes@naic.edu>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.751125235@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [016/121] drm/i915/lvds: ditch ->prepare special case
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 520c41cf2fa029d1e8b923ac2026f96664f17c4b upstream.

LVDS is the first output where dpms on/off and prepare/commit don't
perfectly match. Now the idea behind this special case seems to be
that for simple resolution changes on the LVDS we don't need to stop
the pipe, because (at least on newer chips) we can adjust the panel
fitter on the fly.

There are a few problems with the current code though:
- We still stop and restart the pipe unconditionally, because the crtc
  helper code isn't flexible enough.
- We show some ugly flickering, especially when changing crtcs (this
  the crtc helper would actually take into account, but we don't
  implement the encoder->get_crtc callback required to make this work
  properly).

So it doesn't even work as advertised. I agree that it would be nice
to do resolution changes on LVDS (and also eDP) whithout blacking the
screen where the panel fitter allows to do that. But imo we should
implement this as a special case a few layers up in the mode set code,
akin to how we already detect simple framebuffer changes (and only
update the required registers with ->mode_set_base).

Until this is all in place, make our lives easier and just rip it out.

Also note that this seems to fix actual bugs with enabling the lvds
output, see:

http://lists.freedesktop.org/archives/intel-gfx/2012-July/018614.html

Cc: Takashi Iwai <tiwai@suse.de>
Cc: Giacomo Comes <comes@naic.edu>
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Tested-by: Takashi Iwai <tiwai@suse.de>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_lvds.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -402,13 +402,7 @@ static void intel_lvds_prepare(struct dr
 {
 	struct intel_lvds *intel_lvds = to_intel_lvds(encoder);
 
-	/*
-	 * Prior to Ironlake, we must disable the pipe if we want to adjust
-	 * the panel fitter. However at all other times we can just reset
-	 * the registers regardless.
-	 */
-	if (!HAS_PCH_SPLIT(encoder->dev) && intel_lvds->pfit_dirty)
-		intel_lvds_disable(intel_lvds);
+	intel_lvds_disable(intel_lvds);
 }
 
 static void intel_lvds_commit(struct drm_encoder *encoder)

