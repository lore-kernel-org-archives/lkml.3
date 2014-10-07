Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034AbaJGXec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:34:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619AbaJGXT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:19:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        ming.yao@intel.com, Chris Wilson <chris@chris-wilson.co.uk>,
        Takashi Iwai <tiwai@suse.de>, Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Todd Previte <tprevite@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 3.14 06/37] drm/i915: Flush the PTEs after updating them before suspend
Date: Tue,  7 Oct 2014 16:19:23 -0700
Message-Id: <20141007231827.264095611@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231827.043235686@linuxfoundation.org>
References: <20141007231827.043235686@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 91e56499304f3d612053a9cf17f350868182c7d8 upstream.

As we use WC updates of the PTE, we are responsible for notifying the
hardware when to flush its TLBs. Do so after we zap all the PTEs before
suspend (and the BIOS tries to read our GTT).

Fixes a regression from

commit 828c79087cec61eaf4c76bb32c222fbe35ac3930
Author: Ben Widawsky <benjamin.widawsky@intel.com>
Date:   Wed Oct 16 09:21:30 2013 -0700

    drm/i915: Disable GGTT PTEs on GEN6+ suspend

that survived and continue to cause harm even after

commit e568af1c626031925465a5caaab7cca1303d55c7
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed Mar 26 20:08:20 2014 +0100

    drm/i915: Undo gtt scratch pte unmapping again

v2: Trivial rebase.
v3: Fixes requires pointer dances.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=82340
Tested-by: ming.yao@intel.com
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Paulo Zanoni <paulo.r.zanoni@intel.com>
Cc: Todd Previte <tprevite@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem_gtt.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -827,6 +827,16 @@ void i915_check_and_clear_faults(struct
 	POSTING_READ(RING_FAULT_REG(&dev_priv->ring[RCS]));
 }
 
+static void i915_ggtt_flush(struct drm_i915_private *dev_priv)
+{
+	if (INTEL_INFO(dev_priv->dev)->gen < 6) {
+		intel_gtt_chipset_flush();
+	} else {
+		I915_WRITE(GFX_FLSH_CNTL_GEN6, GFX_FLSH_CNTL_EN);
+		POSTING_READ(GFX_FLSH_CNTL_GEN6);
+	}
+}
+
 void i915_gem_suspend_gtt_mappings(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -843,6 +853,8 @@ void i915_gem_suspend_gtt_mappings(struc
 				       dev_priv->gtt.base.start / PAGE_SIZE,
 				       dev_priv->gtt.base.total / PAGE_SIZE,
 				       true);
+
+	i915_ggtt_flush(dev_priv);
 }
 
 void i915_gem_restore_gtt_mappings(struct drm_device *dev)
@@ -863,7 +875,7 @@ void i915_gem_restore_gtt_mappings(struc
 		i915_gem_gtt_bind_object(obj, obj->cache_level);
 	}
 
-	i915_gem_chipset_flush(dev);
+	i915_ggtt_flush(dev_priv);
 }
 
 int i915_gem_gtt_prepare_object(struct drm_i915_gem_object *obj)


