Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaFEEWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:22:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbaFEEWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aaron Lu <aaron.lu@intel.com>, Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 182/214] drm/i915: try not to lose backlight CBLV precision
Date: Wed,  4 Jun 2014 21:19:05 -0700
Message-Id: <20140605041703.938573324@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_opregion.c |    2 +-
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


