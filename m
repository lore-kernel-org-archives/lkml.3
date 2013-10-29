Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab3J2SY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:24:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59282 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3J2SFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:05:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Francisco Jerez <currojerez@riseup.net>, Daniel Vetter <daniel@ffwll.ch>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 05/81] drm/i915/hsw: Disable L3 caching of atomic memory operations.
Date: Tue, 29 Oct 2013 11:03:26 -0700
Message-Id: <1383069882-11437-6-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francisco Jerez <currojerez@riseup.net>

commit f3fc4884ebe6ae649d3723be14b219230d3b7fd2 upstream.

Otherwise using any atomic memory operation will lock up the GPU due
to a Haswell hardware bug.

v2: Use the _MASKED_BIT_ENABLE macro.  Drop drm parameter definition.

Signed-off-by: Francisco Jerez <currojerez@riseup.net>
Reviewed-by: Ben Widawsky <ben@bwidawsk.net>
Cc: Daniel Vetter <daniel@ffwll.ch>
[danvet: Fix checkpatch fail.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_reg.h | 6 ++++++
 drivers/gpu/drm/i915/intel_pm.c | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 7924166..854f215 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3485,6 +3485,9 @@
 #define GEN7_SQ_CHICKEN_MBCUNIT_CONFIG		0x9030
 #define  GEN7_SQ_CHICKEN_MBCUNIT_SQINTMOB	(1<<11)
 
+#define HSW_SCRATCH1				0xb038
+#define  HSW_SCRATCH1_L3_DATA_ATOMICS_DISABLE	(1<<27)
+
 #define HSW_FUSE_STRAP		0x42014
 #define  HSW_CDCLK_LIMIT	(1 << 24)
 
@@ -4321,6 +4324,9 @@
 #define GEN7_ROW_CHICKEN2_GT2		0xf4f4
 #define   DOP_CLOCK_GATING_DISABLE	(1<<0)
 
+#define HSW_ROW_CHICKEN3		0xe49c
+#define  HSW_ROW_CHICKEN3_L3_GLOBAL_ATOMICS_DISABLE    (1 << 6)
+
 #define G4X_AUD_VID_DID			0x62020
 #define INTEL_AUDIO_DEVCL		0x808629FB
 #define INTEL_AUDIO_DEVBLC		0x80862801
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index b035d41..0d9a852 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -3730,6 +3730,11 @@ static void haswell_init_clock_gating(struct drm_device *dev)
 	I915_WRITE(GEN7_L3_CHICKEN_MODE_REGISTER,
 			GEN7_WA_L3_CHICKEN_MODE);
 
+	/* L3 caching of data atomics doesn't work -- disable it. */
+	I915_WRITE(HSW_SCRATCH1, HSW_SCRATCH1_L3_DATA_ATOMICS_DISABLE);
+	I915_WRITE(HSW_ROW_CHICKEN3,
+		   _MASKED_BIT_ENABLE(HSW_ROW_CHICKEN3_L3_GLOBAL_ATOMICS_DISABLE));
+
 	/* This is required by WaCatErrorRejectionIssue */
 	I915_WRITE(GEN7_SQ_CHICKEN_MBCUNIT_CONFIG,
 			I915_READ(GEN7_SQ_CHICKEN_MBCUNIT_CONFIG) |
-- 
1.8.1.2

