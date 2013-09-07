Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389Ab3IGKlv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 06:41:51 -0400
Received: from mail.kaapeli.fi ([212.16.172.147]:38522 "EHLO mail.kaapeli.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab3IGKlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 06:41:50 -0400
Message-ID: <522B02EB.9030204@iki.fi>
Date: Sat, 07 Sep 2013 13:41:47 +0300
From: Jyrki Kuoppala <jkp@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>
CC: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Patch for i915 module load parameter to igore edp bpp value
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch against Linus' latest git, fixing bug 59841 reported at 
https://bugzilla.kernel.org/show_bug.cgi?id=59841 for the cases where
a quirk has not been added to the kernel for specific hardware.

At least one Intel HD Graphics 4000 PCI display controller hardware with 
PCI id 0x0166 appears to return an incorrect edp bpp value 18 instead of 
the correct 24. This patch allows user to set a flag at
module load time to ignore the incorrect edp bpp value.

Correction to previous patch notes: the edp bpp value returned is 18,
not 16 as erroneusly claimed in previous patch (quirking the feature).

Date: Sat, 7 Sep 2013 13:17:59 +0300
Subject: [PATCH] i915: add module load parameter to ignore incorrect edp_bpp
  value


Signed-off-by: Jyrki Kuoppala <jkp@iki.fi>
---
  drivers/gpu/drm/i915/i915_drv.c | 4 ++++
  drivers/gpu/drm/i915/i915_drv.h | 1 +
  drivers/gpu/drm/i915/intel_dp.c | 1 +
  3 files changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_drv.c 
b/drivers/gpu/drm/i915/i915_drv.c
index ccb28ea..debb785 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -136,6 +136,10 @@ int i915_enable_ips __read_mostly = 1;
  module_param_named(enable_ips, i915_enable_ips, int, 0600);
  MODULE_PARM_DESC(enable_ips, "Enable IPS (default: true)");

+bool i915_ignore_edp_bpp __read_mostly;
+module_param_named(i915_ignore_edp_bpp, i915_ignore_edp_bpp, bool, 0600);
+MODULE_PARM_DESC(i915_ignore_edp_bpp, "Ignore BDB edp BPP value 
(default: false)");
+
  bool i915_fastboot __read_mostly = 0;
  module_param_named(fastboot, i915_fastboot, bool, 0600);
  MODULE_PARM_DESC(fastboot, "Try to skip unnecessary mode sets at boot 
time "
diff --git a/drivers/gpu/drm/i915/i915_drv.h 
b/drivers/gpu/drm/i915/i915_drv.h
index 3784be1..95b1abe 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1707,6 +1707,7 @@ extern int i915_enable_psr __read_mostly;
  extern unsigned int i915_preliminary_hw_support __read_mostly;
  extern int i915_disable_power_well __read_mostly;
  extern int i915_enable_ips __read_mostly;
+extern bool i915_ignore_edp_bpp __read_mostly;
  extern bool i915_fastboot __read_mostly;
  extern int i915_enable_pc8 __read_mostly;
  extern int i915_pc8_timeout __read_mostly;
diff --git a/drivers/gpu/drm/i915/intel_dp.c 
b/drivers/gpu/drm/i915/intel_dp.c
index 0e0fc37..a3442cd 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -732,6 +732,7 @@ intel_dp_compute_config(struct intel_encoder *encoder,
  	 * bpc in between. */
  	bpp = pipe_config->pipe_bpp;
  	if (is_edp(intel_dp) && dev_priv->vbt.edp_bpp
+	    && !i915_ignore_edp_bpp
  	    && !(dev_priv->quirks & QUIRK_IGNORE_EDP_BPP)) {
  		DRM_DEBUG_KMS("clamping bpp for eDP panel to BIOS-provided %i\n",
  			      dev_priv->vbt.edp_bpp);
-- 
1.8.1.2


