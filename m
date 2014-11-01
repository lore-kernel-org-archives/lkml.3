Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbaKAWxi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:53:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60120 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751550AbaKAWj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:28 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "Duncan Laurie" <dlaurie@chromium.org>,
        "Rusty Russell" <rusty@rustcorp.com.au>,
        "Jarod Wilson" <jarod@redhat.com>,
        "Jani Nikula" <jani.nikula@intel.com>,
        "Mathias Krause" <minipli@googlemail.com>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.131315171@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 011/102] drm/i915: Remove bogus __init annotation from
 DMI callbacks
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: drop inapplicable change in intel_crt.c]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_bios.c | 2 +-
 drivers/gpu/drm/i915/intel_crt.c  | 2 +-
 drivers/gpu/drm/i915/intel_lvds.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -651,7 +651,7 @@ init_vbt_defaults(struct drm_i915_privat
 	DRM_DEBUG_KMS("Set default to SSC at %dMHz\n", dev_priv->lvds_ssc_freq);
 }
 
-static int __init intel_no_opregion_vbt_callback(const struct dmi_system_id *id)
+static int intel_no_opregion_vbt_callback(const struct dmi_system_id *id)
 {
 	DRM_DEBUG_KMS("Falling back to manually reading VBT from "
 		      "VBIOS ROM for %s\n",
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -613,7 +613,7 @@ static const struct drm_encoder_funcs in
 	.destroy = intel_encoder_destroy,
 };
 
-static int __init intel_no_lvds_dmi_callback(const struct dmi_system_id *id)
+static int intel_no_lvds_dmi_callback(const struct dmi_system_id *id)
 {
 	DRM_DEBUG_KMS("Skipping LVDS initialization for %s\n", id->ident);
 	return 1;

