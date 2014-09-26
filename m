Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaIZCaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 22:30:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:51790 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029AbaIZCaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 22:30:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,602,1406617200"; 
   d="scan'208";a="579246006"
Message-ID: <5424CFB0.4080102@intel.com>
Date: Fri, 26 Sep 2014 10:30:08 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: =?windows-1252?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
CC: Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH] ACPI / i915: Update the condition to ignore firmware backlight
 change request
References: <201409232206.02819@pali> <201409242021.10107@pali> <542388D7.1010008@intel.com> <201409251623.45636@pali>
In-Reply-To: <201409251623.45636@pali>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the Thinkpads' firmware will issue a backlight change request
through i915 operation region unconditionally on AC plug/unplug, the
backlight level used is arbitrary and thus should be ignored. This is
handled by commit 0b9f7d93ca61 (ACPI / i915: ignore firmware requests
for backlight change). Then there is a Dell laptop whose vendor backlight
interface also makes use of operation region to change backlight level
and with the above commit, that interface no long works. The condition
used to ignore the backlight change request from firmware is thus
changed to: if the vendor backlight interface is not in use and the ACPI
backlight interface is broken, we ignore the requests; oterwise, we keep
processing them.

Reference: https://lkml.org/lkml/2014/9/23/854
Reported-and-tested-by: Pali Rohár <pali.rohar@gmail.com>
Cc: <stable@vger.kernel.org> # v3.16 and later
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/gpu/drm/i915/intel_opregion.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
index ca52ad2ae7d1..d8de1d5140a7 100644
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -396,6 +396,16 @@ int intel_opregion_notify_adapter(struct drm_device *dev, pci_power_t state)
 	return -EINVAL;
 }
 
+/*
+ * If the vendor backlight interface is not in use and ACPI backlight interface
+ * is broken, do not bother processing backlight change requests from firmware.
+ */
+static bool should_ignore_backlight_request(void)
+{
+	return acpi_video_backlight_support() &&
+	       !acpi_video_verify_backlight_support();
+}
+
 static u32 asle_set_backlight(struct drm_device *dev, u32 bclp)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -404,11 +414,7 @@ static u32 asle_set_backlight(struct drm_device *dev, u32 bclp)
 
 	DRM_DEBUG_DRIVER("bclp = 0x%08x\n", bclp);
 
-	/*
-	 * If the acpi_video interface is not supposed to be used, don't
-	 * bother processing backlight level change requests from firmware.
-	 */
-	if (!acpi_video_verify_backlight_support()) {
+	if (should_ignore_backlight_request()) {
 		DRM_DEBUG_KMS("opregion backlight request ignored\n");
 		return 0;
 	}
-- 
1.9.3

