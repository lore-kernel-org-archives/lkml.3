Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaBLIOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:14:11 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50145 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752032AbaBLIN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:58 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jani Nikula" <jani.nikula@linux.intel.com>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Jani Nikula" <jani.nikula@intel.com>,
        "Ville =?UTF-8?Q?Syrj=C3=A4l=C3=A4?=" <ville.syrjala@linux.intel.com>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.375235821@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 48/79] drm/i915: Use the correct GMCH_CTRL register
 for Sandybridge+
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit a885b3ccc74d8e38074e1c43a47c354c5ea0b01e upstream.

The GMCH_CTRL register (or MGCC in the spec) is at a different address
on Sandybridge, and the address to which we currently write to is
undefined. These stray writes appear to upset (hard hang) my Ivybridge
machine whilst it is in UEFI mode.

Note that the register is still marked as locked RO on Sandybridge, so
vgaarb is still dysfunctional.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: add definition of SNB_GMCH_CTRL in i915_reg.h]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9141,14 +9141,15 @@ void intel_connector_attach_encoder(stru
 int intel_modeset_vga_set_state(struct drm_device *dev, bool state)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
+	unsigned reg = INTEL_INFO(dev)->gen >= 6 ? SNB_GMCH_CTRL : INTEL_GMCH_CTRL;
 	u16 gmch_ctrl;
 
-	pci_read_config_word(dev_priv->bridge_dev, INTEL_GMCH_CTRL, &gmch_ctrl);
+	pci_read_config_word(dev_priv->bridge_dev, reg, &gmch_ctrl);
 	if (state)
 		gmch_ctrl &= ~INTEL_GMCH_VGA_DISABLE;
 	else
 		gmch_ctrl |= INTEL_GMCH_VGA_DISABLE;
-	pci_write_config_word(dev_priv->bridge_dev, INTEL_GMCH_CTRL, gmch_ctrl);
+	pci_write_config_word(dev_priv->bridge_dev, reg, gmch_ctrl);
 	return 0;
 }
 
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -37,6 +37,7 @@
  */
 #define INTEL_GMCH_CTRL		0x52
 #define INTEL_GMCH_VGA_DISABLE  (1 << 1)
+#define SNB_GMCH_CTRL		0x50
 
 /* PCI config space */
 

