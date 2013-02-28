Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab3B1Otb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:49:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42323 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815Ab3B1OtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:49:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paulo Zanoni <przanoni@gmail.com>, Ben Widawsky <ben@bwidawsk.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 086/139] drm/i915: Fix CAGF for HSW
Date: Thu, 28 Feb 2013 14:43:56 +0000
Message-Id: <1362062689-2567-87-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Widawsky <ben@bwidawsk.net>

commit f82855d342b6c8483c56e6d2e200a71731509a39 upstream.

The shift changed, hurray.

Reported-by: Kenneth Graunke <kenneth@whitecape.org>
Cc: Paulo Zanoni <przanoni@gmail.com>
Reviewed-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Tested-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-off-by: Ben Widawsky <ben@bwidawsk.net>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ luis: removed reference to GT_FREQUENCY_MULTIPLIER, replacing it by 50 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/i915_debugfs.c | 10 +++++++---
 drivers/gpu/drm/i915/i915_reg.h     |  2 ++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index ca472ca..3459e27 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -894,7 +894,7 @@ static int i915_cur_delayinfo(struct seq_file *m, void *unused)
 		u32 gt_perf_status = I915_READ(GEN6_GT_PERF_STATUS);
 		u32 rp_state_limits = I915_READ(GEN6_RP_STATE_LIMITS);
 		u32 rp_state_cap = I915_READ(GEN6_RP_STATE_CAP);
-		u32 rpstat;
+		u32 rpstat, cagf;
 		u32 rpupei, rpcurup, rpprevup;
 		u32 rpdownei, rpcurdown, rpprevdown;
 		int max_freq;
@@ -913,6 +913,11 @@ static int i915_cur_delayinfo(struct seq_file *m, void *unused)
 		rpdownei = I915_READ(GEN6_RP_CUR_DOWN_EI);
 		rpcurdown = I915_READ(GEN6_RP_CUR_DOWN);
 		rpprevdown = I915_READ(GEN6_RP_PREV_DOWN);
+		if (IS_HASWELL(dev))
+			cagf = (rpstat & HSW_CAGF_MASK) >> HSW_CAGF_SHIFT;
+		else
+			cagf = (rpstat & GEN6_CAGF_MASK) >> GEN6_CAGF_SHIFT;
+		cagf *= 50;
 
 		gen6_gt_force_wake_put(dev_priv);
 		mutex_unlock(&dev->struct_mutex);
@@ -925,8 +930,7 @@ static int i915_cur_delayinfo(struct seq_file *m, void *unused)
 			   gt_perf_status & 0xff);
 		seq_printf(m, "Render p-state limit: %d\n",
 			   rp_state_limits & 0xff);
-		seq_printf(m, "CAGF: %dMHz\n", ((rpstat & GEN6_CAGF_MASK) >>
-						GEN6_CAGF_SHIFT) * 50);
+		seq_printf(m, "CAGF: %dMHz\n", cagf);
 		seq_printf(m, "RP CUR UP EI: %dus\n", rpupei &
 			   GEN6_CURICONT_MASK);
 		seq_printf(m, "RP CUR UP: %dus\n", rpcurup &
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 44feabe..26b8bba 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -4045,7 +4045,9 @@
 #define GEN6_RP_INTERRUPT_LIMITS		0xA014
 #define GEN6_RPSTAT1				0xA01C
 #define   GEN6_CAGF_SHIFT			8
+#define   HSW_CAGF_SHIFT			7
 #define   GEN6_CAGF_MASK			(0x7f << GEN6_CAGF_SHIFT)
+#define   HSW_CAGF_MASK				(0x7f << HSW_CAGF_SHIFT)
 #define GEN6_RP_CONTROL				0xA024
 #define   GEN6_RP_MEDIA_TURBO			(1<<11)
 #define   GEN6_RP_MEDIA_MODE_MASK		(3<<9)
-- 
1.8.1.2

