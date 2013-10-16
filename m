Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761964Ab3JPR5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:57:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934607Ab3JPRq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Francisco Jerez <currojerez@riseup.net>,
        Ben Widawsky <ben@bwidawsk.net>, Daniel Vetter <daniel@ffwll.ch>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 25/50] drm/i915/hsw: Disable L3 caching of atomic memory operations.
Date: Wed, 16 Oct 2013 10:45:11 -0700
Message-Id: <20131016174401.413524732@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174358.335646140@linuxfoundation.org>
References: <20131016174358.335646140@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_reg.h |    6 ++++++
 drivers/gpu/drm/i915/intel_pm.c |    5 +++++
 2 files changed, 11 insertions(+)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3791,6 +3791,9 @@
 #define GEN7_SQ_CHICKEN_MBCUNIT_CONFIG		0x9030
 #define  GEN7_SQ_CHICKEN_MBCUNIT_SQINTMOB	(1<<11)
 
+#define HSW_SCRATCH1				0xb038
+#define  HSW_SCRATCH1_L3_DATA_ATOMICS_DISABLE	(1<<27)
+
 #define HSW_FUSE_STRAP		0x42014
 #define  HSW_CDCLK_LIMIT	(1 << 24)
 
@@ -4624,6 +4627,9 @@
 #define GEN7_ROW_CHICKEN2_GT2		0xf4f4
 #define   DOP_CLOCK_GATING_DISABLE	(1<<0)
 
+#define HSW_ROW_CHICKEN3		0xe49c
+#define  HSW_ROW_CHICKEN3_L3_GLOBAL_ATOMICS_DISABLE    (1 << 6)
+
 #define G4X_AUD_VID_DID			(dev_priv->info->display_mmio_offset + 0x62020)
 #define INTEL_AUDIO_DEVCL		0x808629FB
 #define INTEL_AUDIO_DEVBLC		0x80862801
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4699,6 +4699,11 @@ static void haswell_init_clock_gating(st
 	I915_WRITE(GEN7_L3_CHICKEN_MODE_REGISTER,
 			GEN7_WA_L3_CHICKEN_MODE);
 
+	/* L3 caching of data atomics doesn't work -- disable it. */
+	I915_WRITE(HSW_SCRATCH1, HSW_SCRATCH1_L3_DATA_ATOMICS_DISABLE);
+	I915_WRITE(HSW_ROW_CHICKEN3,
+		   _MASKED_BIT_ENABLE(HSW_ROW_CHICKEN3_L3_GLOBAL_ATOMICS_DISABLE));
+
 	/* This is required by WaCatErrorRejectionIssue:hsw */
 	I915_WRITE(GEN7_SQ_CHICKEN_MBCUNIT_CONFIG,
 			I915_READ(GEN7_SQ_CHICKEN_MBCUNIT_CONFIG) |


