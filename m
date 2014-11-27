Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbaK0Ip7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:45:59 -0500
Received: from mail.kernel.org ([198.145.19.201]:40998 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbaK0Ip4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:45:56 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Duncan Laurie <dlaurie@chromium.org>, Jarod Wilson <jarod@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jani Nikula <jani.nikula@intel.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 03/91] drm/i915: Remove bogus __init annotation from DMI callbacks
Date: Thu, 27 Nov 2014 16:41:46 +0800
Message-Id: <1417077794-9299-3-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Krause <minipli@googlemail.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit bbe1c2740d3a25aa1dbe5d842d2ff09cddcdde0a upstream.

The __init annotations for the DMI callback functions are wrong as this
code can be called even after the module has been initialized, e.g. like
this:

  # echo 1 > /sys/bus/pci/devices/0000:00:02.0/remove
  # modprobe i915
  # echo 1 > /sys/bus/pci/rescan

The first command will remove the PCI device from the kernel's device
list so the second command won't see it right away. But as it registers
a PCI driver it'll see it on the third command. If the system happens to
match one of the DMI table entries we'll try to call a function in long
released memory and generate an Oops, at best.

Fix this by removing the bogus annotation.

Modpost should have caught that one but it ignores section reference
mismatches from the .rodata section. :/

Fixes: 25e341cfc33d ("drm/i915: quirk away broken OpRegion VBT")
Fixes: 8ca4013d702d ("CHROMIUM: i915: Add DMI override to skip CRT...")
Fixes: 425d244c8670 ("drm/i915: ignore LVDS on intel graphics systems...")
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Duncan Laurie <dlaurie@chromium.org>
Cc: Jarod Wilson <jarod@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>	# Can modpost be fixed?
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/gpu/drm/i915/intel_bios.c | 2 +-
 drivers/gpu/drm/i915/intel_crt.c  | 2 +-
 drivers/gpu/drm/i915/intel_lvds.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
index a2c9e56..d9e359a 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -651,7 +651,7 @@ init_vbt_defaults(struct drm_i915_private *dev_priv)
 	DRM_DEBUG_KMS("Set default to SSC at %dMHz\n", dev_priv->lvds_ssc_freq);
 }
 
-static int __init intel_no_opregion_vbt_callback(const struct dmi_system_id *id)
+static int intel_no_opregion_vbt_callback(const struct dmi_system_id *id)
 {
 	DRM_DEBUG_KMS("Falling back to manually reading VBT from "
 		      "VBIOS ROM for %s\n",
diff --git a/drivers/gpu/drm/i915/intel_crt.c b/drivers/gpu/drm/i915/intel_crt.c
index a83f7ac..b4f71c2 100644
--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -564,7 +564,7 @@ static const struct drm_encoder_funcs intel_crt_enc_funcs = {
 	.destroy = intel_encoder_destroy,
 };
 
-static int __init intel_no_crt_dmi_callback(const struct dmi_system_id *id)
+static int intel_no_crt_dmi_callback(const struct dmi_system_id *id)
 {
 	DRM_DEBUG_KMS("Skipping CRT initialization for %s\n", id->ident);
 	return 1;
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index b695ab4..77190cc 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -619,7 +619,7 @@ static const struct drm_encoder_funcs intel_lvds_enc_funcs = {
 	.destroy = intel_encoder_destroy,
 };
 
-static int __init intel_no_lvds_dmi_callback(const struct dmi_system_id *id)
+static int intel_no_lvds_dmi_callback(const struct dmi_system_id *id)
 {
 	DRM_DEBUG_KMS("Skipping LVDS initialization for %s\n", id->ident);
 	return 1;
-- 
1.9.1

