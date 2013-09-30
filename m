Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab3I3KSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:18:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43784 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab3I3KNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 088/104] drm/i915: try not to lose backlight CBLV precision
Date: Mon, 30 Sep 2013 11:11:05 +0100
Message-Id: <1380535881-9239-89-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_opregion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
index e27c170..6d708d7 100644
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -163,7 +163,7 @@ static u32 asle_set_backlight(struct drm_device *dev, u32 bclp)
 
 	max = intel_panel_get_max_backlight(dev);
 	intel_panel_set_backlight(dev, bclp * max / 255);
-	iowrite32((bclp*0x64)/0xff | ASLE_CBLV_VALID, &asle->cblv);
+	iowrite32(DIV_ROUND_UP(bclp * 100, 255) | ASLE_CBLV_VALID, &asle->cblv);
 
 	return 0;
 }
-- 
1.8.3.2

