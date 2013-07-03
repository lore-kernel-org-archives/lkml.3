Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965360Ab3GCTP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:15:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28849 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933592Ab3GCTAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:15 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Gvb0uAJMIQoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=RP31ACToYCAA:10 a=taGs_qngAAAA:8 a=e5mUnYsNAAAA:8 a=VwQbUJbxAAAA:8 a=HqBHPJKoD76ig-6nzqEA:9 a=0kPLrQdw3YYA:10 a=n7Cch7CHiCMA:10 a=jeBq3FmKZ4MA:10 a=BeuDQNqZoyMhOs7P:21 a=xRJh194nYD8zr7xH:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184107.632354550@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:41:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Egbert Eich <eich@suse.de>, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [126/141] drm/i915: prefer VBT modes for SVDO-LVDS over EDID
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0126-drm-i915-prefer-VBT-modes-for-SVDO-LVDS-over-EDID.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

[ Upstream commit c3456fb3e4712d0448592af3c5d644c9472cd3c1 ]

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
Cc: stable@vger.kernel.org
Reported-and-tested-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/i915/intel_sdvo.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 95c0433..2ee6bf1 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1604,10 +1604,13 @@ static void intel_sdvo_get_lvds_modes(struct drm_connector *connector)
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
@@ -1619,7 +1622,6 @@ static void intel_sdvo_get_lvds_modes(struct drm_connector *connector)
 		}
 	}
 
-end:
 	list_for_each_entry(newmode, &connector->probed_modes, head) {
 		if (newmode->type & DRM_MODE_TYPE_PREFERRED) {
 			intel_sdvo->sdvo_lvds_fixed_mode =
-- 
1.7.10.4


