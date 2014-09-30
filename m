Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaI3VmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:42:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32967 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbaI3VjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:39:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Krause <minipli@googlemail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Duncan Laurie <dlaurie@chromium.org>, Jarod Wilson <jarod@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jani Nikula <jani.nikula@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 083/103] drm/i915: Remove bogus __init annotation from DMI callbacks
Date: Tue, 30 Sep 2014 14:31:28 -0700
Message-Id: <1412112708-27356-84-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_bios.c | 2 +-
 drivers/gpu/drm/i915/intel_crt.c  | 2 +-
 drivers/gpu/drm/i915/intel_lvds.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
index e4fba39..3947c77 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -811,7 +811,7 @@ init_vbt_defaults(struct drm_i915_private *dev_priv)
 	}
 }
 
-static int __init intel_no_opregion_vbt_callback(const struct dmi_system_id *id)
+static int intel_no_opregion_vbt_callback(const struct dmi_system_id *id)
 {
 	DRM_DEBUG_KMS("Falling back to manually reading VBT from "
 		      "VBIOS ROM for %s\n",
diff --git a/drivers/gpu/drm/i915/intel_crt.c b/drivers/gpu/drm/i915/intel_crt.c
index c48e62d..3a0d2ae 100644
--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -749,7 +749,7 @@ static const struct drm_encoder_funcs intel_crt_enc_funcs = {
 	.destroy = intel_encoder_destroy,
 };
 
-static int __init intel_no_crt_dmi_callback(const struct dmi_system_id *id)
+static int intel_no_crt_dmi_callback(const struct dmi_system_id *id)
 {
 	DRM_INFO("Skipping CRT initialization for %s\n", id->ident);
 	return 1;
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index c3b4da7..b76a0be 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -533,7 +533,7 @@ static const struct drm_encoder_funcs intel_lvds_enc_funcs = {
 	.destroy = intel_encoder_destroy,
 };
 
-static int __init intel_no_lvds_dmi_callback(const struct dmi_system_id *id)
+static int intel_no_lvds_dmi_callback(const struct dmi_system_id *id)
 {
 	DRM_INFO("Skipping LVDS initialization for %s\n", id->ident);
 	return 1;
-- 
1.9.1

