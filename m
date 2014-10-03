Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419AbaJCXCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:02:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47264 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095AbaJCWXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:23:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Duncan Laurie <dlaurie@chromium.org>, Jarod Wilson <jarod@redhat.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3.10 029/143] drm/i915: Remove bogus __init annotation from DMI callbacks
Date: Fri,  3 Oct 2014 14:33:44 -0700
Message-Id: <20141003213315.367132840@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_bios.c |    2 +-
 drivers/gpu/drm/i915/intel_crt.c  |    2 +-
 drivers/gpu/drm/i915/intel_lvds.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -657,7 +657,7 @@ init_vbt_defaults(struct drm_i915_privat
 	DRM_DEBUG_KMS("Set default to SSC at %dMHz\n", dev_priv->lvds_ssc_freq);
 }
 
-static int __init intel_no_opregion_vbt_callback(const struct dmi_system_id *id)
+static int intel_no_opregion_vbt_callback(const struct dmi_system_id *id)
 {
 	DRM_DEBUG_KMS("Falling back to manually reading VBT from "
 		      "VBIOS ROM for %s\n",
--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -702,7 +702,7 @@ static const struct drm_encoder_funcs in
 	.destroy = intel_encoder_destroy,
 };
 
-static int __init intel_no_crt_dmi_callback(const struct dmi_system_id *id)
+static int intel_no_crt_dmi_callback(const struct dmi_system_id *id)
 {
 	DRM_INFO("Skipping CRT initialization for %s\n", id->ident);
 	return 1;
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -694,7 +694,7 @@ static const struct drm_encoder_funcs in
 	.destroy = intel_encoder_destroy,
 };
 
-static int __init intel_no_lvds_dmi_callback(const struct dmi_system_id *id)
+static int intel_no_lvds_dmi_callback(const struct dmi_system_id *id)
 {
 	DRM_INFO("Skipping LVDS initialization for %s\n", id->ident);
 	return 1;


