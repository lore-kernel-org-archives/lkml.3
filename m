Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab3CRLNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:13:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:34172 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab3CRLNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:13:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,863,1355126400"; 
   d="scan'208";a="304415740"
From: Chris Wilson <chris@chris-wilson.co.uk>
To: linux-kernel@vger.kernel.org
Cc: intel-gfx@lists.freedesktop.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Shawn Starr <shawn.starr@rogers.com>, Jiri Kosina <jkosina@suse.cz>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH] drm/i915: Flush writes to GMBUS registers
Date: Mon, 18 Mar 2013 11:13:05 +0000
Message-Id: <1363605185-4030-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <alpine.LNX.2.00.1303151424140.9529@pobox.suse.cz>
References: <alpine.LNX.2.00.1303151424140.9529@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we do not complete the writes to the GMBUS registers, they remain
active for an indefinite period of time afterwards, even causing
spurious interrupts on gm45.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: http://lkml.kernel.org/r/alpine.LNX.2.00.1303151424140.9529@pobox.suse.cz
Cc: Shawn Starr <shawn.starr@rogers.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/intel_i2c.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index acf8aec..ca6c17e 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -64,6 +64,7 @@ intel_i2c_reset(struct drm_device *dev)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	I915_WRITE(dev_priv->gpio_mmio_base + GMBUS0, 0);
 	I915_WRITE(dev_priv->gpio_mmio_base + GMBUS4, 0);
+	POSTING_READ(dev_priv->gpio_mmio_base + GMBUS4);
 }
 
 static void intel_i2c_quirk_set(struct drm_i915_private *dev_priv, bool enable)
@@ -232,6 +233,7 @@ gmbus_wait_hw_status(struct drm_i915_private *dev_priv,
 	finish_wait(&dev_priv->gmbus_wait_queue, &wait);
 
 	I915_WRITE(GMBUS4 + reg_offset, 0);
+	POSTING_READ(GMBUS4 + reg_offset);
 
 	if (gmbus2 & GMBUS_SATOER)
 		return -ENXIO;
@@ -257,6 +259,7 @@ gmbus_wait_idle(struct drm_i915_private *dev_priv)
 	ret = wait_event_timeout(dev_priv->gmbus_wait_queue, C, 10);
 
 	I915_WRITE(GMBUS4 + reg_offset, 0);
+	POSTING_READ(GMBUS4 + reg_offset);
 
 	if (ret)
 		return 0;
@@ -486,6 +489,7 @@ timeout:
 	ret = i2c_bit_algo.master_xfer(adapter, msgs, num);
 
 out:
+	POSTING_READ(GMBUS0 + dev_priv->gpio_mmio_base);
 	mutex_unlock(&dev_priv->gmbus_mutex);
 	return ret;
 }
-- 
1.7.10.4

