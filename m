Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbaDAML3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:11:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42239 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaDALQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Imre Deak <imre.deak@intel.com>, Jani Nikula <jani.nikula@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 036/144] drm/i915: vlv: reserve GT power context early
Date: Tue,  1 Apr 2014 12:14:00 +0100
Message-Id: <1396350948-29910-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 17b0c1f7865d8bf4f5e5aa94e2aeafb35d23e4e9 upstream.

We reserve the space for the power context in stolen memory at a fixed
address from a delayed work. This races with the subsequent driver
init/resume code which could allocate something at that address, so the
reservation for the power context fails. Reserve the space up-front, so
this can't happen. This also adds a missing struct_mutex lock around the
stolen allocation, which wasn't taken in the delayed work path.

Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_pm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index cad0482..94799b6 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -3474,6 +3474,8 @@ static void valleyview_setup_pctx(struct drm_device *dev)
 	u32 pcbr;
 	int pctx_size = 24*1024;
 
+	WARN_ON(!mutex_is_locked(&dev->struct_mutex));
+
 	pcbr = I915_READ(VLV_PCBR);
 	if (pcbr) {
 		/* BIOS set it up already, grab the pre-alloc'd space */
@@ -3522,8 +3524,6 @@ static void valleyview_enable_rps(struct drm_device *dev)
 		I915_WRITE(GTFIFODBG, gtfifodbg);
 	}
 
-	valleyview_setup_pctx(dev);
-
 	gen6_gt_force_wake_get(dev_priv);
 
 	I915_WRITE(GEN6_RP_UP_THRESHOLD, 59400);
@@ -4387,6 +4387,8 @@ void intel_enable_gt_powersave(struct drm_device *dev)
 		ironlake_enable_rc6(dev);
 		intel_init_emon(dev);
 	} else if (IS_GEN6(dev) || IS_GEN7(dev)) {
+		if (IS_VALLEYVIEW(dev))
+			valleyview_setup_pctx(dev);
 		/*
 		 * PCU communication is slow and this doesn't need to be
 		 * done at any specific time, so do this out of our fast path
-- 
1.9.1

