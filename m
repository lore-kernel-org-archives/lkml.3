Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab3HRUde (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:33:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43562 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab3HRUd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:33:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>, Takashi Iwai <tiwai@suse.de>,
        Giacomo Comes <comes@naic.edu>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Haitao Zhang <haitao.zhang@canonical.com>
Subject: [ 03/34] drm/i915/lvds: ditch ->prepare special case
Date: Sun, 18 Aug 2013 13:34:16 -0700
Message-Id: <20130818203259.895868326@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203259.653403173@linuxfoundation.org>
References: <20130818203259.653403173@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Giacomo Comes <comes@naic.edu>
Tested-by: Takashi Iwai <tiwai@suse.de>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Haitao Zhang <haitao.zhang@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_lvds.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -408,13 +408,7 @@ static void intel_lvds_prepare(struct dr
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


