Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbaAGJ7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:59:13 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:37217 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557AbaAGJ6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:58:47 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andreas Heider <andreas@meetr.de>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 4/4] drm/i915: check LVDS for EDID on GPU switches
Date: Tue,  7 Jan 2014 15:28:43 +0530
Message-Id: <1389088723-30959-5-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.229.g4448466
In-Reply-To: <1389088723-30959-1-git-send-email-artagnon@gmail.com>
References: <1389088723-30959-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the LVDS panel wasn't connected at boot then we won't have an EDID
for it. To fix this, call intel_lvds_get_edid() from the vga_switcheroo
reprobe callback.

Cc: Andreas Heider <andreas@meetr.de>
Cc: Seth Forshee <seth.forshee@canonical.com>
Original-patch-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 drivers/gpu/drm/i915/i915_dma.c   | 1 +
 drivers/gpu/drm/i915/intel_drv.h  | 1 +
 drivers/gpu/drm/i915/intel_lvds.c | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 336a835b..5eb37a3 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1268,6 +1268,7 @@ static void i915_switcheroo_set_state(struct pci_dev *pdev, enum vga_switcheroo_
 static void i915_switcheroo_reprobe(struct pci_dev *pdev)
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
+	intel_lvds_get_edid(dev);
 	intel_fbdev_output_poll_changed(dev);
 }
 
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 79f91f2..686954f 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -769,6 +769,7 @@ bool intel_hdmi_compute_config(struct intel_encoder *encoder,
 
 
 /* intel_lvds.c */
+bool intel_lvds_get_edid(struct drm_device *dev);
 void intel_lvds_init(struct drm_device *dev);
 bool intel_is_dual_link_lvds(struct drm_device *dev);
 
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 8275551..f700355 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -922,7 +922,7 @@ static bool intel_lvds_supported(struct drm_device *dev)
 	return false;
 }
 
-static bool intel_lvds_get_edid(struct drm_device *dev)
+bool intel_lvds_get_edid(struct drm_device *dev)
 {
 	struct edid *edid;
 	struct drm_i915_private *dev_priv = dev->dev_private;
-- 
1.8.5.2.229.g4448466

