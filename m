Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153Ab3FPWQt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:16:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46411 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755663Ab3FPWJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:09:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Egbert Eich" <eich@suse.de>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.400255893@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [66/83] drm/i915: prefer VBT modes for SVDO-LVDS over EDID
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit c3456fb3e4712d0448592af3c5d644c9472cd3c1 upstream.

In

commit 53d3b4d7778daf15900867336c85d3f8dd70600c
Author: Egbert Eich <eich@suse.de>
Date:   Tue Jun 4 17:13:21 2013 +0200

    drm/i915/sdvo: Use &intel_sdvo->ddc instead of intel_sdvo->i2c for DDC

Egbert Eich fixed a long-standing bug where we simply used a
non-working i2c controller to read the EDID for SDVO-LVDS panels.
Unfortunately some machines seem to not be able to cope with the mode
provided in the EDID. Specifically they seem to not be able to cope
with a 4x pixel mutliplier instead of a 2x one, which seems to have
been worked around by slightly changing the panels native mode in the
VBT so that the dotclock is just barely above 50MHz.

Since it took forever to notice the breakage it's fairly safe to
assume that at least for SDVO-LVDS panels the VBT contains fairly sane
data. So just switch around the order and use VBT modes first.

v2: Also add EDID modes just in case, and spell Egbert correctly.

v3: Elaborate a bit more about what's going on on Chris' machine.

Cc: Egbert Eich <eich@suse.de>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=65524
Reported-and-tested-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_sdvo.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1583,10 +1583,13 @@ static void intel_sdvo_get_lvds_modes(st
 	 * arranged in priority order.
 	 */
 	intel_ddc_get_modes(connector, &intel_sdvo->ddc);
-	if (list_empty(&connector->probed_modes) == false)
-		goto end;
 
-	/* Fetch modes from VBT */
+	/*
+	 * Fetch modes from VBT. For SDVO prefer the VBT mode since some
+	 * SDVO->LVDS transcoders can't cope with the EDID mode. Since
+	 * drm_mode_probed_add adds the mode at the head of the list we add it
+	 * last.
+	 */
 	if (dev_priv->sdvo_lvds_vbt_mode != NULL) {
 		newmode = drm_mode_duplicate(connector->dev,
 					     dev_priv->sdvo_lvds_vbt_mode);
@@ -1598,7 +1601,6 @@ static void intel_sdvo_get_lvds_modes(st
 		}
 	}
 
-end:
 	list_for_each_entry(newmode, &connector->probed_modes, head) {
 		if (newmode->type & DRM_MODE_TYPE_PREFERRED) {
 			intel_sdvo->sdvo_lvds_fixed_mode =

