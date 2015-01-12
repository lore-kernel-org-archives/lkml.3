Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbbALSGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:06:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57776 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbbALSGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 074/216] drm/i915: Only warn the first time we attempt to mmio whilst suspended
Date: Mon, 12 Jan 2015 18:03:11 +0000
Message-Id: <1421085933-32536-75-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 2b387059817fd100cddc5a97118d63e3f3fade74 upstream.

In all likelihood we will do a few hundred errnoneous register
operations if we do a single invalid register access whilst the device
is suspended. As each instance causes a WARN, this floods the system
logs and can make the system unresponsive.

The warning was first introduced in
commit b2ec142cb0101f298f8e091c7d75b1ec5b809b65
Author: Paulo Zanoni <paulo.r.zanoni@intel.com>
Date:   Fri Feb 21 13:52:25 2014 -0300

    drm/i915: call assert_device_not_suspended at gen6_force_wake_work

and despite the claims the WARN is still encountered in the wild today.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Paulo Zanoni <paulo.r.zanoni@intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_uncore.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_uncore.c b/drivers/gpu/drm/i915/intel_uncore.c
index 4f6fef7ac069..28ac6156ec1d 100644
--- a/drivers/gpu/drm/i915/intel_uncore.c
+++ b/drivers/gpu/drm/i915/intel_uncore.c
@@ -43,8 +43,8 @@
 static void
 assert_device_not_suspended(struct drm_i915_private *dev_priv)
 {
-	WARN(HAS_RUNTIME_PM(dev_priv->dev) && dev_priv->pm.suspended,
-	     "Device suspended\n");
+	WARN_ONCE(HAS_RUNTIME_PM(dev_priv->dev) && dev_priv->pm.suspended,
+		  "Device suspended\n");
 }
 
 static void __gen6_gt_wait_for_thread_c0(struct drm_i915_private *dev_priv)
-- 
2.1.4

