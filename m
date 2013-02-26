Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275Ab3B0BAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:00:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760264Ab3BZX5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kenneth Graunke <kenneth@whitecape.org>,
        Paulo Zanoni <przanoni@gmail.com>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Ben Widawsky <ben@bwidawsk.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 083/150] drm/i915: Fix CAGF for HSW
Date: Tue, 26 Feb 2013 15:55:40 -0800
Message-Id: <20130226235532.723990068@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_debugfs.c |   10 +++++++---
 drivers/gpu/drm/i915/i915_reg.h     |    2 ++
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -888,7 +888,7 @@ static int i915_cur_delayinfo(struct seq
 		u32 gt_perf_status = I915_READ(GEN6_GT_PERF_STATUS);
 		u32 rp_state_limits = I915_READ(GEN6_RP_STATE_LIMITS);
 		u32 rp_state_cap = I915_READ(GEN6_RP_STATE_CAP);
-		u32 rpstat;
+		u32 rpstat, cagf;
 		u32 rpupei, rpcurup, rpprevup;
 		u32 rpdownei, rpcurdown, rpprevdown;
 		int max_freq;
@@ -907,6 +907,11 @@ static int i915_cur_delayinfo(struct seq
 		rpdownei = I915_READ(GEN6_RP_CUR_DOWN_EI);
 		rpcurdown = I915_READ(GEN6_RP_CUR_DOWN);
 		rpprevdown = I915_READ(GEN6_RP_PREV_DOWN);
+		if (IS_HASWELL(dev))
+			cagf = (rpstat & HSW_CAGF_MASK) >> HSW_CAGF_SHIFT;
+		else
+			cagf = (rpstat & GEN6_CAGF_MASK) >> GEN6_CAGF_SHIFT;
+		cagf *= GT_FREQUENCY_MULTIPLIER;
 
 		gen6_gt_force_wake_put(dev_priv);
 		mutex_unlock(&dev->struct_mutex);
@@ -919,8 +924,7 @@ static int i915_cur_delayinfo(struct seq
 			   gt_perf_status & 0xff);
 		seq_printf(m, "Render p-state limit: %d\n",
 			   rp_state_limits & 0xff);
-		seq_printf(m, "CAGF: %dMHz\n", ((rpstat & GEN6_CAGF_MASK) >>
-						GEN6_CAGF_SHIFT) * GT_FREQUENCY_MULTIPLIER);
+		seq_printf(m, "CAGF: %dMHz\n", cagf);
 		seq_printf(m, "RP CUR UP EI: %dus\n", rpupei &
 			   GEN6_CURICONT_MASK);
 		seq_printf(m, "RP CUR UP: %dus\n", rpcurup &
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -4211,7 +4211,9 @@
 #define GEN6_RP_INTERRUPT_LIMITS		0xA014
 #define GEN6_RPSTAT1				0xA01C
 #define   GEN6_CAGF_SHIFT			8
+#define   HSW_CAGF_SHIFT			7
 #define   GEN6_CAGF_MASK			(0x7f << GEN6_CAGF_SHIFT)
+#define   HSW_CAGF_MASK				(0x7f << HSW_CAGF_SHIFT)
 #define GEN6_RP_CONTROL				0xA024
 #define   GEN6_RP_MEDIA_TURBO			(1<<11)
 #define   GEN6_RP_MEDIA_MODE_MASK		(3<<9)


