Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab3GNQaT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 12:30:19 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:62594 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab3GNQaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 12:30:17 -0400
Subject: [PATCH] drm/i915: fix long-standing SNB regression in power
 consumption after resume
To: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Sun, 14 Jul 2013 20:30:09 +0400
Message-ID: <20130714163009.22374.22100.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes regression in power consumtion of sandy bridge gpu, which
exists since v3.6 Sometimes after resuming from s2ram gpu starts thinking that
it's extremely busy. After that it never reaches rc6 state.

Bug was introduce by commit b4ae3f22d238617ca11610b29fde16cf8c0bc6e0
("drm/i915: load boot context at driver init time"). Without documentation
it's not clear what is happening here, probably this breaks internal state of
hardware ring buffers and confuses RPS engine. Fortunately keeping forcewake
during whole initialization sequence in gen6_init_clock_gating() fixes this bug.

References: https://bugs.freedesktop.org/show_bug.cgi?id=54089
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 drivers/gpu/drm/i915/intel_pm.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index aa01128..839a43f 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -3640,6 +3640,8 @@ static void gen6_init_clock_gating(struct drm_device *dev)
 	int pipe;
 	uint32_t dspclk_gate = ILK_VRHUNIT_CLOCK_GATE_DISABLE;
 
+	gen6_gt_force_wake_get(dev_priv);
+
 	I915_WRITE(ILK_DSPCLK_GATE_D, dspclk_gate);
 
 	I915_WRITE(ILK_DISPLAY_CHICKEN2,
@@ -3728,6 +3730,8 @@ static void gen6_init_clock_gating(struct drm_device *dev)
 	cpt_init_clock_gating(dev);
 
 	gen6_check_mch_setup(dev);
+
+	gen6_gt_force_wake_put(dev_priv);
 }
 
 static void gen7_setup_fixed_func_scheduler(struct drm_i915_private *dev_priv)

