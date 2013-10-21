Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab3JUIva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:51:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39516 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753618Ab3JUIv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "Aaron Lu" <aaron.lu@intel.com>, "Jani Nikula" <jani.nikula@intel.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.971060995@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 059/149] drm/i915: try not to lose backlight CBLV
 precision
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit cac6a5ae0118832936eb162ec4cedb30f2422bcc upstream.

ACPI has _BCM and _BQC methods to set and query the backlight
brightness, respectively. The ACPI opregion has variables BCLP and CBLV
to hold the requested and current backlight brightness, respectively.

The BCLP variable has range 0..255 while the others have range
0..100. This means the _BCM method has to scale the brightness for BCLP,
and the gfx driver has to scale the requested value back for CBLV. If
the _BQC method uses the CBLV variable (apparently some implementations
do, some don't) for current backlight level reporting, there's room for
rounding errors.

Use DIV_ROUND_UP for scaling back to CBLV to get back to the same values
that were passed to _BCM, presuming the _BCM simply uses bclp = (in *
255) / 100 for scaling to BCLP.

Reference: https://gist.github.com/aaronlu/6314920
Reported-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2:
 - Adjust context
 - ASLE region is treated as normal memory rather than __iomem]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_opregion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -161,7 +161,7 @@ static u32 asle_set_backlight(struct drm
 
 	max = intel_panel_get_max_backlight(dev);
 	intel_panel_set_backlight(dev, bclp * max / 255);
-	asle->cblv = (bclp*0x64)/0xff | ASLE_CBLV_VALID;
+	asle->cblv = DIV_ROUND_UP(bclp * 100, 255) | ASLE_CBLV_VALID;
 
 	return 0;
 }

