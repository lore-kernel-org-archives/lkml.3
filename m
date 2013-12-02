Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab3LBTy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:54:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab3LBTSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        =?UTF-8?q?J=C3=B6rg=20Otte?= <jrg.otte@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.12 130/212] drm/i915: restore the early forcewake cleanup
Date: Mon,  2 Dec 2013 11:15:21 -0800
Message-Id: <20131202191301.503176805@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit ef46e0d247da0a7a408573aa15870e231bbd4af2 upstream.

Some BIOS just leak the forcewak bits, which we clean up.
Unfortunately this has been broken in

commit 521198a2e7095c8c7daa8d7d3a76a110c346be6f
Author: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Date:   Fri Aug 23 16:52:30 2013 +0300

    drm/i915: sanitize forcewake registers on reset

To make this work both for resets and for BIOS takeover just add the
forcewake clearing call back to intel_uncore_early_sanitize.

We need to clear the forcewake in early sanitize so that the forcewak
dance in intel_uncore_init (to figure out whether we have mt or legacy
forcewake on ivb) works. That cleanup fits in nicely with the general
topic of early_sanitize to prepare for the very first mmio ops.

Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Reported-by: Jörg Otte <jrg.otte@gmail.com>
Cc: Jörg Otte <jrg.otte@gmail.com>
References: https://lkml.org/lkml/2013/11/16/40
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_uncore.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/i915/intel_uncore.c
+++ b/drivers/gpu/drm/i915/intel_uncore.c
@@ -204,6 +204,19 @@ static void vlv_force_wake_put(struct dr
 	gen6_gt_check_fifodbg(dev_priv);
 }
 
+static void intel_uncore_forcewake_reset(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+
+	if (IS_VALLEYVIEW(dev)) {
+		vlv_force_wake_reset(dev_priv);
+	} else if (INTEL_INFO(dev)->gen >= 6) {
+		__gen6_gt_force_wake_reset(dev_priv);
+		if (IS_IVYBRIDGE(dev) || IS_HASWELL(dev))
+			__gen6_gt_force_wake_mt_reset(dev_priv);
+	}
+}
+
 void intel_uncore_early_sanitize(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -259,19 +272,8 @@ void intel_uncore_init(struct drm_device
 		dev_priv->uncore.funcs.force_wake_put =
 			__gen6_gt_force_wake_put;
 	}
-}
-
-static void intel_uncore_forcewake_reset(struct drm_device *dev)
-{
-	struct drm_i915_private *dev_priv = dev->dev_private;
 
-	if (IS_VALLEYVIEW(dev)) {
-		vlv_force_wake_reset(dev_priv);
-	} else if (INTEL_INFO(dev)->gen >= 6) {
-		__gen6_gt_force_wake_reset(dev_priv);
-		if (IS_IVYBRIDGE(dev) || IS_HASWELL(dev))
-			__gen6_gt_force_wake_mt_reset(dev_priv);
-	}
+	intel_uncore_forcewake_reset(dev);
 }
 
 void intel_uncore_sanitize(struct drm_device *dev)


