Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab3KNCCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 21:02:48 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:64716 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3KNCCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 21:02:42 -0500
From: Olof Johansson <olof@lixom.net>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Duncan Laurie <dlaurie@chromium.org>, Olof Johansson <olof@lixom.net>
Subject: [PATCH] i915: Use 120MHz LVDS SSC clock for gen5/gen6/gen7
Date: Wed, 13 Nov 2013 17:59:43 -0800
Message-Id: <1384394383-8582-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.4.1.601.g02b3b1d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Duncan Laurie <dlaurie@chromium.org>

We had been using a DMI table workaround to select the right
frequency for devices, but this is fragile and must be updated
with every new platform.

Instead the default case when VBT is missing is changed to use
120MHz clock for LVDS SSC for these generations.

The docs for 2010-Core, SandyBridge, and IvyBridge all indicate
that the reference frequency for LVDS is 120MHz:

"2010 Core"
http://intellinuxgraphics.org/IHD_OS_Vol3_Part3r2.pdf
page 38
Reference Frequency: 120MHz for CRT and LVDS.  100MHz for the FDI.

"2011 SandyBridge"
http://intellinuxgraphics.org/documentation/SNB/IHD_OS_Vol3_Part3.pdf
page 33
Reference Frequency: 120MHz for CRT, HDMI, LVDS.  100MHz for the FDI.

"2012 IvyBridge"
http://intellinuxgraphics.org/documentation/IVB/IHD_OS_Vol3_Part4.pdf
page 27
Reference Frequency: 120 MHz for CRT, HDMI, LVDS, 100MHz for the FDI.

Signed-off-by: Duncan Laurie <dlaurie@chromium.org>
[olof: Fixup for recent base, switched from if/else to single call]
Signed-off-by: Olof Johansson <olof@lixom.net>
---

Daniel,

This applies on top of -next, which I'm presuming is close to your
for-3.13 base right now. It'd be good to see this go in since it's needed
to boot on Chromebooks (with developer mode off), and is thus blocking
testing next/mainline on a regular basis here.

Thanks!

-Olof

 drivers/gpu/drm/i915/intel_bios.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
index 6dd622d733b9..e4fba39631a5 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -790,7 +790,12 @@ init_vbt_defaults(struct drm_i915_private *dev_priv)
 
 	/* Default to using SSC */
 	dev_priv->vbt.lvds_use_ssc = 1;
-	dev_priv->vbt.lvds_ssc_freq = intel_bios_ssc_frequency(dev, 1);
+	/*
+	 * Core/SandyBridge/IvyBridge use alternative (120MHz) reference
+	 * clock for LVDS.
+	 */
+	dev_priv->vbt.lvds_ssc_freq = intel_bios_ssc_frequency(dev,
+			!HAS_PCH_SPLIT(dev));
 	DRM_DEBUG_KMS("Set default to SSC at %dMHz\n", dev_priv->vbt.lvds_ssc_freq);
 
 	for (port = PORT_A; port < I915_MAX_PORTS; port++) {
-- 
1.8.4.1.601.g02b3b1d

