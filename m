Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab3KIG7G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:59:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758592Ab3KIGwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Qingshuai Tian <qingshuai.tian@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.11 85/94] drm/i915: Add HSW CRT output readout support
Date: Fri,  8 Nov 2013 22:52:31 -0800
Message-Id: <20131109065210.239791988@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 7195a50b5c7e00cc3312934fd022c3006b533d12 upstream.

Call intel_ddi_get_config() to get the pipe_bpp settings from
DDI.

The sync polarity settings from DDI are irrelevant for CRT
output, so override them with data from the ADPA register.

Note: This is already merged in drm-intel-next-queued as

commit 6801c18c0a43386bb44712cbc028a7e05adb9f0d
Author: Ville Syrjälä <ville.syrjala@linux.intel.com>
Date:   Tue Sep 24 14:24:05 2013 +0300

    drm/i915: Add HSW CRT output readout support

but is required for the following edp bpp bugfix.

v2: Extract intel_crt_get_flags()

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=69691
Tested-by: Qingshuai Tian <qingshuai.tian@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_crt.c |   30 ++++++++++++++++++++++++++----
 drivers/gpu/drm/i915/intel_ddi.c |    4 ++--
 drivers/gpu/drm/i915/intel_drv.h |    2 ++
 3 files changed, 30 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -84,8 +84,7 @@ static bool intel_crt_get_hw_state(struc
 	return true;
 }
 
-static void intel_crt_get_config(struct intel_encoder *encoder,
-				 struct intel_crtc_config *pipe_config)
+static unsigned int intel_crt_get_flags(struct intel_encoder *encoder)
 {
 	struct drm_i915_private *dev_priv = encoder->base.dev->dev_private;
 	struct intel_crt *crt = intel_encoder_to_crt(encoder);
@@ -103,7 +102,27 @@ static void intel_crt_get_config(struct
 	else
 		flags |= DRM_MODE_FLAG_NVSYNC;
 
-	pipe_config->adjusted_mode.flags |= flags;
+	return flags;
+}
+
+static void intel_crt_get_config(struct intel_encoder *encoder,
+				 struct intel_crtc_config *pipe_config)
+{
+	struct drm_device *dev = encoder->base.dev;
+
+	pipe_config->adjusted_mode.flags |= intel_crt_get_flags(encoder);
+}
+
+static void hsw_crt_get_config(struct intel_encoder *encoder,
+			       struct intel_crtc_config *pipe_config)
+{
+	intel_ddi_get_config(encoder, pipe_config);
+
+	pipe_config->adjusted_mode.flags &= ~(DRM_MODE_FLAG_PHSYNC |
+					      DRM_MODE_FLAG_NHSYNC |
+					      DRM_MODE_FLAG_PVSYNC |
+					      DRM_MODE_FLAG_NVSYNC);
+	pipe_config->adjusted_mode.flags |= intel_crt_get_flags(encoder);
 }
 
 /* Note: The caller is required to filter out dpms modes not supported by the
@@ -802,7 +821,10 @@ void intel_crt_init(struct drm_device *d
 	crt->base.compute_config = intel_crt_compute_config;
 	crt->base.disable = intel_disable_crt;
 	crt->base.enable = intel_enable_crt;
-	crt->base.get_config = intel_crt_get_config;
+	if (IS_HASWELL(dev))
+		crt->base.get_config = hsw_crt_get_config;
+	else
+		crt->base.get_config = intel_crt_get_config;
 	if (I915_HAS_HOTPLUG(dev))
 		crt->base.hpd_pin = HPD_CRT;
 	if (HAS_DDI(dev))
--- a/drivers/gpu/drm/i915/intel_ddi.c
+++ b/drivers/gpu/drm/i915/intel_ddi.c
@@ -1261,8 +1261,8 @@ static void intel_ddi_hot_plug(struct in
 		intel_dp_check_link_status(intel_dp);
 }
 
-static void intel_ddi_get_config(struct intel_encoder *encoder,
-				 struct intel_crtc_config *pipe_config)
+void intel_ddi_get_config(struct intel_encoder *encoder,
+			  struct intel_crtc_config *pipe_config)
 {
 	struct drm_i915_private *dev_priv = encoder->base.dev->dev_private;
 	struct intel_crtc *intel_crtc = to_intel_crtc(encoder->base.crtc);
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -816,6 +816,8 @@ extern void intel_ddi_prepare_link_retra
 extern bool
 intel_ddi_connector_get_hw_state(struct intel_connector *intel_connector);
 extern void intel_ddi_fdi_disable(struct drm_crtc *crtc);
+extern void intel_ddi_get_config(struct intel_encoder *encoder,
+				 struct intel_crtc_config *pipe_config);
 
 extern void intel_display_handle_reset(struct drm_device *dev);
 extern bool intel_set_cpu_fifo_underrun_reporting(struct drm_device *dev,


