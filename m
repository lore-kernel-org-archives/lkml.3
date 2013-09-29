Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab3I2Tnt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:43:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909Ab3I2T3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aaron Lu <aaron.lu@intel.com>, Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 22/71] drm/i915: try not to lose backlight CBLV precision
Date: Sun, 29 Sep 2013 12:27:34 -0700
Message-Id: <20130929192645.039982757@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_opregion.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -173,7 +173,7 @@ static u32 asle_set_backlight(struct drm
 		return ASLE_BACKLIGHT_FAILED;
 
 	intel_panel_set_backlight(dev, bclp, 255);
-	iowrite32((bclp*0x64)/0xff | ASLE_CBLV_VALID, &asle->cblv);
+	iowrite32(DIV_ROUND_UP(bclp * 100, 255) | ASLE_CBLV_VALID, &asle->cblv);
 
 	return 0;
 }


