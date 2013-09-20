Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab3ITUMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:12:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41488 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab3ITUMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:12:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 80/93] drm/i915: try not to lose backlight CBLV precision
Date: Fri, 20 Sep 2013 13:09:15 -0700
Message-Id: <1379707768-1804-81-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_opregion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
index 7741c22..494fbbf 100644
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -165,7 +165,7 @@ static u32 asle_set_backlight(struct drm_device *dev, u32 bclp)
 
 	max = intel_panel_get_max_backlight(dev);
 	intel_panel_set_backlight(dev, bclp * max / 255);
-	iowrite32((bclp*0x64)/0xff | ASLE_CBLV_VALID, &asle->cblv);
+	iowrite32(DIV_ROUND_UP(bclp * 100, 255) | ASLE_CBLV_VALID, &asle->cblv);
 
 	return 0;
 }
-- 
1.8.1.2

