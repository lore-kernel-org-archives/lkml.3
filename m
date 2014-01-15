Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbaAOWVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:21:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41125 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbaAOV6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:58:36 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 105/166] drm/i915: Use the correct GMCH_CTRL register for Sandybridge+
Date: Wed, 15 Jan 2014 13:51:59 -0800
Message-Id: <1389822780-4729-106-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 5b769a7..7330c58 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9438,14 +9438,15 @@ void intel_connector_attach_encoder(struct intel_connector *connector,
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
 
-- 
1.8.3.2

