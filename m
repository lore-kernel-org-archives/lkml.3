Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbaAMQvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:51:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53092 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbaAMQCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 063/208] drm/i915: Use the correct GMCH_CTRL register for Sandybridge+
Date: Mon, 13 Jan 2014 15:58:24 +0000
Message-Id: <1389628849-1614-64-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index ee0b38f..cfe124a 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -10072,14 +10072,15 @@ void intel_connector_attach_encoder(struct intel_connector *connector,
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

