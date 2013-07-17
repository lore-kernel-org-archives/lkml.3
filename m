Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934247Ab3GQXW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:22:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56412 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934206Ab3GQWyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:54:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Widawsky <ben@bwidawsk.net>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 107/145] drm/i915: Fix context sizes on HSW
Date: Wed, 17 Jul 2013 15:47:19 -0700
Message-Id: <1374101277-7915-108-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Widawsky <ben@bwidawsk.net>

commit a0de80a0e07032a111230ec92eca563f9d93648d upstream.

With updates to the spec, we can actually see the context layout, and
how many dwords are allocated. That table suggests we need 70720 bytes
per HW context. Rounded up, this is 18 pages. Looking at what lives
after the current 4 pages we use, I can't see too much important (mostly
it's d3d related), but there are a couple of things which look scary. I
am hopeful this can explain some of our odd HSW failures.

v2: Make the context only 17 pages. The power context space isn't used
ever, and execlists aren't used in our driver, making the actual total
66944 bytes.

v3: Add a comment to the code. (Jesse & Paulo)

Reported-by: "Azad, Vinit" <vinit.azad@intel.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Ben Widawsky <ben@bwidawsk.net>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem_context.c |  2 +-
 drivers/gpu/drm/i915/i915_reg.h         | 15 +++++++--------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_context.c b/drivers/gpu/drm/i915/i915_gem_context.c
index d8ac0a3..a80bba9 100644
--- a/drivers/gpu/drm/i915/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/i915_gem_context.c
@@ -113,7 +113,7 @@ static int get_context_size(struct drm_device *dev)
 	case 7:
 		reg = I915_READ(GEN7_CXT_SIZE);
 		if (IS_HASWELL(dev))
-			ret = HSW_CXT_TOTAL_SIZE(reg) * 64;
+			ret = HSW_CXT_TOTAL_SIZE;
 		else
 			ret = GEN7_CXT_TOTAL_SIZE(reg) * 64;
 		break;
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index ce70f0a..b7315e3 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -1523,14 +1523,13 @@
 					 GEN7_CXT_EXTENDED_SIZE(ctx_reg) + \
 					 GEN7_CXT_GT1_SIZE(ctx_reg) + \
 					 GEN7_CXT_VFSTATE_SIZE(ctx_reg))
-#define HSW_CXT_POWER_SIZE(ctx_reg)	((ctx_reg >> 26) & 0x3f)
-#define HSW_CXT_RING_SIZE(ctx_reg)	((ctx_reg >> 23) & 0x7)
-#define HSW_CXT_RENDER_SIZE(ctx_reg)	((ctx_reg >> 15) & 0xff)
-#define HSW_CXT_TOTAL_SIZE(ctx_reg)	(HSW_CXT_POWER_SIZE(ctx_reg) + \
-					 HSW_CXT_RING_SIZE(ctx_reg) + \
-					 HSW_CXT_RENDER_SIZE(ctx_reg) + \
-					 GEN7_CXT_VFSTATE_SIZE(ctx_reg))
-
+/* Haswell does have the CXT_SIZE register however it does not appear to be
+ * valid. Now, docs explain in dwords what is in the context object. The full
+ * size is 70720 bytes, however, the power context and execlist context will
+ * never be saved (power context is stored elsewhere, and execlists don't work
+ * on HSW) - so the final size is 66944 bytes, which rounds to 17 pages.
+ */
+#define HSW_CXT_TOTAL_SIZE		(17 * PAGE_SIZE)
 
 /*
  * Overlay regs
-- 
1.8.1.2

