Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722Ab3AOX2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:28:43 -0500
Received: from mail.kernel.org ([198.145.19.201]:46838 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933668Ab3AOWwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:52:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Ben Widawsky <ben@bwidawsk.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Hutchings <ben@decadent.org.uk>,
        Julien Cristau <jcristau@debian.org>
Subject: [ 128/171] drm/i915: Fix GT_MODE default value
Date: Tue, 15 Jan 2013 14:44:53 -0800
Message-Id: <20130115224322.575402381@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Widawsky <ben@bwidawsk.net>

commit f8f2ac9a76b0f80a6763ca316116a7bab8486997 upstream.

I can't even find how I figured this might be needed anymore. But sure
enough, the value I'm reading back on platforms doesn't match what the
docs recommends.

It seemed to fix Chris' GT1 in limited testing as well.

Tested-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Ben Widawsky <ben@bwidawsk.net>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: open-code _MASKED_BIT_{ENABLE,DISABLE}]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Julien Cristau <jcristau@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_reg.h      |    3 +++
 drivers/gpu/drm/i915/intel_display.c |    5 +++++
 2 files changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -445,6 +445,9 @@
 # define VS_TIMER_DISPATCH				(1 << 6)
 # define MI_FLUSH_ENABLE				(1 << 12)
 
+#define GEN6_GT_MODE	0x20d0
+#define   GEN6_GT_MODE_HI	(1 << 9)
+
 #define GFX_MODE	0x02520
 #define GFX_MODE_GEN7	0x0229c
 #define RING_MODE_GEN7(ring)	((ring)->mmio_base+0x29c)
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8620,6 +8620,11 @@ static void gen6_init_clock_gating(struc
 			   DISPPLANE_TRICKLE_FEED_DISABLE);
 		intel_flush_display_plane(dev_priv, pipe);
 	}
+
+	/* The default value should be 0x200 according to docs, but the two
+	 * platforms I checked have a 0 for this. (Maybe BIOS overrides?) */
+	I915_WRITE(GEN6_GT_MODE, 0xffff << 16);
+	I915_WRITE(GEN6_GT_MODE, GEN6_GT_MODE_HI << 16 | GEN6_GT_MODE_HI);
 }
 
 static void gen7_setup_fixed_func_scheduler(struct drm_i915_private *dev_priv)


